#!/bin/sh
#
#$ -cwd
#$ -N Pbcn_deut
#$ -m beas
#$ -pe mpi 16
#$ -R y
#
################################################################

generate_cell()
{
PRESSURE=$1

cat $FILE.base > input/$FILE.$PRESSURE
cat << E0F >> input/$FILE.$PRESSURE

%BLOCK EXTERNAL_PRESSURE
GPA
$1  0   0
    $1  0
        $1
%ENDBLOCK EXTERNAL_PRESSURE
E0F

}

abs_diff()
{
    local diff
    diff=$(($1 - $2));
    if [ $diff -lt 0 ]; then
        diff=$((-$diff))
    fi
    echo $diff
}

################################################################

module load openmpi/1.10
module load castep/18.1
np=${NSLOTS:-4}

FILE=$(find -name '*.cell')
FILE=${FILE:2}
NAME=${FILE%.cell}
PARCE=$(head -n 1 $FILE)
PARCE=${PARCE#"|"}
PARCE=${PARCE%"|"}

START="$(cut -d',' -f1 <<<$PARCE)"
END="$(cut -d',' -f2 <<<$PARCE)"
STEP="$(cut -d',' -f3 <<<$PARCE)"
DIFF=`abs_diff $END $START`
COUNT=$(($DIFF / $STEP))

mkdir -p input
mkdir -p output
cp $FILE $FILE.orig
tail -n +2 $FILE > $FILE.new
rm $FILE
mv $FILE.new $FILE
mv $FILE $FILE.base

for i in `seq 0 $COUNT`; do
    CHANGE=$(($i * $STEP))
    PRESSURE=$(($START - $CHANGE))
    if [ $PRESSURE -lt 100 ]; then
	PRESSURE="0$PRESSURE"
    fi
    generate_cell $PRESSURE
    
    cp input/$FILE.$PRESSURE $FILE
    mpirun -np $np castep.mpi $NAME

    cp $NAME-out.cell output/$NAME-out.cell.$PRESSURE
    cp $NAME.castep output/$NAME.castep.$PRESSURE
    if [ -e $NAME.0001.err ]; then
	cp $NAME.0001.err output/$NAME.0001.err.$PRESSURE
    fi

    P_START=$(grep -niF "%BLOCK external" $NAME-out.cell | cut -f1 -d:)
    P_END=$(grep -niF "%ENDBLOCK external" $NAME-out.cell | cut -f1 -d:)

    sed "${P_START},${P_END}d" $NAME-out.cell > $NAME-out.cell.new
    rm $NAME-out.cell
    mv $NAME-out.cell.new $FILE.base
done
