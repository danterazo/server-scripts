#!/bin/bash
### dante's startup script

## sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

## source machine-specific startup commands, if any
source /home/dante/scripts/specific/$(hostname)/init/$(hostname)-startup.sh

## get and apply updates
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo snap refresh

# update git repos
git -C /home/dante/scripts/ pull

## use custom update scripts
# for f in /home/dante/scripts/updates/*.sh; do
#   bash "$f" 
# done

# perform backup
bbkp

## daily wisdom
goatthink -b -W 60 "It don't take a genius to spot a goat in a flock of sheep."
#sleep 3

## stats
btop    # new C++ version
