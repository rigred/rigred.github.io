# Seagate Nytro 3330 “Jofa” SAS - Firmware Strings Recon Notes

> A concise, shareable write-up for RE folks poking at Seagate enterprise SAS SSD firmware packages (.LOD) and related strings dumps.
> Focus: controller architecture hints, update packaging, secure-boot/SED internals, and where drive-specific config likely resides.

---

## Scope & Inputs

* **Firmware package**: `JofaNytro3330SAS-0005.LOD`

  * Size: **2,020,864 bytes**
  * SHA-256: `90345bd5a4c5726950d0f3a26e2459e5392b97f70d717f6c8e5c28574c11bd4c`
  * Approx. entropy: **6.30 bits/byte** (mix of compressed/signed code and plaintext tables)
  * Notable markers: **gzip** signatures at offsets **0xC0DE3** and **0x108269** (don’t inflate standalone -> likely segmented packaging).
* **Strings dump**: `nytro_3330_jofa_strings.txt` (full ASCII extraction)

---

## Headline Conclusions

* **Controller ISA**: Evidence strongly indicates **ARM (Thumb-2)** - instruction patterns seen adjacent to TCG strings match Thumb-2 (e.g., `70 B5` pushes, `F7` calls, `CD F8` store/mov patterns). Very likely a **Cortex-R–class** SSD SoC (standard in enterprise SAS).
* **Packaging & delivery**: `.LOD` is a **segmented, signed** microcode bundle intended for **SeaChest\_Firmware** / SCSI **WRITE BUFFER (mode 5)** updates. Gzip markers exist inside but segments appear enveloped by a vendor header/manifest.
* **Secure boot & policy**: Strings show **fuse-backed secure boot policy (SBP)** and **signature verification**, implying anti-rollback and signed images.
* **SED/TCG**: Implements **TCG Enterprise SSC** (“Seagate Secure”) with **FIPS 140-2** self-tests; MSID/PSID lifecycle present.
* **Drive-specific configuration**: Serial/VPD, SED state, and calibration look to be stored in **protected system/NVRAM areas on the drive**, not in the `.LOD`.

---

## Key Findings (Grouped)

### 1) Update Packaging & Manifests

* Vendor/version banner (near **0x000A62B0**):

  ```log
  "SEAGATE                 0005SNSNSNSN"
  "Copyright (c) 2019 Seagate All rights reserved"
  ```

* Update/diagnostic verbs appear: `FWDownload`, `CSFWDownload`, `Diagnostics`, `SMART`, `UDS`, `UDS_Debug`, `PsgDiagOnline`.
* Gzip members exist but **don’t inflate directly** → suggests the updater streams segments that reconstruct valid deflate payloads before execution.

**Implication:** The LOD is a container with a manifest + section records; decompression likely occurs after segment reassembly and integrity checks.

---

### 2) Secure Boot Chain & Policy

* Strings include:

  * `Firmware Signature verification failed.`
  * `Misconfigured SBP Fuse Bits`
  * `SBP Check Failure!` (or similar SBP checks)
* Expect **RSA-signed** blocks and **fuse/OTP policy** enforcing image acceptance and rollback protection.

**Implication:** Any SPI or on-flash modification that breaks signature chains will fail secure boot. Rolling back to prior versions is likely blocked without valid chain.

---

### 3) TCG Enterprise / Seagate Secure (SED)

* Clear markers:

  * `TCG Enterprise SSC Self-Encrypting Drive FIPS 140-2 Module`
  * `Seagate Secure`
  * `MSID`, `MSID SCRAMBLE`, `PSID`
  * Terms like `PortLocked`, `Authority`, `ActiveKey`, `Locking`, `RangeStart`, `RangeLength`, `TPerInfo`, `GUDID`.
* Presence of **FIPS POST** messages (`FIPS_SelfTests() != PASS`, `FDE_SelfTest() != PASS`).

**Implication:** Full Enterprise SSC stack with proper key hierarchy and range locking. Drive-unique SED state lives in NV storage (not in the LOD).

---

### 4) Crypto & TLS Artifacts

* Symmetric/asymmetric suite:

  * `C_AES_128`, `C_AES_256`, `K_AES_256`, `C_RSA_2048`, (`C_RSA_1024` references present too)
  * `SHA256`, `SHA384`, `SHA512`, `HMAC`
* TLS handshake/PSK suite markers:

  * `TLS-PSK-WITH-AES-256-GCM-SHA384`, `TLS-DHE-PSK-...`, `client finished`, `server finished`, `master secret`.

**Implication:** Besides SED crypto, the firmware carries an **embedded TLS stack** (PSK/DHE-PSK) for authenticated comms (field service, secure download, enclosure services, or vendor channel).

---

### 5) Platform & Boot

* **ARM Thumb-2** instruction patterns appear around SED functions (e.g., PSID/MSID handlers), consistent with an ARM boot/application image.
* ECC DRAM requirement:

  * `**** DRAM ECC Init Size Too Low **** Required: ... Actual: ...`
* I²C reference:

  * `Seagate-I2C`

**Implication:** Typical enterprise SSD architecture: ARM core(s) + DRAM with ECC + I²C peripherals (PMIC/temp/sensors).

---

### 6) Manufacturing & Config / NV Tables

* Human-readable schema hints:

  ```
  Table / UID / Name / Column / Rows / RowsFree / RowBytes / NumColumns
  Type / IsIndex / Transactional / ~SPByte / ~Block / ~Unmapped / ~SliceMap
  ```

* Drive identity & calibration:

  * `Serial Number:`
  * `ConfigId %llu`
  * `QUALITY_CALIBRATION_SHALLOW_ERASE_{INIT,APPLIED,NOT_APPLIED}`
  * `Die Kill event received: GCU ..., Bus ..., Die ...`

**Implication:** Per-drive configuration is stored in **table-like NV structures** on flash; includes locking, slice maps, calibration; accessed early in boot.

---

### 7) FTL / Media Management

* Subsystem labels and logs:

  * `FLASH_TRANSLATION_LAYER`
  * `VIRT_GARBAGE_COLLECTION`
  * `FLASH_CONTROLLER`, `FLASH_ERROR`, `UNRECOVER_ERROR`, `QUALITY_LAYER`
* Runtime counters:

  * `Requester 0x%x ActiveWriteDie 0x%x ActiveTotalDie 0x%x`

**Implication:** Mature FTL with quality grading, GC, and per-die concurrency/telemetry.

---

### 8) Odd/Useful Artifacts

* Test strings:

  * `seagatepasswordtest123456789abcd`, `seagatesalt12345` (**likely test vectors**, not live secrets)
* Serial mismatch guards:

  * `SER NUM MISMATCH`
* PBM/LWPF references:

  * `PBM Offset 0x%x%x`
  * `LWPF Status/ID`

**Implication:** There’s a **Parameter Block Map** (PBM) and a **Lightweight Preload Firmware** component that reference offsets/IDs used during staged boot/update.

---

## Representative Offsets & Snippets

> Offsets are file offsets within `JofaNytro3330SAS-0005.LOD`.

* **Vendor banner** (\~`0x000A62B0`):

  ```
  SEAGATE                 0005SNSNSNSN
  Copyright (c) 2019 Seagate All rights reserved
  ```

* **SED/TCG module** (\~`0x000B141F`):

  ```
  TCG Enterprise SSC Self-Encrypting Drive FIPS 140-2 Module
  ```

* **Crypto/TLS ciphers** (\~`0x000B0EE0–0x000B1000`):

  ```
  TLS-PSK-WITH-AES-256-GCM-SHA384
  TLS-DHE-PSK-WITH-AES-128-CBC-SHA256
  C_AES_256
  C_RSA_2048
  SHA256 / SHA384 / SHA512
  ```

* **FIPS/POST** (\~`0x00081376`, `0x000B0E92`):

  ```
  FIPS_SelfTests() != PASS
  FDE_SelfTest()!= PASS
  ```

* **MSID/PSID & ARM-ish code nearby** (\~`0x00064xxx–0x00075xxx`):

  ```
  MSID / PSID
  ... (Thumb-2 patterns in adjacent bytes: 70 B5 ... CD F8 ...)
  ```

* **Calibrations** (\~`0x00090318–0x00090370`):

  ```
  QUALITY_CALIBRATION_SHALLOW_ERASE_INIT / APPLIED / NOT_APPLIED
  ```

* **Secure boot** (\~`0x0000E844`, `0x00007A26`):

  ```
  Firmware Signature verification failed.
  Misconfigured SBP Fuse Bits:
  ```

---

## Where the Drive-Unique Stuff Lives

* **Not** in the `.LOD` (no unique serial/keys inside).
* Stored in protected **system/NVRAM areas** on NAND (and/or small internal NVRAM), formatted as the **tables** hinted above (locking ranges, authorities, slice maps, calibration, IDs).
* TCG **MSID/PSID** and key material are handled by the SED stack and guarded by the secure-boot chain.

---

## Hypothesized On-Device Layout (Typical Enterprise SSD)

1. **Boot ROM** (in SoC, immutable) → verifies 2nd stage.
2. **SPI NOR** (bootloader + recovery + certificates/manifests).
3. **Main app/FTL** (NAND system area; updated via `.LOD` download).
4. **NV tables** (TCG/locking, calibration, PBM/slice maps, VPD/serial).
5. **User LBA** area (FTL-backed).

*The strings point to PBM/LWPF metadata tying these pieces together.*

---

## How to Reproduce / Extend the RE

> **Note:** Don’t flash modified images on production hardware. Expect signature checks to reject altered code.

1. **Carve container sections**

   * Identify the LOD record format: `[hdr][segment#][len][payload][CRC]…`.
   * Reassemble segments into continuous streams; **then** try gzip inflate on the reconstructed payloads.
2. **Mine manifests & certs**

   * Grep for ASN.1/DER (`30 82 …`) and RSA CRT labels (`Iqmp`, `Pr_Exp`, etc.).
   * Map hashes/signature blocks to the segments.
3. **TCG table census**

   * Search for the table schema keywords:
     `Table, UID, Name, Column, Rows, RowBytes, NumColumns, ~SliceMap, RangeStart, RangeLength, Authority, ActiveKey`.
   * Build a quick parser to enumerate candidate NV tables (even if content is binary).
4. **ISA confirmation**

   * Take a code region (from reassembled payload or a future SPI dump) and feed to a disassembler - ARM/Thumb-2 should decode cleanly.

---

## SPI Dump Plan (If You Go There)

* **Identify chip & voltage** (common NOR; some are **1.8 V**). Use level-correct clip/programmer.
* Expect **reset vector/Thumb-2** patterns if plaintext; otherwise look for **cert/manifests** and a small 2nd-stage loader.
* Don’t power the SSD from host while clipping. Isolate and power the flash safely.

---

## Legal / Safety

* Firmware appears **signed** and **fuse-policy enforced**. Alterations will likely **fail boot** and can brick the device.
* Handle any drive data in compliance with your local laws and org policies.

---

## Appendix - Small Sampler of Interesting Strings

```text
"Seagate Secure"
"TCG Enterprise SSC Self-Encrypting Drive FIPS 140-2 Module"
"MSID SCRAMBLE" / "MSID" / "PSID"
"PortLocked" "Authority" "ActiveKey" "Locking" "RangeStart" "RangeLength" "TPerInfo" "GUDID"
"Table" "UID" "Name" "Rows" "RowBytes" "NumColumns" "~SliceMap" "~Unmapped" "~Block"
"Firmware Signature verification failed."
"Misconfigured SBP Fuse Bits:"
"K_AES_256" "C_AES_128" "C_AES_256" "C_RSA_2048"
"TLS-PSK-WITH-AES-256-GCM-SHA384" (and related PSK/DHE-PSK ciphers)
"**** DRAM ECC Init Size Too Low **** Required: ... Actual: ..."
"Requester 0x%x ActiveWriteDie 0x%x ActiveTotalDie 0x%x"
"QUALITY_CALIBRATION_SHALLOW_ERASE_{INIT,APPLIED,NOT_APPLIED}"
"PBM Offset 0x%x%x" / "LWPF Status/ID"
"Seagate-I2C"
"SER NUM MISMATCH"
"SEAGATE                 0005SNSNSNSN"
"seagatepasswordtest123456789abcd" / "seagatesalt12345" (test artifacts)
```

---

**Notes welcome.** If anyone’s already mapped the LOD container record format or has a type table for the PBM/LWPF structures, that’d speed up carving and clean inflation of the inner payloads.
