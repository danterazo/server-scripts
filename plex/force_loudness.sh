#!/bin/bash
### force loudness analysis on entire Plex music library

## env variables
export LD_LIBRARY_PATH=/usr/lib/plexmediaserver:/usr/lib/plexmediaserver/lib
export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/var/lib/plexmediaserver/Library/Application\ Support

## sudo timeout trick
sudo-timeout

## local constants
plex_music_lib=2
plex_scanner_path=/usr/lib/plexmediaserver/'Plex Media Scanner'

## input / arguments
scan="true" # either "true", "false", or "force"
logs="true" # either "true" or "false"
while getopts 'fvlq' flag; do
    case "${flag}" in
    f) scan="force" ;;                # toggle force flag in scanner task
    s) scan="true" ;;                 # kick off normal scan
    v) logs="true" ;;                 # show logs if "-v" is passed in. V for verbose
    q) logs="false" ;;                # hide logs if "-q". Q for quiet
    l) scan="false" && logs="true" ;; # show ONLY logs. don't kick off loudness analysis. just a shortcut
    esac
done

# scan types
if [ $scan == "true" ]; then
    # kick off normal scan (potentially not as thorough)
    echo -n -e "${ORANGE}Loudness analysis job started!${NOCOLOR}\n"
    $plex_scanner_path --analyze-loudness --section $plex_music_lib &
elif [ $scan == "force" ]; then
    # kick off forced scan
    echo -n -e "${ORANGE}Loudness analysis job started!${NOCOLOR}\n"
    $plex_scanner_path --analyze-loudness --section $plex_music_lib --force &
else
    # if given "false" or no argument, skip scan
    echo -n -e "${RED}Skipped loudness analysis.${NOCOLOR}\n"
fi

# logs display
if [ $logs == "true" ]; then
    # if given "true" OR no arguments, watch logs (work doesn't appear in the Plex GUI)
    echo -n -e "${YELLOW}Printing logs:${NOCOLOR}\n"
    tail -f "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Logs/Plex Media Server.log" | grep loudness # grep by default
else
    :
fi
