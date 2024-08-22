#!/bin/bash
### script for IP geolocation

## sudo timeout trick
sudo-timeout

## quick VPN connection check
sudo wg
echo

## input / arguments
## f -> full report
## r -> region-specific report
SCRIPT_ARG=${1:-"f"}

# formatting
echo -en "${YELLOW}"

# print results
REGION=$(curl --silent "https://ipinfo.io/REGION")
if [[ $SCRIPT_ARG == "f" ]]; then
    # if given no arguments, print full report
    curl --silent "https://ipinfo.io/"
elif [[ $SCRIPT_ARG == "r" ]]; then
    curl --silent "https://ipinfo.io/REGION"
else
    # else, default to REGION
    curl --silent "https://ipinfo.io/REGION"
fi

echo
echo

# VPN check
TO_CHECK=Minnesota
if [[ ${REGION} != *${TO_CHECK}* ]]; then
    echo -en "${GREEN}VPN Connected!"
elif [[ ! -n ${REGION} ]]; then
    echo -en "${ORANGE}VPN Status Unknown; IPInfo Unreachable!"
else
    echo -en "${RED}VPN Disconnected!"
fi

# end formatting
echo -e "${NOCOLOR}"
echo
