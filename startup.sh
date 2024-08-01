#!/bin/bash
### dante's system startup/update script

# sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

# reduce console logging
sudo dmesg -n 1

## package updates
# update ubuntu packages
sudo apt update -y
sudo apt upgrade -y

# clean up old ubuntu packages
sudo apt autoremove -y

# update snap packages
sudo snap refresh

# update rubygems packages
gem update

# update git repos
git -C /home/dante/scripts/ pull

# use custom update scripts
# for f in /home/dante/scripts/specific/$(hostname)/*.sh; do
#   bash "$f"
# done

# perform Borg backup
bbkp

# print daily wisdom
goatthink -b -W 60 "It don't take a genius to spot a goat in a flock of sheep."
#sleep 3

# display stats
btop # new C++ version
