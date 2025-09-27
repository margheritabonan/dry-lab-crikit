# About Module UI
# This function defines the UI for the "About" section of the app,
# providing an overview, features, instructions, and data format information.

about_ui <- function(id) {
  ns <- NS(id)
  
  fluidRow(
    column(12,
           # App welcome header
           h2("Welcome to the CRIKIT data anaylsis software (We need to give it a name)"),
           br(),
           div(
             # Overview section
             h3("Overview"),
             p(".... is a comprehensive tool for analyzing well plate data from fluorescence assays. 
               This application provides multiple analysis modules to help you understand your experimental results."),
             
             # Features list
             h3("Features"),
             tags$ul(
               tags$li("Upload and manage multiple datasets"),
               tags$li("Interactive well plate visualization")
             ),
             
             # Getting started instructions
             h3("Getting Started"),
             tags$ol(
               tags$li("Navigate to the 'Datasets' tab to upload your fluorescence data"),
               tags$li("Use the analysis tabs to explore your data"),
             ),
             
             # Data format requirements
             h3("Data Format"),
             p("We support raw datasets from Tecan SparkControl and delimited text files which must contain the following columns:"),
             p("(update this later)"),
             tags$ul(
               tags$li(strong("Cycle Nr.:"), " The PCR cycle"),
               tags$li(strong("Time:"), " Time point (optional)"),
               tags$li(strong("A1-H12:"), "The wells of a 96 well plate")
             ),
             
             # Disclaimer note
             h3("Note"),
             p("This webtool is not meant for decision taking for treatment, it only serves as additional support."),
  
             br(),
             # Info alert for users
             div(class = "alert alert-info",
                 strong("Note:"), " Make sure your data follows the expected format for optimal results."
             )
           )
    )
  )
}