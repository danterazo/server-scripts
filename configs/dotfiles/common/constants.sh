#!/bin/bash

: 'Terminal'
# terminal colors
export RED="\033[0;31m"
export GREEN="\033[0;32m"
export ORANGE="\033[0;33m"
export YELLOW="\033[1;33m"
export NOCOLOR="\033[0m"

# terminal formatting
export BOLD="\e[1m"
export ITALIC="\e[3m"
export UNDERLINE="\e[4m"
export STRIKETHROUGH="\e[9m"
export NOFORMAT="\e[0m"

:'App Configs'
# borg
export BORGPATH="/backup"
export BORGPASS=$(head -n 1 /home/dante/.creds/borg)

# rclone
export RCLONE_CONFIG="/home/dante/.config/rclone/rclone.conf"

# python
#export PYENV_VERSION="3.13.0"

# ICAO
export BloomingtonICAO="KBMG"
export MinneapolisICAO="KMSP"
