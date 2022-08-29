#!/bin/sh
#
#$ -cwd
#$ -N Pbcn_r50
#$ -m beas
#$ -pe mpi 4
#$ -R y
#
################################################################

FILE=$(find -name '*.cell')
FILE=${FILE:2}
NAME=${FILE%.cell}

np=${NSLOTS:-4}
module load openmpi/1.10
module load castep/18.1
mpirun -np $np castep.mpi $NAME
