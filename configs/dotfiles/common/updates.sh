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
echo -e "${ORANGE}Refreshing environment...${nocolor}"
for file in "$(find /home/dante/scripts/configs/dotfiles/common/ -maxdepth 1 -name '*.sh' -print -quit)"; do source $file; done
echo -e "${GREEN}Successfully refreshed environment!${nocolor}\n"
