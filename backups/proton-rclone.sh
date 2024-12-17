#!/bin/bash

: 'Config'
export RCLONE_CONFIG="/home/dante/.config/rclone/rclone.conf"

: 'List Services to Back Up'
SERVICES=(
    "backrest"
    "dawarich"
    "dockge"
    "immich"
    "nginx-proxy-manager"
    "planka"
    "radicale"
)

: 'Run All'
# NOTE: runs sequentially to avoid HTTP 429 errors with API
for i in "${SERVICES[@]}"
do
    echo -e "${ORANGE}Backing up ${BOLD}${ITALIC}${i}${NOFORMAT} to Proton Drive...${NOCOLOR}"
    sudo rclone sync /self-hosted/${i} proton-drive:Starálfur/${i}/current \
            --backup-dir="proton-drive:Starálfur/${i}/archive/$(date -I)" \
            --exclude="*.git/" \
            --exclude="*cache/" \
            --config="${RCLONE_CONFIG}"
    echo -e "${GREEN}Successfully backed up ${i} to Proton Drive!${NOCOLOR}"
done
