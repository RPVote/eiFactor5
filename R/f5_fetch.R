#' @title Fetch ACS Data for Factor 5 Analysis
#' @description Retrieves American Community Survey data via the Census API
#'   and computes 12 socioeconomic status (SES) indicators by racial/ethnic
#'   group.
#'
#' @param state State abbreviation (e.g., "NM") or FIPS code. Use \code{NULL}
#'   for national-level data.
#' @param county County FIPS code(s) or name(s). Use \code{NULL} for statewide.
#' @param geography Geographic level: \code{"state"}, \code{"county"},
#'   \code{"tract"}, \code{"block group"}, or \code{"congressional district"}.
#'   Default: \code{"county"}.
#' @param year ACS survey year. Default: 2022.
#' @param groups Character vector of racial/ethnic groups to include. Options:
#'   \code{"white"}, \code{"black"}, \code{"hispanic"}, \code{"aapi"},
#'   \code{"native"}. Default: all five groups.
#' @param survey ACS survey type: \code{"acs5"} (default) or \code{"acs1"}.
#' @param geometry Logical. If \code{TRUE}, includes TIGER/Line geometry for
#'   mapping with \code{\link{f5_map}}. Default: \code{FALSE}.
#'
#' @return A data.frame (or \code{sf} object if \code{geometry = TRUE}) with
#'   one row per sub-geography. Contains columns for:
#'   \itemize{
#'     \item \code{GEOID}, \code{NAME}: Geography identifiers
#'     \item \code{tot_pop}: Total population
#'     \item \code{pct_white}, \code{pct_black}, etc.: Racial composition
#'     \item 12 SES indicators per group (e.g., \code{med_hh_inc_white},
#'       \code{pct_snap_black})
#'   }
#'   Attributes include \code{groups}, \code{year}, \code{geography}, and
#'   \code{survey} metadata used by downstream functions.
#'
#' @details
#' This function calls \code{\link[tidycensus]{get_acs}} to retrieve raw ACS
#' data, then computes the following 12 SES indicators for each requested
#' racial/ethnic group:
#' \enumerate{
#'   \item Median Household Income (B19013)
#'   \item Pct. HH Income > $100K (B19001)
#'   \item Pct. HH Income > $125K (B19001)
#'   \item Pct. Receiving SNAP (B22005)
#'   \item Pct. Below Poverty Line (B17001)
#'   \item Pct. Below Poverty, Children under 18 (B17001)
#'   \item Pct. Below Poverty, Adults 18+ (B17001)
#'   \item Pct. Less than HS Diploma, 25+ (C15002)
#'   \item Pct. Bachelor's Degree+, 25+ (C15002)
#'   \item Pct. Unemployed, 16-64 (C23002)
#'   \item Pct. Disabled, 18-64 (B18101)
#'   \item Pct. Uninsured, 19-64 (C27001)
#' }
#'
#' Requires a Census API key set via
#' \code{\link[tidycensus]{census_api_key}}.
#'
#' @examples
#' \dontrun{
#' # All NM counties, White vs Black vs Hispanic
#' dat <- f5_fetch(state = "NM", geography = "county", year = 2022,
#'                 groups = c("white", "black", "hispanic"))
#'
#' # National, state-level, all 5 groups
#' dat <- f5_fetch(geography = "state", year = 2022)
#'
#' # Specific counties, tract-level with geometry
#' dat <- f5_fetch(state = "NM", county = c("049", "039"),
#'                 geography = "tract", geometry = TRUE)
#' }
#'
#' @export
#' @importFrom tidycensus get_acs
f5_fetch <- function(state = NULL,
                     county = NULL,
                     geography = "county",
                     year = 2022,
                     groups = c("white", "black", "hispanic", "aapi", "native"),
                     survey = "acs5",
                     geometry = FALSE) {

  # Validate inputs
  valid_groups <- c("white", "black", "hispanic", "aapi", "native")
  groups <- match.arg(groups, valid_groups, several.ok = TRUE)

  valid_geo <- c("state", "county", "tract", "block group",
                 "congressional district")
  geography <- match.arg(geography, valid_geo)

  survey <- match.arg(survey, c("acs5", "acs1"))

  # Get ACS variable codes for requested groups
  vars <- get_acs_vars(groups)

  # Fetch raw ACS data
  message("Fetching ACS data (", survey, ", ", year, ", ", geography, ")...")
  raw <- tidycensus::get_acs(
    geography = geography,
    variables = vars,
    year = year,
    state = state,
    county = county,
    survey = survey,
    output = "wide",
    geometry = geometry
  )
  message("Retrieved ", nrow(raw), " geographic units.")

  # Compute SES indicators for each group
  result <- compute_indicators(raw, groups)

  # Attach metadata
  attr(result, "groups") <- groups
  attr(result, "year") <- year
  attr(result, "geography") <- geography
  attr(result, "survey") <- survey
  attr(result, "state") <- state
  attr(result, "county") <- county

  result
}
