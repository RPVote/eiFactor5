#' Get the ACS column suffix for an estimate variable
#' @keywords internal
e_col <- function(var_code) {
  paste0(var_code, "E")
}

#' Safe division that returns NA instead of Inf/NaN
#' @keywords internal
safe_div <- function(num, denom) {
  ifelse(denom == 0 | is.na(denom), NA_real_, num / denom)
}

#' Format a number as a percentage string
#' @keywords internal
fmt_pct <- function(x, digits = 1) {
  ifelse(is.na(x), "NA", paste0(round(x * 100, digits), "%"))
}

#' Format a number as currency
#' @keywords internal
fmt_dollar <- function(x, digits = 0) {
  ifelse(is.na(x), "NA", paste0("$", formatC(round(x, digits),
    format = "f", digits = digits, big.mark = ",")))
}

#' Map group labels to display names
#' @keywords internal
group_display_name <- function(group) {
  names_map <- c(
    white = "White",
    black = "Black",
    hispanic = "Hispanic",
    aapi = "AAPI",
    native = "Native Am."
  )
  ifelse(group %in% names(names_map), names_map[group], group)
}

#' Get indicator metadata
#' @keywords internal
indicator_meta <- function() {
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
    stringsAsFactors = FALSE
  )
}
