#!/bin/bash -l
#SBATCH --partition=hmq
#SBATCH --job-name=parallel_job                         # Job name
#SBATCH --mail-type=END,FAIL                            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=ks575@exeter.ac.uk                  # Where to send mail
#SBATCH --ntasks=1                                      # Run a single task
#SBATCH --cpus-per-task=64                           # Number of CPU cores per task
#SBATCH --nodelist=athena-h03
#SBATCH --mem=700gb                                       # Job memory request
#SBATCH --time=240:05:00                                 # Time limit hrs:min:sec
#SBATCH --output=purge_parallel_%j.log                        # Standard output and error log
#SBATCH --account=c.bass

pwd; hostname; date
export OMP_NUM_THREADS=64
pwd; hostname; date
echo "Running a program on $SLURM_JOB_NODELIST"
#
module load Workspace/v1 bwa/0.7.17 samtools/1.9 Conda/Python2/2.7.15 ks575/Purge-haplotigs/v1.0.4 ks575/minimap2/v2.17 ActivePerl/5.26.3.2603 
#/path/to/my/application
echo "Hello $USER, this is running on the $SLURM_CLUSTER_NAME cluster at `hostname` using PI account = $SLURM_JOB_ACCOUNT"
cd $WORKSPACE/Data/Danaus_assemblies/merged_assemblies/canu+falcon/purged
module load shared ks575/Purge-haplotigs/v1.0.4 ks575/minimap2/v2.17 samtools/1.9
minimap2 -t 128 -ax map-pb /nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/merged_assemblies/canu+falcon/merged_out.fasta /nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/m54082_combined_reads.fasta.gz | samtools view -hF 256 - | samtools sort -@ 128 -m 1G -o /nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/merged_assemblies/canu+falcon/purged/aligned.bam -T tmp.ali
purge_haplotigs readhist -t 32 -b /nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/merged_assemblies/canu+falcon/purged/aligned.bam -g /nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/merged_assemblies/canu+falcon/merged_out.fasta
