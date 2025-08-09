#!/bin/bash
### wrapper script to benchmark given storage device

## sudo timeout trick
sudo-timeout

## input / arguments
drive_arg=${1:-"noarg"}

if [ $drive_arg == "noarg" ]; then
    #if given no arguments, ask user for input
    lsblk -e7
    echo -en "\nWhich ${ORANGE}storage device${NOCOLOR} would you like to benchmark? "
    read drive

    sudo hdparm -Ttv /dev/$drive
else
    # else, use given argument
    sudo hdparm -Ttv /dev/$drive_arg
fi
