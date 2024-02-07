#!/bin/bash
## sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

## install prereqs
sudo apt install g++ pkg-config git git-buildpackage pandoc debhelper libfuse-dev libattr1-dev -y

## clone code
git clone https://github.com/trapexit/mergerfs.git 
cd mergerfs

## build
make clean
make deb
cd ..

## install
sudo dpkg -i mergerfs*_amd64.deb

## clean up
rm mergerfs*_amd64.deb mergerfs*_amd64.changes mergerfs*.dsc mergerfs*.tar.gz
