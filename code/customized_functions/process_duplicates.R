# Load necessary libraries
library(dplyr)
library(purrr) # For map and walk functions (optional but clean)

# --- Function to process duplicates and export cleaned data frames ---
#' Processes a list of data frames or tibbles to detect and remove duplicates,
#' and exports the cleaned data frames to a specified directory.
#'
#' For each data frame in the list, it reports the number of duplicates found.
#' If duplicates exist, it removes them and reports the number of rows remaining.
#' If no duplicates are found, it reports that and keeps the original data frame.
#' The cleaned data frames are then saved as CSV files in the specified output directory.
#'
#' @param list_of_data A list where each element is a data frame or tibble.
#' @param output_dir A character string specifying the directory where cleaned CSV files will be saved.
#'                   The directory will be created if it does not exist.
#' @return A list of data frames/tibbles with duplicates removed where found.
process_list <- function(list_of_data, output_dir) {
  # Check if the input is a list
  if (!is.list(list_of_data)) {
    stop("Input must be a list of data frames or tibbles.")
  }
  
  # Check if output_dir is provided and is a character string
  if (missing(output_dir) || !is.character(output_dir) || length(output_dir) != 1) {
    stop("An output directory path (character string) must be provided.")
  }
  
  # Create the output directory if it doesn't exist
  if (!dir.exists(output_dir)) {
    cat(paste("Creating output directory:", output_dir, "\n"))
    dir.create(output_dir, recursive = TRUE) # recursive = TRUE allows creating parent directories
  }
  
  cleaned_list <- list() # Initialize an empty list to store cleaned data frames
  
  # Iterate through each item in the list
  for (i in seq_along(list_of_data)) {
    current_data <- list_of_data[[i]]
    data_name <- names(list_of_data)[i] # Get the name of the list element (if available)
    if (is.null(data_name) || data_name == "") {
      data_name <- paste("Item", i) # Use index if no name is available
    }
    
    # Check if the current item is a data frame or tibble
    if (!is.data.frame(current_data)) {
      warning(paste("Skipping", data_name, "as it is not a data frame or tibble."))
      cleaned_list[[data_name]] <- current_data # Keep non-data frame items as they are
      next # Move to the next item in the loop
    }
    
    initial_rows <- nrow(current_data)
    
    # Detect duplicates
    duplicate_rows_logical <- duplicated(current_data)
    num_duplicates <- sum(duplicate_rows_logical)
    
    # Announce the number of duplicates found
    cat(paste("--- Processing:", data_name, "---\n"))
    cat(paste("Found", num_duplicates, "potential duplicate row(s) in", data_name, ".\n"))
    
    # --- Conditional Removal ---
    if (num_duplicates > 0) {
      # Remove duplicates only if they exist
      cleaned_data <- current_data %>%
        distinct()
      
      rows_after_cleaning <- nrow(cleaned_data)
      rows_removed <- initial_rows - rows_after_cleaning
      
      # Announce that duplicates have been removed
      cat(paste("Removed", rows_removed, "duplicate row(s) from", data_name, ".\n"))
      cat(paste("Remaining rows in", data_name, ":", rows_after_cleaning, ".\n"))
      
    } else {
      # If no duplicates, keep the original data and announce
      cleaned_data <- current_data # No duplicates, so the cleaned data is the original data
      rows_after_cleaning <- initial_rows # Number of rows remains the same
      
      cat(paste("No duplicates found. Data for", data_name, "remains unchanged.\n"))
      cat(paste("Total rows in", data_name, ":", rows_after_cleaning, ".\n"))
    }
    cat("---\n") # Separator for clarity
    
    # Store the cleaned data frame in the result list
    cleaned_list[[data_name]] <- cleaned_data
    
    # --- Write the cleaned data frame to a CSV file in the specified directory ---
    # Construct the full file path
    file_name <- paste0("cleaned_", data_name, ".csv")
    full_file_path <- file.path(output_dir, file_name) # Use file.path for cross-platform compatibility
    
    # Write the data frame to CSV
    write.csv(cleaned_data, file = full_file_path, row.names = FALSE)
    cat(paste("Saved cleaned data for", data_name, " to:", full_file_path, "\n\n")) # Announce file saving
  }
  
  # Return the list of cleaned data frames
  return(cleaned_list)
}

# --- Sample Usage ---

# Define the output directory path
## my_output_directory <- "cleaned_data_output" # You can change this path

# --- Process the list and save files using the modified function ---
# The function will print messages and save files as it processes
## cleaned_data_list_output <- process_list(sample_list_of_data_mixed, my_output_directory)

# The cleaned data frames are also returned as a list, which you can access like:
# print(cleaned_data_list_output$dataset_A)
