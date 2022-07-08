# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
```bash

[opc@instance-20211206-2239 mnt-netlogy]$ ansible --version
ansible [core 2.11.12]
  config file = None
  configured module search path = ['/home/opc/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.6/site-packages/ansible
  ansible collection location = /home/opc/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.6.8 (default, Apr 11 2022, 08:25:52) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10.0.1)]
  jinja version = 2.10.1
  libyaml = True
```
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
https://github.com/dymix82/mnt-netology.git
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

4. https://github.com/dymix82/mnt-netology/tree/main/playbook

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
```bash
[opc@instance-20211206-2239 playbook]$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ***********************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************

ok: [localhost]

TASK [Print OS] *****************************************************************************************************************
ok: [localhost] => {
    "msg": "OracleLinux"
}

TASK [Print fact] ***************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP **********************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[opc@instance-20211206-2239 playbook]$
```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
```commandline
[opc@instance-20211206-2239 mnt-netlogy]$ grep -rnw ./* -e '12'
./playbook/group_vars/all/examp.yml:2:  some_fact: 12
[opc@instance-20211206-2239 mnt-netlogy]$ cat ./playbook/group_vars/all/examp.yml
---
  some_fact: all default fact
```
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
```bash
[opc@instance-20211206-2239 mnt-netlogy]$ docker ps
CONTAINER ID  IMAGE                                         COMMAND               CREATED         STATUS             PORTS       NAMES
90e7285a91f8  docker.io/brunneis/python:3.8.6-ubuntu-focal                        24 minutes ago  Up 14 minutes ago              ubuntu
efd338c2f1e9  docker.io/library/centos:centos7                                    24 minutes ago  Up 14 minutes ago              centos7
```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
```bash
[opc@instance-20211206-2239 mnt-netlogy]$ ansible-playbook playbook/site.yml -i playbook/inventory/prod.yml

PLAY [Print os facts] ***********************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *****************************************************************************************************************
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] ***************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP **********************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[opc@instance-20211206-2239 mnt-netlogy]$
```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
```bash
TASK [Print fact] **********************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
