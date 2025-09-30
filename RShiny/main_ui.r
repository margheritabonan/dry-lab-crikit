# Source module UI files
source("modules/about_ui.R")
source("modules/datasets_ui.R")
source("modules/plate_viz_ui.R")
source("modules/time_analysis_ui.R")

# Main UI
ui <- navbarPage(
  title = tags$img(src = "Images/CRIKIT_logo_transparant.png", height = "40px", alt = "crikit Logo"),
  theme = bslib::bs_theme(version = 4),

  # Add custom CSS
  includeCSS("www/styles.css"),

  # Tab 1: About Module
  tabPanel("About", about_ui("about")),
  
  # Tab 2: Datasets Module
  tabPanel("Datasets", datasets_ui("datasets")),
  
  # Tab 3: Plate Visualization Module
  tabPanel("Plate Visualization", plate_viz_ui("plate_viz")),
  
  # Tab 4: Time analysis Module
  tabPanel("Time analysis", time_analysis_ui("time_analysis"))
)