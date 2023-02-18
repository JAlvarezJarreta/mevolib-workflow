
# **N**extflow **W**orkflow **R**epository for **ME**vo**L**ib

The MEvoLib is a library of freely available Python tools for molecular evolution.

This Nextflow Workflow package is open source software made available under the Apache 2.0 License terms. Please see the LICENSE file for further details.


## Execution Example

In order to fetch all the reference mtDNA sequences (RefSeq) in GenBank for the tick genus Ixodes and divide those sequences into genes, the user can execute this command line:

```bash
nextflow run test_fetch_cluster.nf --name example
```
The Query used in this example is: 
```bash
Ixodes [Organism] OR ixodes[All Fields]) AND biomol_genomic[PROP] AND refseq[filter]
```

