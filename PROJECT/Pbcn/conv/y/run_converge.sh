#!/bin/sh
#
#$ -cwd
#$ -N Pbcn_y
#$ -m beas
#$ -pe mpi 8
#$ -R y
#
################################################################

PARCE="none"
N=$(find -name '*.cell')
NAME=${N%.cell}

if grep -q "\[" "$NAME.cell"; then
    PARCE="cell"
elif grep -q "\[" "$NAME.param"; then
    PARCE="param"
else
    echo "No convergence parameters set"
    exit 1
fi

################################################################

if [ $PARCE = "param" ]; then
cat << E0F > parce_param.py
import sys
import re

def main():
    if (len(sys.argv) != 3):
        print("Wrong number of args")
        return 0

    FILE_NAME = sys.argv[1]
    ITER_COUNT = sys.argv[2]

    with open(FILE_NAME) as f:
        FILE = f.readlines()

    out=""
    final = False
    dp = 1
    replace = 0

    for line in FILE:
        if (line.__contains__("[") and line.__contains__("]")):
            res = re.findall(r'\[.*?\]', line)

            parce = res[0][1:-1]
            parce = parce.split(",")
            start = parce[0]
            end = parce[1]
            dp = len(str(end))
            step = parce[2]

            replace = int(start) + int(ITER_COUNT) * int(step)
            if (int(replace) == int(end)):
                final = True
            line = line.replace(res[0], str(replace))
        out += line

    path = 'input/' + FILE_NAME + "." + str(replace).zfill(dp)
    f = open(path, "w+")
    f.write(out)

    return final

final = main()
print(str(final))
E0F
chmod 755 parce_param.py
fi

################################################################

if [ $PARCE = "cell" ]; then
cat << E0F > parce_cell.py
import sys
import re

def main():
    if (len(sys.argv) != 3):
        print("Wrong number of args")
        return 0

    FILE_NAME = sys.argv[1]
    ITER_COUNT = sys.argv[2]

    with open(FILE_NAME) as f:
        FILE = f.readlines()

    out=""
    final = False
    dp = 1
    replace = 0

    for line in FILE:
        if (line.__contains__("[") and line.__contains__("]")):
            res = re.findall(r'\[.*?\]', line)

            parce = res[0][1:-1]
            parce = parce.split(",")
            start = parce[0]
            end = parce[1]
            dp = len(str(end))
            step = parce[2]

            replace = int(start) + int(ITER_COUNT) * int(step)
            if (int(replace) == int(end)):
                final = True
            line = line.replace(res[0], str(replace))
        out += line

    path = 'input/' + FILE_NAME + "." + str(replace).zfill(dp)
    f = open(path, "w+")
    f.write(out)

    return final

final = main()
print(str(final))
E0F
chmod 755 parce_cell.py
fi

################################################################

FILE="$NAME.$PARCE"
ITER=0
mkdir -p input
mkdir -p output
while :
do
    TEST=$(python3 parce_$PARCE.py $FILE $ITER)
    if [ $TEST = "True" ]; then
        break
    fi
    ITER=$((ITER+1))
done

mv $FILE $FILE.old

module load openmpi/1.10
module load castep/18.1
np=${NSLOTS:-4}

for filename in input/*; do
    i=${filename##*.}
    cp input/$FILE.$i $FILE
    mpirun -np $np castep.mpi $NAME
    mv $NAME.castep output/$NAME.castep.$i
done
