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

# source formatting
source /home/dante/scripts/constants/bash_formatting.sh

# common aliases
alias ufwl="sudo cat /var/log/ufw.log" # ufw logs

# common borg constants
export BORGPATH="/backup"
export BORGPASS=$(head -n 1 /home/dante/.creds/borg)

# common functions & exports
rcow() { cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n 1) "${1:-No input!}"; }
export -f rcow

gtb() { goatthink -b "${1:-No input!}"; }
export -f gtb

backup() { bash "/home/dante/scripts/backups/backup.sh" ${1}; }
export -f backup

gcm() { git commit -m ${1}; }
export -f gcm

gcp() { gcm ${1} && git pull && git push; }
export -f gcp

# bash scripts
startup() { bash "/home/dante/scripts/startup.sh"; }
export -f startup

lweather() { bash "/home/dante/scripts/fun/local_weather.sh" ${1}; }
export -f lweather

bblocks() { bash "/home/dante/scripts/hardware/bad_blocks.sh" ${1}; }
export -f bblocks

bench() { bash "/home/dante/scripts/hardware/bench.sh" ${1}; }
export -f bench

hddsmart() { bash "/home/dante/scripts/hardware/hdd_smart.sh" ${1}; }
export -f hddsmart

temps() { bash "/home/dante/scripts/hardware/temps.sh"; }
export -f temps

geoip() { bash "/home/dante/scripts/security/geoip.sh" ${1}; }
export -f geoip

rscreen() { bash "/home/dante/scripts/config/rscreen.sh" ${1}; }
export -f rscreen

bbkp() { sudo bash "/home/dante/scripts/backups/borg_backup.sh" ${1}; }
export -f bbkp

turbo() { bash "/home/dante/scripts/hardware/toggle_turbo_boost.sh" ${1}; }
export -f turbo

exif-proc() { bash "/home/dante/scripts/utils/exiftool/process_photos.sh"; }
export -f exif-proc

exif-add() { bash "/home/dante/scripts/utils/exiftool/add_metadata.sh" ${@}; }
export -f exif-add

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

# for ufw-docker

