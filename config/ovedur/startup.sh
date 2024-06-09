#!/bin/bash
## sourced when user runs startup.sh or "startup" alias
## contains code specific to ovedur (ubuntu, wsl2)

## autosource inherited startup code
FILENAME="startup"
source /home/dante/scripts/config/autosource.sh -f $FILENAME -wv

## ovedur-specific startup code
