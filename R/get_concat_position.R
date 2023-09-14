#' Helper function. Takes in a fragmented DNAString object, returns a data frame of contig positions once all contigs are concatenated. 
#' 
#' @param dna_contigs fragmented DNAString object
#' 
#' @import  dplyr
#'          vcfR
#'          Biostrings
#'          
#' @export

get_concat_position = function(dna_contigs){
  data.frame("name"= names(dna_contigs),
             "length"=nchar(dna_contigs),
             "seqid"= str_extract(names(dna_contigs),"^[^\\s]*") ) %>% 
    mutate( prev_cont_lnth= data.table::shift(length,n=1,type = "shift",fill=0)) %>% 
    mutate( cum_lnth=cumsum(prev_cont_lnth) ) %>% 
    mutate( contig_end=cum_lnth+length-1)
}