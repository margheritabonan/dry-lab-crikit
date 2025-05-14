# install only if not there yet
if (!require(shiny)) {
  install.packages("shiny", repos = "https://cloud.r-project.org")
}
#install.packages("shiny", repos = "https://cloud.r-project.org")
library(shiny)

# server logic for the app
server <- function(input, output, session) {
  
  # Reactive expression to load and preprocess data
  my_data <- reactive({
    req(input$datafile)
    df <- read.csv(input$datafile$datapath, stringsAsFactors = FALSE)
    # preprocessing steps 
    # df
  })
  
  # make the uploaded data a table (when "Run Analysis" is clicked)
  output$datatable <- renderTable({
    req(input$go)
    isolate(my_data())
  })
  
  # make a histogram of the first column
  output$plot1 <- renderPlot({
    req(input$go)
    df <- isolate(my_data())
    num_cols <- sapply(df, is.numeric)
    if (any(num_cols)) {
      hist(
        df[[ which(num_cols)[1] ]],
        main = "Histogram of First Column",
        xlab = names(df)[which(num_cols)[1]]
      )
    } else {
      plot.new()
      text(0.5, 0.5, "No columns to plot")
    }
  })
}
