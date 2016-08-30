#!/usr/bin/env bash

echo "Informe o nome do servidor (Ex.: siteexemplo) :"
read vhost
 
echo "Informe o caminho do site (Ex.: pastapai/pastafilha) :"
read path
 
echo "Criando configuração de VHost para o servidor"

docker exec -d nginx-php-5.6 sh /serve.sh $vhost $path

echo "127.0.0.1		$vhost" >> "/etc/hosts"

echo "Vhost criado!"
