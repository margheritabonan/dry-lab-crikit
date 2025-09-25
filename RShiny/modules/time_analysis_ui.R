# Time Analysis Module Server
time_analysis_ui <- function(id) {
  
  
  ns <- NS(id)
  
  
  tagList(
    h3("Time Series Analysis"),
    
    conditionalPanel(
      condition = sprintf("output['%s']", ns("dataUploaded")),
      fluidRow(
        column(
          width = 6,
          selectInput(ns("vizDataset"), "Select Dataset:", choices = NULL)
        ),
        column(
          width = 6,
          selectInput(ns("vizWell"), "Select Well:", choices = NULL)
        ),
      ),
      
      (div(sliderInput(ns("VizThreshold"), "Select Threshold:", min = 0, max = 200, value = 100, step = 0.01))
      ),
      
      br(),
      plotOutput(ns("timePlot"), height = "500px"),
      br(),
      downloadButton(ns("downloadTimePlot"), "Download Plot", class = "btn-secondary")
    ),
    
    conditionalPanel(
      condition = sprintf("!output['%s']", ns("dataUploaded")),
      div(
        class = "text-center",
        h4("No data available"),
        p("Upload data in the Datasets tab to view time series visualization.")
        
      )
    )
  )
  
}