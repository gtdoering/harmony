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

thematic::thematic_shiny()
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    fluidPage(
      theme = dark,
      titlePanel(
        "harmony"
      ),
      
      shinyWidgets::materialSwitch("light_mode", "Light mode", 
                                   status = "default",
                                   value = FALSE),
      fluidRow(
        column(3,
               wellPanel(
               mod_artist_data_ui("artist"),
               mod_plot_clicks_ui("plot"),
               mod_artist_plots_side_ui("plot"),
               mod_pca_plot_side_ui("pca")
               )

               ),
        column(9,
               tabsetPanel(id = "tabs",
                           tabPanel("Scatter", 
                                    mod_artist_plots_main_ui("plot")),
                           tabPanel("PCA",
                                    mod_pca_plot_main_ui("pca")
                           
                           )
               )
               
               ),
      )
  ))
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

