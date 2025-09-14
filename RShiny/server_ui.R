# Load required libraries
library(shiny)
library(ggplot2)
library(DT)

# UI
ui <- navbarPage(
  title = tags$img(src = "../Images/CRIKIT_logo_transparant.png", height = "40px", alt = "crikit Logo"),
  theme = bslib::bs_theme(version = 4),

  # Add custom CSS
  includeCSS("www/styles.css"),


  # Tab 1: About
  tabPanel("About",
           fluidRow(
             column(12,
                    h2("Welcome to crikit Analyze"),
                    br(),
                    div(
                      h3("Overview"),
                      p("crikit Analyze is a comprehensive tool for analyzing well plate data from crikit assays. 
            This application provides multiple analysis modules to help you understand your experimental results."),
                      
                      h3("Features"),
                      tags$ul(
                        tags$li("Upload and manage multiple datasets"),
                        tags$li("Interactive well plate visualization"),
                        tags$li("Time course analysis"),
                        tags$li("Customizable threshold settings")
                      ),
                      
                      h3("Getting Started"),
                      tags$ol(
                        tags$li("Navigate to the 'Datasets' tab to upload your CSV files"),
                        tags$li("Use the analysis tabs to explore your data"),
                        tags$li("Adjust parameters using the sidebar controls")
                      ),
                      
                      h3("Data Format"),
                      p("Your CSV files should contain the following columns:"),
                      tags$ul(
                        tags$li(strong("Well:"), " Well position (e.g., A1, B2, etc.)"),
                        tags$li(strong("Value:"), " Measurement value"),
                        tags$li(strong("Time:"), " Time point (optional)")
                      ),
                      
                      br(),
                      div(class = "alert alert-info",
                          strong("Note:"), " Make sure your data follows the expected format for optimal results."
                      )
                    )
             )
           )
  ),
  
  # Tab 2: Datasets
  tabPanel("Datasets",
           sidebarLayout(
             sidebarPanel(
               h4("Data Management"),
               fileInput("datafile", "Upload CSV file", 
                         accept = ".csv", 
                         multiple = TRUE),
               br(),
               conditionalPanel(
                 condition = "output.dataUploaded",
                 selectInput("selectedDataset", "Select Dataset:", choices = NULL),
                 br(),
                 h5("Dataset Info:"),
                 verbatimTextOutput("datasetInfo")
               )
             ),
             mainPanel(
               conditionalPanel(
                 condition = "output.dataUploaded",
                 h4("Dataset Preview"),
                 DT::dataTableOutput("dataPreview")
               ),
               conditionalPanel(
                 condition = "!output.dataUploaded",
                 div(class = "text-center",
                     h4("No data uploaded"),
                     p("Please upload a CSV file to get started.")
                 )
               )
             )
           )
  ),
  
  # Tab 3: Plate Visualization
  tabPanel("Plate Visualization",
           sidebarLayout(
             sidebarPanel(
               h4("Visualization Controls"),
               conditionalPanel(
                 condition = "output.dataUploaded",
                 selectInput("vizDataset", "Select Dataset:", choices = NULL),
                 sliderInput("threshold", "Value Threshold:", 
                             min = 0, max = 1, value = 0.5, step = 0.01),
                 sliderInput("timepoint", "Select Timepoint:", 
                             min = 0, max = 3, value = 0, step = 1),
                 actionButton("plotButton", "Update Plot", class = "btn-primary"),
                 br(), br(),
                 downloadButton("downloadPlot", "Download Plot", class = "btn-secondary")
               ),
               conditionalPanel(
                 condition = "!output.dataUploaded",
                 p("Please upload data in the Datasets tab first.")
               )
             ),
             mainPanel(
               conditionalPanel(
                 condition = "output.dataUploaded",
                 plotOutput("plateplot", height = "500px")
               ),
               conditionalPanel(
                 condition = "!output.dataUploaded",
                 div(class = "text-center",
                     h4("No data available"),
                     p("Upload data in the Datasets tab to view plate visualization.")
                 )
               )
             )
           )
  )
)

# Server
server <- function(input, output, session) {
  
  # Reactive values to store uploaded datasets
  datasets <- reactiveValues()
  
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
    
    # Update dataset choices in all tabs
    choices <- names(datasets)
    updateSelectInput(session, "selectedDataset", choices = choices, selected = choices[1])
    updateSelectInput(session, "vizDataset", choices = choices, selected = choices[1])
    updateSelectInput(session, "timeDataset", choices = choices, selected = choices[1])
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
  
  # Update controls based on selected dataset
  observeEvent(input$vizDataset, {
    req(input$vizDataset)
    df <- datasets[[input$vizDataset]]
    if ("Time" %in% names(df)) {
      times <- sort(unique(df$Time))
      updateSliderInput(session, "timepoint", min = min(times), max = max(times), value = min(times))
    }
  })
  
  # Update well choices when time dataset changes
  observeEvent(input$timeDataset, {
    req(input$timeDataset)
    df <- datasets[[input$timeDataset]]
    if ("Well" %in% names(df)) {
      wells <- sort(unique(df$Well))
      updateSelectInput(session, "selectedWells", choices = wells, selected = wells[1:min(5, length(wells))])
      updateSelectInput(session, "excludedWells", choices = wells, selected = character(0))
    }
  })
  
  # Select all wells button
  observeEvent(input$selectAllWells, {
    req(input$timeDataset)
    df <- datasets[[input$timeDataset]]
    if ("Well" %in% names(df)) {
      wells <- sort(unique(df$Well))
      updateSelectInput(session, "selectedWells", selected = wells)
      updateSelectInput(session, "excludedWells", selected = character(0))
    }
  })
  
  # Clear all wells button
  observeEvent(input$clearAllWells, {
    updateSelectInput(session, "selectedWells", selected = character(0))
    updateSelectInput(session, "excludedWells", selected = character(0))
  })
  
  # Update included wells when excluded wells change
  observeEvent(input$excludedWells, {
    req(input$timeDataset)
    df <- datasets[[input$timeDataset]]
    if ("Well" %in% names(df)) {
      all_wells <- sort(unique(df$Well))
      excluded <- input$excludedWells
      included <- setdiff(all_wells, excluded)
      updateSelectInput(session, "selectedWells", selected = included)
    }
  })
  
  # Update excluded wells when included wells change
  observeEvent(input$selectedWells, {
    req(input$timeDataset)
    df <- datasets[[input$timeDataset]]
    if ("Well" %in% names(df)) {
      all_wells <- sort(unique(df$Well))
      included <- input$selectedWells
      excluded <- setdiff(all_wells, included)
      updateSelectInput(session, "excludedWells", selected = excluded)
    }
  })
  
  # Plate plot
  output$plateplot <- renderPlot({
    req(input$plotButton)
    req(input$vizDataset)
    df <- isolate(datasets[[input$vizDataset]])
    
    if ("Time" %in% names(df) && !is.null(input$timepoint)) {
      df <- df[df$Time == input$timepoint, ]
    }
    
    df$Row <- substr(df$Well, 1, 1)
    df$Col <- as.numeric(sub("^[A-Z]", "", df$Well))
    
    ggplot(df, aes(x = Col, y = Row)) + 
      geom_tile(aes(fill = Value > input$threshold), color = "purple") + 
      scale_y_discrete(limits = rev(LETTERS[1:8])) + 
      scale_x_continuous(breaks = 1:12) + 
      scale_fill_manual(values = c("FALSE" = "white", "TRUE" = "purple")) +
      theme_minimal(base_size = 14) + 
      labs(title = paste("Well Plate Readout", 
                         if ("Time" %in% names(df)) paste("at time", input$timepoint) else ""), 
           fill = "Above threshold") + 
      theme(panel.grid = element_blank(), axis.title = element_blank())
  })
}

# Run the app
shinyApp(ui = ui, server = server)