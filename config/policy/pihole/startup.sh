#!/bin/bash
## sourced when user runs startup.sh or "startup" alias
## contains code specific to systems running pihole

# update gravity-sync (for PiHole)
gravity-sync update

# update PiHole
pihole -up
