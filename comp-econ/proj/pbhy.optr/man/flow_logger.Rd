% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flow.R
\name{flow_logger}
\alias{flow_logger}
\title{Flow Logger Constructor}
\usage{
flow_logger(
  formulas_list = list(list(t ~ paste("=> Iter:", .m), mean(f) ~ paste("mean(f):",
    round(.m, 4)))),
  log_each = 1,
  sep = " -- ",
  args_alert = list(),
  args_ul = list()
)
}
\arguments{
\item{formulas_list}{A list of \code{formulas} as in \code{\link[=flow_stopper]{flow_stopper()}} (a list of
lists), except the RHS to be a function that takes the LHS value \code{.m} and
returns a single string to be printed.}

\item{log_each}{An integer specifying the frequency of logging.}

\item{sep}{A character string used to concatenate logs associated with a list
inside \code{formulas_list}.}

\item{args_alert, args_ul}{A list of arguments passed to \code{\link[cli:cli_alert]{cli::cli_alert()}}
and \code{\link[cli:cli_ul]{cli::cli_ul()}}, the functions that format the console output.}
}
\value{
A \code{"flow_logger"}-class object to be passed to \code{optimize_pbhy()}.
}
\description{
\loadmathjax{}

This function creates a flow logger object that calculates metrics and logs
them into the console. The metrics definition are done very similarly to the
\code{\link[=flow_stopper]{flow_stopper()}} function (see its help page), but the \code{formulas} are
divided into lists, each list being printed in a different line.
}
\details{
The LHS of the formulas are evaluated in the same way as in \code{\link[=flow_stopper]{flow_stopper()}}
(see its help page), but the user only access the current results
(\mjseqn{R_t}). Additionally, any metric of the current iteration
(\mjseqn{M_t}) can be accessed by its name (if \code{formulas} was named).
}
