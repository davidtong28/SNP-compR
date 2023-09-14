#' Calculates FST of all mutation loci, given an output sheet from the main function `vcgff_gen()` and a vector of suspected subpopulations.
#' 
#' @param mut_table Output sheet from the main function `vcgff_gen()`.
#' @param subpop_vector A vector that records the suspected subpopulation that would be examined for FST. The vector should be numerical, in the order of the column name that appeared in the mut_table.
#' 
#' @import  dplyr
#'          tidyr
#'          stringr
#'                    
#' @export

fst_<-function(mut_table,subpop_vector){
  new_table<-mut_table
  for ( n in c(1:nrow(mut_table)) ) {
    if (mut_table$var_count[n] > 0.5*(ncol(mut_table) -28 ) ){
      new_table[n,-c(1:28)][new_table[n,-c(1:28)]==0] <-'2'
      new_table[n,-c(1:28)][new_table[n,-c(1:28)]==1] <-'0'
      new_table[n,-c(1:28)][new_table[n,-c(1:28)]==2] <-'1'
      new_table$var_count[n]<-ncol(mut_table)-28-mut_table$var_count[n]
    }
  }
  portion=sum(subpop_vector)/(ncol(mut_table)-28)
  new_table<-new_table %>% cbind(new_table [,-c(1:28)] [subpop_vector ] %>%rowwise %>%  summarise(var_sub=sum(across(everything())==1))) %>% 
    mutate(pT=var_count/(ncol(mut_table)-28),pS=var_sub/sum(subpop_vector),pS2=(var_count-var_sub)/( ncol(mut_table)-28 - sum(subpop_vector) ) ) %>% 
    mutate(Fst= 1- ( portion*pS*(1-pS) + (1-portion)*pS2*(1-pS2) )/(pT*(1-pT))   ) %>% 
    select(c(1:7),var_sub,pT,pS,pS2,Fst,everything())
  return(new_table)
}