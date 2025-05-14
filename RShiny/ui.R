library(shiny)
#library(shinythemes)

ui <- fluidPage(
  #theme = shinytheme("cosmo"),
  titlePanel(" CRIKIT Data Analysis App"),
  sidebarLayout(
    sidebarPanel(
      # upload input
      fileInput("datafile", "Upload CSV Data", accept = c(".csv")),
      
      # more inputs here
      actionButton("go", "Run Analysis")
    ),
    mainPanel(
      # outputs: table and plot
      tableOutput("datatable"),
      plotOutput("plot1")
    )
  )
)