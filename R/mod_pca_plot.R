#' pca_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' 
mod_pca_plot_side_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("album_select"))
    
  )
}

mod_pca_plot_main_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotOutput(ns("pca_plot"),width = "100%", height = "700px")
 
  )
}
    
#' pca_plot Server Functions
#'
#' @noRd 
mod_pca_plot_server <- function(id, data, go){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    list_of_albums <- reactive({
      req(!is.null(data()))
      
      
      albums <- unique(data()$album_name)
      albums
      })
    
    output$album_select <- renderUI({
      req(!is.null(data()))
      tagList(
        selectInput(ns("album_list"), 
                    label = "Choose Albums to Plot", 
                    choices = list_of_albums(),
                    multiple = TRUE)
      )
    })
    
    output$pca_plot <- renderPlot({
      req(!is.null(data()))
      req(input$album_list != '')
      
      pca_plot(data(),input$album_list)
  })
  }
)}
    
## To be copied in the UI
# mod_pca_plot_ui("pca_plot_ui_1")
    
## To be copied in the server
# mod_pca_plot_server("pca_plot_ui_1")
