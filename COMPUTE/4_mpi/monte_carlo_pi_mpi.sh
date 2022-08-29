#!/bin/sh
#
# Standard arguments
#$ -cwd
#$ -N mcp_mpi
#$ -m beas
#
# MPI arguments
#$ -pe mpi 16
#$ -R y
#
################################################################

num_trials=${1:-1000000}
np=${NSLOTS:-4}
module load openmpi
mpirun -np $np ./monte_carlo_pi_mpi $num_trials