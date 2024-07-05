#!/bin/bash
## this script, given a few args, sources the desired config files

# evaluate variables
HOST=$(hostname)
ARCH=$(arch | sed -e 's:^x86_64$:x64:' -e 's:^aarch64$:arm64:')

# define paths
CONFIG_ROOT="/home/dante/scripts/config"

# assign defaults to policy (bool) parameters
IS_WSL=false
IS_VIRTUAL=false
IS_PIHOLE=false
NEEDS_BACKUP=false
HAS_BREW=false
HAS_NVM=false

# parse args
get_arg() {
    echo "${2:-${1#*=}}"
}

while getopts 'f:bhwvl' flag; do
    case "${flag}" in
    f) FILENAME="${OPTARG}" ;; # -f <str>. arg sets filename to source
    b) NEEDS_BACKUP=true ;;
    h) HAS_BREW=true ;;
    w) IS_WSL=true ;;
    l) IS_PIHOLE=true ;;
    n) HAS_NVM=true ;;
    *) exit 1 ;;
    esac
done

# source default code
source ${CONFIG_ROOT}/default/${FILENAME}.sh

# BUG: this doesn't seem to source properly
# source common code
source ${CONFIG_ROOT}/common/${FILENAME}.sh

# source architecture code
source ${CONFIG_ROOT}/arch/${ARCH}/${FILENAME}.sh >/dev/null 2>&1

# source policies
if [ "$IS_WSL" = true ]; then
    source ${CONFIG_ROOT}/policy/wsl2/${FILENAME}.sh >/dev/null 2>&1
fi
if [ "$IS_PIHOLE" = true ]; then
    source ${CONFIG_ROOT}/policy/pihole/${FILENAME}.sh >/dev/null 2>&1
fi
if [ "$NEEDS_BACKUP" = true ]; then
    source ${CONFIG_ROOT}/policy/backup/${FILENAME}.sh >/dev/null 2>&1
fi
if [ "$HAS_BREW" = true ]; then
    source ${CONFIG_ROOT}/policy/brew/${FILENAME}.sh >/dev/null 2>&1
fi
if [ "$HAS_NVM" = true ]; then
    source ${CONFIG_ROOT}/policy/nvm/${FILENAME}.sh >/dev/null 2>&1
fi
