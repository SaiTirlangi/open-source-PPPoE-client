#!/bin/sh
# PPPoE client configuration
# Replace <INTERFACE_NAME> with your network interface name
# Replace <USERNAME> with your PPPoE username
# Replace <PASSWORD> with your PPPoE password

INTERFACE_NAME=eth0
USERNAME=your_username
PASSWORD=your_password

# Bring up the network interface
ip link set $INTERFACE_NAME up

# Start the PPPoE client
pppoe-start

# Configure the network interface with an IP address
dhclient $INTERFACE_NAME

# Add a default route via the PPPoE interface
ip route add default dev ppp0

# Start a DNS resolver
systemctl start systemd-resolved.service

# Set the DNS resolver to use the PPPoE connection
systemd-resolve --interface ppp0 --set-dns 8.8.8.8 --set-domain-only

# Run a test to verify the PPPoE connection is working
ping -c 4 8.8.8.8

# Bring down the PPPoE connection
pppoe-stop

# Bring down the network interface
ip link set $INTERFACE_NAME down
