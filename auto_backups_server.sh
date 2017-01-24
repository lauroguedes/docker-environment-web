#!/bin/sh

#Apagando os backups com mais de 3 dias
#find /home/git/gitlab/tmp/backups -ctime +2 -exec rm -rf {} \;

rclone sync /home/websites/apps googledrive:'SETOR WEBSITES/bkp_webserver'
