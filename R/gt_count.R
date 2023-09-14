#' Helper function. Takes in a vcfR object and returns its gt section into a 0/1 presence absence matrix.
#' 
#' @param vcf vcfR object. Ideally a multi-vcf file generated from FreeBayes.
#' @param count A boolean that indicates if the presence absence matrix transformation would be done. Defaults to FALSE, which will only return the gt section without alteration.
#' 
#' @import  dplyr
#'          vcfR
#'          Biostrings
#'          stringr
#'          
#' @export

gt_count <- function(vcf,count=F){
  #not all vcf are able to be turned into presence absence table in this way.
  gt_presabs <- vcf@gt %>%
    as.data.frame() %>%
    select(-1)
  gt_presabs[as.matrix(as.data.frame(base::lapply(gt_presabs,function(x)str_starts(x,"1"))))] <- 1 #this actually doesn't make much sense, need fix
  gt_presabs[gt_presabs!=1] <- 0
  return(if(count){gt_presabs}else{vcf@gt})
}