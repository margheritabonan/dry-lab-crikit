# Datasets Module UI
datasets_ui <- function(id) {
  ns <- NS(id)
  
  sidebarLayout(
    sidebarPanel(
      h4("Data Management"),
      
      # File type selection
      radioButtons(ns("fileType"), "File Type:",
                   choices = list(
                     "Delimited Files (CSV, TSV, TXT)" = "delimited",
                     "Spark Control Raw Data (Excel)" = "sparkcontrol"
                   ),
                   selected = "delimited"),
      br(),
      
      # File input with conditional accept types
      conditionalPanel(
        condition = paste0("input['", ns("fileType"), "'] == 'delimited'"),
        fileInput(ns("datafile"), "Upload delimited file(s)", 
                  accept = c(".csv", ".tsv", ".txt"), 
                  multiple = TRUE),
        # Delimiter specification (optional)
        selectInput(ns("delimiter"), "Delimiter (auto-detect if not specified):",
                    choices = list("Auto-detect" = "auto",
                                   "Comma (,)" = ",",
                                   "Semicolon (;)" = ";",
                                   "Tab" = "\t",
                                   "Space" = " ",
                                   "Pipe (|)" = "|"),
                    selected = "auto")
      ),
      
      conditionalPanel(
        condition = paste0("input['", ns("fileType"), "'] == 'sparkcontrol'"),
        fileInput(ns("datafile"), "Upload Spark Control file(s)", 
                  accept = c(".xlsx", ".xls"), 
                  multiple = TRUE),
        numericInput(ns("sheetNumber"), "Sheet Number:", 
                     value = 1, min = 1, step = 1)
      ),
      
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
            p("Please select a file type and upload a file to get started.")
        )
      )
    )
  )
}