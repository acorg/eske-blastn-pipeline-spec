#!/bin/bash -e

log=../slurm-pipeline.log

# The task is ignored (it's just the word "start" from ../00-start/start.sh).
# TODO: absorb the task?
# task=$1

echo "01-split sbatch.sh running at `date`" >> $log
# echo "task is $task" >> $log
echo "dependencies are $SP_DEPENDENCY_ARG" >> $log
echo >> $log

# TODO: Fix this, somehow.
# jobid=`sbatch -n 1 split.sh | cut -f4 -d' '`
# echo "TASK: $task $jobid"

# This will run synchronously on localhost and emit task names.
./split.sh
