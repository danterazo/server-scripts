#!/bin/bash
## sourced when new session is opened. contains stuff specific to ovedur (ubuntu, wsl2)

# clear borg backup alias
unset -f bbkp

# add alias for windows path conversion
wp () { wslpath ${1}; }
export -f wp

# add cd w/ windows path conversion
cdw() { cd wp; }
export -f cdw

# cd "$(find -name script.py -type f -printf '%h\n' -quit)"

# fn() {
#     helper1() { : defines another function which it can call; }
#     helper2() { : and another; }
#     helper1 "$@" | helper2 "$@"     #processes args twice over pipe
#     command "$@"; list;             #without altering its args
# }
