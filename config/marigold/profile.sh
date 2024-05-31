#!/bin/bash
## sourced upon first login. contains code specific to marigold (ubuntu, wsl2)

## source default profile code
source /home/dante/scripts/config/default/profile.sh

## source common profile code
source /home/dante/scripts/config/common/profile.sh

## source common architecture profile code
source /home/dante/scripts/config/arch/x64/profile.sh

## source common physical system profile code
source /home/dante/scripts/config/platform/physical/profile.sh

## source common wsl2 system profile code
source /home/dante/scripts/config/platform/wsl2/profile.sh

## marigold-specific profile code
