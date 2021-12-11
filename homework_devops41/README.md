# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательные задания

1. Есть скрипт:
    ```bash
    a=1
    b=2
    c=a+b
    d=$a+$b
    e=$(($a+$b))
    ```
    * Какие значения переменным c,d,e будут присвоены?
    * Почему?  
`c` так и присвоится значение строки `a+b` так как это строчная переменная  
`d` присвоится значение `1+2`, т.к bash так же воспринимает их две строчных переменных  
`e` будет равна `3` т.к bash воспримет двойную скобку как арифметическую операцию двух целых чисел.

2. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
    ```bash
    while ((1==1)
    do
    curl https://localhost:4757
    if (($? != 0))
    then
    date >> curl.log
    fi
    done
    ```
Первое в условии while пропущена скобка из-за этого скрипт не запустится  
Второе чтобы скрипт не писал так много событий в лог можно поставить ожидание и выход при успехе:
```bash
while ((1==1)
  do
         curl https://localhost:4757
    if (($? != 0))
      then
          date >> curl.log
      else
          break
    fi
    sleep 5 # ждать 5 сек
  done
```
    
Можно "заморочиться" и сделать скрипт таким образом, чтобы в лог только писалось время падения сервиса и время его поднятия
```bash
#!/bin/bash
wait_until_start () {
 while ((1==1))
 do
 curl https://localhost:4757
 if (($? == 0))
   then
  echo $(date) Server goes up >> curl.log
 break
 fi
 sleep 5
done
}
while ((1==1))
 do
    curl https://localhost:4757
 if (($? != 0))
    then
    echo $(date) Server goes down  >> curl.log
 wait_until_start
 fi
sleep 5
done
```
Получим такой лог:
```bash
[opc@mylinuxbox ~]$ cat curl.log
Sat Dec 11 20:32:44 GMT 2021 Server goes down
Sat Dec 11 20:33:04 GMT 2021 Server goes up
Sat Dec 11 20:33:29 GMT 2021 Server goes down
Sat Dec 11 20:33:54 GMT 2021 Server goes up
```

3. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.
```bash
#!/bin/bash
declare -a ips=(192.168.0.1, 173.194.222.113, 87.250.250.242)
count=5
for i in $(seq $count)
do
 for ip in "${ips[@]}"
  do
   curl -I -m 1 http://$ip
   if (($? == 0))
   then
    echo $(date) Service $ip is ok >> log.log
   else
     echo $(date) Serivce $ip is not ok >> log.log
   fi
 done
done
```
4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается
```bash
#!/bin/bash
declare -a ips=(192.168.0.1, 173.194.222.113, 87.250.250.242)
while ((1==1))
do
 for ip in "${ips[@]}"
  do
   curl -I -m 1 http://$ip
   if (($? == 0))
   then
    echo $(date) Service $ip is ok >> log.log
   else
   echo $ip - $(date) Something went wrong >> error
   exit
   fi
 done
done
```