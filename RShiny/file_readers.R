library(readxl)
library(readr)
library(tools)
library(stringr)

# ------------------------- Read formatted datasets ----------------------------

read_preprocessed_file <- function(input_file) {
  # Check if file exists
  if (!file.exists(input_file)) {
    stop(paste("File does not exist:", input_file))
  }
  
  # Get file extension
  file_ext <- tolower(tools::file_ext(input_file))
  
  # Read based on file type
  if (file_ext %in% c("xlsx", "xls")) {
    # Excel files
    df <- read_excel(input_file)
  } else if (file_ext == "csv") {
    # For CSV files, detect delimiter and decimal format
    sample_lines <- readLines(input_file, n = 5)
    sample_text <- paste(sample_lines, collapse = "\n")
    
    semicolon_count <- stringr::str_count(sample_text, ";")
    comma_count <- stringr::str_count(sample_text, ",")
    
    # Detect if commas are used as decimal separators or delimiters
    # If we see patterns like "123,45" (European decimals), commas are likely decimal separators
    european_decimal_pattern <- stringr::str_detect(sample_text, "\\d+,\\d+")
    
    if (semicolon_count > 0 && (european_decimal_pattern || semicolon_count >= comma_count)) {
      # European format: semicolon-delimited with comma decimal separators
      df <- read_delim(input_file, delim = ";", show_col_types = FALSE, 
                       locale = locale(decimal_mark = ",", grouping_mark = "."), 
                       quote = "\"")
    } else {
      # American format: comma-delimited with period decimal separators
      df <- read_csv(input_file, show_col_types = FALSE, 
                     locale = locale(decimal_mark = ".", grouping_mark = ","))
    }
  } else if (file_ext %in% c("tsv", "txt")) {
    # Tab-separated or text files
    df <- read_tsv(input_file, show_col_types = FALSE)
  } else {
    # For unknown extensions, try to guess the delimiter
    # Read first few lines to guess delimiter
    sample_lines <- readLines(input_file, n = 5)
    
    # Count occurrences of common delimiters
    delim_counts <- c(
      "," = sum(stringr::str_count(sample_lines, ",")),
      "\t" = sum(stringr::str_count(sample_lines, "\t")),
      ";" = sum(stringr::str_count(sample_lines, ";")),
      "|" = sum(stringr::str_count(sample_lines, "\\|"))
    )
    
    # Use the most common delimiter
    best_delim <- names(which.max(delim_counts))
    
    # Detect decimal format for unknown file types
    sample_text <- paste(sample_lines, collapse = "\n")
    european_decimal <- stringr::str_detect(sample_text, "\\d+,\\d+")
    
    if (best_delim == ",") {
      df <- read_csv(input_file, show_col_types = FALSE,
                     locale = locale(decimal_mark = ".", grouping_mark = ","))
    } else if (best_delim == "\t") {
      decimal_mark <- if(european_decimal) "," else "."
      grouping_mark <- if(european_decimal) "." else ","
      df <- read_tsv(input_file, show_col_types = FALSE,
                     locale = locale(decimal_mark = decimal_mark, grouping_mark = grouping_mark))
    } else {
      decimal_mark <- if(european_decimal) "," else "."
      grouping_mark <- if(european_decimal) "." else ","
      df <- read_delim(input_file, delim = best_delim, show_col_types = FALSE,
                       locale = locale(decimal_mark = decimal_mark, grouping_mark = grouping_mark),
                       quote = "\"")
    }
  }
  
  return(df)
}
  
  
# ------------------------- Read raw datasets ----------------------------------


# Read Tecan SparkControl data
read_sparkcontrol_file <- function(input_file, sheet = 1) {
  # Check if file exists
  if (!file.exists(input_file)) {
    stop(paste("File does not exist:", input_file))
  }
  
  # Read raw excel sheet without headers
  raw <- read_excel(input_file, sheet = sheet, col_names = FALSE)
  
  # Find the starting point of the data
  start_row <- which(raw[[1]] == "Cycle Nr.")
  if (length(start_row) == 0) stop("Could not find 'Cycle Nr.' in file.")
  
  # Find where "End Time" appears
  end_row <- which(raw[[1]] == "End Time")
  if (length(end_row) == 0) {
    # fallback: last non-empty row
    end_row <- max(which(!is.na(raw[[1]])))
  }
  
  # Number of rows to read (exclusive of End Time row)
  nrows <- (end_row - start_row) - 1
  
  # Read again with proper headers, limited to nrows
  df <- read_excel(input_file,
                   sheet = sheet,
                   skip = start_row - 1,
                   n_max = nrows)

  # Delete empty columns
  df <- df[, colSums(df != "" & !is.na(df)) > 0]
  return(df)
}

# ------------------------- Testing --------------------------------------------

# Debug function to see what's happening
debug_file <- function(input_file) {
  cat("File exists:", file.exists(input_file), "\n")
  cat("File extension:", tools::file_ext(input_file), "\n")
  
  # Read first few lines
  first_lines <- readLines(input_file, n = 5)
  cat("First 5 lines:\n")
  for(i in 1:length(first_lines)) {
    cat("Line", i, ":", first_lines[i], "\n")
  }
  
  # Check delimiter counts
  sample_text <- paste(first_lines, collapse = "\n")
  cat("\nDelimiter counts:\n")
  cat("Semicolons:", stringr::str_count(sample_text, ";"), "\n")
  cat("Commas:", stringr::str_count(sample_text, ","), "\n")
  cat("Tabs:", stringr::str_count(sample_text, "\t"), "\n")
}

# Example usage:
#df <- read_sparkcontrol_file("Datasets/spark_control_example.xlsx")
df2 <-  read_preprocessed_file("Datasets/simple_example.csv")
