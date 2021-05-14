# 25 урок. Архитектура сетей.

#### Домашнее задание по теме "Архитектура сетей"
#### Часть 1 - теоретическая

**Сеть "central" 192.168.0.0/24, разбита на подсети :**

- _192.168.0.0/28 - directors. В данной подсети может быть 15 хостов_

      Network:        192.168.0.0/28
      Netmask:        255.255.255.240 = 28
      Broadcast:      192.168.0.15

      HostMin:        192.168.0.1
      HostMax:        192.168.0.14
      Hosts/Net:      14

- _192.168.0.16/28 - свободная подсеть_
- _192.168.0.32/28 - office hardware. В данной подсети может быть 15 хостов_

      Network:        92.168.0.32/28
      Netmask:        255.255.255.240 = 28
      Broadcast:      92.168.0.47

      HostMin:        92.168.0.33
      HostMax:        92.168.0.46
      Hosts/Net:      14

- _192.168.0.48/28 - свобдная подсеть_

- _192.168.0.64/26 - wifi. В данной подсети может быть 62 хоста_

      Network:        192.168.0.64/26
      Netmask:        255.255.255.192 = 26
      Broadcast:      192.168.0.127

      HostMin:        192.168.0.65
      HostMax:        192.168.0.126
      Hosts/Net:      62

- _192.168.0.128 - свободная подсеть, можно или создать одну подсеть с маской 25 (255.255.255.128) или нарезать на более меньшие подсети, с помощью масок_

___

**Сеть "office1" (192.168.2.0/24), разбита на подсети :**

- _192.168.2.0/26 - dev. В данной подсети может быть 62 хоста_

      Network:        192.168.2.0/26
      Netmask:        255.255.255.192 = 26
      Broadcast:      192.168.2.63

      HostMin:        192.168.2.1
      HostMax:        192.168.2.62
      Hosts/Net:      62

- 192.168.2.64/26 - test servers
- 192.168.2.128/26 - managers
- 192.168.2.192/26 - office hardware

_Весь доступный дипазон сети 192.168.2.0/24 разбит на одинаковые подсети, по 62 хоста в каждой._

___


**Сеть "office2" (192.168.1.0/24), разбита на подсети :**

- _192.168.1.0/25 - dev. В данной подсети может быть 126 хостов_

    Network:        192.168.1.0/25
    Netmask:        255.255.255.128 = 25
    Broadcast:      192.168.1.127

    HostMin:        192.168.1.1
    HostMax:        192.168.1.126
    Hosts/Net:      126

- _192.168.1.128/26 - test servers. В данной подсети может быть 62 хоста. Маска 26 (255.255.255.192)_

- _192.168.1.192/26 - office hardware. В данной подсети может быть 62 хоста. Маска 26 (255.255.255.192)_

Весь доступный дипазон сети 192.168.1.0/24 использован

___


#### Часть 2 - практическая
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
В RHEL7 используются следующие варианты схем наименования сетевого интерфейса, в порядке применения:

1. Имя, предоставляемое аппаратным обеспечением (Firmware или BIOS), включающее порядковый номер, для устройств, расположенных на материнской плате, к примеру eno1. Если выбор имени не произведен, используется схема 2.
2. Имя, предоставляемое аппаратным обеспечением (Firmware или BIOS), включающее порядковый номер слота PCI Express, к примеру ens1. Если выбор не произведен, используется схема 3.
3. Имя формируется из физического положения точки подключения устройства, к примеру enp2s0. Иначе используется схема 5.
4. Имя включает MAC устройства, к примеру enx94de80a44f0c. Эта схема по умолчанию не используется.
5. Старая схема, где имя присваивается ядром в порядке обнаружения интерфейса, к примеру eth0 и т.д.


- o<index> — индекс для устройств расположенных на материнской плате.
- s<slot>[f<function>][d<dev_id>] — сначала идет номер PCI Express слота, далее f<function> - номер функции у многофункционального PCI устройства  и последним идет идентификатор устройства.
- p<bus>s<slot>[f<function>][d<dev_id>] — расположение устройства на PCI шине. Домен PCI (p<bus>) указывается только если он отличен от нулевого (это можно увидеть в больших системах). Номер функции и номер устройства аналогично предыдущему примеру.
- p<bus>s<slot>[f<function>][u<port>][..][c<config>][i<interface>] — расположение устройства на USB шине, причем учитывается вся цепочка портов.
- x<MAC> — MAC адрес.

В случае использования VLAN добавляется следующее соглашение о имени интерфейса:

      vlan<vlanid> — имя с полным номером vlanid, к примеру vlan0012 или имя с сокращенным vlanid — vlan12

      device_name.<vlanid> - имя интерфейса и VLAN ID в полном или сокращенном виде, к примеру ens3.0012 или ens3.12


В своем виде по умолчанию использует форматы (упрощенно)

• **PCI:**
(en|wl)[P<domain>]p<bus>s<slot>[f<function>][n<phys_port_name>|d<dev_port>]

• **Onboard:**
(en|wl)[P<domain>]o<bus>[f<function>][n<phys_port_name>|d<dev_port>]

Таким образом enp0s3 говорит нам о том, что мы имеем дело с Ethernet-адаптером подключенным к шине pci №0 в слот №3, а eno1 говорит об onboard ethernet-адаптере с индексом 1.

___
**Можно вернуться к стандартному имени интерфейса Linux с помощью следующих действий.**

Отредактируйте файл /etc/default/grub:

      nano /etc/default/grub

В строку GRUB_CMDLINE_LINUX нужно добавить:

      net.ifnames=0 biosdevname=0

Пример полной строки:

      GRUB_CMDLINE_LINUX="consoleblank=0 fsck.repair=yes crashkernel=auto nompath selinux=0 rhgb quiet net.ifnames=0 biosdevname=0"

Обновите конфигурацию grub:

      grub2-mkconfig -o /boot/grub2/grub.cfg

Переименуйте конфигурационный файл сетевого интерфейса:

      mv /etc/sysconfig/network-scripts/ifcfg-ens3 /etc/sysconfig/network-scripts/ifcfg-eth0

И заменить значение DEVICE на eth0

___



##### Основные параметры /etc/sysconfig/network-scripts/ifcfg-* файлов:

- DEFROUTE=no — не устанавливать defaul gw
- DEVICE – имя сетевого адаптера, совпадает с именем в системе, у нас это eht0
- BOOTPROTO – способ назначения IP-адреса (static — статическое значение, указываем в ручную. dhcp — получить адрес автоматически)
- IPADDR – IP-адрес
- NETMASK – маска подсети
- GATEWAY – шлюз по умолчанию
- DNS1 – Основной DNS-сервер
- DNS2 — альтернативный DNS-сервер
- ONBOOT — способ запуска сетевого интерфейса (yes – автоматически, no – вручную)
- UUID – уникальный идентификатор сетевого интерфейса. Можно сгенерировать самостоятельно командой uuidgen.
- IPV4_FAILURE_FATAL – отключение сетевого интерфейса с IP-адресом v4, если он имеет неверную конфигурацию (yes – отключить, no – не отключать)
- IPV6_FAILURE_FATAL – отключение сетевого интерфейса с IP-адресом v6, если он имеет неверную конфигурацию (yes – отключить, no – не отключать)
- IPV6_AUTOCONF – разрешает или запрещает автоконфигурирование Ipv6 с помощью протокола
- IPV6_INIT – включение возможности использования адресации Ipv6(yes – адресация может использоваться, no – не используется)
- PEERROUTES – устанавливает приоритет настройки шлюза по умолчанию, при использовании DHCP
- IPV6_PEERROUTES — устанавливает приоритет настройки шлюза по умолчанию, при использовании DHCP для IPv6

___

**Дополнительный IP адрес на интерфейс:**

создайте alias к вашему основному файлу конфигурации:

      nano /etc/sysconfig/network-scripts/ifcfg-eth0:0

И добавьте несколько строк, без основного шлюза:

      DEVICE="eth0:0"
      BOOTPROTO=static
      ONBOOT="yes"
      IPADDR=192.168.x.x
      NETMASK=255.255.0.0

_или добавив дополнительный IP-адрес в основной файл конфигурации:_

      nano /etc/sysconfig/network-scripts/ifcfg-eth0

И измените его следующим образом:

 Generated by parse-kickstart

      UUID="b8bccd4c-fb1b-4d36-9d45-044c7c0194eb"
      IPADDR1="*.*.*.*"
      IPADDR2="*.*.*.*"
      GATEWAY="*.*.*.*"
      NETMASK="255.255.255.0"
      BOOTPROTO="static"
      DEVICE="eth0"
      ONBOOT="yes"
      DNS1=77.88.8.8
      DNS2=8.8.8.8
      DNS3=8.8.4.4
Где:

      IPADDR1 — первый IP-адрес
      IPADDR2 — второй IP-адрес
      GATEWAY — основной шлюз
