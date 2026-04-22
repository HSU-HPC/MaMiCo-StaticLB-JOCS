#!/bin/bash

#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --nodelist=amd03
#SBATCH --partition=seperate_homes
#SBATCH --job-name="mamico"
#SBATCH --output="output%j"
#SBATCH --ntasks=32
##SBATCH --overcommit
#SBATCH --exclusive


export OMP_NUM_THREADS=1
cd /home/amartya/mpi-experiments/paperRuns/migrateRuns/amd32
mpirun --display-allocation --hostfile hosts --report-bindings hostname
mpirun -mca coll_hcoll_enable 0 --hostfile hosts ~/mpi-experiments/programs/MaMiCo/build/couette 2>&1

rm *.csv
rm AutoPas_Rank*
