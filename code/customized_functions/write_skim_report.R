# --- Function to Skim List and Save to CSV with Source Column ---

# Ensure you have skimr, purrr, readr, and dplyr installed and loaded
# install.packages("skimr")
# install.packages("purrr") # purrr is part of the tidyverse
# install.packages("readr") # readr is part of the tidyverse
# install.packages("dplyr") # dplyr is part of the tidyverse

library(skimr)
library(purrr)
library(readr)
library(dplyr)

#' Applies skim() to each data frame in a list, adds a source column,
#' and saves the combined output to a CSV file.
#'
#' The combined output will include a 'source_table' column identifying the
#' original data frame name from the input list.
#'
#' @param list_of_tables A named list where each element is a data frame. The names
#'   of the list elements will be used for the 'source_table' column.
#' @param output_path The file path (including filename and .csv extension) where the
#'   combined skim output will be saved.
#' @return The path to the output file if successful, or stops with an error if
#'   input is invalid or writing fails.
write_skim_report <- function(list_of_tables, output_path) {
  
  # Input Validation
  if (!is.list(list_of_tables)) {
    stop("Input 'list_of_tables' must be a list.")
  }
  
  if (length(list_of_tables) == 0) {
    message("Input list is empty. No data frames to skim.")
    # Optionally create an empty file with just the column names
    # readr::write_csv(data.frame(source_table = character(), t(skimr::skim(data.frame()))[0,]), output_path) # More complex empty structure
    return(output_path)
  }
  
  # Ensure the list is named; otherwise, the source_table column will be indices
  if (is.null(names(list_of_tables))) {
    message("Input list is not named. Using indices as source_table names.")
    names(list_of_tables) <- seq_along(list_of_tables)
  }
  
  
  message("Applying skim() to each data frame and adding source column...")
  # Use purrr::imap to iterate with both element (.x) and its name (.y)
  skim_outputs_list_with_source <- purrr::imap(list_of_tables, function(.x, .y) {
    # Apply skim to the current data frame
    skim_output <- skimr::skim(.x)
    
    # Add the 'source_table' column with the list item's name
    # Use dplyr::mutate to add the column
    skim_output_with_source <- dplyr::mutate(skim_output, source_table = .y)
    
    # Rearrange columns to make 'source_table' the first column
    skim_output_ordered <- dplyr::select(skim_output_with_source, source_table, dplyr::everything())
    
    return(skim_output_ordered)
  })
  
  # Combine the list of modified skim outputs into a single data frame
  message("Combining skim outputs...")
  combined_skim_df <- purrr::list_rbind(skim_outputs_list_with_source)
  
  # Write the combined data frame to a CSV file
  message("Writing combined skim output to: ", output_path)
  readr::write_csv(combined_skim_df, output_path)
  
  message("Successfully saved combined skim output.")
  
  # Return the output path on success
  return(output_path)
}

# --- Example Usage ---
# Assuming you have 'list_of_tables' (a NAMED list of data frames)
# Example:
# df1 <- data.frame(colA = 1:10, colB = rnorm(10))
# df2 <- data.frame(colX = letters[1:5], colY = c(TRUE, FALSE, NA, TRUE, FALSE))
# list_of_tables_example <- list(MyDataFrame1 = df1, AnotherTable = df2)

# Load libraries first if not already loaded
# library(skimr)
# library(purrr)
# library(readr)
# library(dplyr)

# Define where you want to save the output
# output_file_with_source <- "combined_skim_report_with_source.csv"

# Run the function
# write_skim_report(list_of_tables_example, output_file_with_source)

# Check the generated CSV file - it should have 'source_table' as the first column.