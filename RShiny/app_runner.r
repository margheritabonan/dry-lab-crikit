# Main app file to run the application
library(shiny)
library(ggplot2)
library(DT)

# Source the UI and Server files
source("main_ui.R")
source("main_server.R")

# Run the app
shinyApp(ui = ui, server = server)