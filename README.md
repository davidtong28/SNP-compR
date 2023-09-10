# SNP-compR

## Introduction
SNP-compR (SNP-compare) is an R package made for bacterial comparative genomics. It offers functionality to:
1. Compare mutations among highly similar genomes.
2. Characterize each identified mutation by type (indel, SNP etc.).
3. Predict the outcome of each mutation, as well as the post-mutation translation product.
4. Generate visualizations of mutations.

In order to obtain such results, the following files should be provided as input:
i. **A multi-VCF file** of a set of highly similar genomes (Can be derived from multiple VCF files, see **Input Generation**), generated using the same reference genome.
ii. **An annotated reference genome**, provided in long `GFF3` format (annotation + `FASTA`).

## Installation
Install `SNP-compR` via `devtools`:
```
devtools::install_github("davidtong28/SNP-compR")
```
SNP-compR requires the following R packages:
1. dplyr
2. tidyr
3. magrittr
4. stringr
5. vcfR
6. ape
7. Biostrings
8. ggtree
They will be installed automatically if not already installed

## Input Generation
In order to compare a set of highly similar bacterial genomes, first select an appropriate reference genome. This could be either a publicly available whole genome that is close enough to your genomes, or your own fragmented genome. However, if you choose to use a fragmented genome, it is highly recommended to re-align the fragmented genome to a whole genome before any variant calling is done.
After selecting a reference genome, the next step is to perform variant calling. This can be achieved by many tools such as [FreeBayes](https://github.com/freebayes/freebayes). The goal is to generate a set of VCF files.
Using [Samtools](https://github.com/samtools/samtools), compress and index all VCF files:
```
for file in *.vcf; do bgzip $file; done; for file in *.vcf.gz; do tabix -p vcf $file; done
```
Using [BCFtools](https://samtools.github.io/bcftools/bcftools.html), merge all VCF files into a multi-VCF file
```
bcftools merge -m all *.vcf.gz > merged.vcf;bcftools norm -f /path/to/reference/fasta -m - merged.vcf > norm_merged.vcf
```
The `norm_merged.vcf` file contains a multi-VCF file with all mutation sites normalized (multiple mutations at the same site are counted in different lines), and is the desired input for this tool. `/path/to/reference/fasta` is the path to the fasta file of your reference genome.
A separate annotated reference genome (in either long `GFF3` format, containing both annotation and FASTA data, or a short `GFF3` format file with a FASTA file) must be provided as input.

## Running SNP-compR
You can either run `SNP-compR` as a do-it-all script, or manually call its functions however you wish.
### Do-it-all script
### Calling separate functions
#### Input data
The input data will be 
```
read_long_gff3(longgff_path,keepDNA=T,gff_NAME="gff",concat_dna_NAME="dna",dna_NAME=paste(concat_dna_NAME,"_contigs",sep = ""))
```
Reads in a long `GFF3` file and stores the annotation into the variable "gff_NAME" (which `gff` by default) and FASTA into "concat_dna_NAME" (concatenated DNA, `dna` by default) and "dna_NAME" (DNA in contigs, `dna_contigs` by default).
```
input_data_long(vcf_path,long_gff_path,dna_path=NA,vcf_name="vcf",gff_name="gff",concat_dna_name="dna",dna_name=paste(concat_dna_name,"_contigs",sep = ""))
```
Uses `read_long_gff3` to input both the long `GFF3` file as well as the multi-VCF file. The VCF data will be stored at variable "vcf_name" in global environment (which is `vcf` by default). The annotation will be stored into the variable "gff_NAME" (which `gff` by default) and FASTA into "concat_dna_NAME" (concatenated DNA, `dna` by default) and "dna_NAME" (DNA in contigs, `dna_contigs` by default). When `dna_path` is NA (default), a long `GFF3` file will be expected. Alternatively, you can specify `dna_path` to input a short `GFF3` file and a `FASTA` file.
```
vcgff_gen(vcf=vcf,gff=gff,dna_c=dna,dnaContigs=dna_contigs,virulence=F,count=F,remove_consensus=F,fix_contig_name=NA)
```
The main function that generates a sheet of mutations and predicted outcomes. It takes in the VCF (defaulted as the variable `vcf` in global environment)
