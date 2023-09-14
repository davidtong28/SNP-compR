#' Create a hierarchical clustering phylo object using the output mutation sheet from the main function `vcgff_gen()`.
#' 
#' @param mut_table Output sheet from the main function `vcgff_gen()`.
#' @param METHOD method of hierarchical clustering, defaults to "average".
#' @import  dplyr
#'          stats          
#' @export

htree<-function(mut_table,METHOD="average"){
  (as.matrix(select(mut_table,!c(1:28))) %>% t() %>% dist() %>% hclust(method=METHOD) )
}
