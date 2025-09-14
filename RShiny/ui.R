library(shiny)
#library(shinythemes)

ui <- fluidPage(
  #theme = shinytheme("cosmo"),
  titlePanel("CRIKIT Data Analysis Website"),
  sidebarLayout(
    sidebarPanel(
      # upload input
      fileInput("datafile", "Upload CSV Data", accept = c(".*")),
      
      # more inputs here
      actionButton("go", "Run Analysis")
    ),
    mainPanel(
      # outputs: table and plot
      #tableOutput("datatable"),
      plotOutput("plot2")
    )
  )
)