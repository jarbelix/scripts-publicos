#!/bin/bash
# Remove unused data
# Jarbas, 28/10/2020

export PATH="/usr/sbin:/usr/bin:/sbin:/bin"

# Se este script já estiver rodando então não faça nada
pidof -x -o %PPID $0 > /dev/null && exit

#------------------------------------------
# Informa sobre o Cancelamento pelo Usuário
_abort()
{ # BEGIN _abort
        echo "!!! Rotina $0 CANCELADA por usuário.">&2
        exit 1
} # END _abort

# Basename/Dirname
BASENAME=`basename $0 .sh`
DIRNAME=`dirname $0`

# Arquivo de log
FILE_LOG="/tmp/${BASENAME}.log"

{

echo "BEGIN: `date`"
df -hT /
echo "Show docker disk usage"
echo "======================"
docker system df
echo "======================"
echo "Remove unused data"
echo "======================"
echo "y" | docker system prune -a --volumes
echo "======================"
df -hT /
echo "END: `date`"

} 2>&1 | tee ${FILE_LOG}.txt

