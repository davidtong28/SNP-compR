#' Helper function. Takes in the original DNA sequence, start and end positions of a gene, and the information of a mutation. Calculates the altered CDS sequence had the mutation taken place, considering frameshifts.
#' 
#' @param dna_c Concatenated DNAString
#' @param contig Contig position table, which is the output of `get_concat_position()`.
#' @param start Start position of a gene on the concatenated DNA.
#' @param end End position of a gene on the concatenated DNA.
#' @param POS Position of the mutation on the concatenated DNA 
#' @param strand Strand direction of the gene
#' @param seqid If the original DNA sequence is fragmented, this is the contig number of the mutation on the fragmented DNAString object.
#' @param REF The sequence before the mutation (reference)
#' @param ALT The sequence after the mutation (query)
#' 
#' @import  dplyr
#'          vcfR
#'          Biostrings
#'          stringr
#'                    
#' @export

get_extended_CDS= function(dna_c,contig,start,end,POS,strand,seqid,REF,ALT){
  
  mut_contig= paste( substring(dna_c,contig$cum_lnth[match(seqid,contig$seqid)]+1,POS-1),ALT,substring(dna_c,POS+nchar(REF),contig$contig_end[match(seqid,contig$seqid)]) ,sep="" ) %>% DNAString()
  
  mut_DNA_long= if(strand=="+"){
    substring(mut_contig,start-contig$cum_lnth[match(seqid,contig$seqid)],-1) %>% DNAString()
  }else{
    substring(reverseComplement(mut_contig),contig$contig_end[match(seqid,contig$seqid)]-end+1,-1)
  }

  aa_length<-mut_DNA_long %>% 
    translate() %>%
    suppressWarnings() %>%
    as.character( ) %>%
    str_extract("^[^\\*]*\\*") %>%
    nchar()
  
  if(is.na(aa_length)){
    mut_DNA_long = NA
  }else{
    mut_DNA_long %>% as.character() %>% substring(1,3*aa_length)
  }
  
}