# Datasets Module UI
datasets_ui <- function(id) {
  ns <- NS(id)
  
  sidebarLayout(
    sidebarPanel(
      h4("Data Management"),
      fileInput(ns("datafile"), "Upload CSV file", 
                accept = ".csv", 
                multiple = TRUE),
      br(),
      conditionalPanel(
        condition = paste0("output['", ns("dataUploaded"), "']"),
        selectInput(ns("selectedDataset"), "Select Dataset:", choices = NULL),
        br(),
        h5("Dataset Info:"),
        verbatimTextOutput(ns("datasetInfo"))
      )
    ),
    mainPanel(
      conditionalPanel(
        condition = paste0("output['", ns("dataUploaded"), "']"),
        h4("Dataset Preview"),
        DT::dataTableOutput(ns("dataPreview"))
      ),
      conditionalPanel(
        condition = paste0("!output['", ns("dataUploaded"), "']"),
        div(class = "text-center",
            h4("No data uploaded"),
            p("Please upload a CSV file to get started.")
        )
      )
    )
  )
}