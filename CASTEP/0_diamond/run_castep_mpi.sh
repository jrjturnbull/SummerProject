#!/bin/sh
#
#$ -cwd
#$ -N castep_mpi_C2
#$ -m beas
#$ -pe mpi 4
#$ -R y
#
################################################################

np=${NSLOTS:-4}
module load openmpi/1.10
module load castep/18.1
mpirun -np $np castep.mpi C2
