#!/bin/bash

INICIO=`date +%d/%m/%Y-%H:%M:%S`
LOG=/var/log/rsync/`date +%Y-%m-%d`_log_bkp_webserver.txt

echo " " >> $LOG
echo " " >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo " Sincronização iniciada em $INICIO" >> $LOG

sudo rsync -Cravzp ~/apps/ /mnt/externalhd/backup_webserver >> $LOG
FINAL=`date +%d/%m/%Y-%H:%M:%S`

echo " Sincronização Finalizada em $FINAL" >> $LOG
echo "|-----------------------------------------------" >> $LOG
echo " " >> $LOG
echo " " >> $LOG
