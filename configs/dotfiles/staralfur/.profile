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

# source formatting script
source "${SCRIPTS_ROOT}/constants/bash_formatting.sh"

# common aliases
alias ufwl="sudo cat /var/log/ufw.log" # ufw logs
alias occ="sudo docker exec --user www-data -it nextcloud-aio-nextcloud php occ" # nextcloud AIO occ
alias gcm="git commit -m"

# common borg constants
export BORGPATH="/backup"
export BORGPASS=$(head -n 1 /home/dante/.creds/borg)

# common functions & exports
rcow() { cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n 1) "${1:-No input!}"; }
export -f rcow

gtb() { goatthink -b "${1:-No input!}"; }
export -f gtb

backup() { bash "${SCRIPTS_ROOT}/backups/backup.sh" ${1}; }
export -f backup

gcp() { gcm ${1} && git pull && git push; }
export -f gcp

# bash scripts
startup() { bash "${SCRIPTS_ROOT}/startup.sh"; }
export -f startup

lweather() { bash "${SCRIPTS_ROOT}/fun/local_weather.sh" ${1}; }
export -f lweather

bblocks() { bash "${SCRIPTS_ROOT}/hardware/bad_blocks.sh" ${1}; }
export -f bblocks

bench() { bash "${SCRIPTS_ROOT}/hardware/bench.sh" ${1}; }
export -f bench

hddsmart() { bash "${SCRIPTS_ROOT}/hardware/hdd_smart.sh" ${1}; }
export -f hddsmart

temps() { bash "${SCRIPTS_ROOT}/hardware/temps.sh"; }
export -f temps

geoip() { bash "${SCRIPTS_ROOT}/security/geoip.sh" ${1}; }
export -f geoip

rscreen() { bash "${SCRIPTS_ROOT}/config/rscreen.sh" ${1}; }
export -f rscreen

bbkp() { sudo bash "${SCRIPTS_ROOT}/backups/borg_backup.sh" ${1}; }
export -f bbkp

turbo() { bash "${SCRIPTS_ROOT}/hardware/toggle_turbo_boost.sh" ${1}; }
export -f turbo

exif-proc() { bash "${SCRIPTS_ROOT}/utils/exiftool/process_photos.sh"; }
export -f exif-proc

exif-add() { bash "${SCRIPTS_ROOT}/utils/exiftool/add_metadata.sh" ${@}; }
export -f exif-add

dx() { sudo docker exec -it ${1} /bin/bash; }
export -f dx

dxs() { sudo docker exec -it ${1} /bin/sh; }
export -f dxs

immich-clean() { bash "${SCRIPTS_ROOT}/utils/immich/immich_maintenance.sh"; }
export -f immich-clean

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
