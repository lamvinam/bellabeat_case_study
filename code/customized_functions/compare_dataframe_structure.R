# Load necessary libraries: n/a


# This function compares the column names and data types of two data frames.
# It checks if the data frames have the exact same columns in the same order,
# and if the data types within those corresponding columns are also the same.
#
# Args:
#   df1: The first data frame to compare.
#   df2: The second data frame to compare.
#
# Returns:
#   TRUE if both column names and data types are identical (in order),
#   FALSE otherwise.
#   Stops with an error message if either input is not a data frame.

compare_dataframe_structure <- function(df1, df2) {
  # Check if both inputs are data frames
  if (!is.data.frame(df1) || !is.data.frame(df2)) {
    stop("Both inputs must be data frames.")
  }
  
  # 1. Compare column names (checks names, order, and number of columns)
  col_names_identical <- identical(colnames(df1), colnames(df2))
  
  # If column names are not identical, the structures are different,
  # so we can stop here and return FALSE.
  if (!col_names_identical) {
    message("Column names are NOT identical.")
    return(FALSE)
  }
  
  # 2. If column names ARE identical, compare the column data types (classes)
  col_types_identical <- identical(sapply(df1, class), sapply(df2, class))
  
  # Message to indicate result of type comparison
  if (!col_types_identical) {
    message("Column names ARE identical, but data types are NOT identical.")
  } else {
    message("Column names and data types ARE identical.")
  }
  
  
  # Return the result of the type comparison (which is only reached if names matched)
  return(col_types_identical)
}