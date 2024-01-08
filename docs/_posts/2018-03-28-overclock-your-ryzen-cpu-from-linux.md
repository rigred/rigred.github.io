---
title: "Overclock your Ryzen CPU from linux"
date: 2018-03-28
excerpt: "Overclock your Ryzen CPU without the UEFI while running Linux, no proprietary tools needed."
categories:
  - Software
  - Overclocking
tags:
  - AMD
  - Zen 1
  - Overclocking
  - MSR
---

If you happen to have a 1st generation Ryzen CPU you may well have tried overclocking it. Usually this is done via the Mainboard UEFI interface.
Except here I am are going to do things differently! 

On Windows there exists 'Ryzen Master', a tool provided by AMD to overclock a Ryzen CPU from an easy to use interface while the system is running.
But I am running Linux and want to do the same. What's there to do?
<!--more-->

With this little python application and the help of MSR's (Model Specific Registers) on Ryzen CPU's you can manually overclock your Ryzen processor while it's 
running!

And I will show you how!

## Load kernel modules
These should come as standard on any distro
```sh 
sudo modprobe msr cpuid
```

## Download the tool

https://github.com/r4m0n/ZenStates-Linux/

```sh
git clone https://github.com/r4m0n/ZenStates-Linux.git
```

Now once that's done it's time to get well acquainted with your processor

## Run zenstates

```sh
sudo ./zenstates.py  -l
```

### State tables

For a 1700X on stock settings you should see something like this

> P0 - Enabled - FID = 88 - DID = 8 - VID = 20 - Ratio = 34.00 - vCore = 1.35000  
> P1 - Enabled - FID = 78 - DID = 8 - VID = 2C - Ratio = 30.00 - vCore = 1.27500  
> P2 - Enabled - FID = 84 - DID = C - VID = 68 - Ratio = 22.00 - vCore = 0.90000  
> P3 - Disabled  
> P4 - Disabled  
> P5 - Disabled  
> P6 - Disabled  
> P7 - Disabled  
> C6 State - Package - Enabled  
> C6 State - Core - Enabled  

For a stock 1800X it looks like this:

> P0 - Enabled - FID = 90 - DID = 8 - VID = 20 - Ratio = 36.00 - vCore = 1.35000  
> P1 - Enabled - FID = 80 - DID = 8 - VID = 2C - Ratio = 32.00 - vCore = 1.27500  
> P2 - Enabled - FID = 84 - DID = C - VID = 68 - Ratio = 22.00 - vCore = 0.90000  
> P3 - Disabled  
> P4 - Disabled  
> P5 - Disabled  
> P6 - Disabled  
> P7 - Disabled  
> C6 State - Package - Enabled  
> C6 State - Core - Enabled  

### Warning

> Most Ryzen CPU's only seem to support P-states P0, P1 and P2.

All values are set in hexadecimal values and require a bit of thought and math to use safely 

> **YOU CAN TOTALLY BREAK THINGS HERE!**

> You and only you the reader take responsibility for performing any of the actions described here on your system. 
> Don't come crying to me if you entered the wrong values and flames came shooting out of your Hardware.

### Explanation of Values
* FID – Frequency ID in Hexadecimal
* VID – Voltage ID in Hexadecimal
* DID – Divisor ID in Hexadecimal
* Ratio - CPU Clock Ratio * 100Mhz to get Full CPU base frequency
* vCore - The actual CPU base voltage (This will vary with Line Load)

This in all works very similar to what you see in your BIOS P-states settings under the AMD CBS menu.

### Calculations

For a standard DID value of 8 the FID value is calculated as follows:

> (CPU ratio * 4) = FID(Decimal)

So lets take an example for 3900Mhz.
This means we want a ratio of 39.
> 39 x 4 = 156

Now we convert 156 to hexadecimal to get `9C`

To help you here is a table of all the common VID's, and FID's

### FID Table

| FID | Base Clock (MHz) |
| :-: | :--------------: |
| 90  |       3600       |
| 91  |       3625       |
| 92  |       3650       |
| 93  |       3675       |
| 94  |       3700       |
| 95  |       3725       |
| 96  |       3750       |
| 97  |       3775       |
| 98  |       3800       |
| 99  |       3825       |
| 9a  |       3850       |
| 9b  |       3875       |
| 9c  |       3900       |
| 9d  |       3925       |
| 9e  |       3950       |
| 9f  |       3975       |
| a0  |       4000       |
| a1  |       4025       |
| a2  |       4050       |
| a3  |       4075       |
| a4  |       4100       |

### VID Table

| VID | Voltage (V) |
| :-: | :---------: |
| 30  |   1.2500    |
| 2f  |   1.2560    |
| 2e  |   1.2562    |
| 2d  |   1.2680    |
| 2c  |   1.2750    |
| 2b  |   1.2812    |
| 2a  |   1.2870    |
| 29  |   1.2930    |
| 28  |   1.3000    |
| 27  |   1.3062    |
| 26  |   1.3125    |
| 25  |   1.3180    |
| 24  |   1.3250    |
| 23  |   1.3312    |
| 22  |   1.3375    |
| 21  |   1.3430    |
| 20  |   1.3500    |
| 1f  |   1.3560    |
| 1e  |   1.3625    |
| 1d  |   1.3680    |
| 1c  |   1.3750    |
| 1b  |   1.3812    |
| 1a  |   1.3875    |
| 19  |   1.3937    |
| 18  |   1.4000    |
| 17  |   1.4060    |
| 16  |   1.4125    |
| 15  |   1.4180    |
| 14  |   1.4250    |
| 13  |   1.4321    |
| 12  |   1.4375    |
| 11  |   1.4430    |
| 10  |   1.4500    |

### Example Clocks

These are based on rough CPU quality binning estimates

#### Ryzen 7 1700

> 97% reach 3.8GHz @ 1.376V  
> 70% reach 3.9GHz @ 1.408V  
> 20% reach 4.0GHz @ 1.440V  

#### Ryzen 7 1700X

> 100% reach 3.8GHz @ 1.360V  
> 77% reach 3.9GHz @ 1.392V  
> 33% reach 4.0GHz @ 1.424V  

#### Ryzen 7 1800X

> 100% reach 3.8GHz (assumed)  
> 97% reach 3.9GHz @ 1.376V  
> 67% reach 4.0GHz @ 1.408V  
> 20% reach 4.1GHz @ 1.440V  

For most 1700X I have simply set both P0 and P1 to 3800MHz with the following settings, yours may differ. And 1.35V is generally safe for 3.8Ghz.
Obviously all of these have to be executed as root with the `msr` and `cpuid` modules loaded.

## Overclocking

> P0 = 3.800GHz, 1.3500v  
```sh
./zenstates.py -p 0 -f 98 -d 8 -v 20
```

> P1 = 3.800GHz, 1.3500v  
```sh
./zenstates.py -p 1 -f 98 -d 8 -v 20
```

> P2 = 2.200GHz, 0.9000v (The Power saving Idle state)  
```sh
./zenstates.py -p 2 -f 84 -d C -v 68
```

## Making it persistent

Now if you want to have your system load these settings at startup you can create a simple systemd service as follows:

First ensure that the necessary modules are loaded:

```sh
sudoedit /etc/modules-load.d/cpu.conf
```

Now in this file simply enter these two lines and save it.

```text
msr
cpuid
```

This will ensure that your kernel loads these two modules at startup.

First copy `zenstates.py` from the local directory to `/usr/local/bin/`

```sh
sudo cp ./zenstates.py /usr/local/bin/
```
Then make sure it's still executable
```sh
sudo chmod +x /usr/local/bin/zenstates.py
```

Now create our shell script that will invoke zenstates.py in `/usr/local/bin`

```sh
sudoedit /usr/local/bin/enable-pstates
```

Add the following lines and save it
```sh
#!/bin/sh
## The default configuration incase you want to revert
#       P0 - Enabled - FID = 88 - DID = 8 - VID = 20 - Ratio = 34.00 - vCore = 1.35000
#       P1 - Enabled - FID = 78 - DID = 8 - VID = 2C - Ratio = 30.00 - vCore = 1.27500
#       P2 - Enabled - FID = 84 - DID = C - VID = 68 - Ratio = 22.00 - vCore = 0.90000

## P0 = 3.800GHz, 1.3500v
zenstates.py -p 0 -f 98 -d 8 -v 20

## P1 = 3.800GHz, 1.3500v
zenstates.py -p 1 -f 98 -d 8 -v 20

## P2 = 2.200GHz, 0.9000v
zenstates.py -p 2 -f 84 -d C -v 68

## List the result.
zenstates.py -l
```

### Startup script

Now make the script executable
```sh
sudo chmod +x /usr/loca/bin/enable-pstates
```

### Systemd service

Next up create a new file for our systemd service
```sh
sudoedit /etc/systemd/system/ryzen-overclock.service
```
This will be our systemd service file that will get tell systemd to run our small bash script very early at boot for maximum benefit

```text
[Unit]
Description=Ryzen Overclock
DefaultDependencies=no
After=sysinit.target local-fs.target
Before=basic.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/enable-pstates

[Install]
WantedBy=basic.target
```

Now reload your systemd services for good measure

```sh
sudo systemctl daemon-reload
```

And enable the service to run at startup

```sh
sudo systemctl enable ryzen-overclock
```

You can now either reboot or manually start the service via `systemctl` and enjoy your overclock.

```sh
sudo systemctl start ryzen-overclock
```

FIN