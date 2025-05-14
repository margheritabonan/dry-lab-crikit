# install only if not there yet
if (!require(shiny)) {
  install.packages("shiny", repos = "https://cloud.r-project.org")
}
install.packages("shiny", repos = "https://cloud.r-project.org")
install.packages("QurvE", repos = "https://cloud.r-project.org")
install.packages("systemfonts", repos = "https://cloud.r-project.org")
#install.packages("shinythemes") 

library(shiny)
#library(shinythemes) 
library(QurvE) # may give error if some dependencies are not installed (in my experience)


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

  # make a fluorescence analysis plot using QurvE
  output$plot2 <- renderPlot({
  req(input$go)
  df <- isolate(my_data())
  num_cols <- sapply(df, is.numeric)
  if (any(num_cols)) {
    # assuming the first numeric column is fluorescence data
    fluorescence_data <- df[[ which(num_cols)[1] ]]
    time_points <- seq_along(fluorescence_data) # replace with actual time points if available
    
    # perform fluorescence analysis using QurvE # not sure if this is correct
    result <- growth.gcFit(time = rnd.fluorescence_data$time,
                      data = rnd.fluorescence_data$data,
                      parallelize = FALSE,
                      control = growth.control(suppress.messages = TRUE,
                                               fit.opt = 's'))
    
    # plot the result
    plot(result)
  } else {
    plot.new()
    text(0.5, 0.5, "No columns to plot")
  }
})
}
