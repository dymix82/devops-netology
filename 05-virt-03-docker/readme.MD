## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.
### Ответ
https://hub.docker.com/repository/docker/dymix82/nginx
### 

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

### Ответ
Мне кажется, вышеописанная конфигурация прямо напрашивается на контейнеризацию. Несколько микросервисов с независимым функционалом,
все можно поднять на одной ОС, для всех существуют образы на dockerhub, соответственно получаем легкость и быстроту развертывания плюс идемпотентность.
Единственное, я бы подумал над запуском БД на отдельной ВМ или как сервиса в облаке, но это зависит от требований к безопасности и сохранности данных конкретного проекта. 
Тестовый контур можно и БД в контейнере запустить.
### 

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

### Ответ
```bash
root@vault:~/docker# mkdir data
root@vault:~/docker# docker run -it --rm -d --name centos -v ./data:/data centos                                                                                                                                                  Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
ef8f4a5783c39f63b65af1278eca6723042f5543d468b7803c798c6418a06ddc
root@vault:~/docker# docker run -it --rm -d --name debian -v ~/docker/data:/data                                                                                                                                                   debian
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
e4d61adff207: Pull complete
Digest: sha256:10b622c6cf6daa0a295be74c0e412ed20e10f91ae4c6f3ce6ff0c9c04f77cbf6
Status: Downloaded newer image for debian:latest
dcc3e06268a518437baf8a1e2c6594ad8ed013ae39950407552e019cae09767a
root@vault:~/docker# docker exec -it centos /bin/bash
[root@ef8f4a5783c3 /]# ls
bin   dev  home  lib64       media  opt   root  sbin  sys  usr
data  etc  lib   lost+found  mnt    proc  run   srv   tmp  var
[root@ef8f4a5783c3 /]# cd data
[root@ef8f4a5783c3 data]# echo "Test test test" > test.txt
[root@ef8f4a5783c3 data]# exit
exit
root@vault:~/docker# docker exec -it debian /bin/bash
root@dcc3e06268a5:/# cat /data/test.txt
Test test test
root@dcc3e06268a5:/# ls /data
test.txt
```