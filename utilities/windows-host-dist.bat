REM[Desenvolvido por Lauro Guedes - leowgweb.com]

@ECHO OFF
CLS

cd c:\windows\system32\drivers\etc

SET /P NOME=Insira o nome do host:
echo <IP_do_seu_servidor>		%NOME% >> hosts