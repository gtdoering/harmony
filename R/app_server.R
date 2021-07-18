#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  artist_data <- reactive(mod_artist_data_server('artist'))
  output$test <- renderTable(head(artist_data()$album_name))
}
