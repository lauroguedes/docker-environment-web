# Ambiente web docker modificado do projeto **Laravel homestead-docker**
Esse ambiente docker monta 5 containers sendo um ambiente Web nginx php7.0(php7, nginx, grunt, gulp, git, bower, redis, etc...), um ambiente web nginx php5.6, um ambiente web apache php7.1, mysql 5.7 e phpmyadmin. 

- link do projeto original (https://github.com/shincoder/homestead-docker)
- imagem oficial mysql (https://hub.docker.com/r/mysql/mysql-server/)
- imagem oficial phpmyadmin (https://hub.docker.com/r/phpmyadmin/phpmyadmin)

### Instalar docker e docker compose
* Acesse esse material para instalar o docker em ambiente linux (https://docs.docker.com/installation/ubuntulinux/)
* Acesse esse material para instalar o docker compose (https://docs.docker.com/compose/install/)

Após feita a instalação siga os passos seguintes

### Baixe a imagem do ambiente web
```shell
docker pull shincoder/homestead:php7.0
```

### Clone o projeto em uma pasta no seu host
```shell
git clone http://192.168.1.5/leo/docker-environment-web.git
```

### Inicie os containers
```shell
sudo docker-compose up -d
```

### Entre no container php7.0 utilizando SSH (a senha solicitada é: secret)
```shell
ssh -p 2221 homestead@localhost
```
### Entre no container php5.6 utilizando SSH (a senha solicitada é: secret)
```shell
ssh -p 2224 homestead@localhost
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
Para criar um virtual hosts de forma automática basta executar o arquivo **nginx7vhost.sh** para o container php7.0 e **nginx5vhost.sh** para o container php5.6 e **apachevhost.sh** para o container apache-php7.1 e passar os parâmetros pedidos como string do host e caminho do projeto.

### Criar pasta de projeto no servidor Apache PHP 7

Insira o seguinte comando no servidor web

```shell
sudo createproject.sh <tipo_projeto> <ano> <dominiodoprojeto>
```

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
0  3    * * *   root    ~/docker/homestead-docker/autbackup.sh
```

Lembrando que o caminho do arquivo **autbackup.sh** deve ser alterado caso você tenha colocado o arquivo em outro local. O crontab irá executar o script todos os dias as 3 horas da manhã, altere de acordo com sua necessidade.

Altere também o script autbackup.sh e coloque o caminho de sua unidade montada no host.

### Sobre o Ambiente

O ambiente criará os links entre os dois ambientes web e mysql e também mysql e phpmyadmin.

Os volumes serão criados no seguinte diretório do Host:

**~/apps/volumes** para o container php7.0, **~/apps/volumessites** para o container php5.6 e **~/apps/volumeswebsites** para container apache-php7.1. Dentro da pasta ~/apps/www(projetos do container php7.0), ~/apps/sites (projetos do container php5.6) e ~/apps/websites (projetos do container apache-php7.1) é onde ficarão as pastas e arquivos dos projetos que poderão ser acessados publicamente.

As portas mapeadas no host serão:
- 80 - acesso público container apache-php7.1
- 8000 - acesso público container php7.0
- 8002 - acesso público container php5.6
- 8080 - acesso ao phpMyAdmin
- 33060 - porta mapeada para o mysql

Caso queira alterar qualquer configuração dos containers docker, basta editar o arquivo **docker-compose.yml**.

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
