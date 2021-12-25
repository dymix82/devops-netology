# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Никакое т.к разные типы переменных a - целое и b -  строка, операция завершится с ошибкой  |
| Как получить для переменной `c` значение 12?  | c = str(a) + b  |
| Как получить для переменной `c` значение 3?  | c = a + int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
#is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
#        break
```

### Вывод скрипта при запуске при тестировании:
```bash
[opc@mylinuxbox 04-script-02-py]$ cd ~
[opc@mylinuxbox ~]$ ./git.py
04-script-02-py/README.md
04-script-03-yaml/README.md
README.md
[opc@mylinuxbox ~]$

```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os
print("Введите директорию репозитория, нажмите ввод если необходимо проверить текущую ")
rep_directory = input()
if(len(rep_directory) == 0):
    rep_directory = os.getcwd()
print("Проверка осуществлена в директории "+rep_directory)
bash_command = ["cd "+rep_directory , "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
  if result.find('modified') != -1:
   prepare_result = result.replace('\tmodified:   ', '')
   print(rep_directory+'/'+prepare_result)


```

### Вывод скрипта при запуске при тестировании:
```bash
[opc@mylinuxbox ~]$ ./git_mod.py
Введите директорию репозитория, нажмите ввод если необходимо проверить текущую

Проверка осуществлена в директории /home/opc
fatal: not a git repository (or any of the parent directories): .git
[opc@mylinuxbox ~]$ ./git_mod.py
Введите директорию репозитория, нажмите ввод если необходимо проверить текущую
~/netology/sysadm-homeworks
Проверка осуществлена в директории ~/netology/sysadm-homeworks
~/netology/sysadm-homeworks/04-script-02-py/README.md
~/netology/sysadm-homeworks/04-script-03-yaml/README.md
~/netology/sysadm-homeworks/README.md
[opc@mylinuxbox ~]$
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import socket
import time
from datetime import datetime
hosts = {"drive.google.com": "0.0.0.0", "mail.google.com": "0.0.0.0", "google.com": "0.0.0.0"}
i=1
#while i <= 5:   #Количество итераций - 5 для отладки
while 1 == 1: 
for key, value in hosts.items():
    last = value
    value = socket.gethostbyname(key)
    hosts[key] = value
    now = datetime.now()
    timenow = now.strftime("%d/%m/%Y %H:%M:%S")
    if ( value == last):
      print (timenow,key,value)
    else:
      print (timenow, "[ERROR]" ,key, "IP mismatch", last, value)
 time.sleep(10)
# i = i + 1
```

### Вывод скрипта при запуске при тестировании:
```bash
[opc@mylinuxbox ~]$ ./hosts
25/12/2021 19:43:28 [ERROR] drive.google.com IP mismatch 0.0.0.0 142.250.185.110
25/12/2021 19:43:28 [ERROR] mail.google.com IP mismatch 0.0.0.0 142.250.184.229
25/12/2021 19:43:28 [ERROR] google.com IP mismatch 0.0.0.0 142.250.181.238
25/12/2021 19:43:38 drive.google.com 142.250.185.110
25/12/2021 19:43:38 mail.google.com 142.250.184.229
25/12/2021 19:43:38 google.com 142.250.181.238
25/12/2021 19:43:48 drive.google.com 142.250.185.110
25/12/2021 19:43:48 mail.google.com 142.250.184.229
25/12/2021 19:43:48 google.com 142.250.181.238
25/12/2021 19:43:58 drive.google.com 142.250.185.110
25/12/2021 19:43:58 mail.google.com 142.250.184.229
25/12/2021 19:43:58 google.com 142.250.181.238

```