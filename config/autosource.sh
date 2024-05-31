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

# parse args
get_arg() {
  echo "${2:-${1#*=}}"
}

while getopts 'f:wvib' flag; do
	case "${flag}" in
        f) FILENAME="${OPTARG}" ;; # -f <str>. arg sets filename to source
        w) IS_WSL=true ;;
        v) IS_VIRTUAL=true ;;
        i) IS_PIHOLE=true ;;
        b) NEEDS_BACKUP=true ;;
        *) exit 1 ;;
	esac
done

# debugging, to remove
echo $HOST
echo $ARCH
echo $FILENAME
echo $IS_WSL
echo $IS_VIRTUAL
echo $IS_PIHOLE
echo $NEEDS_BACKUP

# source default code
source ${CONFIG_ROOT}/default/${FILENAME}.sh

# source common code
source ${CONFIG_ROOT}/common/${FILENAME}.sh

# source architecture
source ${CONFIG_ROOT}/arch/${ARCH}/${FILENAME}.sh

# source policies
if [ "$IS_VIRTUAL" = true ]; then
    echo "Applying virtual machine policy"
    source ${CONFIG_ROOT}/policy/virtual/${FILENAME}.sh
fi
if [ "$IS_WSL" = true ]; then
    echo "Applying WSL2 machine policy"
    source ${CONFIG_ROOT}/policy/wsl2/${FILENAME}.sh
fi
if [ "$IS_PIHOLE" = true ]; then
    echo "Applying Pihole machine policy"
    source ${CONFIG_ROOT}/policy/pihole/${FILENAME}.sh
fi
if [ "$NEEDS_BACKUP" = true ]; then
    echo "Applying backup policy"
    source ${CONFIG_ROOT}/policy/backup/${FILENAME}.sh
fi

# TODO: refactor code into correct locations

# TODO: "todo tree" colors and recognized keywords

# TODO: docstrings and bash type hints

# TODO: write policy files

# TODO: apply changes to saeglopur

# TODO: test on each machine
