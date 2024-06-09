#!/bin/bash
## sourced upon first login
## contains code specific to smaskifa

## autosource inherited profile code
FILENAME="profile"
source /home/dante/scripts/config/autosource.sh -f $FILENAME -bl

## smaskifa-specific profile code
# neofetch ASCII art update
alias neofetch='neofetch --ascii_distro Raspbian'
