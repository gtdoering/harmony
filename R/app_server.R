#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Dynamic Theme switch
  observe(session$setCurrentTheme(
    if (isTRUE(input$light_mode)) light else dark
  ))
  
  # Your application server logic 
  data <- mod_artist_data_server("artist")
  mod_plot_clicks_server("plot", data$data_filtered)
  mod_artist_plots_server("plot", data$data_filtered)
  mod_pca_plot_server("pca", data$data_filtered)
  
  #Plot Tabs Dynamically Created
  observeEvent(data$data_filtered(), {
    appendTab(inputId  = "tabs", select = TRUE,
              tabPanel("Scatter",
                       mod_artist_plots_main_ui("plot"))
              
    )
    appendTab(inputId  = "tabs",
              tabPanel("PCA",
                       mod_pca_plot_main_ui("pca"))
              
    )
    })
  
  #UI sidebar Changing Dynamically with Tab changing
  output$scatter <- renderUI({
    req(input$tabs == "Scatter")
    
    tagList(
    mod_plot_clicks_ui("plot"),
    mod_artist_plots_side_ui("plot"))
  })
  
  output$pca_plot <- renderUI({
    req(input$tabs == "PCA")
    
    tagList(
      mod_pca_plot_side_ui("pca"))
  })
}