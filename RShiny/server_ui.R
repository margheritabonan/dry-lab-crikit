
  #Server#------------------------------------------------------------

library(shiny)
library(ggplot2)

server <- function(input, output, session){
  
  uploaded_data <- reactive({
    req(input$datafile)
    read.csv(input$datafile$datapath)
  })
  
  # update time slider after data upload
  observeEvent(uploaded_data(), {
    df <- uploaded_data()
    if ("Time" %in% names(df)) {
      times <- sort(unique(df$Time))
      updateSliderInput(session, "timepoint", min = min(times), max = max(times), value = min(times), step = 1)
    }
  })
  
  output$plateplot <- renderPlot({
    req(input$plotButton)
    df <- isolate(uploaded_data())
    
    # Filter by selected timepoint
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
      labs(title = paste("Well Plate readout", if ("Time" %in% names(df)) paste("at time", input$timepoint) else ""), fill = "Above threshold") + 
      theme(panel.grid = element_blank(), axis.title = element_blank())
  })

}

#Ui------------------------------------------------------------------------

ui <- fluidPage(
  titlePanel("CRICKIT analyze"), 
  sidebarLayout(
    sidebarPanel(
      fileInput("datafile", "Upload CSV file", accept = ".csv"), 
      sliderInput("threshold", "Value Threshold:", min = 0, max = 1, value = 0.5, step = 0.01),

      sliderInput("timepoint", "Select Timepoint:", min = 0, max = 3, value = 0, step = 1),
      actionButton("plotButton", "Show plate data")
    ),
    mainPanel(plotOutput("plateplot"))
  )
)

shinyApp(ui = ui, server = server)