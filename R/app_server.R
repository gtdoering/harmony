#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  thematic::thematic_shiny()
  
  # Your application server logic 
  data <- mod_artist_data_server("artist")
  mod_plot_clicks_server("plot", data$data_filtered)
  mod_artist_plots_server("plot", data$data_filtered)
  
  observeEvent(data$data_filtered(), {
    appendTab(inputId  = "tabs",
              tabPanel("Scatter",
                       mod_artist_plots_main_ui("plot"))
              
    )
    appendTab(inputId  = "tabs",
              tabPanel("PCA",
                       mod_artist_plots_main_ui("plot"))
              
    )
    })
  
  output$scatter <- renderUI({
    req(input$tabs == "Scatter")
    
    tagList(
    mod_plot_clicks_ui("plot"),
    mod_artist_plots_side_ui("plot"))
  })
}