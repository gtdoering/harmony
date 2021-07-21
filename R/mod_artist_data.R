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
    shinyWidgets::searchInput(
      ns("artist_search") , 
      label = "Enter an Artist Name to Search",
      placeholder = "ex. Juice WRLD",
      btnSearch = icon("search"),
      btnReset = icon("remove")),
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
    spotify_access_token <- reactive({
      spotifyr::get_spotify_access_token()
    })
    
    list_of_names <- reactive({
      req(input$artist_search != '')
      artists <- spotifyr::search_spotify(input$artist_search, authorization = spotify_access_token())
      artists$artists$items$name
    })
    
    output$artist_select <- renderUI({
      selectInput(ns("artist_select"), 
                  label = "Choose Artist From Search", 
                  choices = list_of_names())
    })
    
    artist_data_raw <- reactive({
      req(input$artist_select != '')
      req(input$artist_search != '')
      shinybusy::show_modal_spinner()

      data <- spotifyr::get_artist_audio_features(input$artist_select, authorization = spotify_access_token())
      
      shinybusy::remove_modal_spinner()
      
      if(nrow(data) == 0) {
        stop("Sorry, couldn't find any tracks for that artist's albums on Spotify.")
      }
      
      return(data)
    })
    
      data_raw = reactive(as.data.frame(artist_data_raw()))
  })
}

## To be copied in the UI
# mod_artist_data_ui("artist_data_ui_1")

## To be copied in the server
# mod_artist_data_server("artist_data_ui_1")
