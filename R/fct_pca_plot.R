#' pca_plot 
#'
#' @description A plotting function that receives a data frame and runs
#' PCA on it to produce a formatted ggplot.
#'
#' @param data A filtered dataframe from the spotifyr function 
#' get_artist_audio_features.
#' @param album_filter A list of albums to perform the PCA on and plot.
#'
#' @return Returns a formatted ggplot.
#'
#' @export pca_plot
#' 
#' @examples 
#' pca_plot(spotifyr::get_artist_audio_features('Morgan Wallen'), c('Dangerous: The Double Album', 'If I Know Me'))
#' 
pca_plot <- function(data, album_filter){
  pca_variables <- c("acousticness","danceability","energy","instrumentalness",
                     "liveness","loudness","speechiness","tempo","valence")
  
  data <- data[,c(pca_variables,'album_name','track_name')]
  
  pca_data <- data[data$album_name %in% album_filter, c(pca_variables)]
  
  prin_comp_data <- stats::prcomp(pca_data, scale = TRUE)
  
  pca_plot <- ggplot2::autoplot(prin_comp_data, data =  data[data$album_name %in% album_filter,], shape = FALSE, colour = 'album_name', label = TRUE,
                                loadings = TRUE,
                                loadings.colour = 'black',
                                loadings.label = TRUE)+
                ggplot2::theme(legend.position = 'none')
  
  pca_plot
}

