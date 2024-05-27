#!/bin/bash
### script to update wireguard configs

## sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

## constants
wg_profile_src_dir=/home/dante/.config/wireguard/
wg_profile_dst_dir=/etc/wireguard/
wg_service_name=wg0

## input / arguments
new_wg_profile=${1:-"noarg"}

## defaults
default_wg_profile=us-co-10

if [ $new_wg_profile == "noarg" ]; then
    # if given no arguments, ask user for input
    echo
    sudo ls $wg_profile_src_dir | sed s:.conf:: | sort -u
    echo -en "\nWhich ${orange}Wireguard Profile${nocolor} would you like to use? "
    read new_wg_profile
else
    # else, use given argument
    new_wg_profile=${1}
fi

# bring down VPN and deluge service
echo -e "Stopping Deluge and Wireguard..."
sudo service deluged stop
sudo wg-quick down ${wg_service_name}
echo

# copy
echo -e "Applying ${orange}${new_wg_profile}${nocolor} profile"
sudo cp ${wg_profile_src_dir}${new_wg_profile}.conf ${wg_profile_dst_dir}${wg_service_name}.conf
echo

# restore VPN and deluge
echo -e "Starting Deluge and Wireguard..."
sudo service deluged start
sudo wg-quick up ${wg_service_name}
