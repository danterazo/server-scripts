#!/bin/bash
## source: https://github.com/Paul-Reed/cloudflare-ufw/blob/master/cloudflare-ufw.sh

# allow cloudflare IPs
for cfip in `curl -sw '\n' https://www.cloudflare.com/ips-v{4,6}`; do ufw allow proto tcp from $cfip to any port 80,443 comment 'Cloudflare IP'; done

# delete cloudflare IP exceptions
# for cfip in `curl -sw '\n' https://www.cloudflare.com/ips-v{4,6}`; do ufw delete allow proto tcp from $cfip to any port 80,443 comment 'Cloudflare IP'; done
