# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

### Ответ
```bash
docker  run -e POSTGRES_HOST_AUTH_METHOD=trust -e POSTGRES_PASSWORD=password --mount=type=volume,src=vol1,dst=/vol1 --mount=type=volume,src=vol2,dst=/vol2 -d docker.io/library/postgres:12-alpine
```
###

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
```
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
```
```commandline
test_db=# \d
               List of relations
 Schema |      Name      |   Type   |  Owner
--------+----------------+----------+----------
 public | clients        | table    | postgres
 public | clients_id_seq | sequence | postgres
 public | orders         | table    | postgres
 public | orders_id_seq  | sequence | postgres
(4 rows)
```
- описание таблиц (describe)
```commandline
test_db=# \d+ clients
                                                      Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default               | Storage  | Stats target | Description
-------------------+---------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 фамилия           | text    |           |          |                                     | extended |              |
 страна_проживания | text    |           |          |                                     | extended |              |
 заказ             | integer |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "страна_проживания_idx" btree ("страна_проживания")
Foreign-key constraints:
    "fk_orders" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap

test_db=#
```
```commandline
test_db=# \d+ orders
                                                   Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------------+---------+-----------+----------+------------------------------------+----------+--------------+-------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 наименование | text    |           |          |                                    | extended |              |
 цена         | integer |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "fk_orders" FOREIGN KEY ("заказ") REFERENCES orders(id)
Access method: heap
```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```sql
test_db=# SELECT grantee, privilege_type
test_db-# FROM information_schema.role_table_grants
test_db-# WHERE table_name='orders'
test_db-# ;
     grantee      | privilege_type
------------------+----------------
 postgres         | INSERT
 postgres         | SELECT
 postgres         | UPDATE
 postgres         | DELETE
 postgres         | TRUNCATE
 postgres         | REFERENCES
 postgres         | TRIGGER
 test_admin_user  | INSERT
 test_admin_user  | SELECT
 test_admin_user  | UPDATE
 test_admin_user  | DELETE
 test_admin_user  | TRUNCATE
 test_admin_user  | REFERENCES
 test_admin_user  | TRIGGER
 test_simple_user | INSERT
 test_simple_user | SELECT
 test_simple_user | UPDATE
 test_simple_user | DELETE
(18 rows)
```
```
test_db=# SELECT grantee, privilege_type
test_db-# FROM information_schema.role_table_grants
test_db-# WHERE table_name='clients'
test_db-# ;
     grantee      | privilege_type
------------------+----------------
 postgres         | INSERT
 postgres         | SELECT
 postgres         | UPDATE
 postgres         | DELETE
 postgres         | TRUNCATE
 postgres         | REFERENCES
 postgres         | TRIGGER
 test_admin_user  | INSERT
 test_admin_user  | SELECT
 test_admin_user  | UPDATE
 test_admin_user  | DELETE
 test_admin_user  | TRUNCATE
 test_admin_user  | REFERENCES
 test_admin_user  | TRIGGER
 test_simple_user | INSERT
 test_simple_user | SELECT
 test_simple_user | UPDATE
 test_simple_user | DELETE
(18 rows)
```
- список пользователей с правами над таблицами test_db


## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|
```commandline
test_db=# INSERT INTO orders ("наименование","цена")
test_db-# VALUES
test_db-# ('Шоколад',10),
test_db-# ('Принтер',3000),
test_db-# ('Книга',500),
test_db-# ('Монитор',7000),
test_db-# ('Гитара',4000)
test_db-# ;
INSERT 0 5

```

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|
```commandline
test_db=# INSERT INTO clients ("фамилия","страна_проживания")
test_db-# VALUES
test_db-# ('Иванов Иван Иванович','USA'),
test_db-# ('Петров Петр Петрович','Canada'),
test_db-# ('Иоганн Себастьян Бах','Japan'),
test_db-# ('Ронни Джеймс Дио','Russia'),
test_db-# ('Ritchie Blackmore','Russia')
test_db-# ;
INSERT 0 5
```
Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
```commandline
test_db=# SELECT count(*) FROM orders;
 count
-------
     5
(1 row)

test_db=# SELECT count(*) FROM clients;
 count
-------
     5
(1 row)

test_db=#

```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.
```bash
test_db=# UPDATE clients SET заказ=3 WHERE id=1;
UPDATE 1
test_db=# UPDATE clients SET заказ=4 WHERE id=2;
UPDATE 1
test_db=# UPDATE clients SET заказ=5 WHERE id=3;
UPDATE 1
```
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 ```commandline
test_db=# SELECT * FROM clients WHERE заказ IS NOT NULL;
 id |       фамилия        | страна_проживания | заказ
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```commandline
test_db=# EXPLAIN SELECT clients."фамилия", orders."наименование" FROM clients, orders WHERE clients."заказ" = orders.id
test_db-# ;
                              QUERY PLAN
-----------------------------------------------------------------------
 Hash Join  (cost=37.00..57.24 rows=810 width=64)
   Hash Cond: (clients."заказ" = orders.id)
   ->  Seq Scan on clients  (cost=0.00..18.10 rows=810 width=36)
   ->  Hash  (cost=22.00..22.00 rows=1200 width=36)
         ->  Seq Scan on orders  (cost=0.00..22.00 rows=1200 width=36)
(5 rows)
```
Выбран план простого последовательного сканирования.
37.00: приблизительная стоимость запуска. Это время, которое проходит, прежде чем начнётся этап вывода данных, например для сортирующего узла это время сортировки.
57.24: приблизительная общая стоимость. Она вычисляется в предположении, что узел плана выполняется до конца, то есть возвращает все доступные строки.
810: ожидаемое число строк, которое должен вывести этот узел плана. При этом так же предполагается, что узел выполняется до конца.
64: ожидаемый средний размер строк, выводимых этим узлом плана (в байтах).
## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```commandline
docker exec -itu postgres 7dfc6de3d8c1 pg_dump -U postgres -h 127.0.0.1 -x -F c test_db >/vol1/test_db_backup
docker exec -itu postgres ca68ba48c68f pg_restore -U postgres -C -d postgres /vol1/test_db_backup 
```
