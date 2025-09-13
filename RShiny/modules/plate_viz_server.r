# Plate Visualization Module Server
plate_viz_server <- function(id, datasets) {
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
    
    # Update controls (Interactive ui) based on selected dataset
    observeEvent(input$vizDataset, {
      req(input$vizDataset)
      df <- datasets[[input$vizDataset]]
      if ("Time" %in% names(df)) {
        times <- sort(unique(df$Time))
        updateSliderInput(session, "timepoint", min = min(times), max = max(times), value = min(times))
      }
    })
    
    # Create plate plot
    create_plot <- function() {
      req(input$vizDataset)
      df <- datasets[[input$vizDataset]]
      
      if ("Time" %in% names(df) && !is.null(input$timepoint)) {
        df <- df[df$Time == input$timepoint, ]
      }
      
      df$Row <- substr(df$Well, 1, 1)
      df$Col <- as.numeric(sub("^[A-Z]", "", df$Well))
      
      ggplot(df, aes(x = Col, y = Row)) + 
        geom_tile(aes(fill = Value > input$threshold), color = "#CB6CE6") + 
        scale_y_discrete(limits = rev(LETTERS[1:8])) + 
        scale_x_continuous(breaks = 1:12) + 
        scale_fill_manual(values = c("FALSE" = "white", "TRUE" = "#CB6CE6")) +
        theme_minimal(base_size = 14) + 
        labs(title = paste("Well Plate Readout", 
                           if ("Time" %in% names(df)) paste("at time", input$timepoint) else ""), 
             fill = "Above threshold") + 
        theme(
          panel.grid = element_blank(),
          axis.title = element_blank()
        )
    }
    
    # Save plot for UI
    output$plateplot <- renderPlot({
      create_plot()
    })
    
    # Download handler for plot
    output$downloadPlot <- downloadHandler(
      filename = function() paste("plate_plot_", Sys.Date(), ".png", sep = ""),
      content = function(file) {
        ggsave(file, plot = create_plot(), device = "png", width = 10, height = 6, dpi = 300)
      }
    )
  })
}