---
title: ATI FireGL 2 and 4 Drivers/BIOS
date: 2022-07-05 23:48:41.000000000 +02:00
type: page
categories:
tags:

permalink: "/software/ati-firegl-2-and-4-drivers-bios"
---
This page contains the latest known drivers for the ATI, Formerly SonicBlue, Formerly Diamond Multimedia [FireGL 2](https://www.techpowerup.com/gpu-specs/fire-gl2.c), 3 and 4 Graphics cards that are powered by the IBM RC1000 and GT1000 "Sandstorm" Graphics chips.

[ATI-FGL-2-software-kit.zip]({{ site.baseurl }}/2022/07/ATI-FGL-2-software-kit.zip)

Above you can download a ZIP archive that includes the following files pulled from an HP X2000 workstation drive.

**1\. ATI FGL - 2106 GL Driver.exe**

Setup containing the last known version 2106 OpenGL only Driver for the FireGL 2 and 4 from 2004. This is stable and runs Counter Strike CS1.6, Half Life 1, Unreal, and many other OpenGL 1.2 titles.

**2\. ATI FGL 2 - 2090 DirectX Enable Driver.exe**

Setup containing the last known version 2090 DirectX 6 enabled Driver for the FireGL 2 and 4.
This has many bugs, but is enough to run 3Dmark 1999 and 2000, 2001 runs with some resolution concessions.

**3\. ATI FGL 2 - BIOS 1.26 Update.exe**
This BIOS fixes many bugs with VIA and AMD Chipsets for the FireGL 2 (codename Sandstorm v1.2). Such as:

*   Enabling AGP 4x (instead of 2x) on AMD 762/760MP chipsets
*   Enabling AGP operation (instead of PCI) on various VIA boards.
*   Removing the slow POST screen and greatly speeding up time to first image.

**Bugs**
The DirectX driver has a framebuffer memory allocation logic bug that prevents it from correctly managing the available memory.
The card does not correctly perform Triple Buffered rendering in DirectX mode, Double Buffering is suggested instead, especially 3dmark 2000.

**To get the best of both drivers it is suggested to:**

1.  Install the **2106** driver
2.  Reboot
3.  Wait for complete GPU detection
4.  Install the **2090** driver, electing "YES" to replace existing files when prompted.
5.  Reboot

Congrats you now have a **2106** GL Driver with DirectX Enabled.