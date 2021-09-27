#!/bin/bash -l
#SBATCH --partition=hmq
#SBATCH --job-name=F1_racon                         # Job name
#SBATCH --mail-type=ALL                            # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=ks575@exeter.ac.uk                  # Where to send mail
#SBATCH --ntasks=1                                      # Run a single task
#SBATCH --cpus-per-task=64                         # Number of CPU cores per task
#SBATCH --mem=10gb                                       # Job memory request
#SBATCH --time=240:05:00                                 # Time limit hrs:min:sec
#SBATCH --output=racon_parallel_%j.log                        # Standard output and error log
#SBATCH --account=c.bass

pwd; hostname; date
export OMP_NUM_THREADS=64
pwd; hostname; date
echo "Running a program on $SLURM_JOB_NODELIST"
#
#/path/to/my/application
echo "Hello $USER, this is running on the $SLURM_CLUSTER_NAME cluster at `hostname` using PI account = $SLURM_JOB_ACCOUNT"
cd $WORKSPACE/Data/Myzus/Barteks_PB/Project_2912/wtdbg2/Polish/racon/run1
module load shared sge Conda/Python2/2.7.15 ks575/minimap2/v2.17 samtools/1.9 ks575/racon/v1.4.3 Workspace/v1
raw_pacbio_reads=$WORKSPACE/Data/Danaus_assemblies/m54082_combined_reads.fasta.gz
run1=$WORKSPACE/Data/Danaus_assemblies/polishing_canu_falcon/canu_polish/racon/run1
run2=$WORKSPACE/Data/Danaus_assemblies/polishing_canu_falcon/canu_polish/racon/run2
run3=$WORKSPACE/Data/Danaus_assemblies/polishing_canu_falcon/canu_polish/racon/run3
input1=$run1/canu2.racon.iter1.fasta
input2=$run2/canu2.racon.iter2.fasta
input3=$run3/canu2.racon.iter3.fasta
work_dir=$run1
##minimap2 -t 64 -ax map-pb $input1 $raw_pacbio_reads  > $work_dir/aligned.sam
##racon -t 64 $raw_pacbio_reads $work_dir/aligned.sam $input1 > $run1/canu2.racon.iter2.fasta
cp $work_dir/canu2.racon.iter2.fasta $run2/
work_dir=$run2
minimap2 -t 64 -ax map-pb $input2 $raw_pacbio_reads  > $work_dir/aligned.sam
racon -t 64 $raw_pacbio_reads $work_dir/aligned.sam $input2 > $run2/canu2.racon.iter3.fasta
cp -vrf $run2/canu2.racon.iter3.fasta $run3/
work_dir=$run3
minimap2 -t 64 -ax map-pb $input3 $raw_pacbio_reads > $work_dir/aligned.sam
racon -t 64 $raw_pacbio_reads $work_dir/aligned.sam $input3 > $run3/canu2.racon.iter4.fasta
cp -vrf $run3/canu2.racon.iter4.fasta $WORKSPACE/Data/Danaus_assemblies/polishing_canu_falcon/canu_polish/racon/canu2.polished3R.racon.fasta
##
module purge
module load shared slurm/18.08.4 samtools/1.9 bwa/0.7.17 Oracle_Java/8u192
read1=/nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/Trio_binning/MB18111/trimmed/MB18111_UKDSW02198-1_HJ2JWDSXX_L3_1_val_1.fq
read2=/nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/Trio_binning/MB18111/trimmed/MB18111_UKDSW02198-1_HJ2JWDSXX_L3_2_val_2.fq
run1=/nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/polishing_canu_falcon/canu_polish/pilon/run1
run2=/nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/polishing_canu_falcon/canu_polish/pilon/run2
run3=/nobackup/beegfs/workspace/ks575/Data/Danaus_assemblies/polishing_canu_falcon/canu_polish/pilon/run3
input1=$run1/canu2.pilon.iter1.fasta
input2=$run2/canu2.pilon.iter2.fasta
input3=$run3/canu2.pilon.iter3.fasta
cp -vrf $WORKSPACE/Data/Danaus_assemblies/polishing_canu_falcon/canu_polish/racon/canu2.polished3R.racon.fasta $run1/canu2.pilon.iter1.fasta
bwa index -p $run1/pilon.iter1 $input1
bwa mem -t 64 $run1/pilon.iter1 $read1 $read2 | samtools view -bS - | samtools sort -m 8G --threads 45 - > $run1/pilon.r1.sorted.bam
samtools index -b $run1/pilon.r1.sorted.bam
java -Xmx150g -jar $WORKSPACE/Data/Myzus/Barteks_PB/Project_2912/wtdbg2/Polish/pilon/Pilon/pilon-1.23.jar --genome $input1 --frags $run1/pilon.r1.sorted.bam --outdir $run1 --output canu2.pilon.iter2 --diploid --threads 45
cp -vrf $run1/canu2.pilon.iter2.fasta $run2
bwa index -p $run2/pilon.iter2 $input2
bwa mem -t 64 $run2/pilon.iter2 $read1 $read2 | samtools view -bS - | samtools sort -m 8G --threads 45 - > $run2/pilon.r2.sorted.bam
samtools index -b $run2/pilon.r2.sorted.bam
java -Xmx150g -jar $WORKSPACE/Data/Myzus/Barteks_PB/Project_2912/wtdbg2/Polish/pilon/Pilon/pilon-1.23.jar --genome $input2 --frags $run2/pilon.r2.sorted.bam --outdir $run2 --output canu2.pilon.iter3 --diploid --threads 45
cp -vrf $run2/canu2.pilon.iter3.fasta $run3
bwa index -p $run3/pilon.iter3 $input3
bwa mem -t 64 $run3/pilon.iter3 $read1 $read2 | samtools view -bS - | samtools sort -m 8G --threads 45 - > $run3/pilon.r3.sorted.bam
samtools index -b $run3/pilon.r3.sorted.bam
java -Xmx150g -jar $WORKSPACE/Data/Myzus/Barteks_PB/Project_2912/wtdbg2/Polish/pilon/Pilon/pilon-1.23.jar --genome $input3 --frags $run3/pilon.r3.sorted.bam --outdir $run3 --output canu2.pilon.iter4 --diploid --threads 45
cp -vrf $run3/canu2.pilon.iter4.fasta $WORKSPACE/Data/Danaus_assemblies/polishing_canu_falcon/canu_polish/pilon/canu2.polished3R.pilon.fasta
