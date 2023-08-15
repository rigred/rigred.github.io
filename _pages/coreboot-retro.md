---
title: Coreboot-Retro
date: 2023-05-25 12:10:52.000000000 +02:00
type: page
categories: 
tags: 
permalink: "/software/coreboot-retro"
---
Rebuilding Vintage Hardware with Modern Capabilities
----------------------------------------------------

In the realm of hardware hacking and retro computing, I have embarked on an intriguing project called Coreboot-Retro. This personal endeavor aims to breathe new life into various old boards by adding support for them in the Coreboot mainline while also modernizing their capabilities.

Driven by my passion for preserving the value of older hardware systems and seeking to better understand the Coreboot internals, I am focusing on reviving notable boards such as the Shuttle AB61 (440BX) and the MS-5128 (430HX) with Pentium P5x support. These historically significant boards, some of which are about 21 years old, can potentially be reintegrated with modern computing functions.

To explore the progress and contribute to the Coreboot-Retro project, interested individuals can visit the GitHub repository at https://github.com/rigred/coreboot-retro. This provides an opportunity for developers, hardware hackers, and retro computing enthusiasts to collaborate and contribute to the growth of the project. The repository also contains branches for older coreboot versions with about 9 years old code that I can forward port to the latest master branch, along with other components that date back as far as 21 years.

My primary goal with Coreboot-Retro is to integrate support for a diverse range of old chipsets and boards into the mainline Coreboot or the coreboot-retro codebase. In addition to the existing Asus P2B series, I am currently working on adding support for the Shuttle AB61 and MS-5128, and it is still a work in progress. There are also other boards with chipsets such as the 430TX, 82810, 82815ep, 82830, 82855, 82860, and VIA 694 that were previously supported in the old Coreboot v1 code and could potentially be ported to the modern Coreboot framework. By including support for these legacy boards, my aim is to ensure that hardware enthusiasts can once again harness the power of these vintage systems with updated firmware.

Beyond enabling compatibility, I am also focused on modernizing the capabilities of these vintage boards. This involves implementing enhancements and optimizations that improve performance, add additional controls, and enhance the overall user experience. The goal is to leverage Coreboot-Retro, enabling users to fully unlock the potential of their old systems and bring them closer to contemporary standards.

While currently a personal endeavor, Coreboot-Retro is open to contributions and collaboration from the growing retro computing community. By sharing knowledge, participating in discussions, and collectively exploring possibilities, I hope to evolve and expand the project's support for additional legacy boards.

As I continue to explore the potential of older systems, Coreboot-Retro presents an exciting opportunity to rediscover vintage hardware with modern capabilities. The project's efforts to integrate support for various old boards into the Coreboot mainline, along with its focus on modernization, embody the spirit of innovation and preservation within the retro computing community.

For a glimpse of the progress made, check out these teaser screenshots:

![]({{ site.baseurl }}/assets/2023/05/DSC_0945-839x1024.webp)  

Seabios boot screen on Shuttle AB61

![]({{ site.baseurl }}/assets/2023/05/DSC_0949-875x1024.webp)  

CPU-Z open with the board in the screen on a bench, showing Coreboot BIOS is running

![]({{ site.baseurl }}/assets/2023/05/DSC_0980-1024x768.webp)  

Mageia Linux with dmesg showing Coreboot

To explore more about the Shuttle AB61 board, you can visit the entry on theretroweb: [Shuttle AB61](https://theretroweb.com/motherboards/s/shuttle-ab61).

![]({{ site.baseurl }}/assets/2023/05/shuttle-hot-ab61v14-61c3452da5706782118066.jpg)  

### Shuttle AB61

Shuttle AB61 is a motherboard based on the Intel 440BX (Seattle) chipset. Get specs, BIOS, documentation and more!
Likewise, for the MS-5128 board, you can visit: [MSI MS-5128](https://theretroweb.com/motherboards/s/msi-ms-5128-tr4)
![]({{ site.baseurl }}/assets/2023/05/ms5128-front-605779029464c850619228.jpg)  

### MSI MS-5128 (TR4)

MSI MS-5128 (TR4) is a motherboard based on the Intel 430HX (PCIset HX Triton II) chipset. Get specs, BIOS, documentation and more!
To join and contribute to this ongoing venture, visit the Coreboot-Retro project's GitHub repository at [https://github.com/rigred/coreboot-retro](https://github.com/rigred/coreboot-retro) and checkout the branches for the

MS-5128: [https://github.com/rigred/coreboot-retro/tree/ms-5128](https://github.com/rigred/coreboot-retro/tree/ms-5128)

AB61: [https://github.com/rigred/coreboot-retro/tree/ab61-dev](https://github.com/rigred/coreboot-retro/tree/ab61-dev)

or join TheRetroWeb Discord at [https://discord.gg/HWWH7hsk2p](https://discord.gg/HWWH7hsk2p)