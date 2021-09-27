#!/bin/bash -l
# Use bash and pick up a basic login environment

#SBATCH --partition=defq			# Specifies that the job will run on the default queue nodes.
#SBATCH --job-name=single-core-job		# A name for the job to be used when Job Monitoring 
#SBATCH --time=18:05:00				# maximum run time for a job hrs:min:sec
#SBATCH --nodes=1				# Number of full nodes to use
#SBATCH --ntasks-per-node=1			# Run a single task
#SBATCH --ntasks=1                   		# Run a single task	
#SBATCH --account=c.bass			# The accounting code - usually named after the PI for a project
#SBATCH --mem=100000				# Memory per node specification is in MB. It is optional. 
#SBATCH --output=test-quickmerge2-%j.out	# Standard output and error log
#SBATCH --mail-type=ALL                		# Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=ks575@exeter.ac.uk 		# E-Mail address of the user that needs to be notified.
##SBATCH --requeue				# Specifies that the job will be requeued after a node failure.
						# The default is that the job will not be requeued.

pwd; hostname; date

echo "Running a program on $SLURM_JOB_NODELIST"
 
module load shared DefaultModules slurm/18.08.4 Workspace/v1 quickmerge/0.3 ActivePerl/5.26.3.2603
 
#/path/to/my/application
echo "Hello $USER, this is running on the $SLURM_CLUSTER_NAME cluster at `hostname` using PI account = $SLURM_JOB_ACCOUNT"
cd $WORKSPACE/Data/Danaus_assemblies/merged_assemblies/canu+falcon
merge_wrapper.py $WORKSPACE/Data/Danaus_assemblies/assembly_comparison_pacbio_conference/Canu.fa $WORKSPACE/Data/Danaus_assemblies/assembly_comparison_pacbio_conference/falcon.fa
date
