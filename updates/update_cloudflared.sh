#!/bin/bash
### install latest CloudflareD binary

# config
platform="amd64"

# get new binary
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${platform}

# stop service
sudo systemctl stop cloudflared

# move binary
sudo mv -f ./cloudflared-linux-${platform} /usr/local/bin/cloudflared
sudo chmod +x /usr/local/bin/cloudflared

# start service
sudo systemctl start cloudflared

# verify
cloudflared -v
#sudo systemctl status cloudflared
