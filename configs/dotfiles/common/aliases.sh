#!/bin/bash
## a collection of common aliases

# system
alias ufwl="sudo cat /var/log/ufw.log" # ufw logs
alias myip="curl https://ipinfo.io/ip"
alias sn="sudo nano"
alias sc="sudo cat"
alias delete-empty="sudo find . -type d -empty -print -delete"
alias ramdisk="cd /tmp/ramdisk && ls -al"
alias itop="sudo intel_gpu_top"
alias startup="source ${SCRIPTS_ROOT}/startup.sh"
alias czone="find . -type f -name '*Zone.Identifier' -delete" # clean zone.identifier files in WSL2 environment

# git
alias gcm="git commit -m"

# docker general
alias dcd="docker compose down"
alias dcu="docker compose up -d"
alias dlogs="docker logs -f"
alias dxi="docker exec -t" # run command inside container

# docker services
alias fail2ban="docker exec -t fail2ban fail2ban-client"
alias occ="sudo docker exec --user www-data -it nextcloud-aio-nextcloud php occ" # nextcloud AIO container OCC
alias immich-bkp="sudo docker exec -t immich_postgres pg_dumpall --clean --if-exists --username=postgres | gzip > /mnt/hdd-pool/app-data/immich/backups/manual/immich_backup_$(date -I).sql.gz"
alias dawarich-bkp="sudo docker exec -t dawarich-db pg_dumpall --clean --if-exists --username=postgres | gzip > /mnt/hdd-pool/app-data/dawarich/backups/dawarich_backup_$(date -I).sql.gz"
