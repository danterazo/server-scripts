#!/bin/bash
## a collection of common constants

# terminal colors
export red="\033[0;31m"
export green="\033[0;32m"
export orange="\033[0;33m"
export yellow="\033[1;33m"
export nocolor="\033[0m"

# terminal formatting
export bold="\e[1m"
export italic="\e[3m"
export underline="\e[4m"
export strikethrough="\e[9m"
export noformat="\e[0m"

# borg
export BORGPATH="/backup"
export BORGPASS=$(head -n 1 /home/dante/.creds/borg)

# ICAO
export btownICAO="KBMG"
export mplsICAO="KMSP"
