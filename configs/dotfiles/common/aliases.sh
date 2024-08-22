#!/bin/bash
## a collection of common aliases

# system
alias ufwl="sudo cat /var/log/ufw.log" # ufw logs
alias myip="curl https://ipinfo.io/ip"

# git
alias gcm="git commit -m"

# docker general
alias dcd="docker compose down"
alias dcu="docker compose up -d"

# docker services
alias occ="sudo docker exec --user www-data -it nextcloud-aio-nextcloud php occ" # nextcloud AIO container OCC
