#!/bin/bash
### script for IP geolocation

## common
default_wg_profile=us-co-10

if [[ $# == 0 ]]; then
  new_wg_profile=default_wg_profile
else
  new_wg_profile=$1
fi

sudo cp /home/dante/.config/wireguard/${new_wg_profile}.conf /etc/wireguard/wg0.conf

