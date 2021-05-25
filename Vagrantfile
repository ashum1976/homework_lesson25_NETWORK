# -*- mode: ruby -*-
# vim: set ft=ruby :
# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
:inetRouter => {
        :box_name => "centos/7",
        #:public => {:ip => '10.10.10.1', :adapter => 1},
        :net => [
                   {ip: '192.168.255.1', adapter: 2, netmask: "255.255.255.248", virtualbox__intnet: "router-net"},
                ]
  },
  inetRouter2 => {
        :box_name => "centos/7",
        #:public => {:ip => '10.10.10.1', :adapter => 1},
        :net => [
                   {ip: '192.168.255.3', adapter: 2, netmask: "255.255.255.248", virtualbox__intnet: "router-net"},
                ]
  },
  :centralRouter => {
        :box_name => "centos/7",
        :net => [
                   {ip: '192.168.255.2', adapter: 2, netmask: "255.255.255.248", virtualbox__intnet: "router-net"},
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
    config.vm.synced_folder "./", "/vagrant", type: "rsync", rsync__auto: true, rsync__exclude: ['./hddvm, README.md']
    config.vm.define boxname do |box|

        box.vm.box = boxconfig[:box_name]
        box.vm.host_name = boxname.to_s

        boxconfig[:net].each do |ipconf|
          box.vm.network "private_network", ipconf
        end

        box.vm.provision "shell", inline: <<-SHELL
          mkdir -p ~root/.ssh
          cp ~vagrant/.ssh/auth* ~root/.ssh
          sed -i.bak 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
          systemctl restart sshd

        SHELL


        box.vm.provision :ansible_local do |ansible|
       #Установка  коллекции community.general, для использования community.general.nmcli (nmcli) управление сетевыми устройствами.
          ansible.galaxy_command = 'ansible-galaxy collection install community.general'
          ansible.verbose = "vv"
          ansible.install = "true"
          #ansible.limit = "all"
          ansible.tags = boxname.to_s
          # ansible.tags = "facts"
          ansible.inventory_path = "./ansible/inventory/"
          ansible.playbook = "./ansible/playbooks/routers.yml"
          end

      end

  end


end
