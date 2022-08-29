#!/bin/sh
#
#$ -cwd
#$ -N mcp_openmp
#$ -w e
#$ -m beas
#$ -j y
#
#$ -pe omp 16
#
########################################################################
 
# Number of required trials. This can be passed as the first additional
# argument to this script ($1). If not provided, we use the special
# ${value:-default} to specify a default number of trials.
num_trials=${1:-100000000}
 
# When this script is run on the cluster, the special variable $NSLOTS
# will contain the value you passed in the '-pe omp ...' option above.
#
# This variable is the number of threads you want to run, which you
# normally pass to your OpenMP code via the special OMP_NUM_THREADS
# environment variable.
 
# To also allow this script to be run outside the cluster, for example
# during initial testing, we specify a default number of threads (4)
# to use in this case (i.e. if NSLOTS is not set).
export OMP_NUM_THREADS=${NSLOTS:-4}
 
# Now run the OpenMP code
./monte_carlo_pi_openmp $num_trials