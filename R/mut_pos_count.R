#' Helper function. Summarize mutation positions based on a sliding window. Returns a data frame.
#' 
#' @param mut_table Output sheet from the main function `vcgff_gen()`.
#' @param win Size of the sliding window, defaults to 10000
#' @param half If mutations that exactly half of the genomes have should be inverted, defaults to FALSE
#' @param maxlen The maximum length of the examined sequences.
#' 
#' @import  dplyr
#'                    
#' @export

mut_pos_count<-function(mut_table,win=10000,half=F,maxlen=2000000){
  table1<-mut_table[,-c(1,2,4:28)] %>% mutate_all(as.numeric) 
  
  #reverse SNPs more than half, and equals to half when `half`is T
  for (i in c(1:nrow(table1))){
    if(sum(table1[i,-1]) + as.numeric(half) > ncol(table1)/2  ) 
    {table1[i,-1]<-1- table1[i,-1]} }
  table1<-table1%>%mutate(window= ceiling( POS/win) ) %>%
    select(-1) %>% 
    group_by(window) %>%
    summarise_all(sum)
  window_max=ceiling(maxlen/win)
  allcol<-data.frame(window=1:window_max)
  table2<-full_join(allcol,table1,by="window") 
  table2[is.na(table2)]<-0
  return (table2)
}