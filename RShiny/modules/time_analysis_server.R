# Time Analysis Module Server
time_analysis_server <- function(id, datasets) {
  moduleServer(id, function(input, output, session) {
    
    # Check if data is uploaded
    output$dataUploaded <- reactive({
      return(length(names(datasets)) > 0)
    })
    outputOptions(output, "dataUploaded", suspendWhenHidden = FALSE)
    
    # Update dataset choices when datasets change
    observe({
      choices <- names(datasets)
      if (length(choices) > 0) {
        updateSelectInput(session, "vizDataset", choices = choices, selected = choices[1])
      }
    })
    # update well selector when dataset changes
    observeEvent(input$vizDataset, {
      req(input$vizDataset)
      df <- datasets[[input$vizDataset]]
      wells <- setdiff(names(df), "Time")
      updateSelectInput(session, "vizWell", choices = wells, selected = wells[1])
    })
    
    # Example plot using generated data
    # We need to use input$vizDataset instead
    # We only use it to name our dataset right now
    # Instead we should create a plot similar to the one in the excel file
    # x-axis: Time  y-axis: Well values

    output$timePlot <- renderPlot({
      req(input$vizDataset, input$vizWell)
      
      # CHANGE THIS

      # Generate example data
      #set.seed(42)
      #n_points <- 50
      
      # Create sample time-based data
      #time_points <- seq(1, n_points)
      #values <- cumsum(rnorm(n_points, 0, 1)) + time_points * 0.1

      # get dataset chosen by user
      df <- datasets[[input$vizDataset]]

      
      # Create data frame
      #plot_data <- data.frame(
       # Time = time_points,
        #Value = values
      #)
      
      #ggplot(plot_data, aes(x = Time, y = Value)) +
       # geom_line(color = "steelblue", size = 1) +
       # geom_point(color = "darkblue", size = 2) +
       # labs(
        # title = paste("Time Analysis for:", input$vizDataset),
        #  x = "Time",
         # y = "Value"
       # ) +
       #theme_minimal()

      plot_data <- df[, c("Time", input$vizWell), drop = FALSE]
      names(plot_data) <- c("Time", "Value")
      
      ggplot(plot_data, aes(x = Time, y = Value)) +
        geom_line(color = "steelblue", size = 1) +
        geom_point(color = "darkblue", size = 1.5) +
        labs(
          title = paste("Time Analysis for:", input$vizDataset, "-", input$vizWell),
          x = "Time",
          y = "Fluorescence"
        ) +  geom_hline(yintercept = input$threshold, linetype = "dotted", color = "#CB6CE6", size = 2) +
        theme_minimal()
     
    })
    
  })
}