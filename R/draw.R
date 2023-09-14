#' Draw a heatmap of concatenated mutation loci.
#' 
#' @param mut_table Output sheet from the main function `vcgff_gen()`.
#' @param inv If mutations that more than half of the genomes have should be inverted, defaults to FALSE
#' @param half If mutations that exactly half of the genomes have should be inverted, defaults to FALSE
#' @param phylo The vector of rownames or order of genomes that is wished to be drawn. You can provide a tree and use `tree$order` as this vector.
#' 
#' @import  dplyr
#'          stats
#'          grDevices
#'                    
#' @export

draw=function(mut_table,inv=F,half=F,phylo=NULL) {

  tab=mut_table  %>% select(!c(1:28)) %>% mutate_if(is.character,as.numeric) %>% as.matrix() %>% `rownames<-`( mut_table$Mutation_id )
  if (inv){
    i=0;for (i in c(1:nrow(tab))){
      if(sum(tab[i,]) + as.numeric(half) > ncol(tab)/2  ) {tab[i,]<-1- tab[i,]}
    } 
  }
  
  if( length(phylo)==0   ){
    heatmap(t(tab),scale = "none",Colv = NA,col=grey.colors(5)[c(5,1)])
  }else{#phylo is vector of rownames or order of rows
    heatmap(t(tab[,phylo] ),scale = "none",Colv = NA,col=grey.colors(5)[c(5,1)],Rowv = NA)
  }
  
}