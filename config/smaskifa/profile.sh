#!/bin/bash
## sourced upon first login. contains code specific to smaskifa

## source default profile code
source /home/dante/scripts/config/default/profile.sh

## source common profile code
source /home/dante/scripts/config/common/profile.sh

## source common architecture profile code
source /home/dante/scripts/config/arch/arm64/profile.sh

## source common physical system profile code
source /home/dante/scripts/config/platform/physical/profile.sh

## smaskifa-specific profile code
# neofetch ASCII art update
alias neofetch='neofetch --ascii_distro Raspbian'
