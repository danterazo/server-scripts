#!/bin/bash

# source common configs
#echo -e "${ORANGE}Refreshing environment...${nocolor}"
# for file in "$(find ${SCRIPTS_ROOT}/configs/dotfiles/common/ -maxdepth 1 -name "*.sh" -print -quit)"; do source $file; done
source ${SCRIPTS_ROOT}/configs/dotfiles/common/01-constants.sh
source ${SCRIPTS_ROOT}/configs/dotfiles/common/02-aliases.sh
source ${SCRIPTS_ROOT}/configs/dotfiles/common/03-functions.sh
#echo -e "${GREEN}Successfully refreshed environment!${nocolor}\n"
