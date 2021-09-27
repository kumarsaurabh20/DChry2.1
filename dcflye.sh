#!/bin/bash -l
#SBATCH --partition=hmq
#SBATCH --job-name=dc.flye                         # Job name
#SBATCH --mail-type=FAIL                            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=ks575@exeter.ac.uk                  # Where to send mail
#SBATCH --ntasks=1                                      # Run a single task
#SBATCH --cpus-per-task=45                           # Number of CPU cores per task
#SBATCH --mem=10gb                                       # Job memory request
#SBATCH --time=240:05:00                                 # Time limit hrs:min:sec
#SBATCH --output=dc.flye_%j.log                        # Standard output and error log
#SBATCH --account=c.bass

pwd; hostname; date
export OMP_NUM_THREADS=45
pwd; hostname; date
echo "Running a program on $SLURM_JOB_NODELIST"
#
module load slurm/18.08.4 shared DefaultModules Conda/Python3/3.7.2
module load ks575/Flye/v2.6.0 samtools/1.9 
#/path/to/my/application
echo "Hello $USER, this is running on the $SLURM_CLUSTER_NAME cluster at `hostname` using PI account = $SLURM_JOB_ACCOUNT"
cd $WORKSPACE/Data/Danaus_assemblies/new_pacbio_data_2020_neoW/flye
##
flye --pacbio-raw /nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/new_pacbio_data_2020_neoW/m54082_merge_all.fasta --out-dir /nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/new_pacbio_data_2020_neoW/flye --genome-size 250m --threads 45
