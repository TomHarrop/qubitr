#' SubtractBackground
#'
#' Subtract the mean of the background readings from the rest of the data
#'
#' @param raw_data A \code{data.table} of raw Clariostar readings. Must have a
#'   column called \code{raw_fl}. The mean background readings will be
#'   subtracted from values in the raw_fl column
#' @param blank_wells A character vector of column names which were blanks,
#'   \emph{e.g.} \code{c("A1", "B1")}
#' @return Returns a \code{data.table} of \code{raw_data}, with and additional
#'   column called \code{background_subtracted} containing the \code{raw_fl}
#'   minus the mean of \code{blank_wells}
#'
#' @import data.table
#'
#' @export

SubtractBackground <- function(raw_data, blank_wells) {
    my_data <- copy(raw_data)
    if(!"raw_fl" %in% names(my_data)){
        stop("raw_data must have a column called raw_fl")
    }

    blanks <- SplitWellName(blank_wells)
    bg_reading <- my_data[blanks, mean(raw_fl), on = .(plate_row, plate_col)]

    my_data[, background_subtracted := raw_fl - bg_reading]
    return(my_data)
}
