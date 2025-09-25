# Plate Visualization Module Server
# The result looks weird, maybe because of mistakes made in the lab?
# Also the column "Cycle Nr" is hardcoded
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
        cycles <- sort(unique(df$`Time`))
        updateSliderInput(session, "timepoint", min = min(cycles), max = max(cycles), value = min(cycles))
      }
    })
    
    # Create plate plot
    create_plot <- function() {
      req(input$vizDataset)
      df <- datasets[[input$vizDataset]]
      
      # Filter by cycle if available
      if ("Time" %in% names(df) && !is.null(input$timepoint)) {
        df <- df[df$`Time` == input$timepoint, ]
      }
      
      # Get well columns for a 96 well plate
      well_cols <- names(df)[grepl("^[A-H][0-9]+$", names(df))]
      
      # Reshape data to long format
      df_long <- reshape2::melt(df, id.vars = setdiff(names(df), well_cols), 
                                measure.vars = well_cols, 
                                variable.name = "Well", 
                                value.name = "Value")
     
      # Extract row and column from well names
      df_long$Row <- substr(df_long$Well, 1, 1)
      df_long$Col <- as.numeric(sub("^[A-Z]", "", df_long$Well))
      
     
      
      ggplot(df_long, aes(x = Col, y = Row)) + 
        geom_tile(aes(fill = (Value > input$threshold)), color = "white", size = 1) + 
        scale_y_discrete(limits = rev(LETTERS[1:8])) + 
        scale_x_continuous(breaks = 1:12) + 
        scale_fill_manual(values = c("FALSE" = "white", "TRUE" = "#CB6CE6")) +
        theme_linedraw(base_size = 18) + 
        labs(title = paste("Well Plate Readout", 
                           if ("Time" %in% names(df)) paste("at cycle", input$timepoint) else ""), 
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