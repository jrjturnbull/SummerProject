#!/bin/bash
#$ -cwd
#$ -N mcp_simple
#$ -m be

num_trials=${1:-1000}
python3 monte_carlo_pi.py $num_trials -o result
