#!/bin/bash

# Efetua um BKP do Mysql/MariaDB local
#
# 05/Fev/2020 - jarbas.junior@gmail.com - Implementação Inicial
#

export PATH="/usr/sbin:/usr/bin:$HOME/bin"

#Se este script já estiver rodando então não faça nada
pidof -x -o %PPID $0 > /dev/null && echo "Script $0 ainda em execução. Saindo agora..." && exit

# Definição de algumas variáveis globais
#
Basename=`basename $0 .Sh`
Dirname=`dirname $0`

# Data e Hora Local
Datahora=`date +%Y%M%D-%H%M%S`

# Dia da semana (dom, seg, ...)
DDS=`date +%a`

# IP do Servidor (eth0 ou ens192)
IP=`hostname --all-ip-addresses | awk '{ print $1 }'`

# Super Usuário do Mysql
_USER="root"

# Senha do root do Mysql (geralmente é deixado em branco)
_PWD=""

# Onde os dumps serão armazenados
_DUMP_DIR="/root/mysqldump"

echo "Inicio da Execução: `date`"

echo -E "
=============================================================
Backup do Mysql/MariaDB
=============================================================
"

mkdir -p $_DUMP_DIR

# Excluir os databases nativos do Mysql/MariaDB
DATABASES=`mysqlshow --user="$_USER" --password="$_PWD" | grep "^| [a-z]" | cut -f 2 -d" " | grep -v -E "(mysql|performance_schema|information_schema)"`

for BD in $DATABASES; do

	DESTINO="$_DUMP_DIR/mysql-$IP-$DDS-$BD.sql"

        echo ""
        echo "================================================================================"
        echo "`date` - DUMP ==>> $BD"
        echo "================================================================================"
	mysqldump $BD --user="$_USER" --password="$_PWD" --skip-lock-tables > $DESTINO

	DUMP_STATUS=$?

	if [ $DUMP_STATUS -eq 0 ]; then
                ls -laht $DESTINO
                echo "--------------------------------------------------------------------------------"
                echo "`date` - GZIP"
                echo "--------------------------------------------------------------------------------"
                gzip -f $DESTINO

                ZIP_STATUS=$?
                if [ $ZIP_STATUS -eq 0 ]; then
			ls -laht $DESTINO.gz
		else
			echo "*****ERRO***** GZIP $DESTINO"
		fi
	else
		echo "*****ERRO***** DUMP $DESTINO"
	fi
done;


echo "Fim da Execução: `date`"
