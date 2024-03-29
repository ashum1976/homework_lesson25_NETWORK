# -*- mode: ruby -*-
# vim: set ft=ruby :
# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
:inetRouter => {
        :box_name => "centos/7",
        #:public => {:ip => '10.10.10.1', :adapter => 1},
        :net => [
                   {ip: '192.168.255.1', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "router-net"},
                ]
  },
  :centralRouter => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.2', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "router-net"},
                   {ip: '192.168.0.1', adapter: 3, netmask: "255.255.255.240", virtualbox__intnet: "dir-net"},
                   {ip: '192.168.0.33', adapter: 4, netmask: "255.255.255.240", virtualbox__intnet: "hw-net"},
                   {ip: '192.168.0.65', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "mgt-net"},
                   {ip: '192.168.3.3', adapter: 6, netmask: "255.255.255.240", virtualbox__intnet: "office1-router"},
                   {ip: '192.168.3.17', adapter: 7, netmask: "255.255.255.240", virtualbox__intnet: "office2-router"},
                ]
  },

  :centralServer => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.0.2', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "dir-net"},
                   {adapter: 3, auto_config: false, virtualbox__intnet: true},
                   {adapter: 4, auto_config: false, virtualbox__intnet: true},
                ]
  },

  :office1Router =>
                  {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.2.1', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "office1-dev"},
                   {ip: '192.168.2.66', adapter: 3, netmask: "255.255.255.192", virtualbox__intnet: "office1-server"},
                   {ip: '192.168.2.129', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "office1-hw"},
                   {ip: '192.168.3.4', adapter: 5, netmask: "255.255.255.240", virtualbox__intnet: "office1-router"},
                   {ip: '192.168.2.193', adapter: 6, netmask: "255.255.255.192", virtualbox__intnet: "office1-mgt"},

                  ]
                },

  :office2Router => {
        :box_name => "centos/7",
        :net => [
                  {ip: '192.168.1.4', adapter: 2, netmask: "255.255.255.128", virtualbox__intnet: "office2-dev"},
                   {ip: '192.168.1.129', adapter: 3, netmask: "255.255.255.192", virtualbox__intnet: "office2-server"},
                   {ip: '192.168.1.193', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "office2-hw"},
                   {ip: '192.168.3.18', adapter: 5, netmask: "255.255.255.240", virtualbox__intnet: "office2-router"},
                  ]
                },

  :office1Server => {
          :box_name => "centos/7",
          :net => [
                  {ip: '192.168.2.67', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "office1-server"},
                  ]
                },

  :office2Server => {
          :box_name => "centos/7",
          :net => [
                    {ip: '192.168.1.130', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "office2-server"},
                  ]
                },

}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname do |box|

        box.vm.box = boxconfig[:box_name]
        box.vm.host_name = boxname.to_s

        boxconfig[:net].each do |ipconf|
          box.vm.network "private_network", ipconf
        end

        if boxconfig.key?(:public)
          box.vm.network "public_network", boxconfig[:public]
        end

        box.vm.provision "shell", inline: <<-SHELL
          mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
        SHELL

        case boxname.to_s
        when "inetRouter"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
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
            SHELL
        when "centralRouter"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            sysctl net.ipv4.conf.all.forwarding=1
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
            echo "GATEWAY=192.168.255.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
            # touch /etc/sysconfig/network-scripts/ifcfg-eth2:0
            # echo "DEVICE=eth2:0" >> /etc/sysconfig/network-scripts/ifcfg-eth2:0
            # echo "BOOTPROTO=static" >> /etc/sysconfig/network-scripts/ifcfg-eth2:0
            # echo "IPADDR=192.168.3.3" >> /etc/sysconfig/network-scripts/ifcfg-eth2:0
            # echo "NETMASK=255.255.255.224" >> /etc/sysconfig/network-scripts/ifcfg-eth2:0
            # echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-eth2:0
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
            SHELL
        when "centralServer"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
            echo "GATEWAY=192.168.0.1" >> /etc/sysconfig/network-scripts/ifcfg-eth1
            systemctl restart network
            SHELL
        when "office1Router"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            sysctl net.ipv4.conf.all.forwarding=1
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
            echo "GATEWAY=192.168.3.3" >> /etc/sysconfig/network-scripts/ifcfg-eth4
            systemctl restart network
            sysctl net.ipv4.conf.all.forwarding=1
            SHELL
        when "office2Router"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
            sysctl net.ipv4.conf.all.forwarding=1
            echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
            echo "GATEWAY=192.168.3.17" >> /etc/sysconfig/network-scripts/ifcfg-eth4
            systemctl restart network
            sysctl net.ipv4.conf.all.forwarding=1
            SHELL
        when "office1Server"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
          echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
          echo "GATEWAY=192.168.2.66" >> /etc/sysconfig/network-scripts/ifcfg-eth1
          systemctl restart network
          SHELL
        when "office2Server"
          box.vm.provision "shell", run: "always", inline: <<-SHELL
          echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
          echo "GATEWAY=192.168.1.129" >> /etc/sysconfig/network-scripts/ifcfg-eth1
          systemctl restart network
          SHELL


        end

      end

  end


end
