#!/bin/bash
### script for IP geolocation

## sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

## input / arguments
## f = full
## r = region
geoip_arg=${1:-"f"}

# curl --silent "https://ipinfo.io/"

# formatting
echo -en "${yellow}"

# print results
city=`curl --silent "https://ipinfo.io/city"`
if [[ $geoip_arg == "f" ]]; then
    # if given no arguments, print full report
    curl --silent "https://ipinfo.io/"
elif [[ $geoip_arg == "r" ]]; then
    curl --silent "https://ipinfo.io/region"
else
    # else, default to region
    curl --silent "https://ipinfo.io/region"
fi

echo
echo

# VPN "check"
to_check=Minneapolis
if [[ ${city} != *${to_check}* ]];then
    # testmystring does not contain c0
    echo -en "${green}VPN Connected!"
else
    echo -en "${red}VPN Disconnected!"
fi


# end formatting
echo -e "${nocolor}"
echo
