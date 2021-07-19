#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {

  # Your application server logic 
  data <- mod_artist_data_server("artist")
  mod_artist_plots_server("plot", data)
  mod_plot_clicks_server("plot", data)
}
