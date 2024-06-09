#!/bin/bash
## sourced when user runs startup.sh or "startup" alias
## contains code specific to saeglopur

## autosource inherited startup code
FILENAME="startup"
source /home/dante/scripts/config/autosource.sh -f $FILENAME -b

## saeglopur-specific startup code
sudo wg-quick down wg0 && sudo wg-quick up wg0
