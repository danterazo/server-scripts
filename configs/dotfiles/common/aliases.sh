#!/bin/bash
## a collection of common aliases

alias ufwl="sudo cat /var/log/ufw.log" # ufw logs
alias occ="sudo docker exec --user www-data -it nextcloud-aio-nextcloud php occ" # nextcloud AIO occ
alias gcm="git commit -m"

# docker general
alias dcd="docker compose down"
alias dcu="docker compose up -d"

# docker services
alias occ="sudo docker exec --user www-data -it nextcloud-aio-nextcloud php occ" # nextcloud AIO container OCC
