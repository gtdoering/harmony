#' pca_plot UI Function
#'
#' @description This is a two-part UI shiny module to plot the select input bar 
#' and the PCA plot. Both of these are dynamic and will be created upon the 
#' creation of the global dataset. The select input bar enables you to pick the 
#' albums that you want in the plot.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' 

# UI for the side panel. Creates the select input bar
mod_pca_plot_side_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("album_select")),
    uiOutput(ns("control_switch")),
    uiOutput(ns("plot_controls"))
    
    
  )
}

# UI for the main panel. Plots the main PCA plot
mod_pca_plot_main_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotOutput(ns("pca_plot"),
               width = "100%", height = "700px")
 
  )
}
    
#' pca_plot Server Functions
#'
#' @description The server functions for this module take in the data from the 
#' artist data module and put it into the function to create the PCA plot. It 
#' also creates a character vector from the artist albums to give the user the 
#' ability to choose the albums that they want on the plot.
#'
#' @noRd 
mod_pca_plot_server <- function(id, data, go){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Creates a list of albums for the user to choose from
    list_of_albums <- reactive({
      req(!is.null(data()))
      
      
      albums <- unique(data()$album_name)
      albums
      })
    
    # Creates a select input bar that the user can interact with
    output$album_select <- renderUI({
      req(!is.null(data()))
      tagList(
        selectInput(ns("album_list"), 
                    label = "Choose Albums to Plot", 
                    choices = list_of_albums(),
                    multiple = TRUE)
      )
    })
    
    # Creates the switch that allows you to change the axis variables on the plot
    output$control_switch <- renderUI({
      req(!is.null(data()))
      shinyWidgets::materialSwitch(inputId = ns("plot_controls"), 
                                   label = "Plot Settings",
                                   status = "default",
                                   value = FALSE)
    })
    
    # Dynamically creates input controls for PCA plot after data is created
    output$plot_controls <- renderUI({
      req(!is.null(data()))
      req(input$plot_controls)
      tagList(
        splitLayout(
          
          # Creates a fix for the splitLayout function so the select input dropdowns are visible
          tags$head(tags$style(HTML(".shiny-split-layout > div {overflow: visible;}"))),
          cellWidths = c("0%","49.25%", "49.25%"),
          
          shinyWidgets::materialSwitch(inputId = ns("loadings_switch"), 
                                       label = "Plot Loadings",
                                       status = "default",
                                       value = FALSE),
          shinyWidgets::materialSwitch(inputId = ns("grouping_switch"), 
                                       label = "Show Clusters",
                                       status = "default",
                                       value = FALSE)
      )
      )
    })
    
    # Creates the output PCA plot
    output$pca_plot <- renderPlot({
      req(!is.null(data()))
      req(input$album_list != '')
      
      if(is.null(input$loadings_switch)){
        pca_plot(data(),input$album_list)
      }else{
        pca_plot(data(),input$album_list, input$loadings_switch, input$grouping_switch)
      }
      
  })
  }
)}
    
## To be copied in the UI
# mod_pca_plot_ui("pca_plot_ui_1")
    
## To be copied in the server
# mod_pca_plot_server("pca_plot_ui_1")
