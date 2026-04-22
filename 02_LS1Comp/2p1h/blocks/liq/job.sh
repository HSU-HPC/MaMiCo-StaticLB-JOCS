#!/bin/bash

#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --nodelist=amd03
#SBATCH --partition=seperate_homes
#SBATCH --job-name="puremd"
#SBATCH --output="output%j"
#SBATCH --ntasks=64
##SBATCH --overcommit
#SBATCH --exclusive


export OMP_NUM_THREADS=1
cd /home/amartya/mpi-experiments/paperRuns/puremd-comps/halfhalf-amd/blocks/liq
mpirun --display-allocation --hostfile hosts --report-bindings hostname
mpirun -mca coll_hcoll_enable 0 --hostfile hosts /home/amartya/mpi-experiments/programs/ls1-mardyn/build/src/MarDyn config.xml 2>&1

rm *.csv
rm AutoPas_Rank*
