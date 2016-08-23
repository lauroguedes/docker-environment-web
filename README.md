# Ambiente web docker modificado do projeto **Laravel homestead-docker**
Esse ambiente docker monta 3 containers sendo um ambiente Web(php7, nginx, grunt, gulp, git, bower, redis, etc...), mysql 5.7 e phpmyadmin. 

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

### Entre no container web utilizando SSH (a senha solicitada é: secret)
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
Para criar um virtual hosts de forma automática basta executar o arquivo **createvhost.sh** e passar os parâmetros pedidos como string do host e caminho do projeto.

### Compartilhar pasta do servidor web com servidor windows
Siga os links abaixo para realizar o compartilhamento de pastas entre servidor linux e windows

Tutorial - (http://goo.gl/khaVNg)
Vídeo - (https://www.youtube.com/watch?v=PipbcLMaHWo)

### Backup automático do ambiente de desenvolvimento
Para realizar o backup do ambiente de forma automática, basta editar o arquivo /etc/crontab do host e inserir a seguinte linha no final do arquivo:

```shell
0  3    * * *   root    sh ~/docker/homestead-docker/autbackup.sh
```

Lembrando que o caminho do arquivo **autbackup.sh** deve ser alterado caso você tenha colocado o arquivo em outro local. O crontab irá executar o script todos os dias as 3 horas da manhã, altere de acordo com sua necessidade.

Altere também o script autbackup.sh e coloque o caminho de sua unidade montada no host.

### Sobre o Ambiente

O ambiente criará os links entre o ambiente web e mysql e também mysql e phpmyadmin.

Os volumes serão criados no seguinte diretório do Host:
`~/apps/volumes`, dentro da pasta /apps poderá criar as pastas e arquivos do projeto para o ambiente público das aplicações

As portas mapeadas no host serão:
- 80 - acesso público web
- 8080 - acesso ao phpMyAdmin
- 33060 - porta mapeada para o mysql

Caso queira alterar qualquer configuração dos containers docker, basta editar o arquivo ***docker-compose.yml***.
