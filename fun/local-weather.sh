#!/bin/sh
#
# Prints local weather information for the MOTD

city="Bloomington, IN"
ICAO="KBMG"
while getopts 'v' flag; do
  case "${flag}" in
    v) mode="verbose" ;;    # comparatively verbose
    *) mode="home" ;;
  esac
done

echo "Current conditions in ${city} (${ICAO}):"
if [[ $mode != "report" ]]; then
  weather $ICAO
else
  weather -q $ICAO
fi

echo
