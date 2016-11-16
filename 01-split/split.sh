#!/bin/bash -e

#SBATCH -J split
#SBATCH -A DSMITH-BIOCLOUD
#SBATCH -o slurm-%A.out
#SBATCH -p biocloud-normal
#SBATCH --time=05:00:00

. /home/tcj25/.virtualenvs/35/bin/activate

log=../slurm-pipeline.log
sample=`/bin/pwd | tr / '\012' | egrep 'DA[0-9]+'`

echo "01-split/split.sh started at `date`" >> $log
echo "  Sample is '$sample'" >> $log

prexistingCount=`ls chunk-* 2>/dev/null | wc -l | awk '{print $1}'`
echo "  There are $prexistingCount pre-existing split files." >> $log

function makeFasta () {
    echo "  FASTQ is" >> $log
    ls -d1 ../../../*/Sample_ESW_*${sample}_*/03-find-unmapped/*-unmapped.fastq.gz >> $log

    echo >> $log

    # BLAST can't read FASTQ and can't read gzipped files. So make a bunch
    # of FASTA files for it. Note that we know reads just take a single
    # line in the output and that we need to split on an even number of
    # input FASTA lines.
    echo "  Uncompressing and splitting all FASTQ at `date`" >> $log
    zcat `ls -d1 ../../../*/Sample_ESW_*${sample}_*/03-find-unmapped/*-unmapped.fastq.gz` |
        convert-fastq-to-fasta.py | split -l 500000 -a 5 --additional-suffix=.fasta - chunk-
    echo "  FASTQ uncompressed at `date`" >> $log
    echo "  Split into `ls chunk-* | wc -l | awk '{print $1}'` files:" >> $log
    ls -l chunk-* >> $log
}

if [ "$SP_SIMULATE" = 0 ]
then
    echo "  This is not a simulation." >> $log
    if [ $prexistingCount -ne 0 ]
    then
        if [ "$SP_FORCE" = 1 ]
        then
            echo "  Pre-existing split files exist, but --force was used. Overwriting." >> $log
            makeFasta
        else
            echo "  Will not overwrite pre-existing split files. Use --force to make me." >> $log
            exit 1
        fi
    else
        echo "  No pre-existing split files exists, making them." >> $log
        makeFasta
    fi
else
    echo "  This is a simulation. Will re-emit task names." >> $log
fi

echo >> $log

for file in chunk-*.fasta
do
    task=`echo $file | cut -f1 -d.`
    echo "TASK: $task"
done
