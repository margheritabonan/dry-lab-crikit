
  #Server#------------------------------------------------------------

library(shiny)
library(ggplot2)

server <- function(input, output, session){
  
  uploaded_data   <- reactive({req(input$datafile)
    read.csv(input$datafile$datapath)})
  
  
  output$plateplot <- renderPlot({req(input$plotButton) 
    df <- isolate(uploaded_data())

    df$Row <- substr(df$Well, 1, 1)
    df$Col <- as.numeric(sub("^[A-Z]", "", df$Well))
    
    ggplot(df, aes(x=Col, y=Row)) + 
      geom_tile(aes(fill=Value > input$threshold),color = "purple") + 
      scale_y_discrete(limits = rev(LETTERS[1:8])) + 
      scale_x_continuous(breaks = 1:12) + 
      scale_fill_manual(values = c("FALSE" = "white", "TRUE" = "purple"))+
      theme_minimal(base_size = 14) + 
      labs (title = "Well Plate readout", fill = 6) + 
      theme(panel.grid = element_blank(),axis.title = element_blank())
    
    
  })
  
  
}

#Ui------------------------------------------------------------------------


library(shiny)

ui <- fluidPage(
  
  titlePanel("CRICKIT analyze"), 
  sidebarLayout(
    sidebarPanel(fileInput("datafile", "Upload CSV file", accept = ".csv"), 
                 sliderInput("threshold", "Value Threshold:", min = 0, max = 1, value = 0.5, step = 0.01), 
                 actionButton("plotButton", "Show plate data")),
    
    mainPanel(plotOutput("plateplot"))
  )
)

shinyApp(ui = ui, server = server)