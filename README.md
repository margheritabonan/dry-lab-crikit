# Team Groningen 2025 Software Tool

The CRIKIT web tool is an interactive Shiny web application for the analysis and visualization of well plate fluorescence data, specifically designed for CRISPR-Cas13-based antibiotic resistance detection assays. 


## Description
CRIKIT is a modular, user-friendly RShiny application developed by Team Groningen 2025 for iGEM. It enables rapid, reproducible analysis of fluorescence data from 96-well plate assays, with a focus on CRISPR-Cas13-based diagnostics. The app supports multiple data formats, interactive visualizations, and a streamlined workflow from data upload to result interpretation.

For more information about our project, visit our [team wiki](https://2025.igem.wiki/groningen/).

## Features

- **Upload and manage multiple datasets** (CSV, TSV, TXT, or Tecan SparkControl Excel files)
- **Interactive well plate visualization** with thresholding and timepoint selection
- **Time series analysis** for individual wells with customizable threshold lines
- **Downloadable plots** for publication or further analysis
- **User-friendly interface** with modular design
- **Support for raw Tecan SparkControl data** (Excel export)
- **Customizable thresholds and visualization parameters**



## Getting Started

### Requirements

- **R** version 4.0 or higher
- R packages: `shiny`, `ggplot2`, `DT`, `bslib`, `tidyr`, `reshape2`, `readxl`, `readr`, `tools`, `stringr`
- (Optional, for advanced analysis) `QurvE`

### Installation

1. **Clone the repository**
    ```sh
    git clone https://gitlab.com/your-team/dry-lab-crikit.git
    cd dry-lab-crikit/RShiny
    ```

2. **Install required R packages**  
   In your R console:
    ```r
    install.packages(c("shiny", "ggplot2", "DT", "bslib", "tidyr", "reshape2", "readxl", "readr", "tools", "stringr"))
    # Optional for advanced analysis:
    install.packages("QurvE")
    ```

3. **Run the application**
    - From the `RShiny` directory:
      ```sh
      Rscript app_runner.r
      ```
    - Or, in an R console:
      ```r
      setwd("path/to/RShiny")
      source("app_runner.r")
      ```

The app will open in your default web browser. If not, copy the URL from the terminal and open it manually.

---


## Usage

1. **Upload Data:** Go to the "Datasets" tab and upload your fluorescence data (CSV, TSV, TXT, or Tecan SparkControl Excel).
2. **Preview Data:** View a summary and preview of your uploaded datasets.
3. **Plate Visualization:** Use the "Plate Visualization" tab to explore well plate data interactively, set thresholds, and select timepoints.
4. **Time Analysis:** In the "Time analysis" tab, select a well to view its fluorescence over time and set a threshold for visualization.
5. **Download Plots:** Download any visualization for your records or publications.

---

### Data Format

- **Delimited files:** Should contain columns for `Cycle Nr.` (required), `Time` (optional), and wells named `A1` to `H12` (for 96-well plates).
- **Tecan SparkControl files:** Upload the raw Excel export; the app will parse the relevant data.
- **Auto-detection:** The app will attempt to detect delimiters and decimal formats automatically.

---

## Contributing
We welcome contributions! Please open an issue or submit a pull request. For major changes, please discuss them first via an issue.

**To get started:**
- Fork the repository
- Create a new branch (`git checkout -b feature/your-feature`)
- Commit your changes
- Push to your branch and open a pull request

---

## Authors and acknowledgment

Developed by Team Groningen 2025 for iGEM.

**Authors:**  
Yaprak Yigit, Margherita Bonan, Daniël Kassab, ...

**Connect with us:**  
- [Email](mailto:igemteam@rug.nl)
- [Team Wiki](https://2025.igem.wiki/groningen/)
- [LinkedIn](https://www.linkedin.com/in/igem-groningen/)
- [Instagram](https://www.instagram.com/igem_groningen/)

Special thanks to all contributors and advisors.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---