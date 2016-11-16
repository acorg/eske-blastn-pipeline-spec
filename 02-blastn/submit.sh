#!/bin/bash -e

#SBATCH -J blastn
#SBATCH -A DSMITH-BIOCLOUD
#SBATCH -o slurm-%A.out
#SBATCH -p biocloud-normal
#SBATCH --time=05:00:00

task=$1

echo "hostname is `hostname`"
echo "task is $task"

srun -n 1 blastn.sh $task
