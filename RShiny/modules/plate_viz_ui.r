# Plate Visualization Module UI
plate_viz_ui <- function(id) {
  ns <- NS(id)
  
  sidebarLayout(
    sidebarPanel(
      h4("Visualization Controls"),
      conditionalPanel(
        condition = paste0("output['", ns("dataUploaded"), "']"),
        selectInput(ns("vizDataset"), "Select Dataset:", choices = NULL),
        sliderInput(ns("threshold"), "Value Threshold:", 
                    min = 0, max = 200, value = 100, step = 0.01),
        sliderInput(ns("timepoint"), "Select Timepoint:", 
                    min = 0, max = 10, value = 5, step = 1),
        br(), br(),
        downloadButton(ns("downloadPlot"), "Download Plot", class = "btn-secondary")
      ),
      conditionalPanel(
        condition = paste0("!output['", ns("dataUploaded"), "']"),
        p("Please upload data in the Datasets tab first.")
      )
    ),
    mainPanel(
      conditionalPanel(
        condition = paste0("output['", ns("dataUploaded"), "']"),
        plotOutput(ns("plateplot"), height = "500px")
      ),
      conditionalPanel(
        condition = paste0("!output['", ns("dataUploaded"), "']"),
        div(class = "text-center",
            h4("No data available"),
            p("Upload data in the Datasets tab to view plate visualization.")
        )
      )
    )
  )
}