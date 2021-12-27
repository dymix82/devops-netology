# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис  
Добавил ковычек в сроке             "ip" : "71.78.22.43"

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import socket
import time
from datetime import datetime
import json
import yaml
hosts = {"drive.google.com": "0.0.0.0", "mail.google.com": "0.0.0.0", "google.com": "0.0.0.0"}
i=1
#while i <= 5:   #Количество итераций - 4 для отладки
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
      file = open("hosts.yaml", "a")
      outfile = open("hosts.json", "a")
      yaml.dump([{key : value}], file)
      json.dump({key:value}, outfile)
      outfile.write('\n')
      file.close()
 time.sleep(10)
```


### Вывод скрипта при запуске при тестировании:
```
[opc@mylinuxbox ~]$ ./jsonyaml.py
27/12/2021 07:54:57 [ERROR] drive.google.com IP mismatch 0.0.0.0 142.250.185.110
27/12/2021 07:54:57 [ERROR] mail.google.com IP mismatch 0.0.0.0 142.250.184.229
27/12/2021 07:54:57 [ERROR] google.com IP mismatch 0.0.0.0 142.250.181.238
27/12/2021 07:55:07 drive.google.com 142.250.185.110
27/12/2021 07:55:07 mail.google.com 142.250.184.229
27/12/2021 07:55:07 google.com 142.250.181.238
27/12/2021 07:55:17 drive.google.com 142.250.185.110
...
27/12/2021 08:06:48 google.com 142.250.181.238
27/12/2021 08:06:58 [ERROR] drive.google.com IP mismatch 142.250.185.110 142.250.74.206
27/12/2021 08:06:58 mail.google.com 142.250.184.229

```

### json-файл(ы), который(е) записал ваш скрипт:
```json
[opc@mylinuxbox ~]$ cat hosts.json
{"drive.google.com": "142.250.185.110"}
{"mail.google.com": "142.250.184.229"}
{"google.com": "142.250.181.238"}
{"drive.google.com": "142.250.74.206"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
[opc@mylinuxbox ~]$ cat hosts.yaml
- drive.google.com: 142.250.185.110
- mail.google.com: 142.250.184.229
- google.com: 142.250.181.238
- drive.google.com: 142.250.74.206

```
