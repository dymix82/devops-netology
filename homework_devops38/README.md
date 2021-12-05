# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```
Получилось

2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
```bash
vagrant@vagrant:~$ sudo ip link add type dummy
vagrant@vagrant:~$ sudo ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 86096sec preferred_lft 86096sec
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link
       valid_lft forever preferred_lft forever
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 0a:9d:ab:82:70:cb brd ff:ff:ff:ff:ff:ff
vagrant@vagrant:~
```
3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
```bash
vagrant@vagrant:~$ ss -lnt
State                           Recv-Q                           Send-Q                                                     Local Address:Port                                                     Peer Address:Port                          Process
LISTEN                          0                                4096                                                             0.0.0.0:111                                                           0.0.0.0:*
LISTEN                          0                                4096                                                       127.0.0.53%lo:53                                                            0.0.0.0:*
LISTEN                          0                                128                                                              0.0.0.0:22                                                            0.0.0.0:*
LISTEN                          0                                4096                                                                [::]:111                                                              [::]:*
LISTEN                          0                                128                                                                 [::]:22                                                               [::]:*
vagrant@vagrant:~$
```
Т.к виртуалка пустая то слушает только rpcbind порт 111 (зарезервированный порт по RPC,в настоящее время используется только призапуске NFS), SSH по 22 порту (сервис удаленного подключения) и 53 - DNS на интерфейсе localhost


4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
```bash
vagrant@vagrant:~$ ss -lun
State                           Recv-Q                          Send-Q                                                      Local Address:Port                                                     Peer Address:Port                          Process
UNCONN                          0                               0                                                           127.0.0.53%lo:53                                                            0.0.0.0:*
UNCONN                          0                               0                                                          10.0.2.15%eth0:68                                                            0.0.0.0:*
UNCONN                          0                               0                                                                 0.0.0.0:111                                                           0.0.0.0:*
UNCONN                          0                               0                                                                    [::]:111                                                              [::]:*
vagrant@vagrant:~$                        
```
Т.к виртуалка пустая то слушает только rpcbind (зарезервированный порт по RPC,в настоящее время используется только призапуске NFS),  53 - DNS на интерфейсе localhost и 68 BOOTPC использует DHCP-клиент

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.
   ![](../../../Downloads/NETWORK.png)