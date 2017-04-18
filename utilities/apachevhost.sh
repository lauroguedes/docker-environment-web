#!/usr/bin/env bash

echo "Criando configuração de VHost para o servidor"

docker exec -d apache-php-7.1 sh /server.sh $1 $2

echo "127.0.0.1         $1" >> "/etc/hosts"

if [ -e $3 ];
then
  echo "Host without alias"
else
  if [ $3 = "--alias" ];
  then
    echo "alias c-a7-$1='docker run -it --rm -v $(pwd):/apps/www/$2 leowgweb/apache-php-7.1 composer'" >> "/etc/bash.bashrc"
    echo "alias n-a7-$1='docker run -it --rm -v $(pwd):/apps/www/$2 leowgweb/apache-php-7.1 npm'" >> "/etc/bash.bashrc"
    echo "alias g-a7-$1='docker run -it --rm -v $(pwd):/apps/www/$2 leowgweb/apache-php-7.1 gulp'" >> "/etc/bash.bashrc"
  fi
fi

echo "Vhost criado!"
