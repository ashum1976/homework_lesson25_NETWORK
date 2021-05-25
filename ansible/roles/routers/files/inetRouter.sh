#!/usr/bin/env bash
sysctl net.ipv4.conf.all.forwarding=1
iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o eth0 -j MASQUERADE
touch /etc/sysconfig/network-scripts/route-eth1
echo "192.168.1.0/25 via 192.168.255.2" > /etc/sysconfig/network-scripts/route-eth1
echo "192.168.3.0/28 via 192.168.255.2" >> /etc/sysconfig/network-scripts/route-eth1
echo "192.168.3.16/28 via 192.168.255.2" >> /etc/sysconfig/network-scripts/route-eth1
echo "192.168.1.128/26 via 192.168.255.2" >> /etc/sysconfig/network-scripts/route-eth1
echo "192.168.1.192/26 via 192.168.255.2" >> /etc/sysconfig/network-scripts/route-eth1
echo "192.168.2.0/26 via 192.168.255.2" >> /etc/sysconfig/network-scripts/route-eth1
echo "192.168.2.64/26 via 192.168.255.2" >> /etc/sysconfig/network-scripts/route-eth1
echo "192.168.2.128/26 via 192.168.255.2" >> /etc/sysconfig/network-scripts/route-eth1
echo "192.168.2.192/26 via 192.168.255.2" >> /etc/sysconfig/network-scripts/route-eth1
echo "192.168.0.2/28 via 192.168.255.2" >> /etc/sysconfig/network-scripts/route-eth1
systemctl restart network
sysctl net.ipv4.conf.all.forwarding=1
