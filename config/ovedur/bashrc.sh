#!/bin/bash
## sourced in non-login interactive shells, such as terminals
## contains code specific to ovedur (ubuntu, wsl2)

## autosource inherited bashrc code
FILENAME="bashrc"
source /home/dante/scripts/config/autosource.sh -f $FILENAME -wv

## ovedur-specific bashrc code
