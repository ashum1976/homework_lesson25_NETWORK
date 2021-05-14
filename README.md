


#  Сбор и анализ логов

####Домашнее задание по теме "Сбор и анализ логов":
Часть 1 - теоретическая

Часть 2 - практическая
**Задание:**

построить следующую архитектуру

_Сеть office1:_

      192.168.2.0/26 - dev
      192.168.2.64/26 - test servers
      192.168.2.128/26 - managers
      192.168.2.192/26 - office hardware

___

_Сеть office2:_

      192.168.1.0/25 - dev
      192.168.1.128/26 - test servers
      192.168.1.192/26 - office hardware

___

_Сеть central:_

      192.168.0.0/28 - directors
      192.168.0.32/28 - office hardware
      192.168.0.64/26 - wifi

                  Office1 ---\
      CentralServer  -----> Central --IRouter --> internet
                  Office2----/

___

Итого должны получится следующие сервера

inetRouter  
centralRouter  
office1Router  
office2Router  
centralServer  
office1Server  
office2Server  

**Решение:**  
- _Дано:_  

Vagrantfile с начальным построением сети

inetRouter  
centralRouter  
centralServer  


Создаём два роутера для сетей office1 и office2:

      :office1Router =>
                        {
              :box_name => "centos/7",
              :net => [
                         {ip: '192.168.2.1', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "office1-dev"},
                         {ip: '192.168.2.65', adapter: 3, netmask: "255.255.255.192", virtualbox__intnet: "office1-server"},
                         {ip: '192.168.2.129', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "office1-hw"},
                         {ip: '192.168.2.193', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "office1-mgt"},
                         {ip: '192.168.3.4', adapter: 6, netmask: "255.255.255.240", virtualbox__intnet: "office-router"},
                        ]
                      },

      :office2Router => {
              :box_name => "centos/7",
              :net => [
                        {ip: '192.168.1.1', adapter: 2, netmask: "255.255.255.128", virtualbox__intnet: "office2-dev"},
                         {ip: '192.168.1.129', adapter: 3, netmask: "255.255.255.192", virtualbox__intnet: "office2-server"},
                         {ip: '192.168.1.193', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "office2-hw"},
                         {ip: '192.168.3.18', adapter: 5, netmask: "255.255.255.240", virtualbox__intnet: "office-router"},
                        ]
                      },
и отдельную сеть, для связи с centralRouter, через который будем проходить для доступа в интернет, и для связи между сетями office1 и office2

- 192.168.3.0/28 - сеть роутеров

      centralRouter - 192.168.3.3/28
      centralRouter - 192.168.3.17/28
      office1Router - 192.168.3.4/28
      office2Router - 192.168.3.18/28

Для центрального роутера, через который проходят все соединния (с инетом и между офисами), создадим таблицу маршрутизации:

            touch /etc/sysconfig/network-scripts/route-eth5
            touch /etc/sysconfig/network-scripts/route-eth6
            echo "192.168.1.0/25 via 192.168.3.18" > /etc/sysconfig/network-scripts/route-eth6
            echo "192.168.1.128/26 via 192.168.3.18" >> /etc/sysconfig/network-scripts/route-eth6
            echo "192.168.1.192/26 via 192.168.3.18" >> /etc/sysconfig/network-scripts/route-eth6
            echo "192.168.2.0/26 via 192.168.3.4" > /etc/sysconfig/network-scripts/route-eth5
            echo "192.168.2.64/26 via 192.168.3.4" >> /etc/sysconfig/network-scripts/route-eth5
            echo "192.168.2.128/26 via 192.168.3.4" >> /etc/sysconfig/network-scripts/route-eth5
            echo "192.168.2.192/26 via 192.168.3.4" >> /etc/sysconfig/network-scripts/route-eth5

            /etc/sysconfig/network-scripts/route-eth5 - постоянная таблица для роутера office1Router
            /etc/sysconfig/network-scripts/route-eth6 - постоянная таблица для роутера office2Router


Для роутера через который осуществляется выход в Интернет, тоже создаём таблицу маршрутизации:

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

___

- **[Vagrantfile](./Vagrantfile) - полный файл рабочего стенда**

___



#   Общая теория, примеры, полезности.


Именование интерфейсов, нотация от systemd - Predictable Network Interface Names.
В своем виде по умолчанию использует форматы (упрощенно)

• **PCI:**
(en|wl)[P<domain>]p<bus>s<slot>[f<function>][n<phys_port_name>|d<dev_port>]

• **Onboard:**
(en|wl)[P<domain>]o<bus>[f<function>][n<phys_port_name>|d<dev_port>]

Таким образом enp0s3 говорит нам о том, что мы имеем дело с Ethernet-адаптером подключенным к шине pci №0 в слот №3, а eno1 говорит об onboard ethernet-адаптере с индексом 1.
