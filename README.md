# devops-netology
1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.  
Ответ:  
[dima@localhost terraform]$ git show aefea --pretty=oneline  
aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md  

2. Какому тегу соответствует коммит 85024d3?  
Ответ:  
[dima@localhost terraform]$ git tag --points-at 85024d3  
v0.12.23  
3.Сколько родителей у коммита b8d720? Напишите их хеши.  
Ответ:  
Родителя два, ниже часть вывода команды где есть их хеши
[dima@localhost terraform]$   git cat-file -p b8d720f  
...  
parent 56cd7859e05c36c06b56d013b55a252d0bb7e158  
parent 9ea88f22fc6269854151c571162c5bcf958bee2b  
4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.  

[dima@localhost terraform]$ git log --pretty=format:"%H %B" v0.12.23..v0.12.24 
33ff1c03bb960b332be3af2e333462dde88b279e v0.12.24  
b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links  
3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md  
6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable  
Non-HTTP errors previously resulted in a panic due to dereferencing the  
resp pointer while it was nil, as part of rendering the error message.  
This commit changes the error message formatting to cope with a nil  
response, and extends test coverage.  
Fixes #24384

5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location 

Since these links were in the soon-to-be-deprecated 0.11 language section, I 
think we can just remove them without needing to find an equivalent link. 

06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md 
d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows  
4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md  
dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md  
225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release  

5. Найдите коммит в котором была создана функция func providerSource,   
ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).  

8c928e83589d90a031f811fae52a81be7153e82f, Martin Atkins, Thu Apr 2 18:04:39 2020 -0700, main: Consult local directories as potential mirrors of providers

6. Найдите все коммиты в которых была изменена функция globalPluginDirs.  
  
[dima@localhost terraform]$ git log -S "globalPluginDirs" --pretty=oneline  
35a058fb3ddfae9cfee0b3893822c9a95b920f4c main: configure credentials from the CLI config file  
c0b17610965450a89598da491ce9b6b5cbd6393f prevent log output during init  
8364383c359a6b738a436d1b7745ccdce178df47 Push plugin discovery down into command package  

7. Кто автор функции synchronizedWriters?

Martin Atkins  









 
