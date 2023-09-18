#' Helper function. Takes in a GFF3 feature table and a contig position table created by `get_concat_position()`, returns an altered GFF3 feature table once all contigs are concatenated. Only "CDS" features are kept. 
#' 
#' @param gff GFF3 annotation table
#' @param contig Contig position table, which is the output of `get_concat_position()`.
#' 
#' @import  dplyr
#'          vcfR
#'          Biostrings
#'                    
#' @export

concat_gff=function(gff,contig){
  gff %>% 
    #`|` is used as the OR operator instead of `||`. `|` `&` is element-wise, and `||`, `&&` returns one value
    dplyr::filter( type=="CDS" ) %>%
    mutate( score=contig$cum_lnth[match(seqid,contig$seqid)] ) %>% 
    mutate( start=start+score ) %>% 
    mutate( end=end+score ) %>% 
    mutate( score=end-start )
}