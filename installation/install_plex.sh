#!/bin/bash
plex_version="1.23.4.4712-1f0ed4aea"

wget https://downloads.plex.tv/plex-media-server-new/${plex_version}/debian/plexmediaserver_${plex_version}_amd64.deb
sudo dpkg -i plexmediaserver_${plex_version}_amd64.deb
sudo systemctl enable plexmediaserver.service
sudo systemctl start plexmediaserver.service
sudo systemctl status plexmediaserver.service
sudo rm plexmediaserver_${plex_version}_amd64.deb
