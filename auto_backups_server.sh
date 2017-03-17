#!/bin/sh

#Se o storage esta montado, sera desmontado por seguranca
if df -h | awk "{print $6}" | grep -q "/mnt/storagewebsites"; then
   umount /mnt/storagewebsites
fi

echo "montando o storage..."
mount -t cifs //192.168.1.2/websites /mnt/storagewebsites -o user=lauroguedes,pass=789789,uid=1000

#se o storage foi montado com sucesso
if df -h | awk "{print $6}" | grep -q "/mnt/storagewebsites"; then
   echo "sincronizado a pasta do servidor web..."
   rsync -avz ~/apps/* /mnt/storagewebsites/bkp_webserver
   #Apagando os arquivos antigos. Serao preservados apenas os 10 mais novos
   #ls -td1 /mnt/storage/Servers/EagleUbu/gitlab/* | sed -e '1,10d' | xargs -d '\n' rm -rif
fi
