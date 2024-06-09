#!/bin/bash
## sourced upon first login
## contains code specific to saeglopur

## autosource inherited profile code
FILENAME="profile"
source /home/dante/scripts/config/autosource.sh -f $FILENAME -b

## saeglopur-specific profile code
# neofetch ASCII art update
alias neofetch='neofetch --source /home/dante/.ascii/apple.txt'
#alias neofetch='neofetch --ascii_distro macos'

# functions
wgrf() { bash "/home/dante/scripts/security/wireguard_refresh.sh" ${1}; }
export -f wgrf

# force IPv4 for apt package manager
#alias apt='apt -o Acquire::ForceIPv4=true'
