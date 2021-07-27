#' plot_clicks UI Function
#'
#' @description This module produces html outputs from the inputs provided my
#' hovering and clicking on the song_plot. This module is linked with the artist
#' plots module to get these inputs from plot interactions. The UI produces an
#' autoplay bar for a song that is clicked on and the album image for hovering.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 

mod_plot_clicks_ui <- function(id){
  ns <- NS(id)
  tagList(
    # Plot interactive features
    htmlOutput(ns('hover_intro')),
    htmlOutput(ns('hover_info')),
    htmlOutput(ns('album_image')),
    htmlOutput(ns('preview_intro')),
    htmlOutput(ns('preview_title')),
    htmlOutput(ns('song_preview'))
  )
}
    
#' plot_clicks Server Functions
#' 
#' @description The server module takes the hover and click inputs and turns
#' them into data frames that contain the information for the html code. There 
#' are also two html outputs for text that provides labels and song information
#' for the user.
#'
#' @noRd 
mod_plot_clicks_server <- function(id, data, tab){
  
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Creates and filters the data to provide the URL for the song preview
    # If statement to work before the toggle switch is activated
    preview_data <- reactive({
      if(!is.null(input$x_axis_song)){
        preview_data <- nearPoints(data(), input$song_click,
                                   xvar = stringr::str_to_lower(input$x_axis_song), 
                                   yvar = stringr::str_to_lower(input$y_axis_song)  
      )}else{
        preview_data <- nearPoints(data(), input$song_click,
                                       xvar = 'energy', 
                                       yvar = 'valence')
                                   }
      
      preview_data[c('track_preview_url','track_name')]
    })
    
    # Let's the user know how to get the song preview
    output$preview_intro <- renderText({
      req(!is.null(data()))
      req(is.null(input$song_click) | nrow(preview_data()) == 0)
      req(tab() == "scatter")
      
      c('<h4><center>Click a Song for a Preview</center></h4>')
    })
    
    #Gives the name of the song that is selected for the preview
    output$preview_title <- renderText({
      req(nrow(preview_data()) > 0)
      req(tab() == "scatter")
      
      c('<h5><strong>Track Preview: </strong>',preview_data()$track_name[1],'</h5>')
    })
    
    # Creates the audio player using the URL from the song that is selected
    # Prints a message if there is no URL available
    output$song_preview <- renderText({
      req(nrow(preview_data()) > 0)
      req(tab() == "scatter")
      
      if(!is.na(preview_data()$track_preview_url[1])){
        c('<center><audio id="song_preview" src="',preview_data()$track_preview_url[1],
        '" type = "audio/mp3" autoplay controls></audio></center><br>')
      }else{
        c('<h5><center>No Preview Available</center></h5>')
      }
    })
    
    # Creates a small data frame from hovering on the plot using either the input
    # from the axis selectors or defaults to the starter plot before the toggle
    song_hover_data <- reactive({
      if(!is.null(input$x_axis_song)){
        hover_data <- nearPoints(data(), input$song_hover,
                                 xvar = stringr::str_to_lower(input$x_axis_song), 
                                 yvar = stringr::str_to_lower(input$y_axis_song)
      )}else{
        hover_data <- nearPoints(data(), input$song_hover,
                                 xvar = 'energy', 
                                 yvar = 'valence')
      }
      
      hover_data[c('album_images','album_name','track_name')]
    })
    
    # Lets the user know how to get the info of the songs on the plot
    output$hover_intro <- renderText({
      req(!is.null(data()))
      req(is.null(input$song_hover) | nrow(song_hover_data()) == 0)
      req(tab() == "scatter")
      
      c('<h4><center>Hover for Song Info</center></h4>')
    })
    
    # Gives the user the album name and song name of the point they are hovering on
    output$hover_info <- renderText({
      req(nrow(song_hover_data()) > 0)
      req(tab() == "scatter")
      
      c('<h5><strong>Song Name: </strong>',song_hover_data()$track_name[1],'<br><br>
        <strong>Album Name: </strong>',song_hover_data()$album_name[1],'</h5>')
    })
    
    # Creates the album image for the point the user is hovering on 
    output$album_image <- renderText({
      req(nrow(song_hover_data()) > 0)
      req(tab() == "scatter")
      
      c('<center><img src="',song_hover_data()$album_images[[1]]$url[1],'" height = "200"></center><br>')
    })
    
    
  
  })
}
    
## To be copied in the UI
# mod_plot_clicks_ui("plot_clicks_ui_1")
    
## To be copied in the server
# mod_plot_clicks_server("plot_clicks_ui_1")
