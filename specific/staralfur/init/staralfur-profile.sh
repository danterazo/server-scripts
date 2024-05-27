#!/bin/bash
## sourced when new session is opened. contains stuff specific to staralfur

## exports
# plex path constants
export LD_LIBRARY_PATH="/usr/lib/plexmediaserver"
export PLEXDATA="/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/"
export BACKUPDIR="/media/ts/backups/snapshots/"

## aliases
# plex navigation aliases
alias pxd='cd "${PLEXDATA}" && ls'
alias bkp='cd "${BACKUPDIR}" && ls'
