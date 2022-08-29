#!/bin/bash
#
#$ -N mcp_merge
#$ -cwd
#$ -l h_rt=0:05:00
#$ -o /dev/null
#$ -e /dev/null
#$ -m be
#
# Wait until the initial array job has finished
#$ -hold_jid mcp_array
 
# We pipe all of the individual result files into our
# combine.py script to generate the final result
cat results/task.* | python3 combine.py >results/combined
