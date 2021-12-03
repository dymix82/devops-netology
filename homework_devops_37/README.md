# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
```bash
Windows
C:\Users\gavva>ipconfig /all
```
```bash
Linux
vagrant@vagrant:~$ ip a
$ /sbin/ifconfig -a (если стоит inetutils)
```

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
LLDP – протокол для обмена информацией между соседними устройствами.  
lldpd - пакет   
lldpctl - команда
 
3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.   
 VLAN
Пакет vlan
```bash
auto enp1s0
iface enp1s0 inet dhcp

auto enp1s0.10
iface enp1s0.10 inet dhcp
vlan-raw-device enp1s0
```
4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.  
LAG - агрегация портов

для netplan
``` bash
network:
  bonds:
    bond0:
      dhcp4: false
      addresses:
              - 10.8.0.11/24
      gateway4: 10.8.0.1
      nameservers:
              addresses: [10.1.0.203, 10.1.0.204]
      interfaces:
      - ens1f0
      - ens1f1
      parameters:
        lacp-rate: fast
        mode: 802.3ad
        transmit-hash-policy: layer2+3
  ethernets:
    ens1f0: {}
    ens1f1: {}
  version: 2
```
для настройки через файлы interfaces
```bash
auto lo
iface lo inet loopback

# The primary network interface
auto bond0
iface bond0 inet static
address 192.168.1.10
netmask 255.255.255.0
network 192.168.1.0
gateway 192.168.1.254
slaves eth0 eth1
# jumbo frame support
mtu 9000
# Load balancing and fault tolerance
bond-mode balance-rr
bond-miimon 100
bond-downdelay 200
bond-updelay 200
dns-nameservers 192.168.1.254
dns-search localdomain.local
```
6. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.	  
В маске 8 адресов из них под хосты 6  
32 подсетей /29 можно получить из сети с маской /24
10.10.10.0/29  
10.10.10.8/29  
10.10.10.128/29
7. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.  
  100.64.0.0/26
8. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
```powershell
PS C:\Users\gavva> arp -a

Интерфейс: 10.2.2.53 --- 0x8
  адрес в Интернете      Физический адрес      Тип
  10.2.0.1              00-11-22-33-44-55     динамический
  224.0.0.22            01-00-5e-00-00-16     статический
  239.255.255.250       01-00-5e-7f-ff-fa     статический
  255.255.255.255       ff-ff-ff-ff-ff-ff     статический
PS C:\Users\gavva> arp -d *
PS C:\Users\gavva> arp -d 192.168.0.1
```
```bash
vagrant@vagrant:~$ ip neigh
10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 REACHABLE
10.0.2.3 dev eth0 lladdr 52:54:00:12:35:03 STALE
vagrant@vagrant:~$ sudo ip neigh flush all
vagrant@vagrant:~$ ip neigh flush 10.2.2.2
```

