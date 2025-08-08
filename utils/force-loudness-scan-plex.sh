#!/bin/bash
## run within Docker container

# values w/ Docker
export LD_LIBRARY_PATH=/config:/config/Library
export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR='/config/Library/Application Support'

# force loudness scan for music library (index 2)
cd /usr/lib/plexmediaserver
./Plex\ Media\ Scanner --analyze-loudness --section 2
