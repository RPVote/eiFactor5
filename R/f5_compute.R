#' Compute all 12 SES indicators for a single racial group
#' @param data Wide-format ACS data from tidycensus
#' @param group Group name (white, black, hispanic, aapi, native)
#' @return data.frame with 12 indicator columns named \code{indicator_group}
#' @keywords internal
compute_group <- function(data, group) {
  suffix_map <- list(
    white = "H", black = "B", hispanic = "I",
    aapi = c("D", "E"), native = "C"
  )
  sfx <- suffix_map[[group]]

  # Helper: get estimate column value, summing across multiple suffixes (for AAPI)
  e <- function(table, var) {
    col1 <- paste0(table, sfx[1], "_", var, "E")
    val <- if (col1 %in% names(data)) data[[col1]] else rep(NA_real_, nrow(data))
    if (length(sfx) > 1) {
      col2 <- paste0(table, sfx[2], "_", var, "E")
      val2 <- if (col2 %in% names(data)) data[[col2]] else rep(NA_real_, nrow(data))
      val <- ifelse(is.na(val), val2, ifelse(is.na(val2), val, val + val2))
    }
    val
  }

  # 1. Median HH Income
  # For AAPI, use Asian alone (D) since Pacific Islander median is unreliable
  if (group == "aapi") {
    med_hh_inc <- data[["B19013D_001E"]]
  } else {
    col_name <- paste0("B19013", sfx[1], "_001E")
    med_hh_inc <- if (col_name %in% names(data)) data[[col_name]] else NA_real_
  }

  # 2-3. Pct HH Income > $100K and > $125K
  hh_total <- e("B19001", "001")
  hh_100 <- e("B19001", "014")
  hh_125 <- e("B19001", "015")
  hh_150 <- e("B19001", "016")
  hh_200 <- e("B19001", "017")
  pct_hh_inc_100k <- safe_div(hh_100 + hh_125 + hh_150 + hh_200, hh_total)
  pct_hh_inc_125k <- safe_div(hh_125 + hh_150 + hh_200, hh_total)

  # 4. Pct Receiving SNAP
  snap_total <- e("B22005", "001")
  snap_recv <- e("B22005", "002")
  pct_snap <- safe_div(snap_recv, snap_total)

  # 5. Pct Below Poverty Line
  pov_total <- e("B17001", "001")
  pov_below <- e("B17001", "002")
  pct_below_poverty <- safe_div(pov_below, pov_total)

  # 6. Pct Below Poverty - Children (under 18)
  # Below poverty: male 004-009, female 018-023
  # Above poverty: male 033-038, female 047-052
  child_below_m <- e("B17001", "004") + e("B17001", "005") + e("B17001", "006") +
    e("B17001", "007") + e("B17001", "008") + e("B17001", "009")
  child_below_f <- e("B17001", "018") + e("B17001", "019") + e("B17001", "020") +
    e("B17001", "021") + e("B17001", "022") + e("B17001", "023")
  child_above_m <- e("B17001", "033") + e("B17001", "034") + e("B17001", "035") +
    e("B17001", "036") + e("B17001", "037") + e("B17001", "038")
  child_above_f <- e("B17001", "047") + e("B17001", "048") + e("B17001", "049") +
    e("B17001", "050") + e("B17001", "051") + e("B17001", "052")
  child_total <- child_below_m + child_below_f + child_above_m + child_above_f
  child_poverty <- child_below_m + child_below_f
  pct_below_poverty_child <- safe_div(child_poverty, child_total)

  # 7. Pct Below Poverty - Adults (18+)
  # Below poverty: male 010-016, female 024-030
  # Above poverty: male 039-045, female 053-059
  adult_below_m <- e("B17001", "010") + e("B17001", "011") + e("B17001", "012") +
    e("B17001", "013") + e("B17001", "014") + e("B17001", "015") + e("B17001", "016")
  adult_below_f <- e("B17001", "024") + e("B17001", "025") + e("B17001", "026") +
    e("B17001", "027") + e("B17001", "028") + e("B17001", "029") + e("B17001", "030")
  adult_above_m <- e("B17001", "039") + e("B17001", "040") + e("B17001", "041") +
    e("B17001", "042") + e("B17001", "043") + e("B17001", "044") + e("B17001", "045")
  adult_above_f <- e("B17001", "053") + e("B17001", "054") + e("B17001", "055") +
    e("B17001", "056") + e("B17001", "057") + e("B17001", "058") + e("B17001", "059")
  adult_total <- adult_below_m + adult_below_f + adult_above_m + adult_above_f
  adult_poverty <- adult_below_m + adult_below_f
  pct_below_poverty_adult <- safe_div(adult_poverty, adult_total)

  # 8. Pct Less than HS Diploma (25+)
  educ_total <- e("C15002", "001")
  educ_less_hs <- e("C15002", "003") + e("C15002", "008")
  pct_less_hs <- safe_div(educ_less_hs, educ_total)

  # 9. Pct Bachelor's Degree or Higher (25+)
  educ_bachelor <- e("C15002", "006") + e("C15002", "011")
  pct_bachelor <- safe_div(educ_bachelor, educ_total)

  # 10. Pct Unemployed (16-64, civilian labor force)
  civ_labor <- e("C23002", "006") + e("C23002", "019")
  unemployed <- e("C23002", "008") + e("C23002", "021")
  pct_unemployed <- safe_div(unemployed, civ_labor)

  # 11. Pct Disabled (18-64)
  dis_total <- e("B18101", "005")
  dis_with <- e("B18101", "006")
  pct_disabled <- safe_div(dis_with, dis_total)

  # 12. Pct Uninsured (19-64)
  ins_total <- e("C27001", "005")
  ins_none <- e("C27001", "007")
  pct_uninsured <- safe_div(ins_none, ins_total)

  # Build data.frame with group-suffixed column names
  result <- data.frame(
    med_hh_inc = med_hh_inc,
    pct_hh_inc_100k = pct_hh_inc_100k,
    pct_hh_inc_125k = pct_hh_inc_125k,
    pct_snap = pct_snap,
    pct_below_poverty = pct_below_poverty,
    pct_below_poverty_child = pct_below_poverty_child,
    pct_below_poverty_adult = pct_below_poverty_adult,
    pct_less_hs = pct_less_hs,
    pct_bachelor = pct_bachelor,
    pct_unemployed = pct_unemployed,
    pct_disabled = pct_disabled,
    pct_uninsured = pct_uninsured,
    stringsAsFactors = FALSE
  )
  names(result) <- paste0(names(result), "_", group)
  result
}

#' Compute racial composition percentages from raw ACS data
#' @param data Wide-format ACS data from tidycensus
#' @return data.frame with pct_white, pct_black, etc.
#' @keywords internal
compute_race_pcts <- function(data) {
  tot_pop <- data[["B01003_001E"]]
  data.frame(
    tot_pop = tot_pop,
    pct_white = safe_div(data[["B03002_003E"]], tot_pop),
    pct_black = safe_div(data[["B03002_004E"]], tot_pop),
    pct_hispanic = safe_div(data[["B03002_012E"]], tot_pop),
    pct_aapi = safe_div(data[["B03002_006E"]] + data[["B03002_007E"]], tot_pop),
    pct_native = safe_div(data[["B03002_005E"]], tot_pop),
    stringsAsFactors = FALSE
  )
}

#' Compute all indicators for all requested groups
#' @param data Wide-format ACS data from tidycensus
#' @param groups Character vector of group names
#' @return data.frame with GEOID, NAME, race percentages, and all indicators
#' @keywords internal
compute_indicators <- function(data, groups) {
  # Start with geography identifiers
  has_geometry <- inherits(data, "sf")

  if (has_geometry) {
    geo_cols <- data[, c("GEOID", "NAME"), drop = FALSE]
  } else {
    geo_cols <- data[, c("GEOID", "NAME"), drop = FALSE]
  }

  # Compute race percentages
  race_pcts <- compute_race_pcts(data)

  # Compute indicators for each group
  group_results <- lapply(groups, function(g) compute_group(data, g))

  # Combine everything
  result <- cbind(geo_cols, race_pcts)
  for (gr in group_results) {
    result <- cbind(result, gr)
  }

  if (has_geometry) {
    result <- sf::st_sf(result, geometry = sf::st_geometry(data))
  }

  result
}
