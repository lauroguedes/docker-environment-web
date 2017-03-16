#!/usr/bin/env bash

cd ~/apps/websites
cp -R default_folder $1/$2
cd $1/$2
mv default_folder $3
cd $3
mv site.com.br $3

echo "Projeto criado!"
