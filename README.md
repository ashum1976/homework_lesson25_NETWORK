


#  Сбор и анализ логов

####Домашнее задание по теме "Сбор и анализ логов":












#   Общая теория, примеры, полезности.


Именование интерфейсов, нотация от systemd - Predictable Network Interface Names.
В своем виде по умолчанию использует форматы (упрощенно)

• **PCI:**
(en|wl)[P<domain>]p<bus>s<slot>[f<function>][n<phys_port_name>|d<dev_port>]

• **Onboard:**
(en|wl)[P<domain>]o<bus>[f<function>][n<phys_port_name>|d<dev_port>]

Таким образом enp0s3 говорит нам о том, что мы имеем дело с Ethernet-адаптером подключенным к шине pci No0 в слот No3, а eno1 говорит об onboard ethernet-адаптере с индексом 1.
