#!/bin/bash
## sourced when user runs startup.sh or "startup" alias
## contains code specific to staralfur

## autosource inherited startup code
FILENAME="startup"
source /home/dante/scripts/config/autosource.sh -f $FILENAME -bl

## staralfur-specific startup code
