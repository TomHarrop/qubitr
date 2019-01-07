#' SplitWellName
#'
#' Split a well name into rows and columns
#'
#' @param well_name A well name, \emph{e.g.} "A1", "B12"
#' @return Returns a `data.table` of `plate_row` and `plate_col`
#'
#' @import data.table
#'

SplitWellName <- function(well_name) {
    my_row <- gsub("[^[:upper:]]", "", well_name)
    my_col <- as.numeric(gsub("[[:upper:]]", "", well_name))
    if(min(length(my_row[!is.na(my_row)]),
           length(my_col[!is.na(my_col)])) < 1){
        stop(paste("Couldn't parse well name", well_name))
    }
    return(data.table(plate_row = my_row, plate_col = my_col))
}
