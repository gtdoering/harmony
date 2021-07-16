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
#' 
song_plot <- function(artist_data, plot_xaxis, plot_yaxis, color){
  ggsong <- ggplot2::ggplot(artist_data, ggplot2::aes(x= get(plot_xaxis), y= get(plot_yaxis), color= get(color))) +
    ggplot2::geom_point()+
    ggplot2::labs(title = paste0("Song Plot for ", artist_data$artist_name[1]),
                  x = R.utils::capitalize(paste0(plot_xaxis)), 
                  y = R.utils::capitalize(paste0(plot_yaxis)))
  
  ggsong
}


##TESTING##
data <- spotifyr::get_artist_audio_features('The Head and the Heart')

ggsong <- song_plot(data,'valence','danceability', 'album_name')
ggsong

