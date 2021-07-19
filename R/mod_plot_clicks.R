#' plot_clicks UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_plot_clicks_ui <- function(id){
  ns <- NS(id)
  tagList(
    tableOutput(ns('song')),
    htmlOutput(ns('previewtitle')),
    htmlOutput(ns('song_preview'))
  )
}
    
#' plot_clicks Server Functions
#'
#' @noRd 
mod_plot_clicks_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    point_data <- reactive({
      req(input$song_click)
      point_data <- nearPoints(data(), input$song_click,
                               xvar = stringr::str_to_lower(input$x_axis_song), 
                               yvar = stringr::str_to_lower(input$y_axis_song)
      )
      point_data[c('artist_name','valence','energy','album_release_year','track_name','track_preview_url')]
    })
    
    output$song <- renderTable({
      req(nrow(point_data()) > 0)
      point_data()
    })
    
    output$previewtitle <- renderText({
      req(nrow(point_data()) > 0)
      c('<h5><strong>Track Preview:<strong></h5>')
    })
    output$song_preview <- renderText({
      req(nrow(point_data()) > 0)
      c('<center><audio id="song_preview" src="',point_data()$track_preview_url[[1]],'" type = "audio/mp3" autoplay controls></audio></center>')
      })
    
    
  
  })
}
    
## To be copied in the UI
# mod_plot_clicks_ui("plot_clicks_ui_1")
    
## To be copied in the server
# mod_plot_clicks_server("plot_clicks_ui_1")
