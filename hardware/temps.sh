#!/bin/bash
### wrapper script to display formatted temperature data for CPU and attached storage devices
### NOTE: for hardware changes, run: sudo sensors-detect

## imports
source /home/dante/scripts/constants/bash_formats.sh

## sudo timeout trick
while true; do sudo -nv; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# constants
find="coretemp-isa-0000"
replace="Intel i5-10600K:"

# evaluations
nvme_temp=`sudo smartctl -a /dev/nvme0n1 | grep "Temperature Sensor" | grep -o "...........$" | sed -e "s/ Celsius/\//" | tr -d "[:space:]" | sed "s/.$/°C/"`

# print temps
paste \
<( sensors | grep -i "core" | sed -e "s/${find}/${replace}/" ) \
<( echo -e "${underline}SATA${noformat}:" && sudo hddtemp /dev/sd?; \
echo -e "${underline}NVMe${noformat}:\n/dev/nvme0n1: Samsung SSD 980: ${nvme_temp}" ) \
| column -s $'\t' -t
