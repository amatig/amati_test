#!/bin/bash

ifconfig eth0 192.168.64.228
route add default gw 192.168.64.242

# echo "domain delcospa.net" > /etc/resolv.conf
# echo "search delcospa.net">> /etc/resolv.conf
# echo "nameserver 192.168.64.1" >> /etc/resolv.conf
# echo "nameserver 192.168.50.4" >> /etc/resolv.conf

cp /etc/resolv.conf.temp /etc/resolv.conf