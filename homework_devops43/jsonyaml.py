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