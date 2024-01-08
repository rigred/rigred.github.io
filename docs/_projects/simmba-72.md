---
title: SIMMBA-72 (128MB 72pin RAM)
date: 2022-03-25 08:04:15.000000000 +02:00
type: page
header:
 teaser: /assets/2022/03/128MB EDO 72 SIMM.jpg
categories: 
 - Projects
tags: 
 - PCB
---

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

![Image]({{ site.baseurl }}/assets/2022/03/SIMMBA-72-SideA.png)  

Side A of SIMMBA Revision A1 (January 2022)

![Image]({{ site.baseurl }}/assets/2022/03/SIMMBA-72_SideB.png)  

Side B of SIMMBA Revision A1 (January 2022)