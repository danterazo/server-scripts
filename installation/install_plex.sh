#!/bin/bash
plex_version="1.23.4.4712-1f0ed4aea"

## sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

## download
wget https://downloads.plex.tv/plex-media-server-new/${plex_version}/debian/plexmediaserver_${plex_version}_amd64.deb

## install
sudo dpkg -i plexmediaserver_${plex_version}_amd64.deb

## verify
sudo systemctl enable plexmediaserver.service
sudo systemctl start plexmediaserver.service
sudo systemctl status plexmediaserver.service

## add repos for future updates
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -

## clean up
sudo rm plexmediaserver_${plex_version}_amd64.deb
