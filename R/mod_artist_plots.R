#' artist_plots UI Function
#'
#' @description This is a two-part UI module so that the outputs can be 
#' put into the main panel and the sidebar panel. The UI mod for the main
#' panel plots the output scatter song plot and the ridge album plot. The
#' sidebar UI works dynamically to the give the user the choice of variables
#' for both plots.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 

# UI mod for the plots on the main panel
mod_artist_plots_main_ui <- function(id){
  ns <- NS(id)
  
  # UI function for the scatter plot that is put on the main panel also creates 
  # the inputs for clicking on the plot and hovering
  tagList(
    plotOutput(ns('song_plot'), click = ns("song_click"), hover = ns("song_hover"),
               width = "100%", height = "600px"),
    #plotOutput(ns('album_plot'))
  )
}

# UI mod for the sidebar selectors
mod_artist_plots_side_ui <- function(id){
  ns <- NS(id)
  
  # UI function to create toggle switch and select inputs for the axis variables
  tagList(
    uiOutput(ns('axis_switch')),
    uiOutput(ns('axis_selectors')),
    #uiOutput(ns('x_axis_album'))
    )
}
    
#' artist_plots Server Functions
#' 
#' @description The server functions work to create the select inputs for the 
#' axises of the graphs, and also to produce the graphs themselves. 
#'
#' @noRd 
mod_artist_plots_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Numeric variables to choose from for axises
    variables <- c("Acousticness","Danceability","Energy","Instrumentalness",
               "Liveness","Loudness","Speechiness","Tempo","Valence")
    
    # Creates the switch that allows you to change the axis variables on the plot
    output$axis_switch <- renderUI({
      req(!is.null(data()))
      shinyWidgets::materialSwitch(inputId = ns("axis_controls"), 
                                   label = "Change Axis Variable",
                                   status = "default",
                                   value = FALSE)
    })
    
    # Dynamically creates select inputs after data is created
    output$axis_selectors <- renderUI({
      req(!is.null(data()))
      req(input$axis_controls)
      tagList(
        splitLayout(
          
          # Creates a fix for the splitLayout function so the select input dropdowns are visible
          tags$head(tags$style(HTML(".shiny-split-layout > div {overflow: visible;}"))),
          cellWidths = c("0%","49.25%", "49.25%"),
          
          selectInput(ns("x_axis_song"), 
                      label = "X Axis", 
                      choices = variables,
                      selected = "Energy"),
          selectInput(ns("y_axis_song"), 
                    label = "Y Axis", 
                    choices = variables,
                    selected = "Valence"))
          
      )
    })
    
    # output$x_axis_album <- renderUI({
    #   req(!is.null(data()))
    #   
    #   selectInput(ns("x_axis_album"), 
    #               label = "Select X Axis for Album Plot", 
    #               choices = variables,
    #               selected = "Valence")
    # })
    
    # Generates song scatter plot, before toggle switch is activated it defaults 
    # to energy and valence for the axises
    output$song_plot <- renderPlot({
      req(!is.null(data()))
      
      if(!is.null(input$x_axis_song)){
        song_plot(data(), input$x_axis_song, input$y_axis_song,'album_name')
      }else{
        song_plot(data(), 'Energy', 'Valence','album_name')
      }
      })
    
    #Generates album ridge plot
    # output$album_plot <- renderPlot({
    #   req(!is.null(data()))
    #   req(input$x_axis_album != '')
    #   
    #   album_plot(data(), input$x_axis_album,'album_name')
    # })
  })
}
    
## To be copied in the UI
# mod_artist_plots_ui("artist_plots_ui_1")
    
## To be copied in the server
# mod_artist_plots_server("artist_plots_ui_1")
