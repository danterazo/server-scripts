#!/bin/bash
# sudo timeout trick
while true; do
    sudo -nv
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &
