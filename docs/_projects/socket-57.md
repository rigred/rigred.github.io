---
title: Socket-57
date: 2022-03-25 08:04:15.000000000 +02:00
excerpt: A socket 5 to 7 voltage plane adapter
header:
 teaser: /assets/2022/03/image-8.png
categories: 
 - Projects
tags: 
 - PCB
---

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