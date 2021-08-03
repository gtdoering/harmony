#' pca_table 
#'
#' @description A function to create a table with the values that are plotted 
#' by the pca_plot module. This function will work inside of a renderTable 
#' statement to display the data from the PCA that is done in the plot and
#' help the user identify outlier songs.
#' 
#' @param data A data frame from the spotifyr function '
#' get_artist_audio_features.' PCA will be performed on this data within the 
#' function.
#' @param album_filter A character vector of album names that the user selects
#' to display on the plot created by the function 'pca_plot'.
#'
#' @return TThe return value of this function is a sorted data frame. The data 
#' frame contains the values of all 9 of the principal components, as well as 
#' the album name and song name for each value. The row names are the original 
#' numbers from the input data frame. 
#' 
#' @export pca_table
#' 
#' @examples 
#' pca_table(spotifyr::get_artist_audio_features('Adele'),c('25','19'))
#' 

pca_table <- function(data, album_filter){
  
  pca_table <- data %>% 
    dplyr::filter(album_name %in% album_filter) %>%
    dplyr::select(danceability:energy,loudness, speechiness:tempo) %>% 
    stats::prcomp(center = TRUE, scale = TRUE) %>% 
    .$x %>% 
    as.data.frame() %>% 
    dplyr::mutate("Album Name" = data$album_name[data$album_name %in% album_filter],
                "Track Name" = data$track_name[data$album_name %in% album_filter],
                "ID" = rownames(data[data$album_name %in% album_filter,])) %>% 
    tibble::column_to_rownames(var = "ID") %>% 
    dplyr::select("Album Name", "Track Name", dplyr::everything()) 
  
  pca_table
}
