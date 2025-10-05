# Time Analysis Module Server
time_analysis_ui <- function(id) {
  
  
  ns <- NS(id)  # Namespacing for module inputs/outputs
  
  
  tagList(
    h3("Time Series Analysis"), # Section title
    
    # Show controls and plot only if data is uploaded
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
      # Slider to set threshold for visualization
      (div(sliderInput(ns("VizThreshold"), "Select Threshold:", min = 0, max = 100000, value = 50000, step = 0.01))
      ),
      
      br(),
      # Plot output for time series
      plotOutput(ns("timePlot"), height = "500px"),
      br(),
      # Button to download the plot
      downloadButton(ns("downloadTimePlot"), "Download Plot", class = "btn-secondary")
    ),
    # Message shown if no data is uploaded
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