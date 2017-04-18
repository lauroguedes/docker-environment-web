#!/usr/bin/env bash

echo "Criando configuração de VHost para o servidor"

docker exec -d nginx-php-7.0 sudo sh /serve.sh $1 /apps/www/$2

echo "127.0.0.1		$1" >> "/etc/hosts"

if [ -e $3 ];
then
  echo "Host without alias"
else
  if [ $3 = "--alias" ];
  then
    echo "alias c-n7-$1='docker run -it --rm -v $(pwd):/apps/www/$2 shincoder/homestead:php7.0 composer'" >> "/etc/bash.bashrc"
    echo "alias n-n7-$1='docker run -it --rm -v $(pwd):/apps/www/$2 shincoder/homestead:php7.0 npm'" >> "/etc/bash.bashrc"
    echo "alias g-n7-$1='docker run -it --rm -v $(pwd):/apps/www/$2 shincoder/homestead:php7.0 gulp'" >> "/etc/bash.bashrc"
  fi
fi

echo "Vhost criado!"
