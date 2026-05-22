# ============================================================
# eiFactor5: Basic Factor 5 Analysis
# Mississippi: White vs Black, county-level
# ============================================================

library(eiFactor5)

# Fetch county-level data for Mississippi
dat <- f5_fetch(
  state = "MS",
  geography = "county",
  year = 2022,
  groups = c("white", "black")
)

# View available indicators
f5_indicators()

# Comparison table with t-tests
tbl <- f5_table(dat, ref_group = "white", compare_groups = "black")
print(tbl)

# Detailed pairwise statistical tests
comp <- f5_compare(dat, ref_group = "white", compare_group = "black")
print(comp)

# Bar chart
f5_plot(dat, ref_group = "white", compare_groups = "black")

# Dot plot
f5_plot(dat, ref_group = "white", compare_groups = "black", type = "dot")
