#!/bin/bash
### wrapper script to display formatted temperature data for CPU and attached storage devices
### NOTE: for hardware changes, run: sudo sensors-detect

## sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

# constants
cpu_name=`lscpu | sed -nr '/Model name/ s/.*:\s*(.*) @ .*/\1/p'` # for sed

# retrieve and format NVMe temperature
nvme_temp=`sudo smartctl -a /dev/nvme0n1 | grep "Temperature Sensor" | grep -o "...........$" | sed -e "s/ Celsius/\//" | tr -d "[:space:]" | sed "s/.$/°C/"`

# retrieve and print temps
paste \
<( sensors | grep -i "core" | sed -e "s/coretemp-isa-0000/${cpu_name}:/" ) \
<( echo -e "${underline}SATA${noformat}:" && sudo hddtemp /dev/sd?; \
echo -e "${underline}NVMe${noformat}:\n/dev/nvme0n1: Samsung SSD 980: ${nvme_temp}" ) \
| column -s $'\t' -t
