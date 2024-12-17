#!/bin/bash
## installs updates in every system package manager

# sudo timeout trick
sudo-timeout

# reduce console logging
sudo dmesg -n 1

# TODO: use this comment style elsewhere
: 'Package Manager Updates'

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

# update git repo(s)
git -C /home/dante/scripts/ pull

# source common configs
source /home/dante/scripts/configs/dotfiles/refresh.sh
