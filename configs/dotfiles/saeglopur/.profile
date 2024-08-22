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
source "${SCRIPTS_ROOT}/configs/dotfiles/common/aliases.sh"
source "${SCRIPTS_ROOT}/configs/dotfiles/common/constants.sh"
source "${SCRIPTS_ROOT}/configs/dotfiles/common/functions.sh"

## scala
# >>> JVM installed by coursier >>>
export JAVA_HOME="/home/dante/.cache/coursier/arc/https/github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.23%252B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.23_9.tar.gz/jdk-11.0.23+9"
export PATH="$PATH:/home/dante/.cache/coursier/arc/https/github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.23%252B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.23_9.tar.gz/jdk-11.0.23+9/bin"
# <<< JVM installed by coursier <<<

# >>> coursier install directory >>>
export PATH="$PATH:/home/dante/.local/share/coursier/bin"
# <<< coursier install directory <<<

# created by `pipx` on 2024-07-15 12:21:53
export PATH="$PATH:/home/dante/.local/bin"
