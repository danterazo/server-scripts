#!/bin/bash
### script to update wireguard configs

## sudo timeout trick
sudo-timeout

## constants
CONFIG_SRC=/home/dante/.config/wireguard/
CONFIG_DST=/etc/wireguard/
WG_NAME=wg0

## input / arguments
NEW_WG_PROFILE=${1:-"noarg"}

## defaults
default_wg_profile=us-co-10

if [ ${NEW_WG_PROFILE} == "noarg" ]; then
    # if given no arguments, ask user for input
    echo
    sudo ls $CONFIG_SRC | sed s:.conf:: | sort -u
    echo -en "\nWhich ${ORANGE}Wireguard Profile${NOCOLOR} would you like to use? "
    read NEW_WG_PROFILE
else
    # else, use given argument
    NEW_WG_PROFILE=${1}
fi

# bring down VPN and deluge service
echo -e "Stopping Deluge and Wireguard..."
sudo service deluged stop
sudo wg-quick down ${WG_NAME}
echo

# copy
echo -e "Applying ${ORANGE}${NEW_WG_PROFILE}${NOCOLOR} profile"
sudo cp ${CONFIG_SRC}${NEW_WG_PROFILE}.conf ${CONFIG_DST}${WG_NAME}.conf
echo

# restore VPN and deluge
echo -e "Starting Deluge and Wireguard..."
sudo service deluged start
sudo wg-quick up ${WG_NAME}
