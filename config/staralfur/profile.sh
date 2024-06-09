#!/bin/bash
## sourced upon first login
## contains code specific to staralfur

## autosource inherited profile code
FILENAME="profile"
source /home/dante/scripts/config/autosource.sh -f $FILENAME -bl

## staralfur-specific profile code
# plex path constants
export LD_LIBRARY_PATH="/usr/lib/plexmediaserver"
export PLEXDATA="/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/"
export BACKUPDIR="/media/ts/backups/snapshots/"

# plex navigation aliases
alias pxd='cd "${PLEXDATA}" && ls'
alias bkp='cd "${BACKUPDIR}" && ls'
