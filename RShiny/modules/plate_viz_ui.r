# Plate Visualization Module UI
# This function defines the UI for visualizing plate data, including controls for dataset, threshold, and timepoint selection.

plate_viz_ui <- function(id) {
  ns <- NS(id)
  
  sidebarLayout(
    sidebarPanel(
      h4("Visualization Controls"),
      # Show controls only if data is uploaded
      conditionalPanel(
        condition = paste0("output['", ns("dataUploaded"), "']"),
        # Dropdown to select dataset
        selectInput(ns("vizDataset"), "Select Dataset:", choices = NULL),
        # Slider to set value threshold
        sliderInput(ns("threshold"), "Value Threshold:", 
                    min = 0, max = 200, value = 100, step = 0.01),
        # Slider to select timepoint
        sliderInput(ns("timepoint"), "Select Timepoint:", 
                    min = 0, max = 10, value = 5, step = 1),
        br(), br(),
        # Button to download the plot
        downloadButton(ns("downloadPlot"), "Download Plot", class = "btn-secondary")
      ),
      # Message if no data is uploaded
      conditionalPanel(
        condition = paste0("!output['", ns("dataUploaded"), "']"),
        p("Please upload data in the Datasets tab first.")
      )
    ),
    mainPanel(
      # Show plot if data is uploaded
      conditionalPanel(
        condition = paste0("output['", ns("dataUploaded"), "']"),
        plotOutput(ns("plateplot"), height = "500px")
      ),
      # Message if no data is uploaded
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