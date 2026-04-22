# Compilation Instructions

## Installing MPI and UCX for cross-hardware SLURM

A shared path name is necessary for MPI.
(If the two systems have a different architecture, e.g. Intel and ARM, they have to belong to a local filesystem, since the binary executables are not compatible.)

### Prerequisite packages

```bash
# Mandatory

autoconf # for ucx, mpi
automake # for ucx, mpi
g++
gcc
libtools

# Optional
git
bzip2 # for tar
```

### Paths to set in .bashrc

```bash
export PROJ_HOME="<your folder here>"

export PATH="$PROJ_HOME/mpi-software/openmpi-5.0.5-install/bin/${PATH:+:$PATH}"
export LD_LIBRARY_PATH="$PROJ_HOME//mpi-software/openmpi-5.0.5-install/lib/${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export MPI_ROOT="$PROJ_HOME//mpi-software/openmpi-5.0.5-install"

export PATH="$PROJ_HOME/mpi-software/ucx-install/bin/${PATH:+:$PATH}"
export LD_LIBRARY_PATH="$PROJ_HOME/mpi-software/ucx-install/lib/ucx/${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH="$PROJ_HOME/mpi-software/ucx-install/lib/${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
```

### Installing UCX

```bash
wget https://github.com/openucx/ucx/releases/download/v1.19.0/ucx-1.19.0.tar.gz
tar -xf ucx-1.19.0.tar.gz
mkdir ucx-install
cd ucx-1.19.0
CC=gcc CXX=g++ ./contrib/configure-release --prefix="$PROJ_HOME/mpi-software/ucx-install" 2>&1 | tee config.out
CC=gcc CXX=g++ make -j10 2>&1 | tee make.out
CC=gcc CXX=g++ make install 2>&1 | tee install.out
```

### Installing MPI (after UCX)

HCOLL was disabled since it was not supported.

```bash
wget https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.5.tar.bz2
tar -xf openmpi-5.0.5.tar.bz2
mkdir openmpi-5.0.5-install
cd openmpi-5.0.5
mkdir build && cd build
CC=gcc CXX=g++ ../configure --without-hcoll --prefix="$PROJ_HOME/mpi-software/openmpi-5.0.5-install/" --with-ucx="$PROJ_HOME/mpi-software/ucx-install" 2>&1 | tee config.out
CC=gcc CXX=g++ make -j 20 all 2>&1 | tee make.out
CC=gcc CXX=g++ make install 2>&1 | tee install.out
```

### Setting up SLURM

For the experiments, a partition was created with an AMD and an ARM node. Submitting to this partition ensured that SLURM allocated resources appropriately to both nodes.

## Installing the programs for the experiment

### Standalone ls1

#### Versions for experiment 1

ls1 commit: 2755920777fbde8f20058854f8cd76852b85fd1a

AutoPas commit: 0338ff17d55cc770a403efee69740a69753d64ad

#### Instructions

```bash
CC=gcc CXX=g++ cmake -DENABLE_ADIOS2=OFF -DENABLE_MPI=ON -DOPENMP=OFF -DENABLE_AUTOPAS=ON -DAUTOPAS_ENABLE_DYNAMIC_CONTAINERS=OFF -DAUTOPAS_ENABLE_ENERGY_MEASUREMENTS=OFF -DENABLE_UNIT_TESTS=OFF -DENABLE_ALLLBL=ON -DMAMICO_COUPLING=OFF -DMAMICO_SRC_DIR=../.. .. #ls1cmake
```

This is run separately and build on both systems for the internode experiments, on the same relative path from home.

### ls1 + MaMiCo for modelling

MaMiCo tag: MaMiCo-2025

ls1 commit: fcda39fb862f2ff50a4f038e8f75444f13f87625

#### ls1 instructions

Make sure to `init` the ls1 submodule first, and then checkout the above commit before building.

```bash
CC=gcc CXX=g++ cmake -DENABLE_ADIOS2=ON -DENABLE_MPI=ON -DOPENMP=OFF -DENABLE_AUTOPAS=OFF -DENABLE_UNIT_TESTS=OFF -DENABLE_ALLLBL=ON -DMAMICO_COUPLING=ON -DMAMICO_SRC_DIR=../.. .. #ls1cmake
```

#### MaMiCo instructions

```bash
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_WITH_MPI=ON -DMD_SIM=LS1_MARDYN -DBUILD_WITH_EIGEN=ON -DBUILD_WITH_ADIOS2=ON .. #mamicocmake
```

### ls1 + MaMiCo for experiment 3

MaMiCo commit: e538455766e834d7034345d82012f6a3f631ed84

ls1 commit: 6a1a240d6d23ccf635fe528beacf65db2622bc89

Same cmake flags as above, except with `ADIOS2` disabled as it was unnecessary.
