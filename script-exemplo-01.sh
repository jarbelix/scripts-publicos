#!/bin/bash

# Exemplo de uso do pidof
#
# 05/Fev/2020 - jarbas.junior@gmail.com - Implementação Inicial
#

# Se este script já estiver rodando então não faça nada
pidof -x -o %PPID $0 > /dev/null && echo "Script $0 ainda em execução. Saindo agora..." && exit

# Definição de algumas variáveis globais
#
Basename=`basename $0 .Sh`
Dirname=`dirname $0`

# Data e Hora Local
Datahora=`date +%Y%M%D-%H%M%S`

# Simular o tempo de execução necessário
TempoExecucao=$(($RANDOM%120))

echo "Inicio da Execução: `date`"

echo -E "
========== Variaveis Globais Setadas ===========================
Scriptname......: [$0]
Basename........: [$Basename]
Dirname.........: [$Dirname]
Datahora........: [$Datahora]
TempoExecucao...: [$TempoExecucao]
================================================================
"

echo -E "
=============================================================
Execução do script em andamento
=============================================================
"

sleep $TempoExecucao    # Simula a execução com o sleep

echo "Fim da Execução: `date`"