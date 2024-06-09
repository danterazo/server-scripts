#!/bin/bash
## sourced when user runs startup.sh or "startup" alias
## contains code specific to marigold (ubuntu, wsl2)

## autosource inherited startup code
FILENAME="startup"
source /home/dante/scripts/config/autosource.sh -f $FILENAME -wv

## marigold-specific startup code
