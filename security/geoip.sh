#!/bin/bash
### script for IP geolocation

## sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

## quick check
sudo wg
echo

## input / arguments
## f = full
## r = region
geoip_arg=${1:-"f"}

# formatting
echo -en "${yellow}"

# print results
region=`curl --silent "https://ipinfo.io/region"`
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
to_check=Minnesota
if [[ ${region} != *${to_check}* ]]; then
    echo -en "${green}VPN Connected!"
elif [[ ! -n ${region} ]]; then
    echo -en "${orange}VPN Status Unknown; IPInfo Unreachable!"
else
    echo -en "${red}VPN Disconnected!"
fi


# end formatting
echo -e "${nocolor}"
echo
