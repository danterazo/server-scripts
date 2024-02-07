#!/bin/bash
### wrapper script to detect bad blocks on given storage device

## sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

## input / arguments
drive_arg=${1:-"noarg"}

if [ $drive_arg == "noarg" ]; then
    # if given no arguments, ask user for input
    lsblk -e7
    echo -en "\nWhich ${orange}storage device${nocolor} would you like to benchmark? "
    read drive

    sudo badblocks -b 4096 -v /dev/$drive
else
    # else, use given argument
    sudo badblocks -b 4096 -v /dev/$drive_arg
fi
