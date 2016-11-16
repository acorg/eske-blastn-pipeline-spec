## Eske blastn pipeline spec

This repo contains a
[slurm-pipeline](https://github.com/acorg/slurm-pipeline) specification
file (`specification.json`) and associated scripts for processing ancient
DNA samples from Eske Willerslev using BLAST (specifically, blastn).

### Usage

It's assumed you've already run
[the first pipeline](https://github.com/acorg/eske-pipeline-spec) on the
samples you're interested in. This pipeline expects to find its initial
input files in the `03-find-unmapped/$task-unmapped.fastq.gz` files from
that pipeline.

The `01-split/split.sh` script expects the original unmapped sample FASTQ
files to be in
`../../../*/Sample_ESW_*${sample}_*/03-find-unmapped/*-unmapped.fastq.gz`
where `${sample}` is taken from the last component of the local directory
name of this repo.  So you can do this, for example:

```sh
$ mkdir DA100
$ cd DA100
$ git clone https://github.com/acorg/eske-blastn-pipeline-spec
$ make run
```

This will run `blastn` on all the reads from all directories for sample
`DA100`.

### Output

The scripts in `01-split`, `02-blastn`, etc. are all submitted by `sbatch`
for execution under [SLURM](http://slurm.schedmd.com/). The final step,
`03-panel` leaves its output in `03-panel/out` and
`03-panel/summary-virus`.

### Cleaning up

```sh
$ make clean-1
```

Note that this throws away all the intermediate work done by the pipeline.

### Cleaning up a bit more

```sh
$ make clean-2
```

Does a `make clean-1` and removes intermediate SLURM output log files.

### Really cleaning up

```sh
$ make clean-3
```

Does a `make clean-2` and also removes the final output in `03-panel/out`.
