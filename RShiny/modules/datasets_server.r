# Datasets Module Server
# To do: - Add Spark Control data reader
#        - Automatically detect the delimiter
library(readr)
library(shiny)
library(ggplot2)
library(DT)
library(tidyr)
library(reshape2)
library(tidyverse)

datasets_server <- function(id, datasets) {
  moduleServer(id, function(input, output, session) {
    
    # Check if data is uploaded
    output$dataUploaded <- reactive({
      return(length(names(datasets)) > 0)
    })
    outputOptions(output, "dataUploaded", suspendWhenHidden = FALSE)
    
    # Function to auto-detect delimiter
    detect_delimiter <- function(file_path) {
      # Read first few lines to detect delimiter
      sample_lines <- readLines(file_path, n = 5)
      
      delimiters <- c(",", ";", "\t", " ", "|")
      delimiter_counts <- sapply(delimiters, function(d) {
        mean(sapply(sample_lines, function(line) length(strsplit(line, d, fixed = TRUE)[[1]])))
      })
      
      # Return delimiter with highest average count
      names(delimiter_counts)[which.max(delimiter_counts)]
    }
    
    # Function to read delimited files
    read_delimited_file <- function(file_path, delimiter = "auto") {
      if (delimiter == "auto") {
        delimiter <- detect_delimiter(file_path)
      }
      
      # Use appropriate read function based on delimiter
      if (delimiter == "\t") {
        read.delim(file_path, stringsAsFactors = FALSE)
      } else  {
        read_delim(file_path, delim = ";", skip = 48, locale = locale(encoding = "latin1", decimal_mark = ".", grouping_mark = ""), trim_ws = TRUE)  
      }
    }
    
    # Your existing Spark Control read function
    read_sparkcontrol_file <- function(input_file, sheet = 1) {
      # Check if file exists
      if (!file.exists(input_file)) {
        stop(paste("File does not exist:", input_file))
      }
      
      # Read raw excel sheet without headers
      raw <- readxl::read_excel(input_file, sheet = sheet, col_names = FALSE)
      
      # Find the starting point of the data
      start_row <- which(raw[[1]] == "Cycle Nr.")
      if (length(start_row) == 0) stop("Could not find 'Cycle Nr.' in file.")
      
      # Find where "End Time" appears
      end_row <- which(raw[[1]] == "End Time")
      if (length(end_row) == 0) {
        # fallback: last non-empty row
        end_row <- max(which(!is.na(raw[[1]])))
      }
      
      # Number of rows to read (exclusive of End Time row)
      nrows <- (end_row - start_row) - 1
      
      # Read again with proper headers, limited to nrows
      df <- readxl::read_excel(input_file,
                               sheet = sheet,
                               skip = start_row - 1,
                               n_max = nrows)
      
      # Delete empty columns
      df <- df[, colSums(df != "" & !is.na(df)) > 0]
      
      return(df)
    }
    
    # Handle file uploads
    observeEvent(input$datafile, {
      req(input$datafile, input$fileType)
      
      for(i in 1:nrow(input$datafile)) {
        file_info <- input$datafile[i, ]
        dataset_name <- tools::file_path_sans_ext(file_info$name)
        
        tryCatch({
          # Choose read function based on file type
          if (input$fileType == "delimited") {
            data <- read_delimited_file(file_info$datapath, input$delimiter)
            showNotification(paste("Successfully loaded delimited file:", file_info$name), 
                             type = "message")
          } else if (input$fileType == "sparkcontrol") {
            data <- read_sparkcontrol_file(file_info$datapath, input$sheetNumber)
            showNotification(paste("Successfully loaded Spark Control file:", file_info$name), 
                             type = "message")
          }
          
          datasets[[dataset_name]] <- data
          
        }, error = function(e) {
          showNotification(paste("Error loading", file_info$name, ":", e$message), 
                           type = "error")
        })
      }
      
      # Update dataset choices in this module
      choices <- names(datasets)
      if (length(choices) > 0) {
        updateSelectInput(session, "selectedDataset", choices = choices, selected = choices[length(choices)])
      }
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
      DT::datatable(datasets[[input$selectedDataset]], 
                    options = list(scrollX = TRUE, pageLength = 10))
    })
    
    # Return reactive values for other modules to use
    return(list(
      selectedDataset = reactive(input$selectedDataset),
      datasets = datasets,
      fileType = reactive(input$fileType)
    ))
  })
  
}