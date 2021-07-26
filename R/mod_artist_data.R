#' artist_data UI Function
#'
#' @description This UI produces a search bar for the user to search the 
#' Spotify API with an Artist name. It then produces a dropdown selector
#' for the user to choose an artist from the names matching their search.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_artist_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    # Search bar that provides a search for spotifyr::search_spotify
    shinyWidgets::searchInput(
      ns("artist_search") , 
      label = "Enter an Artist Name to Search",
      placeholder = "ex. Juice WRLD",
      btnSearch = icon("search"),
      btnReset = icon("remove")),
    
    # Select input bar to select a name from the search input results
    uiOutput(ns("artist_select"))
  )
}

#' artist_data Server Functions
#'
#' @description This server function takes two inputs to produce a reactive
#' data frame that will power the rest of the app. It uses built-in function 
#' from "spotifyr" to produce a data set that is returned from the function.
#'
#' @noRd 
mod_artist_data_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Provides access token for the spotify functions
    spotify_access_token <- reactive({
      spotifyr::get_spotify_access_token()
    })
    
    # Generates a vector list of names that the user can choose from
    # Fixes issue of a less popular band having the name of a word in the name of another band
    list_of_names <- reactive({
      req(input$artist_search != '')
      artists <- spotifyr::search_spotify(input$artist_search, authorization = spotify_access_token())
      artists <- artists$artists$items[c('id','name')]
      artists <- dplyr::distinct(artists, stringr::str_to_lower(name), .keep_all = TRUE)
      artists[,1:2]
    })
    
    # Creates a UI for the select input bar and a generate plot button that triggers the data
    output$artist_select <- renderUI({
      tagList(
        selectInput(ns("artist_select"), 
                  label = "Choose Artist From Search", 
                  choices = list_of_names()$name),
        actionButton(ns("plot_generate"), "Generate Plot")
      )
    })
    
    # Reactive on the plot generate button, this uses a spotifyr function to get artist
    # data for the artist that the user selects from the list
    artist_data_filtered <- eventReactive(input$plot_generate,{
      shinybusy::show_modal_spinner(spin = "double-bounce",
                                    color = "#1DB954")
      
      data <- spotifyr::get_artist_audio_features(list_of_names()[list_of_names()$name == input$artist_select,]$id, 
                                                  authorization = spotify_access_token())
      
      data <- dplyr::distinct(data,  stringr::str_to_lower(track_name), stringr::str_to_lower(album_name), .keep_all = TRUE)
      
      shinybusy::remove_modal_spinner()
    
      data
      })
    
    # Uses an if statement to make sure that the data clears out when the search bar is reset
    list(
    go = reactive(input$plot_generate),
    
    data_filtered = reactive(
      if(input$artist_search == ''){
        NULL
      }else{
        as.data.frame(artist_data_filtered())
      }
    ))
  }
)}


## To be copied in the UI
# mod_artist_data_ui("artist_data_ui_1")

## To be copied in the server
# mod_artist_data_server("artist_data_ui_1")
