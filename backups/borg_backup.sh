#!/bin/bash
# inspired by: https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups

## sudo timeout trick
sudo-timeout

# setting borg-related constant
export BORG_REPO=/borg-backup

# retrieve borg credential
export BORG_PASSPHRASE=${BORGPASS}

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
