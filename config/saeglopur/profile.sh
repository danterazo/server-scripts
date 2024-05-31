#!/bin/bash
## sourced upon first login. contains code specific to saeglopur

## source default profile code
source /home/dante/scripts/config/default/profile.sh

## source common profile code
source /home/dante/scripts/config/common/profile.sh

## source common architecture profile code
source /home/dante/scripts/config/arch/x64/profile.sh

## source common physical system profile code
source /home/dante/scripts/config/platform/physical/profile.sh

## saeglopur-specific profile code
# neofetch ASCII art update
alias neofetch='neofetch --source /home/dante/.ascii/apple.txt'
#alias neofetch='neofetch --ascii_distro macos'

# force IPv4 for apt package manager
#alias apt='apt -o Acquire::ForceIPv4=true'

# functions
wgrf() { bash "/home/dante/scripts/security/wireguard_refresh.sh" ${1}; }
export -f wgrf
