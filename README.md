# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.  
Ответ:  
chdir("/tmp")

2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.  
Ответ:  
Файл базы данных /usr/share/misc/magic.mgc, так же он ищет его в домашней папке но не находит  
    ```bash
    stat("/home/vagrant/.magic.mgc", 0x7ffd9ccd9c00) = -1 ENOENT (No such file or directory)  
    stat("/home/vagrant/.magic", 0x7ffd9ccd9c00) = -1 ENOENT (No such file or directory)  
    openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)  

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).  
 Ответ:
   ```bash
   vagrant@vagrant:~$ lsof | grep -i test  
   mc        4703                       vagrant   11r      REG              253,0      106     131096 /home/vagrant/test2.txt (deleted)  
   vagrant@vagrant:~$ cd /proc/4703  
   vagrant@vagrant:/proc/4703$ echo '' >/proc/4703/fd/4  
   vagrant@vagrant:/proc/4703$ cat /proc/4703/fd/4
   
     
   ```



4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?  
Ответ:  
 Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, 
 размер которой ограничен для каждого пользователя и системы в целом.  

5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).   
    ```bash
    806    vminfo              4   0 /var/run/utmp
    608    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
    608    dbus-daemon        18   0 /usr/share/dbus-1/system-services
    608    dbus-daemon        -1   2 /lib/dbus-1/system-services
    608    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
   ```
6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.  
   Ответ: системный вызов uname()  
     ```bash
   Part of the utsname information is also accessible  via  /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
     ```
7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?  
 ; - оператор позволяющий запускать несколько команд последовательно  
 && - оператор будет выполнять вторую команду только в том случае, если первая была выполнена успешно.
 Использовать '&&' при применении set -e смысла нет т.к параметр -e комманды set прерывает ее при возвращении ненулевого значения.   
8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
   ```bash 
    -e  прерывает исполнение в случае возврата не нулевого значения .
    -u  выведет необъявленные переменные как ошибки
    -x  выводит комманды и их аргументы как они были введены
    -o pipefail возвращает значение набора комманд , статус последней команды
       при выходе с ненулевым статусом или 0 если не было завершения комманд с ненулевым статусом
    ```
   Большая детализация и немедленное завершение выполнения в случае ошибки

9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
   ```bash
   Самые частые статусы:
   I  - Idle kernel thread (фоновые процессы ядра)
   S  - interruptible sleep (Процессы ожидающие события для завершения)
   ```
   Дополнительные буквы это характеристики приоретет, родительский статус процессов.
  
 ---