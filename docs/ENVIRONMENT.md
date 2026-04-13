# Environment Baseline
Generated: $(date)

## Hardware
### CPU
CPU(s):                                  4
On-line CPU(s) list:                     0-3
Model name:                              Intel(R) Core(TM) i5-5200U CPU @ 2.20GHz
Thread(s) per core:                      2
CPU(s) scaling MHz:                      74%
NUMA node0 CPU(s):                       0-3

### RAM
               total        used        free      shared  buff/cache   available
Mem:            11Gi       2.3Gi       6.7Gi       424Mi       3.1Gi       9.3Gi
Swap:          4.0Gi          0B       4.0Gi

### Disk
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       218G   17G  191G   8% /

### GPU (nếu có)
00:02.0 VGA compatible controller: Intel Corporation HD Graphics 5500 (rev 09)

### CPU Temp (idle)
coretemp-isa-0000
Adapter: ISA adapter
Package id 0:  +67.0°C  (high = +105.0°C, crit = +105.0°C)
Core 0:        +67.0°C  (high = +105.0°C, crit = +105.0°C)
Core 1:        +62.0°C  (high = +105.0°C, crit = +105.0°C)

asus-isa-0000
Adapter: ISA adapter
cpu_fan:     3000 RPM
temp1:        +60.0°C  

BAT0-acpi-0
Adapter: ACPI interface
in0:           7.60 V  
power1:        0.00 W  

radeon-pci-0400
Adapter: PCI adapter
temp1:        +45.0°C  (crit = +120.0°C, hyst = +90.0°C)

pch_wildcat_point-virtual-0
Adapter: Virtual device
temp1:        +46.0°C  

acpitz-acpi-0
Adapter: ACPI interface
temp1:        +60.0°C  
temp2:        +27.8°C  
temp3:        +29.8°C  


### GPU Radeon
00:02.0 VGA compatible controller: Intel Corporation HD Graphics 5500 (rev 09) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. HD Graphics 5500
	Flags: bus master, fast devsel, latency 0, IRQ 54
	Memory at f6000000 (64-bit, non-prefetchable) [size=16M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at f000 [size=64]
	Expansion ROM at 000c0000 [virtual] [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: i915
	Kernel modules: i915

00:03.0 Audio device: Intel Corporation Broadwell-U Audio Controller (rev 09)
	Subsystem: ASUSTeK Computer Inc. Broadwell-U Audio Controller
	Flags: bus master, fast devsel, latency 0, IRQ 55, IOMMU group 1
	Memory at f731c000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel

00:04.0 Signal processing controller: Intel Corporation Broadwell-U Processor Thermal Subsystem (rev 09)
	Subsystem: ASUSTeK Computer Inc. Broadwell-U Processor Thermal Subsystem

### Swap Configuration
Swap file: /swapfile
Swap size: 12GB
NAME      TYPE SIZE USED PRIO
/swapfile file  12G   0B   -2
