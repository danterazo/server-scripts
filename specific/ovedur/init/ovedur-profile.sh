#!/bin/bash
## sourced when new session is opened. contains stuff specific to ovedur (ubuntu, wsl2)

# clear borg backup alias
unset -f bbkp

# add alias for windows path conversion
wp () { wslpath ${1}; }
export -f wp

# add cd w/ windows path conversion
cdw () { cd $(wslpath "${1}"); }
export -f cdw
