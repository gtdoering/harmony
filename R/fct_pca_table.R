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
  pca_variables <- c("acousticness","danceability","energy","instrumentalness",
                     "liveness","loudness","speechiness","tempo","valence")
  
  data <- data[,c(pca_variables,'album_name','track_name')]
  
  pca_data <- data[data$album_name %in% album_filter, c(pca_variables)]
  prin_comp_data <- stats::prcomp(pca_data, center = TRUE, scale = TRUE)
  
  pca_table_data <- as.data.frame(prin_comp_data$x)
  pca_table_data$album_name <- data$album_name[data$album_name %in% album_filter]
  pca_table_data$track_name <- data$track_name[data$album_name %in% album_filter]
  pca_table_data <- pca_table_data[,c(10,11,1,2,3,4,5,6,7,8,9)]
  rownames(pca_table_data) <- rownames(data[data$album_name %in% album_filter,])
  colnames(pca_table_data) <- c("Album Name", "Track Name", "PC1", "PC2", "PC3",
                                "PC4", "PC5", "PC6", "PC7", "PC8", "PC9")
  
  pca_table_data
}
