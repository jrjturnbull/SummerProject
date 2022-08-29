#!/bin/bash
#
# This -t argument is used to create an array job.
# Here we will be running 64 "tasks", numbered from 1 to 64.
#$ -t 1-64
#
#$ -cwd
#$ -N mcp_array
#$ -l h_rt=1:00:00
#$ -o /dev/null
#$ -e /dev/null
 
# Number of Monte Carlo trials to run for each task in this job.
# This can be passed as a command line argument, or will
# default to the number specified
num_trials=${1:-1000}
 
# Run the simulation, saving each task's result to a file
# under a sub-directory called results. The $SGE_TASK_ID
# variable contains the individual task's ID, which will be an
# integer between 1 and 64 here.
mkdir -p results
python3 monte_carlo_pi.py $num_trials -o results/task.$SGE_TASK_ID
