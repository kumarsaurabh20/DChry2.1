#!/bin/bash -l
#SBATCH --partition=hmq
#SBATCH --job-name=danausv32                         # Job name
#SBATCH --mail-type=FAIL                            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=ks575@exeter.ac.uk                  # Where to send mail
#SBATCH --ntasks=1                                      # Run a single task
#SBATCH --cpus-per-task=45                           # Number of CPU cores per task
#SBATCH --mem=10gb                                       # Job memory request
#SBATCH --time=240:05:00                                 # Time limit hrs:min:sec
#SBATCH --output=canu_conda_%j.log                        # Standard output and error log
#SBATCH --account=c.bass

pwd; hostname; date
export OMP_NUM_THREADS=45
pwd; hostname; date
echo "Running a program on $SLURM_JOB_NODELIST"
#
module load slurm/18.08.4 shared DefaultModules Workspace/v1 
module load ks575/Canu/v2.0
module load ks575/GNUplot/v5.2.7
#/path/to/my/application
echo "Hello $USER, this is running on the $SLURM_CLUSTER_NAME cluster at `hostname` using PI account = $SLURM_JOB_ACCOUNT"
cd $WORKSPACE/Data/Danaus_assemblies/new_pacbio_data_2020_neoW/canu_conda
canu -p danaus.neow.cn.conda -d /nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/new_pacbio_data_2020_neoW/canu_conda genomeSize=250m useGrid=false -pacbio-raw /nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/new_pacbio_data_2020_neoW/m54082_merge_all.fasta 
