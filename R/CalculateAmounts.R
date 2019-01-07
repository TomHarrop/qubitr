#' CalculateAmounts
#'
#' Use the \code{background_subtracted} fluorescence values to make a \code{lm}
#' from the \code{standard_wells} and \code{predict} the amounts in the other
#' wells.
#'
#' @param background_subtracted A \code{data.table} of background-subtracted
#'   Clariostar readings. Must have a column called
#'   \code{background_subtracted}.
#' @param standard_wells A \code{data.table} of standards with the columns
#'   \code{well} and \code{amount}, \emph{e.g.}
#'   \preformatted{data.table(well = paste0(LETTERS[3:8], 5),
#'              amount = c(rep(10, 3), rep(100, 3)))}
#'       \tabular{lrr}{ \tab well \tab amount \cr
#'                 1: \tab C5 \tab 10 \cr
#'                 2: \tab D5 \tab 10 \cr
#'                 3: \tab E5 \tab 10 \cr
#'                 4: \tab F5 \tab 100 \cr
#'                 5: \tab G5 \tab 100 \cr
#'                 6: \tab H5 \tab 100 \cr}
#' @return Returns a \code{data.table} of with an additional column called
#'   \code{calculated_amount} containing the result of \code{predict} on the
#'   \code{background_subtracted} values using the \code{lm} from the standards
#'
#' @import data.table
#'
#' @export

CalculateAmounts <- function(background_subtracted, standard_wells){
    if(!"background_subtracted" %in% names(background_subtracted)){
        stop("background_subtracted must have a column called background_subtracted")
    }
    my_data <- copy(background_subtracted)
    my_standards <- copy(standard_wells)
    my_standards[, c("plate_row", "plate_col") := SplitWellName(well)]
    # get the readings for the standards
    control_data <- my_data[my_standards,
                            .(plate_row,
                              plate_col,
                              background_subtracted,
                              amount),
                            on = .(plate_row, plate_col)]
    # run the lm
    control_lm <- lm(amount + 0 ~ background_subtracted + 0, control_data)
    # calculate all amounts
    calculated_amount <- predict(control_lm, newdata = my_data)
    calculated_amounts <- cbind(my_data, calculated_amount)
    # return merged table
    merge(calculated_amounts,
          control_data[, .(plate_row,
                           plate_col,
                           amount_standard = amount)],
          by = c("plate_row", "plate_col"),
          all.x = TRUE)
}
