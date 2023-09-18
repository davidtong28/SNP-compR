#' Splits a long GFF3 file into two files and stores the annotation into the variable "gff_NAME" (which is `gff` by default) and FASTA into "concat_dna_NAME" (concatenated DNA, `dna` by default) and "dna_NAME" (DNA in contigs, `dna_contigs` by default).
#'
#' @param longgff_path Relative path to the long GFF3 file
#' @param keepDNA Option to keep DNA. Defaults to TRUE.When FALSE, the provided GFF3 file will be regarded as a short GFF3 and only annotation data will be saved
#' @param gff_NAME Variable name which stores the GFF annotation table. Defaults to "gff"
#' @param concat_dna_NAME Variable name which stores the concatenated FASTA. Defaults to "dna"
#' @param dna_NAME Variable name which stores the fragmented FASTA. Defaults to "dna_contigs" (or concat_dna_NAME+"_contigs")
#' 
#' @import  dplyr
#'          vcfR
#'          Biostrings
#'          ape
#' @export

read_long_gff3 <- function(longgff_path,keepDNA=T,gff_NAME="gff",concat_dna_NAME="dna",dna_NAME=paste(concat_dna_NAME,"_contigs",sep = "")){

  if(keepDNA){
    shell(paste("csplit ",longgff_path," /FASTA/"))
    shortgff3<-read.gff("xx00",GFF3=T)  
    assign(gff_NAME,value = shortgff3,envir = .GlobalEnv)
    shell('tail -n +2 xx01>xx001')
    gffdna<-readDNAStringSet("xx001")
    assign(dna_NAME,value = gffdna,envir = .GlobalEnv)
    DNA<- gffdna %>%
      base::as.vector() %>% 
      paste0(collapse = "") %>% 
      DNAString()
    assign(concat_dna_NAME,value = DNA,envir = .GlobalEnv)
  }else{
    shortgff3<-read.gff("xx00",GFF3=T)  
    assign(gff_NAME,value = shortgff3,envir = .GlobalEnv)
  }
}

