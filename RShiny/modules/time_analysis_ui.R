# Time Analysis Module Server
time_analysis_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Time Series Analysis"),
    h3("This page is not complete, see the comments in time_analysis_server"),
    
    conditionalPanel(
      condition = paste0("output['", ns("dataUploaded"), "']"),
      fluidRow(
        selectInput(ns("vizDataset"), "Select Dataset:", choices = NULL)
      ),
      br(), plotOutput(ns("timePlot"), height = "500px"), br(),
      downloadButton(ns("downloadTimePlot"), "Download Plot", class = "btn-secondary")
    ),
    conditionalPanel(
      condition = paste0("!output['", ns("dataUploaded"), "']"),
      div(class = "text-center", h4("No data available"), p("Upload data in the Datasets tab to view time series visualization."))
    )
  )
}
