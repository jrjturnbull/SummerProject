#!/bin/sh
#
#$ -cwd
#$ -N Pca21_norm
#$ -m beas
#$ -pe mpi 16
#$ -R y
#
################################################################

module load openmpi/1.10
module load castep/18.1
np=${NSLOTS:-8}
mpirun -np $np castep.mpi Pca21_30GPa
