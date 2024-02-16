#!/bin/sh
# forked from: https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups

# setting borg-related constants
export BORG_REPO=/backup
export BORG_PASSPHRASE=$BORGPASS

# archive name
DATETIME=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVENAME="$HOSTNAME-system_$DATETIME"

# error handling
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

## backup
info "Starting Borg backup"
borg create                         \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression auto,lz4,9        \
    --exclude-caches                \
    --exclude 'var/tmp/*'           \
                                    \
    ::$ARCHIVENAME                  \
    /etc /home /root /var /usr/local/bin /usr/local/sbin /srv /opt

backup_exit=$?

## prune
info "Pruning Borg repository"
borg prune                          \
    --list                          \
    --glob-archives '{hostname}-*'  \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \
    --keep-yearly   1

prune_exit=$?

## compact
info "Compacting Borg repository"
borg compact

compact_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup, Prune, and Compact finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup, Prune, and/or Compact finished with warnings"
else
    info "Backup, Prune, and/or Compact finished with errors"
fi

exit ${global_exit}

# TODO: create borg mount script with these commands:
# sudo borg mount /backup /mnt/borg-fuse
# sudo borg umount /mnt/borg-fuse
