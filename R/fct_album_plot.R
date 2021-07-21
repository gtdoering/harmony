#' album_plot 
#'
#' @description album_plot is a function that will take inputs for the data and
#' axis values and return a joy plot from the package 'ggjoy'.
#' 
#' @param artist_data Data that is retrieved from spotifyr::get_artist_audio_features(). Each row of the 
#' data is a specific song. This plot will only utilize the numeric columns of the dataset. 
#' @param ridge_variable Numeric variable from the artist_data that will be turned into
#' the joy ridges for the joy plot. 
#' @param factor_variable Factor variable from the artist_data that will determine the 
#' grouping for the joy ridges on the y-axis.
#' 
#' @export album_plot
#' 
#' @examples 
#' album_plot(spotifyr::get_artist_audio_features('Adele'),'Valence','album_name')
#'
#' @return Returns a formatted ggjoy plot.
#' 
album_plot <- function(artist_data, ridge_variable, factor_variable){
  ggridge <- ggplot2::ggplot(artist_data, 
                             ggplot2::aes(x = get(stringr::str_to_lower(ridge_variable)), 
                                          y = get(factor_variable), 
                                          fill = get(factor_variable)))+
    ggjoy::geom_joy() +
    ggjoy::theme_joy() +
    ggplot2::theme(legend.position = "none")+
    ggplot2::labs(
      x = paste0(ridge_variable),
      y = stringr::str_to_title(sub("_"," ",paste0(factor_variable)))
    )
    
    ggridge
}

# Testing
# album_plot(spotifyr::get_artist_audio_features('Adele'), "Valence", "album_name")
# album_plot(spotifyr::get_artist_audio_features('Adele'), "Acousticness", "key_mode")