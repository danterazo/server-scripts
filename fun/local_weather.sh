#!/bin/sh
# Prints local weather information for the MOTD

# bash formatting
source /home/dante/scripts/constants/bash_formatting.sh

# defaults
#city="Bloomington, IN"
#ICAO="KBMG"
city="Minneapolis, MN"
ICAO="KMSP"

# weather report
echo "Current conditions in ${city} (${ICAO}):"
if [[ $# == 0 ]]; then
  weather -q $ICAO
else
  weather $1 $ICAO
fi

echo
