#!/bin/bash
## sourced in non-login interactive shells, such as terminals. contains code specific to marigold (ubuntu, wsl2)

## autosource inherited bashrc code
FILENAME="bashrc"
source ../autosource.sh -f $FILENAME -w -v -i -b

## marigold-specific bashrc code
