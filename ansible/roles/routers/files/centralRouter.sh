#!/usr/bin/env bash
sysctl net.ipv4.conf.all.forwarding=1
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
touch /etc/sysconfig/network-scripts/route-eth5
touch /etc/sysconfig/network-scripts/route-eth6
echo "192.168.1.0/25 via 192.168.3.18" > /etc/sysconfig/network-scripts/route-eth6
echo "192.168.1.128/26 via 192.168.3.18" >> /etc/sysconfig/network-scripts/route-eth6
echo "192.168.1.192/26 via 192.168.3.18" >> /etc/sysconfig/network-scripts/route-eth6
echo "192.168.2.0/26 via 192.168.3.4" > /etc/sysconfig/network-scripts/route-eth5
echo "192.168.2.64/26 via 192.168.3.4" >> /etc/sysconfig/network-scripts/route-eth5
echo "192.168.2.128/26 via 192.168.3.4" >> /etc/sysconfig/network-scripts/route-eth5
echo "192.168.2.192/26 via 192.168.3.4" >> /etc/sysconfig/network-scripts/route-eth5
systemctl restart network
sysctl net.ipv4.conf.all.forwarding=1
