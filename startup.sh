#!/bin/bash
### dante's system startup/update script

# sudo timeout trick
sudo-timeout

# reduce console logging
sudo dmesg -n 1

# TODO: use this comment style elsewhere
: 'Package Manager Updates'

## package updates
# update ubuntu packages
sudo apt update -y
sudo apt upgrade -y

# clean up old ubuntu packages
sudo apt autoremove -y

# update snap packages
sudo snap refresh

# update rubygems packages
sudo gem update
sudo gem cleanup

: 'Environment Management'

# update git repos
git -C /home/dante/scripts/ pull

# source common configs
for file in "$(find /home/dante/scripts/configs/dotfiles/common/ -maxdepth 1 -name '*.sh' -print -quit)"; do source $file; done

# use custom update scripts
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
