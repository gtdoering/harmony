#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd

dark <- bslib::bs_theme(
  bg = "#191414", fg = "#1DB954", 
  primary = "#1DB954", secondary = "#1DB954", success = "#1DB954", 
  info = "#1DB954", warning = "#1DB954", danger = "#1DB954"
)

light <- bslib::bs_theme(
  bg = "#FFFFFF", fg = "#1DB954", 
  primary = "#1DB954", secondary = "#1DB954", success = "#1DB954", 
  info = "#1DB954", warning = "#1DB954", danger = "#1DB954"
)


app_ui <- function(request) {
    # Leave this function for adding external resources
    golem_add_external_resources()
    # Your application UI logic 
      header <- shinydashboard::dashboardHeader(
        title = "harmony"
         
                 )
      
      sidebar <- shinydashboard::dashboardSidebar(
        width = 300,
        shinydashboard::sidebarMenu(
          id = "tabs",
          mod_artist_data_ui("artist"),
          shinydashboard::menuItem("Scatter", tabName = "scatter"),
          mod_plot_clicks_ui("plot"),
          mod_artist_plots_side_ui("plot"),
          shinydashboard::menuItem("PCA", tabName = "pca"),
          mod_pca_plot_side_ui("pca")
        )
      )
      
      body <- shinydashboard::dashboardBody(
        shinydashboard::tabItems(
          shinydashboard::tabItem(tabName = "scatter",
                                  mod_artist_plots_main_ui("plot")),
          shinydashboard::tabItem(tabName = "pca",
                                  mod_pca_plot_main_ui("pca"))
          
          )
      )
      
    
      
    shinydashboard::dashboardPage(
      header,
      sidebar,
      body,
      skin = "black"
    )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'harmony'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

