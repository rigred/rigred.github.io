---
title: Projects
date: 2022-03-25 08:04:15.000000000 +02:00
type: page

categories: 
tags: 
permalink: "/projects"
---
This page serves as the directory of my public project resources and their associated blog posts.

SoCat-57 (Socket 5 to 7) v1
---------------------------

[Creating SoCat-57 Part 1]({{ site.baseurl }}/hardware mods/pcb designs/2022/03/31/creating-socat-57-part-1.html)

This project creates a Socket interposer device that allows the use of Socket 7 and other unsupported Socket 5/7 processors on almost any Socket 5/7 motherboard.

The device consists of an interstitial PGA-321 socket stacked through a Printed Circuit Board into another upper LIF(Low Insertion Force) PGA-321 CPU socket. All pins connected to the Vcore (Primary CPU Power) voltage plane are removed from the lower interstitial socket so as not to back-feed the motherboard. The PCB itself contains the fully synchronous controlled Voltage regulator for powering the processor and features a 12V Molex micro-fit (P4) connector for external power. The IO Voltage (3.3V) is still passed through by the motherboard since this cannot always be safely isolated from the board and doing so may create reference level issues on the CPU buses.

This allows you to make use of 2.1/2.2/2.4 or 2.8/2.9 and 3.5V Socket 5/7 processors on motherboards that only support 3.3V Core voltage output, have no split power planes or even have a non-functional onboard voltage regulator. Additionally this allows you to power processors at any voltage from 1.3 to 3.5V in 50mV intervals from 1.3V to 2.0V and in 100mV intervals from 2.05V to 3.5V.

Furthermore the design incorporates active processor type and voltage detection as well as the Intel VRM8.2 (Pentium II) processor power compliant 5bit VID detection also used by AMD's K6-2 and above series under the AMD PowerNow specification. This design allows the motherboard to gain active PowerNow functionality allowing dynamic voltage and clock scaling at runtime via software configuration.

Voltage and multiplier as well as other functionality are configured via DIP switches.

Arguably with this project one of the biggest constraints is finding VRM8.2 (5-bit VID) synchronous regulators that do not require a very large amount of capacitors or support components on the input and output side. A multi phase design could resolve this, but again requires more parts and adapting modern parts that are not designed for this purpose.

### Feature list:

*   LIF socket
*   Modular VRM + Interposer design.
*   PCB heatsink retention clamps
*   Dual voltage plane
*   1.3V to 3.5V support
*   over 70A current rating with 85% efficiency (90%+ design is possible at extreme BOM cost)
*   Realistically no Socket 7 processor will exceed 15A
*   Settable Over-current protection
*   Soft-start functionality
*   Multiplier ratio control
*   Intel Tillamook & Intel Mobile processor compatibility workarounds
*   Full AMD PowerNow! VID voltage control for Desktop and Mobile K6-2 and later processors
*   Access to DIP switches without removing the processor.

SoCat-57 (Socket 5 to 7) v2 Digital
-----------------------------------

In an effort to remove the need for DIP switches and improve flexibility of the design the future second generation of the SoCat-57 adds a microcontroller in conjunction with CPU debug port connection to automatically detect the installed processors type and setup safe defaults or load various stored selected CPU profiles at start. This also upgrades the VRM to a modern design which removes much of the bulky capacitors in favor of a modern dual phase regulator.

A frequency prescaler IC enables the microcontroller to count the bus clock speed of the mainboard and make largely automatic configuration decisions.

The Digital control is done by first starting processors at low safe settings (voltage and multiplier), then detecting the CPU type via direct and indirect pin state interrogation before re-configuring and resetting the processor pin state to an optimal state. The reset causes the processor to resample all configuration inputs and take up the new state. Effectively this behaves like a short 'training' period on modern processors.

### Feature list:

*   Automatic CPU type detection
*   Automatic CPU voltage configuration
*   FSB speed detection and clock counting
*   Automatic CPU multiplier configuration
*   Stored CPU configuration profiles
*   Failed Overclock recovery aka "Safemode"
*   Host based software serial control
*   Real-time Voltage, current and temperature measurement

SlotCat-81 (Socket 8 to Slot 1)
-------------------------------

The SlotCat-81 is a new design Socket-8 to Slot-1 adapter that has been in design for several months now. Due to the complexities of the GTL+ bus and it's faster signaling speed and multi layer construction involving many signals, designing such a device that not only works but also allows for stable overclocking is a complex matter.

This device does not include an active onboard VRM and instead makes use of the existing mainboard VRM. If the need arises a later variant may include an overclocking oriented design also powered by a multi-phase synchronous regulator feed via 4 pin Micro-fit Molex (P4 12V).

Previous devices created by Asus, Tekram and others as well as clones of such exist, however these are scarce, not openly available and fetch a premium price. But they also have several design oversights and problems inherent in their design that limit their potential.

Nonetheless a prototype is in development that enables the following:

*   Adapting Socket 8 processors into 440BX/ZX/LX and some VIA motherboards.
*   BIOS modifications and CPU detection fix guides.
*   Configuring 66/100MHz FSB via the use of a switch.
*   Direct voltage control independent of the motherboard via DIP switch register.
*   Direct multiplier control independent of the motherboard via DIP switch register.
*   The use of modern commodity AM4 alternate processor heatsinks via the clip bracket system.
*   JTAG and Debug interface for in-circuit processor testing via conventional Altera USB Blaster or equivalent JTAG interface devices with OpenOCD.

![]({{ site.baseurl }}/assets/2022/03/Slotcat-8-1024x514.jpg)  

Later SlotCat-8 prototype layout (December 2022)

![]({{ site.baseurl }}/assets/2022/03/Slotcat-8-back-1024x514.jpg)  

Later SlotCat-8 prototype layout back (December 2022)

SlotCat-81 DP
-------------

A 'moonshot' design for a Dual Socket 8 in Slot-1 card is in the very early stages of developmental planning. This is possible because the Slot-1 interface carries all signals required for dual processor operation. However this faces several design constraints and challenges centered around the external IO-APIC logic integration. Effectively every Slot 1 single processor board ever manufactured does not include the external IO-APIC chip required for coordinating multiprocessor IO. The SlotCat-81 board as such integrates it's own IO-APIC chip and interfaces to otherwise standard Slot-1 mainboards with additional PCI and ISA cards (Bridged via IDE cable of all things) as well as a variety of wires soldered onto Southbridge signals. Obviously non-trivial bios modifications are required to facilitate this and so support is expected to be limited. It is likely that I will only ever design one such PCB and it will probably never make it into any sort of widespread production due to the very specialized and difficult constraints involved.

SlotCat-21
----------

This is a far simpler design than any of the others and merely facilitates the use of Slot-2 processors on Slot-1 motherboards via a riser The Slot2 SC-330 interface actually introduces no new signals or alternate functionality to the Slot-1 connector, it merely adds additional power and ground pins to support the higher requirements of the Slot-2 Intel Xeon processors and their large caches. I have already managed to source appropriate connectors for this purpose.

SIMMBA-72 (128MB 72pin RAM)
---------------------------

As the name suggests this is a 128MB 72pin EDO/FPM RAM module design. It is largely an inspired recreation of an existing design that can still be bought via Ebay but attempts to reduce the overall cost of such while also open sourcing a viable design that fixes some of the originals shortcomings such as:

*   EDO & FPM cross compatibility.
*   Support for multiple DRAM chip sourcing.
*   Poor voltage regulator quality. (Currently also my problem)
*   Lack of Quad CAS 4bit RAM chips or sufficiently large 1bit single CAS chips for parity purposes.
*   Poor PCB edge contact plating and too thin PCB resulting in poor slot fit.
*   Failing voltage regulators.
*   High price and limited/uncertain availability.

As of now the design has stalled at the below version due to the limited availability of affordable compact 3.3V regulators that can safely power the full board memory population. The AMS1117 (1A, but really 0.8A) LDO has proven to be effective for a 64MB configuration, but not viable for a 128MB configuration under heavy memory load. So I need a more efficient higher current regulator or redesign to make use of a switch mode regulator. Or possibly external 3.3V memory power board.

![Image]({{ site.baseurl }}/assets/2022/03/FJTKyXgX0AAnPZm?format=png&name=large)  

Side A of SIMMBA Revision A1 (January 2022)

![Image]({{ site.baseurl }}/assets/2022/03/FJTK1F-XsAI0GW4?format=png&name=large)  

Side B of SIMMBA Revision A1 (January 2022)

[SIMMBA-16.P]({{ site.baseurl }}/simmba-16-p-a-30-pin-simm)
--------------------------------------------------------------

Open-source 30 pins 16MB SIMM memory module. [See Here]({{ site.baseurl }}/simmba-16-p-a-30-pin-simm)

[![16MB_SIPPM_30_A2_front]({{ site.baseurl }}/assets/2022/03/16MB_SIPPM_30_A2_front.jpg)](https://github.com/rigred/SIMMBA-16/blob/main/Images/16MB_SIPPM_30_A2_front.jpg)