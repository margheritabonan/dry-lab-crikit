# About Module UI
# This function defines the UI for the "About" section of the app,
# providing an overview, features, instructions, and data format information.

about_ui <- function(id) {
  ns <- NS(id)
  
  fluidRow(
    column(12,
           # App welcome header
           h2("Welcome to the CRIKIT data anaylsis software"),
           br(),
           div(
             # Overview section
             h3("Overview"),
             p("This is a comprehensive tool for analyzing well plate data from fluorescence assays. 
               The application provides multiple analysis modules to help you understand your experimental results."),
             
             # Features list
             h3("Features"),
             tags$ul(
               tags$li("Upload and manage multiple datasets (CSV, TSV, TXT, or Tecan SparkControl Excel files)"),
               tags$li("Automatic delimiter and format detection for delimited files"),
               tags$li("Interactive well plate visualization with thresholding and timepoint selection"),
               tags$li("Time series analysis for individual wells with customizable threshold lines"),
               tags$li("Data preview and summary for uploaded datasets"),
               tags$li("Downloadable plots for publication or further analysis"),
               tags$li("Customizable thresholds and visualization parameters")
             ),
             
             # Getting started instructions
             h3("Getting Started"),
             tags$ol(
               tags$li("Navigate to the 'Datasets' tab to upload your fluorescence data (CSV, TSV, TXT, or Tecan SparkControl Excel)."),
               tags$li("Preview your data and select the dataset to analyze."),
               tags$li("Use the 'Plate Visualization' tab to explore well plate data interactively, set thresholds, and select timepoints."),
               tags$li("Use the 'Time analysis' tab to view time series for individual wells and set visualization thresholds."),
               tags$li("Download plots for your records or publications using the download buttons.")
             ),
             
             # Data format requirements
             h3("Data Format"),
             p("We support raw datasets from Tecan SparkControl and delimited text files which must contain the following columns:"),
             tags$ul(
               tags$li(strong("Delimited files (CSV, TSV, TXT):"), " Should contain columns for 'Cycle Nr.' (required), 'Time' (optional), and wells named 'A1' to 'H12' (for 96-well plates)."),
               tags$li(strong("Tecan SparkControl files:"), " Upload the raw Excel export; the app will parse the relevant data automatically."),
               tags$li(strong("Auto-detection:"), " The app will attempt to detect delimiters and decimal formats automatically.")
             ),
             
             # Installation instructions
             h3("Installation"),
             tags$ol(
               tags$li("Install R (version 4.0 or higher) from https://cran.r-project.org/"),
               tags$li("Install required R packages in your R console:"),
               tags$ul(
                 tags$li("install.packages(c('shiny', 'ggplot2', 'DT', 'bslib', 'tidyr', 'reshape2', 'readxl', 'readr', 'tools', 'stringr'))"),
                 tags$li("Optional for advanced analysis: install.packages('QurvE')")
               ),
               tags$li("Clone the repository from GitLab:"),
               tags$ul(
                 tags$li("git clone https://gitlab.igem.org/2025/software-tools/groningen.git"),
                 tags$li("cd groningen/RShiny")
               ),
               tags$li("Run the application from the RShiny directory:"),
               tags$ul(
                 tags$li("Rscript app_runner.r"),
                 tags$li("Or, in R console: setwd('path/to/groningen/RShiny'); source('app_runner.r')")
               )
             ),
             
             # Disclaimer note
             h3("Note"),
             p("This webtool is intended for research use only and is not intended for clinical decision-making."),
  
             br(),
             # Info alert for users
             div(class = "alert alert-info",
                 strong("Tip:"), " For more information, visit our ",
                 a(href = "https://2025.igem.wiki/groningen/", "team wiki"),
                 " or contact us at ",
                 a(href = "mailto:igemteam@rug.nl", "igemteam@rug.nl"),
                 "."
             )
           )
    )
  )
}