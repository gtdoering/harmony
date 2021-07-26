#' song_plot
#'
#' @description song_plot is a function that will take inputs for data and 
#' axis variables and return a ggplot. 
#'
#' @param artist_data Data that is retrieved from spotifyr::get_artist_audio_features(). Each row of the 
#' data is a specific song. This plot will only utilize the numeric columns of the dataset. 
#' @param  plot_xaxis,plot_yaxis Specify the x-axis and y-axis of the plot. Must be a numeric variable from artist_data.
#' @param  color Sets the color of the points in the plot. Should be a factor or character variable from 
#' the data. Numeric colors will give the plot a continuous color scale.
#'
#' @return Returns a formatted ggplot object. 
#' 
#' @export song_plot
#'
#' @examples
#' 
#' song_plot(spotifyr::get_artist_audio_features('Adele'),'Valence','Energy','album_name')
#' 
#'
song_plot <- function(artist_data, plot_xaxis, plot_yaxis, color){
  ggsong <- ggplot2::ggplot(artist_data, 
                            ggplot2::aes(x= get(stringr::str_to_lower(plot_xaxis)), 
                                         y= get(stringr::str_to_lower(plot_yaxis)), 
                                         color= get(color))) +
    ggplot2::geom_point(size = 4.5)+
    ggplot2::labs(
                   title = paste0("Song Scatter for ", artist_data$artist_name[1]),
                   x = paste0(plot_xaxis), 
                   y =  paste0(plot_yaxis),
                   color = stringr::str_to_title(sub("_"," ",paste0(color)))
                  )+
    ggplot2::theme(legend.position = "none",
                   axis.text= ggplot2::element_text(size=14),
                   axis.title= ggplot2::element_text(size=16),
                   plot.title= ggplot2::element_text(size=16, face = "bold"))
  
  
  ggsong
}



##TESTING##
# data <- spotifyr::get_artist_audio_features('The Head and the Heart')

# ggsong <- song_plot(data,'Valence','Danceability', 'album_name')
# ggsong

