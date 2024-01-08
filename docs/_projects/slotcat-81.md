---
title: SlotCat-81
excerpt: The SlotCat-81 is a new design Socket-8 to Slot-1 adapter
date: 2023-05-31 13:30:15.000000000 +02:00
header:
 teaser: /assets/2023/05/Slotcat-8-1024x514.jpg
categories: 
 - Hardware
tags: 
 - PCB Design
 - Projects
---

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

![]({{ site.baseurl }}/assets/2023/05/Slotcat-8-1024x514.jpg)  

Later SlotCat-8 prototype layout (December 2022)

![]({{ site.baseurl }}/assets/2023/05/Slotcat-8-back-1024x514.jpg)  

Later SlotCat-8 prototype layout back (December 2022)

SlotCat-81 DP
-------------

A 'moonshot' design for a Dual Socket 8 in Slot-1 card is in the very early stages of developmental planning. This is possible because the Slot-1 interface carries all signals required for dual processor operation. However this faces several design constraints and challenges centered around the external IO-APIC logic integration. Effectively every Slot 1 single processor board ever manufactured does not include the external IO-APIC chip required for coordinating multiprocessor IO. The SlotCat-81 board as such integrates it's own IO-APIC chip and interfaces to otherwise standard Slot-1 mainboards with additional PCI and ISA cards (Bridged via IDE cable of all things) as well as a variety of wires soldered onto Southbridge signals. Obviously non-trivial bios modifications are required to facilitate this and so support is expected to be limited. It is likely that I will only ever design one such PCB and it will probably never make it into any sort of widespread production due to the very specialized and difficult constraints involved.