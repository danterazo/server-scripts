#!/bin/bash
## sourced when user runs startup.sh or "startup" alias
## contains code specific to smaskifa

## autosource inherited startup code
FILENAME="startup"
source /home/dante/scripts/config/autosource.sh -f $FILENAME -bl

## smaskifa-specific startup code
# update Plexamp Headless
echo -e 'Updating Plexamp Headless...'
source ~/plexamp/upgrade.sh >/dev/null 2>&1 || true
