# ============================================================
# eiFactor5: Northern New Mexico Factor 5 Analysis
# Native vs Hispanic vs White
# ============================================================

library(eiFactor5)

# --- Statewide NM: county-level ---
nm_dat <- f5_fetch(
  state = "NM",
  geography = "county",
  year = 2022,
  groups = c("white", "hispanic", "native")
)

# Comparison table
nm_table <- f5_table(
  nm_dat,
  ref_group = "white",
  compare_groups = c("hispanic", "native")
)
print(nm_table)

# Bar chart
f5_plot(nm_dat,
        ref_group = "white",
        compare_groups = c("hispanic", "native"))

# --- Northern NM: tract-level with maps ---
# Santa Fe, Rio Arriba, Taos, San Juan, McKinley, Sandoval,
# Los Alamos, Colfax
north_nm_counties <- c("049", "039", "055", "045",
                       "031", "043", "028", "007")

north_dat <- f5_fetch(
  state = "NM",
  county = north_nm_counties,
  geography = "tract",
  year = 2022,
  groups = c("white", "hispanic", "native"),
  geometry = TRUE
)

# Comparison table
north_table <- f5_table(
  north_dat,
  ref_group = "white",
  compare_groups = c("hispanic", "native")
)
print(north_table)

# Pairwise tests: White vs Native
f5_compare(north_dat,
           ref_group = "white",
           compare_group = "native")

# Choropleth map: Native poverty rate
f5_map(north_dat,
       indicator = "pct_below_poverty",
       group = "native",
       title = "Native American Poverty Rate\nNorthern New Mexico")

# Dot plot
f5_plot(north_dat,
        ref_group = "white",
        compare_groups = c("hispanic", "native"),
        type = "dot")
