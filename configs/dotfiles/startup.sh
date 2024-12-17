#!/bin/bash
## dante's system startup/update script

# install updates
source /home/dante/scripts/configs/dotfiles/updates.sh

# use custom startup scripts
# for f in /home/dante/scripts/specific/$(hostname)/*.sh; do
#   bash "$f"
# done

: 'Backups'
# perform Borg backup
#bbkp

: 'Fun'
# print daily wisdom
goatthink -b -W 60 "It don't take a genius to spot a goat in a flock of sheep."
#sleep 3

: 'System & Performance'
# display stats
btop # new C++ version
