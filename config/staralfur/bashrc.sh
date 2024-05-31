#!/bin/bash
## sourced in non-login interactive shells, such as terminals. contains code specific to staralfur

## autosource inherited bashrc code
FILENAME=$(basename "$0")
PLATFORM="phyiscal"
source ../autosource.sh -f $FILENAME -i -b

## staralfur-specific bashrc code
