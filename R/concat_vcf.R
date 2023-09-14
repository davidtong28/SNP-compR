#' Helper function. Takes in a vcfR object and a contig position table created by `get_concat_position()`, returns an altered vcf table once all contigs are concatenated.
#' 
#' @param vcf vcfR object, ideally generated from FreeBayes.
#' @param contig Contig position table, which is the output of `get_concat_position()`.
#' @param remove_consensus if a mutation should be removed had all the genomes contained that same mutation. Defaults to FALSE and only works when count is TRUE.
#' @param count if the presence absence of the loci should be counted, defaults to FALSE.
#' 
#' @import  dplyr
#'          vcfR
#'          Biostrings
#'          stringr
#'                    
#' @export

concat_vcf=function(vcf,contig,remove_consensus=F,count=F){
  
  gt_presabs <- gt_count(vcf,count)
  
  cbind(vcf@fix,gt_presabs) %>% 
    as.data.frame() %>% 
    rowwise %>% 
    mutate(var_count=if(count){ ncol(vcf@gt)-1-sum( (c_across( c( 9:( 7+ncol(vcf@gt) ) ) ) ) ==0 ) }else{NA} ) %>%
    filter(if(remove_consensus){var_count<ncol(vcf@gt)-1}else{TRUE}) %>%
    rename( "#CHROM"=CHROM ) %>%
    arrange( `#CHROM` ) %>% 
    mutate( POS=as.numeric(POS) ) %>%
    mutate( POS=POS+contig$cum_lnth[match(`#CHROM`,contig$seqid)] ) %>%
    mutate( POS=as.character(POS) )
}