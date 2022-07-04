#!/bin/bash

## bash colors
red="\033[0;31m"
green="\033[0;32m"
orange="\033[0;33m"
yellow="\033[1;33m"
nocolor="\033[0m"

## input / arguments
drive_arg=${1:-"noarg"}

if [ $drive_arg == "noarg" ]; then
    #if given no arguments, ask user for input
    lsblk
    echo -en "\nWhich ${orange}drive${nocolor} would you like to benchmark? "
    read drive

    sudo hdparm -Ttv /dev/$drive
else
    # else, use given argument
    sudo hdparm -Ttv /dev/$drive_arg
fi
