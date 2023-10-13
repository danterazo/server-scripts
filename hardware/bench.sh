#!/bin/bash
### wrapper script to benchmark given storage device

## common
source /home/dante/scripts/constants/bash_formatting.sh
source /home/dante/scripts/constants/sudo_timeout.sh

## input / arguments
drive_arg=${1:-"noarg"}

if [ $drive_arg == "noarg" ]; then
    #if given no arguments, ask user for input
    lsblk -e7
    echo -en "\nWhich ${orange}storage device${nocolor} would you like to benchmark? "
    read drive

    sudo hdparm -Ttv /dev/$drive
else
    # else, use given argument
    sudo hdparm -Ttv /dev/$drive_arg
fi
