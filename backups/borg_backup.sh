#!/bin/bash
# inspired by: https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups

## sudo timeout trick
sudo-timeout

# setting borg-related constant
export BORG_REPO=/borg-backup

# retrieve borg credential
export BORG_PASSPHRASE=$(sudo cat /home/dante/.creds/borg)

# archive name
DATETIME=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVENAME="$HOSTNAME-system_$DATETIME"

# error handling
info() { printf "\n%s %s\n\n" "$(date)" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

## backup
info "Starting Borg backup"
borg create \
    --filter ACME \
    --list \
    --stats \
    --show-rc \
    --compression auto,lzma,9 \
    --exclude-caches \
    --exclude '*.ffs_db' \
    --exclude '*.ffs_lock' \
    --exclude '*.copytemp' \
    --exclude 'var/tmp/*' \
    --exclude '/self-hosted/nextcloud/backups' \
    --exclude '/self-hosted/nextcloud/data' \
    \
    ::$ARCHIVENAME \
    /home /etc /root /var /opt /srv /usr/local /self-hosted /ansible

BACKUP_EXIT=$?

## prune
info "Pruning Borg repository"
borg prune \
    --list \
    --glob-archives '{hostname}-*' \
    --show-rc \
    --keep-daily 3 \
    --keep-weekly 2 \
    --keep-monthly 3

PRUNE_EXIT=$?

## compact
info "Compacting Borg repository"
borg compact

COMPACT_EXIT=$?

# use highest exit code as global exit code
GLOBAL_EXIT=$((BACKUP_EXIT > PRUNE_EXIT ? BACKUP_EXIT : PRUNE_EXIT))
GLOBAL_EXIT=$((COMPACT_EXIT > GLOBAL_EXIT ? COMPACT_EXIT : GLOBAL_EXIT))

if [ ${GLOBAL_EXIT} -eq 0 ]; then
    info "Backup, Prune, and Compact finished successfully"
elif [ ${GLOBAL_EXIT} -eq 1 ]; then
    info "Backup, Prune, and/or Compact finished with warnings"
else
    info "Backup, Prune, and/or Compact finished with errors"
fi

exit ${GLOBAL_EXIT}
