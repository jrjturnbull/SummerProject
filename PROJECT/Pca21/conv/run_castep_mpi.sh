#!/bin/sh
#
#$ -cwd
#$ -N Pca21_30GPa
#$ -m beas
#$ -pe mpi 16
#$ -R y
#
################################################################

module load openmpi/1.10
module load castep/18.1

job_name=Pca21_30GPa
x=18
y=18
z=18
np=${NSLOTS:-16}

function write_cell
{
cat <<E0F
#
# CELL written by cell_write: Keith Refson, Oct 2006
#
%BLOCK lattice_cart
   ANG
       3.40621154263542        0.00000000000000        0.00000000000000    
       0.00000000000000        1.97875658594966        0.00000000000000    
       0.00000000000000        0.00000000000000        3.14678839465559    
%ENDBLOCK lattice_cart

%BLOCK cell_constraints
      1   2   3
      0   0   0
%ENDBLOCK cell_constraints

%BLOCK positions_frac
   H              0.352640568806495       0.136479606438893       0.378419098773317
   H              0.480559875935281       0.363449537236897       0.500481134793583
   H              0.980559875935281       0.636550462763102       0.500481134793583
   H              0.852640568806495       0.863520393561107       0.378419098773317
   H              0.019440124064719       0.363449537236897       0.000481134793584
   H              0.147359431193504       0.136479606438893       0.878419098773317
   H              0.519440124064719       0.636550462763102       0.000481134793584
   H              0.647359431193505       0.863520393561107       0.878419098773317
%ENDBLOCK positions_frac

FIX_COM : true

%BLOCK species_mass
   AMU
   H          1.007825032    
%ENDBLOCK species_mass

%BLOCK species_pot
   H       0|0.7|2|6|8|10L(qc=10)
%ENDBLOCK species_pot

%BLOCK symmetry_ops
# Symm. op. 1       E
          1.000000000000000       0.000000000000000       0.000000000000000
          0.000000000000000       1.000000000000000       0.000000000000000
          0.000000000000000       0.000000000000000       1.000000000000000
          0.000000000000000       0.000000000000000       0.000000000000000
# Symm. op. 2     2_1
         -1.000000000000000       0.000000000000000       0.000000000000000
          0.000000000000000      -1.000000000000000       0.000000000000000
          0.000000000000000       0.000000000000000       1.000000000000000
         -0.000000000000000      -0.000000000000000       0.500000000000000
# Symm. op. 3       c
         -1.000000000000000       0.000000000000000       0.000000000000000
          0.000000000000000       1.000000000000000       0.000000000000000
          0.000000000000000       0.000000000000000       1.000000000000000
          0.500000000000000       0.000000000000000       0.500000000000000
# Symm. op. 4       a
          1.000000000000000       0.000000000000000       0.000000000000000
          0.000000000000000      -1.000000000000000       0.000000000000000
          0.000000000000000       0.000000000000000       1.000000000000000
          0.500000000000000      -0.000000000000000       0.000000000000000
%ENDBLOCK symmetry_ops

kpoint_mp_grid :    $x  $y  $z

phonon_kpoint_mp_grid :    1   1   1

%BLOCK external_pressure
   GPA
        30.00000000      0.00000000      0.00000000
        30.00000000      0.00000000
        30.00000000
%ENDBLOCK external_pressure
E0F
}

mkdir kpoint_x
x=1
while [ $x -lt 18 ]; do
    write_cell > $job_name.cell
    mpirun -np $np castep.mpi Pca21_30GPa
    mv $job_name.castep kpoint_x/$job_name.castep.$x
    x=$((x+1))
done
x=18

mkdir kpoint_y
y=1
while [ $y -lt 18 ]; do
    write_cell > $job_name.cell
    mpirun -np $np castep.mpi Pca21_30GPa
    mv $job_name.castep kpoint_y/$job_name.castep.$y
    y=$((y+1))
done
y=18

mkdir kpoint_z
z=1
while [ $z -lt 18 ]; do
    write_cell > $job_name.cell
    mpirun -np $np castep.mpi Pca21_30GPa
    mv $job_name.castep kpoint_z/$job_name.castep.$z
    z=$((z+1))
done
z=18