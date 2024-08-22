#!/bin/bash
## source: https://github.com/Paul-Reed/cloudflare-ufw/blob/master/cloudflare-ufw.sh

# allow cloudflare IPs
for CLOUDFLARE_IP in `curl -sw '\n' https://www.cloudflare.com/ips-v{4,6}`; do ufw allow proto tcp from ${CLOUDFLARE_IP} to any port 80,443 comment "Cloudflare IP"; done

# delete cloudflare IP exceptions
# for CLOUDFLARE_IP in `curl -sw '\n' https://www.cloudflare.com/ips-v{4,6}`; do ufw delete allow proto tcp from ${CLOUDFLARE_IP} to any port 80,443 comment "Cloudflare IP"; done

# reload ufw
ufw reload #> /dev/null
