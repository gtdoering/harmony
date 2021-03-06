#' pca_plot 
#'
#' @description A plotting function that receives a data frame and runs
#' PCA on it to produce a formatted ggplot.
#'
#' @param data A filtered dataframe from the spotifyr function 
#' get_artist_audio_features.
#' @param album_filter A list of albums to perform the PCA on and plot.
#' @param loading A logical value to specify whether to plot the loadings or not
#' @param cluster A logical value to specify whether to plot the clusters or not
#'
#' @return Returns a formatted ggplot.
#'
#' @export pca_plot
#' 
#' @import ggfortify
#' 
#' @examples 
#' pca_plot(spotifyr::get_artist_audio_features('Morgan Wallen'), 
#' c('Dangerous: The Double Album', 'If I Know Me'), TRUE, TRUE)
#' 
pca_plot <- function(data, album_filter, loading = FALSE, cluster = FALSE){
  
  
  pca_plot <- data %>%
    dplyr::filter(album_name %in% album_filter) %>%
    dplyr::select(danceability:energy,loudness, speechiness:tempo) %>%
    stats::prcomp(center = TRUE, scale = TRUE) %>%
    ggplot2::autoplot(data =  data[data$album_name %in% album_filter,],
                      shape = FALSE, colour = 'album_name',
                      label = TRUE,
                      loadings = loading,
                      frame = cluster, frame.type = 'norm',
                      loadings.colour = 'black',
                      loadings.label = loading,
                      scale = 0) +
    ggplot2::labs(fill="Album Name", colour = "Album Name")+
    ggplot2::theme(legend.position = 'bottom',
                   legend.text = ggplot2::element_text(size=15),
                   legend.title = ggplot2::element_text(size = 16))
  
  pca_plot
}



