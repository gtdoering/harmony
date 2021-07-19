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
  tagList(
    plotOutput(ns('song_plot'), click = ns("song_click")),
    plotOutput(ns('album_plot'))
  )
}

# UI mod for the sidebar selectors
mod_artist_plots_side_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns('x_axis_song')),
    uiOutput(ns('y_axis_song')),
    uiOutput(ns('x_axis_album'))
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
    
    #Numeric variables to choose from for axises
    variables <- c("Acousticness","Danceability","Energy","Instrumentalness",
               "Liveness","Loudness","Speechiness","Tempo","Valence")
    
    #Dynamically creates select inputs after data is created
    output$x_axis_song <- renderUI({
      req(!is.null(data()))
      
      selectInput(ns("x_axis_song"), 
                  label = "Select X Axis for Song Plot", 
                  choices = variables,
                  selected = "Energy")
    })
    output$y_axis_song <- renderUI({
      req(!is.null(data()))
      
      selectInput(ns("y_axis_song"), 
                  label = "Select Y Axis for Song Plot", 
                  choices = variables,
                  selected = "Valence")
    })
    output$x_axis_album <- renderUI({
      req(!is.null(data()))
      
      selectInput(ns("x_axis_album"), 
                  label = "Select X Axis for Album Plot", 
                  choices = variables,
                  selected = "Valence")
    })
    
    #Generates song scatter plot
    output$song_plot <- renderPlot({
      req(!is.null(data()))
      req(input$x_axis_song != '')
      req(input$y_axis_song != '')
      
      song_plot(data(), input$x_axis_song, input$y_axis_song,'album_name')
      })
    
    #Generates album ridge plot
    output$album_plot <- renderPlot({
      req(!is.null(data()))
      req(input$x_axis_album != '')
      
      album_plot(data(), input$x_axis_album,'album_name')
    })
  })
}
    
## To be copied in the UI
# mod_artist_plots_ui("artist_plots_ui_1")
    
## To be copied in the server
# mod_artist_plots_server("artist_plots_ui_1")
