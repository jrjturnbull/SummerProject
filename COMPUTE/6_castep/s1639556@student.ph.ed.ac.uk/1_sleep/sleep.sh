#!/bin/sh
#$ -cwd
#$ -N sleep
#$ -m be
#$ -l h_rt=0:05:00

###############################################

echo "Going to sleep"
sleep 60
echo "Woken up!"
