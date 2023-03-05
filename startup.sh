#!/bin/bash
# dante's startup script

# get + apply updates
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

# funny goat go brrrrrrr
goatthink -b -W 60 "It don't take a genius to spot a goat in a flock of sheep."
#sleep 3

# stats
bashtop
