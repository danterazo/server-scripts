#!/bin/bash
## sourced when user runs startup.sh or "startup" alias. contains code specific to staralfur
# metadata
ARCH="x64"

## source default startup code
source /home/dante/scripts/config/default/startup.sh

## source common startup code
source /home/dante/scripts/config/common/startup.sh

## source common architecture startup code
source /home/dante/scripts/config/arch/x64/startup.sh

## source common physical system startup code
source /home/dante/scripts/config/platform/physical/startup.sh

## staralfur-specific startup code
# update gravity-sync (for PiHole)
gravity-sync update
