#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Dynamic Theme switch
  thematic::thematic_shiny()
  observe(session$setCurrentTheme(
    if (isTRUE(input$light_mode)) light else dark
  ))
  TAB <- reactive(input$tabs)
  
  # Your application server logic 
  data <- mod_artist_data_server("artist")
  mod_plot_clicks_server("plot", data$data_filtered, TAB, data$img)
  mod_artist_plots_server("plot", data$data_filtered, TAB)
  mod_pca_plot_server("pca", data$data_filtered, TAB)
}