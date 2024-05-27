#!/bin/bash
# based on script from: https://www.wireguard.com/netns/
set -ex

## sudo timeout trick
source /home/dante/scripts/constants/sudo_timeout.sh

# adapter names
ETHERNET=enp3s0f0
WIREGUARD=wg0
WIFI=wlan0

# rest
[[ $UID != 0 ]] && exec sudo -E "$(readlink -f "$0")" "$@"

up() {
    sudo killall wpa_supplicant dhcpcd || true
    sudo ip netns add physical
    sudo ip -n physical link add $WIREGUARD type wireguard
    sudo ip -n physical link set $WIREGUARD netns 1
    sudo wg setconf $WIREGUARD /etc/wireguard/$WIREGUARD.conf
    sudo ip addr add 192.168.4.33/32 dev $WIREGUARD
    sudo ip link set $ETHERNET down
    # sudo ip link set $WIFI down
    sudo ip link set $ETHERNET netns physical
    sudo iw phy phy0 set netns name physical
    sudo ip netns exec physical dhcpcd -b $ETHERNET
    sudo ip netns exec physical dhcpcd -b $WIFI
    # sudo ip netns exec physical wpa_supplicant -B -c/etc/wpa_supplicant/wpa_supplicant-wlan0.conf -iwlan0
    sudo ip link set $WIREGUARD up
    sudo ip route add default dev $WIREGUARD
}

down() {
    sudo killall wpa_supplicant dhcpcd || true
    sudo ip -n physical link set $ETHERNET down
    # sudo ip -n physical link set $WIFI down
    sudo ip -n physical link set $ETHERNET netns 1
    sudo ip netns exec physical iw phy phy0 set netns 1
    sudo ip link del $WIREGUARD
    sudo ip netns del physical
    sudo dhcpcd -b $ETHERNET
    # sudo dhcpcd -b $WIFI
    # sudo wpa_supplicant -B -c/etc/wpa_supplicant/wpa_supplicant-$WIFI.conf -i$WIFI
}

execi() {
    exec ip netns exec physical sudo -E -u \#${SUDO_UID:-$(id -u)} -g \#${SUDO_GID:-$(id -g)} -- "$@"
}

command="$1"
shift

case "$command" in
up) up "$@" ;;
down) down "$@" ;;
exec) execi "$@" ;;
*)
    echo "Usage: $0 up|down|exec" >&2
    exit 1
    ;;
esac
