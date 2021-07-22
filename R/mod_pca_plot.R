#' pca_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_pca_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' pca_plot Server Functions
#'
#' @noRd 
mod_pca_plot_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$artist_select <- renderUI({
      req(!is.null(data()))
      
      tagList(
        selectInput(ns("artist_select"), 
                    label = "Choose Artist From Search", 
                    choices = list_of_names()$name),
        actionButton(ns("plot_generate"), "Generate Plot")
      )
    })
 
  })
}
    
## To be copied in the UI
# mod_pca_plot_ui("pca_plot_ui_1")
    
## To be copied in the server
# mod_pca_plot_server("pca_plot_ui_1")
