#!/bin/sh
#
#$ -cwd
#$ -N castep_mpi_NaCl
#$ -m beas
#$ -pe mpi 16
#$ -R y
#
################################################################

np=${NSLOTS:-4}
module load openmpi/1.10
module load castep/18.1
mpirun -np $np castep.mpi NaCl
