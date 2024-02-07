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
output=""
if [[ $geoip_arg == "f" ]]; then
    # if given no arguments, print full report
    output=`curl --silent "https://ipinfo.io/"`
elif [[ $geoip_arg == "f" ]]; then
    output=`curl --silent "https://ipinfo.io/region"`
else
    # else, use region
    output=`curl --silent "https://ipinfo.io/region"`
fi

echo $output
echo

# VPN "check"
to_check=Minneapolis
if [[ ${output} != *${to_check}* ]];then
    # testmystring does not contain c0
    echo "VPN connected!"
fi


# end formatting
echo -e "${nocolor}"
