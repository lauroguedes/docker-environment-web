# Ambiente web docker modificado do projeto **Laravel homestead-docker**

Esse ambiente foi criado para sanar a necessidade de utlilizar versões diferentes do php e de servidores web diferentes.

Esse ambiente docker monta 5 containers sendo eles:
- um ambiente Web nginx php7.0(php7, nginx, grunt, gulp, git, bower, redis, npm, composer, etc...);
- um ambiente web nginx php5.6(php5.6, nginx, grunt, gulp, git, bower, redis, npm, composer, etc...);
- um ambiente web apache php7.1(php7.1, apache, composer, npm, gulp, git);
- mysql 5.7;
- phpMyAdmin. 

**Links dos projetos originais**

- link do projeto original (https://github.com/shincoder/homestead-docker)
- imagem oficial mysql (https://hub.docker.com/r/mysql/mysql-server/)
- imagem oficial phpmyadmin (https://hub.docker.com/r/phpmyadmin/phpmyadmin)

### Instalar docker e docker compose
Antes de usar esse ambiente primeiramente deverá instalar o docker e o docker-compose em seu servidor.

* Acesse esse material para instalar o docker em ambiente linux (https://docs.docker.com/installation/ubuntulinux/)
* Acesse esse material para instalar o docker-compose (https://docs.docker.com/compose/install/)

Após feita a instalação siga os passos seguintes

### Fazer o comando docker rodar sem sudo
1. Adicione o grupo docker caso não exista
```shell
sudo groupadd docker
```

2. Adicione seu usuário ao grupo docker
```shell
sudo gpasswd -a ${USER} docker
```

3. Reinicie o docker
```shell
sudo service docker restart
```

4. Ative as mudanças de grupo
```shell
newgrp docker
```

### Clone o projeto em uma pasta no seu host
```shell
git clone https://github.com/lauroguedes/docker-environment-web.git
```

### Inicie os containers
Antes de dar o comando abaixo, abra o arquivo docker-composer.dist.yaml e configure as portas, nome dos containers, senha do mysql e volumes de acordo com sua necessidade e salve o arquivo como **docker-composer.yaml**.
```shell
sudo docker-compose up -d
```

### Entre no container php7.0 utilizando SSH (a senha solicitada é: secret)
```shell
ssh -p 2221 homestead@localhost
```

### Entre no container php5.6 utilizando SSH (a senha solicitada é: secret)
```shell
ssh -p 2223 homestead@localhost
```

### Entre no container apache php7.1 utilizando SSH (a senha solicitada é: secret)
```shell
ssh -p 2222 homestead@localhost
```

### Adicione virtual hosts aos projetos
Supondo que sua pasta mapeada é a /apps então digite o seguinte comando dentro do container web

```shell
cd / && ./serve.sh minhaapp /apps/minhaapp
```

Ao fazer isso o nome 'minhaapp' já estará disponível no virtual host do nginx

Agora saia do container web digitando 'exit' para voltar ao servidor host e edite o arquivo /etc/hosts inserindo a seguinte linha:
```shell
127.0.0.1               minhaapp
```

### Virtual hosts de forma automática
Para criar um virtual hosts de forma automática basta executar o arquivo **nginx7vhost.sh** para o container php7.0 e **nginx5vhost.sh** para o container php5.6 e **apachevhost.sh** para o container apache-php7.1 e passar os parâmetros: Ex: `comando <host> <caminlho> --alias(opcional)`. O parâmetro **--alias** fará com que crie um apelido no seu servidor para rodar comandos como composer, npm e gulp. 

Para ilustrar esse cenário suponha que você esteja criando um virtual host para o projeto **globalsys** onde os arquivos que rodam o projeto está em **apps/nginx-php-7.0/www/globalsys/appsys** e você quer usar o composer nesse projeto. Então o camando para criar o virtual host no container será o seguinte:

```shell
sudo nginx7vhost globalsys globalsys/appsys --alias
```

No 2º parâmetro coloque o caminho sempre a partir da pasta **www**.

### Compartilhar pasta do servidor web com servidor windows
Siga os links abaixo para realizar o compartilhamento de pastas entre servidor linux e windows

Tutorial - (http://goo.gl/khaVNg)
Vídeo - (https://www.youtube.com/watch?v=PipbcLMaHWo)

Caso queira compartilhar uma pasta mapeada por um HD Externo ou pendrive do linux para windows, edite o arquivo /etc/samba/smb.conf e acrescente a linha seguinte:

```shell
usershare owner only = false
```

Reinicie o samba com

```shell
sudo service samba reload
```

### Backup automático do ambiente de desenvolvimento
Para realizar o backup do ambiente de forma automática, basta editar o arquivo /etc/crontab do host e inserir a seguinte linha no final do arquivo:

```shell
0  3    * * *   root    ~/<caminho_do_projeto>/utilities/autobkp.sh
```

Lembrando que o caminho do arquivo **autobkp.sh** deve ser alterado caso você tenha colocado o arquivo em outro local. O crontab irá executar o script todos os dias as 3 horas da manhã, altere de acordo com sua necessidade.

Altere também o script autobkp.sh e coloque o caminho de sua unidade montada no host.

## Utilitários
Esse projeto vem com alguns utilitários que podem ser úteis para seu ambiente. Lembrando que todos os arquivos que tem o sufixo **-dist** são modificáveis para cada ambiente e por esse motivo devem ser copiados no seu projeto sem o sufixo e o seu conteúdo deve ser alterado de acordo com sua necessidade.
- autobkp-dist.sh: Esse script executa uma rotina de backup automático para alguma outra mídia utilizando o rsync;
- apachevhost.sh - Cria virtual hosts para o container apache-php-7.1;
- nginx7vhost.sh - Cria virtual hosts para o container nginx-php-7.0;
- nginx5vhost.sh - Cria virtual hosts para o container nginx-php-5.6;
- windows-host-dist.bat - Cria virtual host para ambiente windows.

## Criando Alias para agilisar execução de comandos no Servidor

Abra o arquivo /etc/bash.bashrc (com isso, todos os usuários vão ter acesso a esses aliases), digite: 

```shell
sudo vim /etc/bash.bashrc
```

E cole os comandos abaixo: 

```shell
alias c='clear'
alias upgrade='sudo apt-get upgrade'
alias reiniciar='sudo reboot'
alias desligar='sudo shutdown -h now'
alias update='sudo apt-get update'
# Entrar nos containers via bash
alias n7bash='docker exec -it nginx-php-7.0 bash'
alias n5bash='docker exec -it nginx-php-5.6 bash'
alias a7bash='docker exec -it apache-php-7.1 bash'
```


## GUIA DE BOLSO DOCKER

**Build de uma imagem**

docker build -t <nome_da_imagem> <caminho_para_dockerfile>

**Executar um container**

docker run -d -p <porta_host>:<porta_container> --name <nome_container> <nome_imagem>
OBS1: Nesse exemplo, eu estou fazendo um mapeamento de portas com a opção -p. Para mais detalhes, veja aqui a documentação desse tópico.
OBS2: Você pode adicionar links entre um ou mais containers usando a opção --link <nome_container>:<alias>.
OBS3: Você pode adicionar explicitamente uma entrada ao arquivo de hosts do container através do parâmetro --add-host <nome_host>:<endereco_IP>.

**Iniciar uma sessão bash em um container que esteja rodando**

docker exec -it <nome_container> bash

**Ver os logs de um container**

docker logs <nome_container>

**Ver todas as imagens no host**

docker images

**Ver todos os containers**

docker ps -a

**Remover um container**

docker rm -f <nome_container>

**Remover TODOS os containers**

docker rm -f $(docker ps -a -q)

**Remover uma imagem**

docker rmi -f <nome_imagem>

**Remover dangling images (Dangling images", imagens sem uma tag)**

docker rmi $(docker images -q -f dangling=true)

**Copiar um arquivo do container para o host**

docker cp <nome_container>:/caminho/no/container /caminho/no/host
Exemplo: docker cp app1:/home/ec2-user/log.txt /logs

**Docker stats - Verificar os recursos consumidos pelo container da máquina física**

docker stats <nome_container>
