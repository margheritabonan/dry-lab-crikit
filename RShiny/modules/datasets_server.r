# Datasets Module Server
# To do: - Add Spark Control data reader
#        - Automatically detect the delimiter

datasets_server <- function(id, datasets) {
  moduleServer(id, function(input, output, session) {
    
    # Check if data is uploaded
    output$dataUploaded <- reactive({
      return(length(names(datasets)) > 0)
    })
    outputOptions(output, "dataUploaded", suspendWhenHidden = FALSE)
    
    # Handle file uploads
    observeEvent(input$datafile, {
      req(input$datafile)
      
      for(i in 1:nrow(input$datafile)) {
        file_info <- input$datafile[i, ]
        dataset_name <- tools::file_path_sans_ext(file_info$name)
        
        tryCatch({
          data <- read.csv(file_info$datapath)
          datasets[[dataset_name]] <- data
        }, error = function(e) {
          showNotification(paste("Error loading", file_info$name, ":", e$message), type = "error")
        })
      }
      
      # Update dataset choices in this module
      choices <- names(datasets)
      updateSelectInput(session, "selectedDataset", choices = choices, selected = choices[1])
    })
    
    # Dataset info
    output$datasetInfo <- renderText({
      req(input$selectedDataset)
      data <- datasets[[input$selectedDataset]]
      paste0("Rows: ", nrow(data), "\n",
             "Columns: ", ncol(data), "\n",
             "Column names: ", paste(names(data), collapse = ", "))
    })
    
    # Dataset preview
    output$dataPreview <- DT::renderDataTable({
      req(input$selectedDataset)
      DT::datatable(datasets[[input$selectedDataset]], options = list(scrollX = TRUE))
    })
    
    # Return reactive values for other modules to use
    return(list(
      selectedDataset = reactive(input$selectedDataset),
      datasets = datasets
    ))
  })
}