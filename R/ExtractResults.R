#' ExtractResults
#'
#' Convenience function for calculating the original concentration and total
#' amount from the results from \code{\link{CalculateAmounts}}
#'
#' @param calculated_amounts A \code{data.table} output from
#'   \code{\link{CalculateAmounts}}
#' @return A \code{data.table} with calculated_concentration and sample_volume
#'
#' @import data.table
#'
#' @export

ExtractResults <- function(calculated_amounts){
    my_data <- copy(calculated_amounts)
    my_data[!is.na(volume_added) & !is.na(sample_volume),
            calculated_concentration := calculated_amount / volume_added]
    my_data[!is.na(volume_added) & !is.na(sample_volume),
            total_amount := calculated_concentration * sample_volume]
    final_results <- my_data[!is.na(volume_added) & !is.na(sample_volume)]
    setorder(final_results, plate_col, plate_row)
    return(final_results[, .(plate_col,
                             plate_row,
                             volume_added,
                             calculated_concentration,
                             sample_volume,
                             total_amount)])
}

