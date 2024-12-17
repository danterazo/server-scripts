#!/bin/bash

: 'Setup'
export RCLONE_CONFIG="/home/dante/.config/rclone/rclone.conf"

: 'List Services to Back Up'
SERVICES=(
    "dockge"
    "radicale"
    "dawarich"
    "immich"
    "nginx-proxy-manager"
)

: 'Run All'
# NOTE: runs sequentially to avoid HTTP 429 errors with API
for i in "${SERVICES[@]}"
do
    echo -e "${ORANGE}Backing up ${UNDERLINE}${i}${NOFORMAT} to Proton Drive...${NOCOLOR}" && \
    sudo rclone sync /self-hosted/${i} proton-drive:Starálfur/${i}/current --backup-dir="proton-drive:Starálfur/${i}/archive/$(date -I)" && \
    echo -e "${GREEN}Successfully backed up ${i} to Proton Drive!${NOCOLOR}"
done
