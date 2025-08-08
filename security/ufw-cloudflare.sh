#!/bin/bash
## source: https://github.com/Paul-Reed/cloudflare-ufw/blob/master/cloudflare-ufw.sh

# delete cloudflare IP exceptions (assumes they already exist)
for CLOUDFLARE_IP in `curl -sw '\n' https://www.cloudflare.com/ips-v{4,6}`; do sudo ufw delete allow proto tcp from ${CLOUDFLARE_IP} to any port 80,443 comment "Cloudflare IP"; done

# allow cloudflare IPs
for CLOUDFLARE_IP in `curl -sw '\n' https://www.cloudflare.com/ips-v{4,6}`; do sudo ufw allow proto tcp from ${CLOUDFLARE_IP} to any port 80,443 comment "Cloudflare IP"; done

# reload ufw
sudo ufw reload #> /dev/null
