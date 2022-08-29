#!/bin/sh
#
#$ -cwd
#$ -N castep_mpi_quartz
#$ -m beas
#$ -pe mpi 4
#$ -R y
#
################################################################

module load openmpi/1.10
module load castep/18.1

job_name=quartz
energy=100
np=${NSLOTS:-4}

function write_param
{
cat <<E0F
task                :       singlepoint
fix_occupancy       :       true
opt_strategy        :       speed
num_dump_cycles     :       0
xc_functional       :       LDA
cut_off_energy      :       $energy eV
grid_scale          :       1.75
elec_method         :       dm
mixing_scheme       :       Pulay
mix_charge_amp      :       0.6
elec_energy_tol     :       1.0e08 eV
calculate_stress    :       true

E0F
}

mkdir output

while [ $energy -lt 1001 ]; do
write_param > $job_name.param
mpirun -np $np castep.mpi quartz
mv $job_name.castep output/$job_name.castep_2.$energy
energy=$((energy+10))
done