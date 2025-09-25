# Source module server files
source("modules/about_server.R")
source("modules/datasets_server.R")
source("modules/plate_viz_server.R")
source("modules/time_analysis_server.R")

# Main Server
server <- function(input, output, session) {
  
  # Store uploaded datasets
  datasets <- reactiveValues()
  
  # Call module servers
  about_server("about")
  datasets_return <- datasets_server("datasets", datasets)
  plate_viz_server("plate_viz", datasets)
  time_analysis_server("time_analysis", datasets)
  
}