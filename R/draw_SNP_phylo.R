#' Visualization function to draw SNP distributions by position in the form of sliding windows.
#' 
#' @param mut_table Output sheet from the main function `vcgff_gen()`.
#' @param half If mutations that exactly half of the genomes have should be inverted, defaults to FALSE
#' @param range The range of the DNA region to be plotted, defaults to c(0,2000000)
#' @param win size of the sliding window, defaults to range_length/200
#' @param GGTR A ggtree object of the genomes wished to be drawn. Defaults to `as.phylo(htree(mut_table)) %>% ggtree(ladderize = F)+geom_tiplab(align = T)+geom_rootpoint()+ xlim_tree(5.5)`.
#' @param Size Text size, defaults to 7
#' 
#' @import  dplyr
#'          stringr
#'          tidyr
#'          ggplot2
#'          ggtree
#'          stats
#'          grDevices
#'                    
#' @export

draw_SNP_phylo<-function(mut_table,half=F,range=c(0,2000000),win=(range[2]-range[1])/200,
                         GGTR=as.phylo(htree(mut_table)) %>% ggtree(ladderize = F)+geom_tiplab(align = T)+geom_rootpoint()+ xlim_tree(5.5), Size=7){
  
  counttable<-mut_pos_count(mut_table,win,half)%>%
    dplyr::filter(window<=ceiling(range[2]/win) ) %>%
    dplyr::filter(window>= ceiling(range[1]/win)) %>%
    mutate(window=window*win) %>%
    pivot_longer(cols = c(-1),names_to = "isolate",values_to = "count") %>%
    na_if(0) %>% 
    select(2,1,3)
  
  GGTR+
    geom_facet(data = counttable,mapping = aes(x=window,fill=`count`),
               geom = geom_tile,panel = 'Point Mutations')+
    scale_fill_gradientn(colours = c("#73bcc9","gold","#ff0000"),values = c(0,0.5-(0.25*(mean(counttable$count )-median(counttable$count ))/mean(counttable$count ) ),1),na.value = grey(0.85),guide = "colourbar")
    theme(text = element_text(size = Size))+
    theme_tree2()
  
}
