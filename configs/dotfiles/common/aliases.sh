#!/bin/bash
## a collection of common aliases

# system
alias ufwl="sudo cat /var/log/ufw.log" # ufw logs
alias myip="curl https://ipinfo.io/ip"
alias sn="sudo nano"
alias sc="sudo cat"
alias delete-empty="sudo find . -type d -empty -print -delete"
alias ramdisk="cd /tmp/ramdisk && ls -al"

# git
alias gcm="git commit -m"

# docker general
alias dcd="docker compose down"
alias dcu="docker compose up -d"

# docker services
alias fail2ban="docker exec -t fail2ban fail2ban-client"
alias occ="sudo docker exec --user www-data -it nextcloud-aio-nextcloud php occ" # nextcloud AIO container OCC
