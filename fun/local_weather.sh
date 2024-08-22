#!/bin/bash
# Prints local weather information for the MOTD

# common constants
source /home/dante/scripts/constants/icao.sh

# defaults
city="Minneapolis, MN"
ICAO="${MinneapolisICAO}"

# weather report
echo "Current conditions in ${city} (${ICAO}):"
if [[ $# == 0 ]]; then
  weather -q $ICAO
else
  weather $1 $ICAO
fi

echo
