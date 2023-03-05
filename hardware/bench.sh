#!/bin/bash
### wrapper script to benchmark given storage device

## imports
source ~/scripts/constants/bash_colors.sh

## sudo timeout trick
while true; do sudo -nv; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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
