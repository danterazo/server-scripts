#!/bin/bash
## a collection of common functions

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

sudo-timeout() {
    while true; do
    sudo -nv
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &
}
export -f sudo-timeout
