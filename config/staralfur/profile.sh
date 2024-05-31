#!/bin/bash
## sourced upon first login. contains code specific to staralfur

## source default profile code
source /home/dante/scripts/config/default/profile.sh

## source common profile code
source /home/dante/scripts/config/common/profile.sh

## source common architecture profile code
source /home/dante/scripts/config/arch/x64/profile.sh

## source common physical system profile code
source /home/dante/scripts/config/platform/physical/profile.sh

## staralfur-specific profile code
# plex path constants
export LD_LIBRARY_PATH="/usr/lib/plexmediaserver"
export PLEXDATA="/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/"
export BACKUPDIR="/media/ts/backups/snapshots/"

# plex navigation aliases
alias pxd='cd "${PLEXDATA}" && ls'
alias bkp='cd "${BACKUPDIR}" && ls'
