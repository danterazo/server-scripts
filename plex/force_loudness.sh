#!/bin/sh
### force loudness analysis on entire Plex music library

## env variables
export LD_LIBRARY_PATH=/usr/lib/plexmediaserver:/usr/lib/plexmediaserver/lib
export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/var/lib/plexmediaserver/Library/Application\ Support

## common constants
source /home/dante/scripts/constants/bash_formatting.sh
source /home/dante/scripts/constants/sudo_timeout.sh

## input / arguments
show_logs="false"
while getopts 'v' flag; do
  case "${flag}" in
	v) show_logs="true" ;;	# show logs if "-v" is passed in. V for verbose
  esac
done

if [ $show_logs == "true" ]; then
    # if given no arguments, watch logs (work doesn't show in the Plex GUI)
    echo -n -e "${yellow}Loudness analysis job started!${green} Printing logs:${nocolor}\n"
    /usr/lib/plexmediaserver/'Plex Media Scanner' --analyze-loudness --section 2 --force &
    tail -f "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Logs/Plex Media Server.log"
else
    # if given "false" or no argument, skip logs
    echo -n -e "${yellow}Loudness analysis job started!${red} Skipping logs.${nocolor}\n"
    /usr/lib/plexmediaserver/'Plex Media Scanner' --analyze-loudness --section 2 --force &
fi
