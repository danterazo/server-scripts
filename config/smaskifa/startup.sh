#!/bin/bash
## sourced when user runs startup.sh or "startup" alias. contains code specific to smaskifa

## source default startup code
source /home/dante/scripts/config/default/startup.sh

## source common startup code
source /home/dante/scripts/config/common/startup.sh

## source common architecture startup code
source /home/dante/scripts/config/arch/arm64/startup.sh

## source common physical system startup code
source /home/dante/scripts/config/platform/physical/startup.sh

## smaskifa-specific startup code
# update Plexamp Headless
echo -e 'Updating Plexamp Headless...'
source ~/plexamp/upgrade.sh >/dev/null 2>&1 || true

# update gravity-sync (for PiHole)
gravity-sync update
