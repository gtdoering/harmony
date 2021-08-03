#' rmd_generator UI Function
#'
#' @description This UI module is for a download button that is dynamically 
#' created when the plots are prepared to be downloaded. 
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_rmd_generator_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("download_button"))
  )
}
    
#' rmd_generator Server Functions
#' 
#' @description Code to create a file called report from the exists RMD file 
#' in the directory.
#'
#' @noRd 
mod_rmd_generator_server <- function(id, ggscatter, pca_scatter, pca_table){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Dynamically creates the download report button when the plot is ready
    output$download_button <- renderUI({
      req(!is.null(ggscatter()))
      req(!is.null(pca_scatter()))
      req(!is.null(pca_table()))
      
      downloadButton(ns("report"),"Generate Report")
    })
    
    output$report <- downloadHandler(
      # For PDF output, change this to "report.pdf"
      filename = "report.html",
      content = function(file) {
        # Copy the report file to a temporary directory before processing it, in
        # case we don't have write permissions to the current working dir (which
        # can happen when deployed).
        tempReport <- file.path(tempdir(), "report.Rmd")
        file.copy("report.Rmd", tempReport, overwrite = TRUE)
        
        # Set up parameters to pass to Rmd document
        params <- list(ggscatter = ggscatter(),
                       pca_scatter = pca_scatter(),
                       pca_table = pca_table())
        
        # Knit the document, passing in the `params` list, and eval it in a
        # child of the global environment (this isolates the code in the document
        # from the code in this app).
        rmarkdown::render(tempReport, output_file = file,
                          params = params,
                          envir = new.env(parent = globalenv())
        )
      }
    )
 
  })
}
    
## To be copied in the UI
# mod_rmd_generator_ui("rmd")
    
## To be copied in the server
# mod_rmd_generator_server("rmd")
