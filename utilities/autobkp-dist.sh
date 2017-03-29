#!/bin/sh

INICIO=`date +%d/%m/%Y-%H:%M:%S`
LOG=~/apps/log/autobkp/`date +%Y-%m-%d`_log_bkp_webserver.txt

echo " " >> $LOG
echo " " >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo " Sincronização iniciada em $INICIO" >> $LOG

#Se o storage esta montado, sera desmontado por seguranca
if df -h | awk "{print $6}" | grep -q "/mnt/storage-bkp"; then
   umount /mnt/storage-bkp >> $LOG
fi

echo "montando o storage..."
mount -t cifs <seu_servidor_remoto> /mnt/storage-bkp -o user=<user>,pass=<pw>,uid=1000 >> $LOG

#se o storage foi montado com sucesso
if df -h | awk "{print $6}" | grep -q "/mnt/storage-bkp"; then
   rsync -Cravzp --progress --delete ~/apps/* /mnt/storage-bkp >> $LOG
fi

FINAL=`date +%d/%m/%Y-%H:%M:%S`

echo " Sincronização Finalizada em $FINAL" >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo " " >> $LOG
echo " " >> $LOG
