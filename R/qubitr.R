#' qubitr: Analyse Results from the Clariostar Qubit Assay
#'
#' @section Example analysis:
#'
#' \preformatted{
#' rename <- c("plate_row",
#' "plate_col",
#' "content",
#' "raw_fl",
#' "average_fl")
#'
#' raw_data <- fread("my_clariostar_data.csv",
#'                   skip = 11,
#'                   select = c(1:4, 6),
#'                   col.names = rename)
#'
#' # where is everything?
#' raw_data[grep("^Standard", content)]
#' raw_data[grep("^Blank", content)]
#'
#' # add volumes
#' AddVolumes(raw_data, "A1", "D5", 1, 50)   # side effects!
#' AddVolumes(raw_data, "A6", "H6", 1, 50)
#' AddVolumes(raw_data, "A7", "H11", 10, 800) # side effects!
#' AddVolumes(raw_data, "E5", "H5", 10, 800)
#'
#' # subtract background
#' background_subtracted <- SubtractBackground(raw_data, c("A12", "B12"))
#'
#' # run the linear model
#' standard_wells <- data.table(well = paste0(LETTERS[3:8], 12),
#'                              amount = c(rep(10, 3), rep(100, 3)))
#' calculated_amounts <- CalculateAmounts(background_subtracted, standard_wells)
#'
#' # get the results
#' final_results <- ExtractResults(calculated_amounts)
#' }
#'
#' @docType package
#' @name qubitr
NULL
