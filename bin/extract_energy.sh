#!/bin/sh

rm -f output.dat

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi

F=${1}.castep

for FILE in $(find . -name "$F.*" | sort -V); do
    PARAM="${FILE##*.}"
    LINE=`grep "Total energy corrected for finite basis set" $FILE`
    if [ -z "$LINE" ]; then
        echo "Run $PARAM does not have finite basis set corrected energy"
    else
        ENERGY=$(echo $LINE | awk '{print $9}')
        OUT="${PARAM},${ENERGY}"
        echo $OUT >> output.dat
    fi
done