#' Inputs VCF and GFF data at the same time.
#'
#' @param vcf_path Relative path to the VCF file
#' @param long_gff_path Relative path to the long GFF3 file
#' @param dna_path Relative path to the FASTA file, defaults to NA; if specified, will interpret the provided GFF3 as a short GFF file (FASTA component will be ignored).
#' @param vcf_name Variable name which stores the VCF file. Defaults to variable "vcf"in the global environment, as a vcfR object
#' @param gff_name Variable name which stores the GFF annotation table. Defaults to variable "gff" in the global environment, as a dataframe
#' @param concat_dna_name Variable name which stores the concatenated FASTA. Defaults to "dna" as a DNAString object
#' @param dna_name Variable name which stores the fragmented FASTA. Defaults to "dna_contigs" (or concat_dna_NAME+"_contigs") as a DNAString object
#' 
#' @import  dplyr
#'          vcfR
#'          Biostrings
#'          ape
#' @export

input_data_long=function(vcf_path,long_gff_path,dna_path=NA,vcf_name="vcf",gff_name="gff",concat_dna_name="dna",dna_name=paste(concat_dna_name,"_contigs",sep = "")){
  
  VCF<-read.vcfR(vcf_path)
  assign(vcf_name,value = VCF,envir = .GlobalEnv)
  print( paste("VCF is stored at `",vcf_name,"` as a vcfR object",sep = "") )
  
  if(is.na(dna_path)){ 
    read_long_gff3(long_gff_path,T,gff_name,dna_name,concat_dna_name)
  }else{ 
    read_long_gff3(long_gff_path,F,gff_name,dna_name)
    DNA_contigs<-readDNAStringSet(dna_path)
    DNA<- DNA_contigs %>%
      base::as.vector() %>% 
      paste0(collapse = "") %>% 
      DNAString()
  }
  print( paste("GFF is stored at `",gff_name,"` as a data frame",sep = "") )
  assign(dna_name,value = DNA_contigs,envir = .GlobalEnv)
  print( paste("DNA is sequence stored at `",dna_name,"_contigs` as a DNAStringSet object",sep = "") )
  assign(concat_dna_name,value = DNA,envir = .GlobalEnv)
  print( paste("DNA is concatenated to one sequence and stored at `",dna_name,"` as a DNAString object",sep = "") )
  
}

