# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

### Ответ
```
FROM centos:7
MAINTAINER dymix82
LABEL Remarks="Elastic Search"
USER root
RUN yum -y update
RUN yum -y install wget
RUN yum -y install java-1.8.0-openjdk
RUN yum -y install java-1.8.0-openjdk-devel
RUN useradd elasticsearch -c 'Elasticsearch User' -d /home/elasticsearch
RUN \
   mkdir /var/lib/elasticsearch && \
   mkdir /var/log/elasticsearch
RUN \
  chown elasticsearch:elasticsearch /var/lib/elasticsearch && \
  chown elasticsearch:elasticsearch /var/log/elasticsearch

USER elasticsearch
RUN cd /tmp && wget --no-check-certificate https://138.3.251.58/elasticsearch-8.1.2-linux-x86_64.tar.gz && tar -xzf elasticsearch-8.1.2-linux-x86_64.tar.gz && rm elasticsearch-8.1.2-linux-x86_64.tar.gz
RUN mv /tmp/elasticsearch-8.1.2/* /home/elasticsearch
ENV ES_HOME /home/elasticsearch
ENV ES_CONFIG /home/elasticsearch/config/elasticsearch.yml
ENV PATH=$PATH:/home/elasticsearch/bin
RUN echo "node.name: netology_test" >> $ES_CONFIG
RUN echo "node.roles: [ master ]" >> $ES_CONFIG
RUN echo "path.data: /var/lib/elasticsearch" >> $ES_CONFIG
RUN echo "path.logs: /var/log/elasticsearch" >> $ES_CONFIG
CMD ["elasticsearch"]
EXPOSE 9200
EXPOSE 9300
```
https://hub.docker.com/repository/docker/dymix82/elastic
```bash
[elasticsearch@031d6a6f0f5b bin]$ curl -u admin -k -X GET "https://127.0.0.1:9200                                                                                                                                                  /"
Enter host password for user 'admin':
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "5YVevD4yQxSCAWrA1g0I-w",
  "version" : {
    "number" : "8.1.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "31df9689e80bad366ac20176aa7f2371ea5eb4c1",
    "build_date" : "2022-03-29T21:18:59.991429448Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
[elasticsearch@031d6a6f0f5b bin]$
```
## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
```bash
[elasticsearch@031d6a6f0f5b _state]$ curl -ku admin  https://localhost:9200/_cat/indices
Enter host password for user 'admin':
green open ind-1 BJTlOsHpQ-2Qp_Ha9bIW3A 1 0
yellow open ind-3 6BiOqGtHTv2gHE6s8ECzIw 2 4
yellow open ind-2 fW7wrCMXR8GaSlAPEz6gkw 1 2
```
Получите состояние кластера `elasticsearch`, используя API.
```bash
	$ curl -ku elastic  https://localhost:9200/_cluster/hh?pretty
	Enter host password for user 'elastic':
	{
	  "cluster_name" : "elasticsearch",
	  "status" : "yellow",
	  "timed_out" : false,
	  "number_of_nodes" : 1,
	  "number_of_data_nodes" : 1,
	  "active_primary_shards" : 9,
	  "active_shards" : 9,
	  "relocating_shards" : 0,
	  "initializing_shards" : 0,
	  "unassigned_shards" : 10,
	  "delayed_unassigned_shards" : 0,
	  "number_of_pending_tasks" : 0,
	  "number_of_in_flight_fetch" : 0,
	  "task_max_waiting_in_queue_millis" : 0,
	  "active_shards_percent_as_number" : 47.368421052631575
	}
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

 "Желтые" индексы созданы с количеством реплик и шард больше фактически имеющихся. Кластер "желтый" потому, что количество unassigned_shards больше нуля.


Удалите все индексы.
```bash
curl -u admin -X DELETE "https://localhost:9200/ind-2"
```
**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.

		$ docker exec -it 0a5764a8b82a mkdir /home/elasticsearch/snapshots

Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup
```
$ curl -ku elastic -X PUT "https://127.0.0.1:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/home/elasticsearch/snapshots"
  }
}
'
Enter host password for user 'elastic':
{
  "error" : {
    "root_cause" : [
      {
        "type" : "repository_exception",
        "reason" : "[netology_backup] location [/home/elasticsearch/snapshots] doesn't match any of the locations specified by path.repo because this setting is empty"
      }
    ],
    "type" : "repository_exception",
    "reason" : "[netology_backup] failed to create repository",
    "caused_by" : {
      "type" : "repository_exception",
      "reason" : "[netology_backup] location [/home/elasticsearch/snapshots] doesn't match any of the locations specified by path.repo because this setting is empty"
    }
  },
  "status" : 500
}
```
Разместим каталог снапшотов в /var/lib/elastic/snapshots, для этого модифицируем Dockerfile и пересоберем контейнер:

```
RUN adduser -mr elastic && mkdir -p /var/lib/elasticsearch/snapshots && chown -R elastic /var/lib/elasticsearch/snapshots
$ curl -ku elastic -X PUT "https://127.0.0.1:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
 {
   "type": "fs",
   "settings": {
   "location": "/var/lib/elasticsearch/snapshots"
   }
 }
'
```
Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
```
$ curl -ku elastic -X PUT http://localhost:9200/test -H 'Content-Type: application/json' -d'
	{ "settings":
    { "number_of_replicas": 0,
	   "number_of_shards": 1 }
    }
	'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
$ curl -X GET 'http://localhost:9200/_cat/indices?v'
	health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
	green  open   test  8AUelgbETem8uCUkF5baXA   1   0          0            0       225b           225b
```
Создайте snapshot состояния кластера elasticsearch.
Приведите в ответе список файлов в директории со snapshotами.
```
$ curl -ku elastic -X PUT http://localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
	{"snapshot": {"snapshot":"elasticsearch", "uuid":"s83fs4KlTnuuQqfjP6e59Q", "repository":"netology_backup","version_id":8000099,"version":"8.0.0","indices":["t0est"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-03-02T04:11:05.095Z","start_time_in_millis":1646194265095,"end_time":"2022-03-02T04:11:05.495Z","end_time_in_millis":1646194265495,"duration_in_millis":400,"failures":[],"shards":{"total":1,"failed":0,"successful":1},"feature_states":[]}}

$ docker exec -it 0a5764a8b82a ls -la /var/lib/elasticsearch/snapshots/
		total 36
		drwxr-xr-x. 1 elasticsearch elasticsearch   176 Mar  2 04:11 .
		drwxr-xr-x. 1 elasticsearch elasticsearch    34 Mar  2 03:56 ..
		-rw-r--r--. 1 elasticsearch elasticsearch   589 Mar  2 04:11 index-0
		-rw-r--r--. 1 elasticsearch elasticsearch     8 Mar  2 04:11 index.latest
		drwxr-xr-x. 1 elasticsearch elasticsearch    44 Mar  2 04:11 indices
		-rw-r--r--. 1 elasticsearch elasticsearch 17135 Mar  2 04:11 meta-s83fs4KlTnuuQqfjP6e59Q.dat
		-rw-r--r--. 1 elasticsearch elasticsearch   308 Mar  2 04:11 snap-s83fs4KlTnuuQqfjP6e59Q.dat
```
Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
```
$ curl -ku elastic -X DELETE 'http://localhost:9200/test?pretty'
$ curl -ku elastic -X PUT http://localhost:9200/test-2 -H 'Content-Type: application/json' -d'
	{ "settings":
	  { "number_of_replicas": 0,
	   "number_of_shards": 1 }
	   }
	'
$ curl -ku elastic -X GET 'http://localhost:9200/_cat/indices?v'		
	health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
	green  open   test-2 oez0F7msTnydqE0UB5uMBw   1   0          0            0       225b           225b
```
Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.
Приведите в ответе запрос к API восстановления и итоговый список индексов.
```
$ curl -ku elastic -X POST 'http://localhost:9200/.*/_close?pretty'
		{
		  "acknowledged" : true,
		  "shards_acknowledged" : false,
		  "indices" : { }
		}
$ curl -ku elastic -X POST 'http://localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?wait_for_completion=true'
{
  "snapshot":
  {
    "snapshot":"elasticsearch",
    "indices":["test"],
    "shards":
      {
        "total":1,
        "failed":0,
        "successful":1
      }
   }
}
```
```
$ curl -ku elastic -X GET 'http://localhost:9200/_cat/indices?v'
     health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
	 green  open   test-2 oez0F7msTnydqE0UB5uMBw   1   0          0            0       247b           247b
	 green  open   test   x77pFGEBQr6JLdh4Nu01YQ   1   0          0            0       225b           225b
```