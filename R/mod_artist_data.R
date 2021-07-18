#' artist_data UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_artist_data_ui <- function(id){
  ns <- NS(id)
  tagList(
    textInput(ns('artist_search'), "Search an Artist"),
    selectInput(ns('artist_select'), "Select Artist From Your Search", choices = NULL)
  )
}

#' artist_data Server Functions
#'
#' @noRd 
mod_artist_data_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    names <- {
      req(input$artist_search != '')
      search <- spotifyr::search_spotify(input$artist_search)
      search$artists$items$name
    }
    updateSelectInput(session = session, 'artist_select', choices = names)
    
    observeEvent(input$artist_select,{
    artist_data <- {
      req(input$artist_select != '')
      spotifyr::get_artist_audio_features(input$artist_select)
    }}
    )
    
    artist_data
  })
}

## To be copied in the UI
# mod_artist_data_ui("artist_data_ui_1")

## To be copied in the server
# mod_artist_data_server("artist_data_ui_1")
