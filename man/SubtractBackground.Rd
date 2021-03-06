% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SubtractBackground.R
\name{SubtractBackground}
\alias{SubtractBackground}
\title{SubtractBackground}
\usage{
SubtractBackground(raw_data, blank_wells)
}
\arguments{
\item{raw_data}{A \code{data.table} of raw Clariostar readings. Must have a
column called \code{raw_fl}. The mean background readings will be
subtracted from values in the raw_fl column}

\item{blank_wells}{A character vector of column names which were blanks,
\emph{e.g.} \code{c("A1", "B1")}}
}
\value{
Returns a \code{data.table} of \code{raw_data}, with and additional
  column called \code{background_subtracted} containing the \code{raw_fl}
  minus the mean of \code{blank_wells}
}
\description{
Subtract the mean of the background readings from the rest of the data
}
