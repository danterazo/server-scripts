#!/bin/bash
### script for IP geolocation

## common
source /home/dante/scripts/constants/bash_formatting.sh
source /home/dante/scripts/constants/sudo_timeout.sh

## input / arguments
## f = full
## r = region
geoip_arg=${1:-"f"}

# curl --silent "https://ipinfo.io/"

# formatting
echo -en "${yellow}"

# print results
if [[ $geoip_arg == "f" ]]; then
    # if given no arguments, print full report
    curl --silent "https://ipinfo.io/"
elif [[ $geoip_arg == "f" ]]; then
    curl --silent "https://ipinfo.io/region"
else
    # else, use region
    curl --silent "https://ipinfo.io/region"
fi

# end formatting
echo -e "${nocolor}"
