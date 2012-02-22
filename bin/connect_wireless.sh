#!/bin/sh
# Connect to the wireless network.

# Enable the wireless card.
sudo ip link set wlan0 up

# Connect to the network.
sudo wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf -B

# Get an IP address for the network interface.
sudo dhcpcd wlan0

