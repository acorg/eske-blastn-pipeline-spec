#!/bin/bash -e

#SBATCH -J panel
#SBATCH -A DSMITH-BIOCLOUD
#SBATCH -o slurm-%A.out
#SBATCH -p biocloud-normal
#SBATCH --time=10:00:00

. /home/tcj25/.virtualenvs/35/bin/activate

# The log file is the overall top-level job log file, seeing as this step
# is a 'collect' step that is only run once.
log=../slurm-pipeline.log

echo "03-panel started at `date`" >> $log

json_option=
fasta_option=
for task in "$@"
do
    echo "  task $task" >> $log
    json_option="$json_option --json ../02-blastn/$task.json.bz2"
    fasta_option="$fasta_option --fasta ../01-split/$task.fasta"
done

echo "  noninteractive-alignment-panel.py started at `date`" >> $log
srun -n 1 noninteractive-alignment-panel.py \
  $json_option \
  $fasta_option \
  --matcher blast \
  --outputDir out \
  --withScoreBetterThan 40 \
  --minMatchingReads 10 \
  --minCoverage 0.1 > summary-virus
echo "  noninteractive-alignment-panel.py stopped at `date`" >> $log

echo "03-panel stopped at `date`" >> $log
echo >> $log
