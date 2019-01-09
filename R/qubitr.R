#' qubitr: Analyse Results from the Clariostar Qubit Assay
#'
#' @section Example analysis:
#'
#' \preformatted{
#' library(data.table)
#' library(qubitr)
#'
#' load the raw data. You'll need columns called `plate_row`, `plate_col` and
#' `raw_fl` for the analysis. `content` helps you find the blank and standard
#' wells.
#' rename <- c("plate_row",
#'             "plate_col",
#'             "content",
#'             "raw_fl")
#'
#' # this command will be different for different input files, especially the
#' # `skip` argument.
#' raw_data <- fread("my_clariostar_data.csv",
#'                   skip = 11,
#'                   select = c(1:4),
#'                   col.names = rename)
#'
#' # make sure it looks OK
#' head(raw_data)
#'
#' # where are the standards?
#' raw_data[grep("^Standard", content)]
#'
#' # where are the blanks?
#' raw_data[grep("^Blank", content)]
#'
#' # add volumes (**SIDE EFFECTS**: this modifies `raw_data`)
#' AddVolumes(raw_data, "A1", "D5", 1, 50)
#' AddVolumes(raw_data, "A6", "H6", 1, 50)
#' AddVolumes(raw_data, "A7", "H11", 10, 800)
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
#'
#' head(final_results)
#' }
#'
#' @docType package
#' @name qubitr
NULL
