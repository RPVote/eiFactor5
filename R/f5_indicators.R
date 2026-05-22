#' @title List Factor 5 SES Indicators
#' @description Returns a data.frame documenting the 12 socioeconomic status
#'   indicators used in Factor 5 analysis, including their ACS source tables
#'   and summary measure type.
#'
#' @return A data.frame with columns:
#'   \itemize{
#'     \item \code{id}: Short identifier used in column names (e.g.,
#'       \code{"pct_snap"})
#'     \item \code{label}: Display label (e.g., \code{"Pct. Receiving SNAP"})
#'     \item \code{summary_type}: Summary measure (\code{"median"} or
#'       \code{"proportion"})
#'     \item \code{acs_table}: Primary ACS table series
#'     \item \code{description}: Brief description of the indicator
#'   }
#'
#' @examples
#' f5_indicators()
#'
#' @export
f5_indicators <- function() {
  data.frame(
    id = c("med_hh_inc", "pct_hh_inc_100k", "pct_hh_inc_125k",
           "pct_snap", "pct_below_poverty", "pct_below_poverty_child",
           "pct_below_poverty_adult", "pct_less_hs", "pct_bachelor",
           "pct_unemployed", "pct_disabled", "pct_uninsured"),
    label = c("Median Household Income",
              "Pct. HH Income > $100K",
              "Pct. HH Income > $125K",
              "Pct. Receiving SNAP",
              "Pct. Below Poverty Line",
              "Pct. Below Poverty (Children)",
              "Pct. Below Poverty (Adults)",
              "Pct. Less than HS Diploma",
              "Pct. Bachelor's Degree+",
              "Pct. Unemployed (16-64)",
              "Pct. Disabled (18-64)",
              "Pct. Uninsured (19-64)"),
    summary_type = c("median", rep("proportion", 11)),
    acs_table = c("B19013", "B19001", "B19001", "B22005",
                  "B17001", "B17001", "B17001", "C15002", "C15002",
                  "C23002", "B18101", "C27001"),
    description = c(
      "Median household income in the past 12 months",
      "Pct. of households with income >= $100,000",
      "Pct. of households with income >= $125,000",
      "Pct. of households receiving SNAP/food stamps",
      "Pct. of persons with income below poverty level",
      "Pct. of children (under 18) below poverty level",
      "Pct. of adults (18+) below poverty level",
      "Pct. of persons 25+ with less than high school diploma",
      "Pct. of persons 25+ with bachelor's degree or higher",
      "Pct. unemployed in civilian labor force, ages 16-64",
      "Pct. with a disability, ages 18-64",
      "Pct. without health insurance, ages 19-64"
    ),
    stringsAsFactors = FALSE
  )
}
