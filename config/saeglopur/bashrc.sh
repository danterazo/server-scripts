#!/bin/bash
## sourced in non-login interactive shells, such as terminals. contains code specific to saeglopur

## autosource inherited bashrc code
../autosource/ -a "x64"

## source default bashrc code
source /home/dante/scripts/config/default/bashrc.sh

## source common bashrc code
source /home/dante/scripts/config/common/bashrc.sh

## source common architecture bashrc code
source /home/dante/scripts/config/arch/x64/bashrc.sh

## source common platform bashrc code
source /home/dante/scripts/config/platform/physical/bashrc.sh

## saeglopur-specific bashrc code
