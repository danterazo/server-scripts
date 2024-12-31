#!/bin/bash
## sourced upon first login
## contains common code for all systems

## default code
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# define scripts root
export SCRIPTS_ROOT="/home/dante/scripts"

# source common stuff
source "${SCRIPTS_ROOT}/configs/dotfiles/refresh.sh"

# pipx
export PATH="$PATH:/home/dante/.local/bin"

# docker global
export TZ="America/Indiana/Indianapolis"
