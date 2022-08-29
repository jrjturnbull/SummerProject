#!/bin/sh

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi


FILE=${1}.phonon
if ! test -f "$FILE"; then
    echo "$FILE does not exist"
    exit 1
fi


NAME=$1
NAME="${NAME}.castep"
LN=`grep -Fn 'Raman Susceptibility Tensors' $NAME`
LN="${LN%%:*}"
START=$(($LN-1))
tail -n +$START $NAME | tee output.temp 1>/dev/null


NAME="output.temp"
LN=`grep -Fn 'Symmetrised' $NAME`
LN="${LN%%:*}"
LN=$(($LN-3))
head -n $LN $NAME | tee ${1}.raman 1>/dev/null

rm output.temp