#!/bin/bash

#SBATCH --time=00:30:00
#SBATCH --nodes=2
#SBATCH --nodelist=amd03,arm07
#SBATCH --partition=seperate_homes
#SBATCH --job-name="mamico"
#SBATCH --output="output%j"
#SBATCH --ntasks-per-node=48 
#SBATCH --cpus-per-task=1
#SBATCH --exclusive


export OMP_NUM_THREADS=1
cd /home/amartya/mpi-experiments/paperRuns/migrateRuns2/amd40arm08
mpirun --display-allocation --hostfile hosts --report-bindings hostname
mpirun -mca coll_hcoll_enable 0 --hostfile hosts ~/mpi-experiments/programs/MaMiCo/build/couette 2>&1
rm *.csv
rm AutoPas_Rank*
