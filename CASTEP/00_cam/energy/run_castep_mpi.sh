#!/bin/sh
#
#$ -cwd
#$ -N castep_Si
#$ -m beas
#$ -pe mpi 16
#$ -R y
#
################################################################

module load openmpi/1.10
module load castep/18.1

job_name=Si
energy=100
np=${NSLOTS:-4}

function write_param
{
cat <<EOF
TASK                :   SinglePoint
XC_FUNCTIONAL       :   PBE
CUT_OFF_ENERGY      :   $energy eV
SPIN_POLARISED      :   false
FIX_OCCUPANCY       :   false
METALS_METHOD       :   DM
PERC_EXTRA_BANDS    :   40
MAX_SCF_CYCLES      :   100
CALCULATE_STRESS    :   true
WRITE_BIB           :   false
OPT_STRATEGY        :   speed
PAGE_WVFNS          :   0
NUM_DUMP_CYCLES     :   0
BACKUP_INTERVAL     :   0
FINITE_BASIS_CORR   :   0
EOF
}

mkdir output

while [ $energy -lt 701 ]; do
write_param > $job_name.param
mpirun -np $np castep.mpi Si
mv $job_name.castep output/$job_name.castep_2.$energy
energy=$((energy+10))
done