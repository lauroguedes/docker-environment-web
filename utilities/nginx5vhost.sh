#!/usr/bin/env bash
 
echo "Criando configuração de VHost para o servidor"

docker exec -d nginx-php-5.6 sh /serve.sh $1 /apps/www/$2

echo "127.0.0.1		$1" >> "/etc/hosts"

if [ -e $3 ];
then
  echo "Host without alias"
else
  if [ $3 = "--alias" ];
  then
    echo "alias c-n5-$1='docker run -it --rm -v $(pwd):/apps/www/$2 shincoder/homestead:php5.6 composer'" >> "/etc/bash.bashrc"
    echo "alias n-n5-$1='docker run -it --rm -v $(pwd):/apps/www/$2 shincoder/homestead:php5.6 npm'" >> "/etc/bash.bashrc"
    echo "alias g-n5-$1='docker run -it --rm -v $(pwd):/apps/www/$2 shincoder/homestead:php5.6 gulp'" >> "/etc/bash.bashrc"
  fi
fi

echo "Vhost criado!"
