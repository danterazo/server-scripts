#!/bin/bash
### sourced by dante's bash profiles

# source formatting
source /home/dante/scripts/constants/bash_formatting.sh

# dante's common aliases
alias startup="bash /home/dante/scripts/startup.sh"
alias temps="bash /home/dante/scripts/hardware/temps.sh"
alias ufwl="sudo cat /var/log/ufw.log"   # ufw logs
#alias sudop="while true; do sudo -nv; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &"
# alias dc="sudo docker compose up -d"

# dante's common functions & exports
lweather () { bash "/home/dante/scripts/fun/local_weather.sh" ${1}; }
export -f lweather

rcow () { cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n 1) "${1:-No input!}"; }
export -f rcow

gtb () { goatthink -b "${1:-No input!}"; }
export -f gtb

backup () { bash "/home/dante/scripts/backups/backup.sh" ${1}; }
export -f backup

gcm () { git commit -m ${1}; }
export -f gcm

gcp () { gcm ${1} && git pull && git push; }
export -f gcp

# bash scripts
bblocks () { bash "/home/dante/scripts/hardware/bad_blocks.sh" ${1}; }
export -f bblocks

bench () { bash "/home/dante/scripts/hardware/bench.sh" ${1}; }
export -f bench

hddsmart () { bash "/home/dante/scripts/hardware/hdd_smart.sh" ${1}; }
export -f hddsmart

geoip  () { bash "/home/dante/scripts/security/geoip.sh" ${1}; }
export -f geoip

rscreen  () { bash "/home/dante/scripts/config/rscreen.sh" ${1}; }
export -f rscreen

bbkp  () { bash "/home/dante/scripts/backups/borg_backup.sh" ${1}; }
export -f bbkp

turbo () { bash "/home/dante/scripts/hardware/toggle_turbo_boost.sh" ${1}; }
export -f turbo

wgrf () { bash "/home/dante/scripts/security/wireguard_refresh.sh" ${1}; }
export -f wgrf
