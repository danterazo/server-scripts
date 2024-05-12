#!/bin/bash
## sourced when user sources startup.sh or "startup" alias. contains stuff specific to smaskifa

# update Plexamp Headless
echo -e 'Updating Plexamp Headless...'
source ~/plexamp/upgrade.sh > /dev/null 2>&1 || true

# update gravity-sync (for PiHole)
gravity-sync update
