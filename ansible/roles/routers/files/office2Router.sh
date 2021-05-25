#!/usr/bin/env bash
sysctl net.ipv4.conf.all.forwarding=1
echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "GATEWAY=192.168.3.17" >> /etc/sysconfig/network-scripts/ifcfg-eth4
systemctl restart network
sysctl net.ipv4.conf.all.forwarding=1
