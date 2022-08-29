#!/bin/sh

rm -f output.dat

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi

F=${1}.castep

for FILE in $(find . -name "$F.*" | sort -V); do
    ENERGY="${FILE##*.}"
    LINE=`grep "LBFGS: Final Enthalpy" $FILE | tail -1`
    if [ -z "$LINE" ]; then
        echo "Run $ENERGY does not have finite basis set corrected energy"
    else
        ENTHALPY=$(echo $LINE | awk '{print $5}')
        OUT="${ENERGY},${ENTHALPY}"
        echo $OUT >> output.dat
        #cp output.dat ../../../enthalpies/$1.dat
    fi
done