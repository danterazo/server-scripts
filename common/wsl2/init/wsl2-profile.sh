#!/bin/bash
## sourced when new session is opened. contains stuff common to all WSL2 installations

# clear borg backup alias
unset -f bbkp

# add alias for windows path conversion
wp() { wslpath ${1}; }
export -f wp

# TODO: finish this code
# add intelligent windows path conversion to cd
cdw() {
    if [[ ${1} == *":"* ]]; then
        wsl_path=$(wslpath "$1")
        # echo "Translated Path: ${wsl_path}"
        cd $(wslpath "${wsl_path}")
    else
        cd "$1"
    fi
}
export -f cdw
# alias cd=wcd
