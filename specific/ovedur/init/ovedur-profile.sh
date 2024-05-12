#!/bin/bash
## sourced when new session is opened. contains stuff specific to ovedur (ubuntu, wsl2)

## overrides
# neofetch ASCII art update
alias neofetch='neofetch --source /home/dante/.ascii/apple.txt'
#alias neofetch='neofetch --ascii_distro macos'

# force IPv4 for apt
#alias apt='apt -o Acquire::ForceIPv4=true'
