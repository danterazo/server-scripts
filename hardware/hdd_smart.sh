#!/bin/bash
### wrapper script to query SMART data for given storage device

## common
source /home/dante/scripts/constants/bash_formatting.sh
source /home/dante/scripts/constants/sudo_timeout.sh

## input / arguments
drive_arg=${1:-"noarg"}

if [[ $drive_arg == "noarg" ]]; then
    #if given no arguments, ask user for input
    lsblk -e7
    echo -en "\nWhich ${orange}storage device${nocolor} would you like to review? "
    read drive

    sudo smartctl -Ai /dev/$drive
else
    # else, use given argument
    sudo smartctl -Ai /dev/$drive_arg
fi
