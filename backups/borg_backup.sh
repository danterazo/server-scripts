#!/bin/bash
# inspired by: https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups

## sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

# setting borg-related constants
export BORG_REPO=/backup
export BORG_PASSPHRASE=$(head -n 1 /home/dante/.creds/borg)

# archive name
DATETIME=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVENAME="$HOSTNAME-system_$DATETIME"

# error handling
info() { printf "\n%s %s\n\n" "$(date)" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

## backup
info "Starting Borg backup"
borg create \
    --filter AME \
    --list \
    --stats \
    --show-rc \
    --compression auto,lz4,9 \
    --exclude-caches \
    --exclude '*.ffs_db' \
    --exclude '*.ffs_lock' \
    --exclude '*.copytemp' \
    --exclude 'var/tmp/*' \
    --exclude '/self-hosted/nextcloud/backups' \
    --exclude '/self-hosted/nextcloud/data' \
    \
    ::$ARCHIVENAME \
    /etc /root /var /usr/local/bin /usr/local/sbin /srv /opt /self-hosted /ansible /self-hosted/planka/db /self-hosted/nextcloud /self-hosted/nginx-proxy-manager

backup_exit=$?

## prune
info "Pruning Borg repository"
borg prune \
    --list \
    --glob-archives '{hostname}-*' \
    --show-rc \
    --keep-daily 3 \
    --keep-weekly 2 \
    --keep-monthly 3

prune_exit=$?

## compact
info "Compacting Borg repository"
borg compact

compact_exit=$?

# use highest exit code as global exit code
global_exit=$((backup_exit > prune_exit ? backup_exit : prune_exit))
global_exit=$((compact_exit > global_exit ? compact_exit : global_exit))

if [ ${global_exit} -eq 0 ]; then
    info "Backup, Prune, and Compact finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup, Prune, and/or Compact finished with warnings"
else
    info "Backup, Prune, and/or Compact finished with errors"
fi

exit ${global_exit}
