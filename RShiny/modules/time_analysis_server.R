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

    output$timePlot <- renderPlot({
      req(input$vizDataset, input$vizWell)
    
      # get dataset chosen by user
      df <- datasets[[input$vizDataset]]
     
      plot_data <- df[, c("Time", input$vizWell), drop = FALSE]
      names(plot_data) <- c("Time", "Value")
      
      ggplot(plot_data, aes(x = Time, y = Value)) +
        geom_line(color = "steelblue", size = 1) +
        geom_point(color = "darkblue", size = 1.5) +
        labs(
          title = paste("Time Analysis for:", input$vizDataset, "-", input$vizWell),
          x = "Time",
          y = "Fluorescence"
        ) +  geom_hline(yintercept = input$VizThreshold, linetype = "dotted", color = "#CB6CE6", size = 2) +
        theme_minimal()
     
    })
    
  })
}