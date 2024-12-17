#!/bin/bash

# source common configs
#echo -e "${ORANGE}Refreshing environment...${nocolor}"
for file in "$(find /home/dante/scripts/configs/dotfiles/common/ -maxdepth 1 -name '*.sh' -print -quit)"; do source $file; done
#echo -e "${GREEN}Successfully refreshed environment!${nocolor}\n"
