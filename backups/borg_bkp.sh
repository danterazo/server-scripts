#!/bin/bash
### script to initiate borg backups

## input / arguments
mode=${1:-"c"}

## sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

# local variables
borg_bkp_name=sgsys_$(date +%Y-%m-%d_%H-%M-%S)
compression_lvl=9   # go big or go home

## funny goat go baaaaaaa
goatthink -b "Kicking off Borg system backup job."

# kick off borg backup of entire system
borg create --compression lz4,$compression_lvl $BORGPATH::$borg_bkp_name /

if [[ $mode == "c" ]]; then
    goatthink -b "Compacting Borg Repo: $BORGREPO."
    borg compact $BORGPATH
fi
