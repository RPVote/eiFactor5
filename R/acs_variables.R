# ACS table suffix codes by racial group:
# B = Black alone
# H = White alone, not Hispanic or Latino
# I = Hispanic or Latino
# D = Asian alone
# E = Native Hawaiian and Other Pacific Islander alone
# C = American Indian and Alaska Native alone

#' Get all ACS variable codes needed for a set of racial groups
#' @param groups Character vector of group names
#' @return Character vector of ACS variable codes
#' @keywords internal
get_acs_vars <- function(groups = c("white", "black", "hispanic", "aapi", "native")) {
  # Mapping from group names to ACS suffixes
  suffix_map <- list(
    white = "H",
    black = "B",
    hispanic = "I",
    aapi = c("D", "E"), # Asian + Pacific Islander
    native = "C"
  )

  # Base variables (always needed)
  vars <- c(
    "B01003_001", # Total population
    "B03002_003", # White NH
    "B03002_004", # Black NH
    "B03002_005", # Native NH
    "B03002_006", # Asian NH
    "B03002_007", # Pacific Islander NH
    "B03002_012" # Hispanic
  )

  for (grp in groups) {
    suffixes <- suffix_map[[grp]]
    if (is.null(suffixes)) next

    for (sfx in suffixes) {
      vars <- c(
        vars,
        # Median HH Income
        paste0("B19013", sfx, "_001"),

        # HH Income distribution (for >100K, >125K)
        paste0("B19001", sfx, "_001"), # total households
        paste0("B19001", sfx, "_014"), # $100K-$124K
        paste0("B19001", sfx, "_015"), # $125K-$149K
        paste0("B19001", sfx, "_016"), # $150K-$199K
        paste0("B19001", sfx, "_017"), # $200K+

        # SNAP
        paste0("B22005", sfx, "_001"), # denominator
        paste0("B22005", sfx, "_002"), # receiving SNAP

        # Poverty status
        paste0("B17001", sfx, "_001"), # denominator
        paste0("B17001", sfx, "_002"), # below poverty

        # Poverty: children (under 18) - males
        paste0("B17001", sfx, "_004"), # below pov male <5
        paste0("B17001", sfx, "_005"), # below pov male 5
        paste0("B17001", sfx, "_006"), # below pov male 6-11
        paste0("B17001", sfx, "_007"), # below pov male 12-14
        paste0("B17001", sfx, "_008"), # below pov male 15
        paste0("B17001", sfx, "_009"), # below pov male 16-17
        # above pov male children
        paste0("B17001", sfx, "_033"),
        paste0("B17001", sfx, "_034"),
        paste0("B17001", sfx, "_035"),
        paste0("B17001", sfx, "_036"),
        paste0("B17001", sfx, "_037"),
        paste0("B17001", sfx, "_038"),

        # Poverty: children - females
        paste0("B17001", sfx, "_018"), # below pov female <5
        paste0("B17001", sfx, "_019"),
        paste0("B17001", sfx, "_020"),
        paste0("B17001", sfx, "_021"),
        paste0("B17001", sfx, "_022"),
        paste0("B17001", sfx, "_023"),
        # above pov female children
        paste0("B17001", sfx, "_047"),
        paste0("B17001", sfx, "_048"),
        paste0("B17001", sfx, "_049"),
        paste0("B17001", sfx, "_050"),
        paste0("B17001", sfx, "_051"),
        paste0("B17001", sfx, "_052"),

        # Poverty: adults (18+) - males
        paste0("B17001", sfx, "_010"),
        paste0("B17001", sfx, "_011"),
        paste0("B17001", sfx, "_012"),
        paste0("B17001", sfx, "_013"),
        paste0("B17001", sfx, "_014"),
        paste0("B17001", sfx, "_015"),
        paste0("B17001", sfx, "_016"),
        # above pov male adults
        paste0("B17001", sfx, "_039"),
        paste0("B17001", sfx, "_040"),
        paste0("B17001", sfx, "_041"),
        paste0("B17001", sfx, "_042"),
        paste0("B17001", sfx, "_043"),
        paste0("B17001", sfx, "_044"),
        paste0("B17001", sfx, "_045"),

        # Poverty: adults - females
        paste0("B17001", sfx, "_024"),
        paste0("B17001", sfx, "_025"),
        paste0("B17001", sfx, "_026"),
        paste0("B17001", sfx, "_027"),
        paste0("B17001", sfx, "_028"),
        paste0("B17001", sfx, "_029"),
        paste0("B17001", sfx, "_030"),
        # above pov female adults
        paste0("B17001", sfx, "_053"),
        paste0("B17001", sfx, "_054"),
        paste0("B17001", sfx, "_055"),
        paste0("B17001", sfx, "_056"),
        paste0("B17001", sfx, "_057"),
        paste0("B17001", sfx, "_058"),
        paste0("B17001", sfx, "_059"),

        # Educational attainment (25+)
        paste0("C15002", sfx, "_001"), # total
        paste0("C15002", sfx, "_003"), # male less than HS
        paste0("C15002", sfx, "_006"), # male bachelor's+
        paste0("C15002", sfx, "_008"), # female less than HS
        paste0("C15002", sfx, "_011"), # female bachelor's+

        # Employment status (16-64)
        paste0("C23002", sfx, "_006"), # male civilian labor force
        paste0("C23002", sfx, "_008"), # male unemployed
        paste0("C23002", sfx, "_019"), # female civilian labor force
        paste0("C23002", sfx, "_021"), # female unemployed

        # Disability (18-64)
        paste0("B18101", sfx, "_005"), # total 18-64
        paste0("B18101", sfx, "_006"), # with disability 18-64

        # Health insurance (19-64)
        paste0("C27001", sfx, "_005"), # total 19-64
        paste0("C27001", sfx, "_007") # uninsured 19-64
      )
    }
  }

  unique(vars)
}
