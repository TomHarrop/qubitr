#' AddVolumes
#'
#' Add the volume added to the Qubit reaction and the original sample volume to
#' the raw data. Assumes plates were used in a "vertical" layout, \emph{e.g.}
#' with an 8-channel pipette.
#'
#' @param raw_data A \code{data.table} of raw Clariostar readings.
#' @param start_well The first well in the series
#' @param stop_well The last well in the series
#' @param volume_added The volume of sample added to the Qubit reaction for
#'   wells in this series
#' @param sample_volume The original sample volume for wells in this series (for
#'   amount calculations)
#' @return \strong{Modifies the \code{raw_data} \code{data.table}} by adding
#'   \code{volume_added} and \code{sample_volume} to the specified wells.
#'
#' @import data.table
#'
#' @export

AddVolumes <- function(raw_data,
                       start_well,
                       stop_well,
                       volume_added,
                       sample_volume){
    # this has side effects!
    a <- SplitWellName(start_well)$plate_row
    b <- SplitWellName(start_well)$plate_col
    c <- SplitWellName(stop_well)$plate_row
    d <- SplitWellName(stop_well)$plate_col

    my_volume_added <- volume_added
    my_sample_volume <- sample_volume

    # vector of acceptable wells
    all_wells <- paste0(LETTERS[1:8], rep(c(1:12), each = 8))
    all_from <- which(all_wells == paste0(a, b))
    all_to <- which(all_wells == paste0(c, d))

    raw_data[paste0(plate_row, plate_col) %in% all_wells[all_from:all_to],
             volume_added := my_volume_added]
    raw_data[paste0(plate_row, plate_col) %in% all_wells[all_from:all_to],
             sample_volume := my_sample_volume]
}
