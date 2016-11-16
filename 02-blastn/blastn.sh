#!/bin/bash -e

. /home/tcj25/.virtualenvs/35/bin/activate

task=$1
log=../$task.log
fasta=../01-split/$task.fasta
out=$task.json.bz2

echo "02-blastn on task $task started at `date`" >> $log
echo "  fasta file is $fasta" >> $log

db=hbv-complete-nt

# This is just one of the BLAST db files.
dbfile=$HOME/scratch/root/share/ncbi/blast-dbs/$db.nsq

if [ ! -f $dbfile ]
then
    echo "blastn database file $dbfile does not exist!" >> $log
    exit 1
fi

echo "  blastn started at `date`" >> $log
blastn \
    -task blastn \
    -query $fasta \
    -db $db \
    -num_threads 24 \
    -evalue 0.01 \
    -outfmt 5 |
convert-blast-xml-to-json.py | bzip2 > $out
echo "  blastn stopped at `date`" >> $log

echo "02-blastn on task $task stopped at `date`" >> $log
echo >> $log
