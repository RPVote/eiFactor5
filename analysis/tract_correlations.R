###############################################################
# Tract-Level Correlations: Racial Composition (VAP) vs SES
# State: Texas
###############################################################

library(tidycensus)
library(dplyr)

# ---- 1. Build variable list ----

# VAP by race: B01001X tables
# Race-specific tables (B01001B, C, D, E, H, I) structure:
#   Male 18+: vars 007-016 (10 vars)
#   Female 18+: vars 022-031 (10 vars)

# Total population B01001:
#   Male 18+: vars 007-025 (19 vars)
#   Female 18+: vars 031-049 (19 vars)

race_suffixes <- c("B", "C", "D", "E", "H", "I")
race_labels <- c("black", "native", "asian", "nhpi", "white", "hispanic")

# Total VAP variables
total_vap_male <- sprintf("B01001_%03d", 7:25)
total_vap_female <- sprintf("B01001_%03d", 31:49)

# Race-specific VAP variables
race_vap_vars <- c()
for (sfx in race_suffixes) {
  race_vap_vars <- c(race_vap_vars,
    paste0("B01001", sfx, "_001"),  # total
    sprintf("B01001%s_%03d", sfx, 7:16),   # male 18+
    sprintf("B01001%s_%03d", sfx, 22:31))  # female 18+
}

# Overall SES variables
ses_vars <- c(
  # Median HH income
  "B19013_001",

  # HH income distribution (for > 100K, > 125K)
  "B19001_001",  # total HH
  "B19001_014",  # $100K-124K
  "B19001_015",  # $125K-149K
  "B19001_016",  # $150K-199K
  "B19001_017",  # $200K+

  # Overall poverty
  "B17001_001",  # total for poverty determination
  "B17001_002",  # below poverty level

  # Child poverty (under 18) - below poverty
  sprintf("B17001_%03d", 4:9),    # male children below poverty
  sprintf("B17001_%03d", 18:23),  # female children below poverty
  # Child total (below + above poverty)
  sprintf("B17001_%03d", 33:38),  # male children above poverty
  sprintf("B17001_%03d", 47:52),  # female children above poverty

  # Adult poverty (18+) - below poverty
  sprintf("B17001_%03d", 10:16),  # male adults below poverty
  sprintf("B17001_%03d", 24:30),  # female adults below poverty
  # Adult total (above poverty)
  sprintf("B17001_%03d", 39:45),  # male adults above poverty
  sprintf("B17001_%03d", 53:59),  # female adults above poverty

  # Education (25+) - B15003
  "B15003_001",   # total 25+
  sprintf("B15003_%03d", 2:16),   # less than HS (all subcategories)
  "B15003_017",   # HS diploma
  "B15003_022",   # bachelor's
  "B15003_023",   # master's
  "B15003_024",   # professional
  "B15003_025",   # doctorate

  # Employment (16+) - B23025
  "B23025_001",   # total 16+
  "B23025_003",   # civilian labor force
  "B23025_005",   # unemployed

  # SNAP - B22010
  "B22010_001",   # total HH
  "B22010_002",   # received SNAP

  # Disability (18-64) - B18101
  "B18101_006",   # total 18-34
  "B18101_007",   # with disability 18-34
  "B18101_008",   # total 35-64
  "B18101_009",   # with disability 35-64

  # Health insurance - B27010
  "B27010_001",   # total civilian noninstitutionalized
  "B27010_017",   # uninsured 19-34
  "B27010_033",   # uninsured 35-44
  "B27010_050",   # uninsured 45-54
  "B27010_066"    # uninsured 55-64
)

all_vars <- unique(c(
  "B01001_001",  # total pop
  total_vap_male, total_vap_female,
  race_vap_vars,
  ses_vars
))

cat("Total variables to pull:", length(all_vars), "\n")

# ---- 2. Fetch data ----
cat("Fetching TX tract data from ACS...\n")
tx <- get_acs(
  geography = "tract",
  variables = all_vars,
  state = "TX",
  year = 2022,
  survey = "acs5",
  output = "wide"
)
cat("Retrieved", nrow(tx), "tracts\n")

# ---- 3. Compute VAP racial percentages ----
e <- function(var) paste0(var, "E")

# Total VAP
tx$total_vap <- rowSums(tx[, e(total_vap_male), drop = FALSE], na.rm = TRUE) +
                rowSums(tx[, e(total_vap_female), drop = FALSE], na.rm = TRUE)

# Race-specific VAP
for (i in seq_along(race_suffixes)) {
  sfx <- race_suffixes[i]
  lbl <- race_labels[i]
  male_vars <- e(sprintf("B01001%s_%03d", sfx, 7:16))
  female_vars <- e(sprintf("B01001%s_%03d", sfx, 22:31))
  tx[[paste0("vap_", lbl)]] <- rowSums(tx[, male_vars, drop = FALSE], na.rm = TRUE) +
                                 rowSums(tx[, female_vars, drop = FALSE], na.rm = TRUE)
}

# AAPI = Asian + NHPI
tx$vap_aapi <- tx$vap_asian + tx$vap_nhpi

# Percentages
tx$pct_vap_white <- tx$vap_white / tx$total_vap
tx$pct_vap_black <- tx$vap_black / tx$total_vap
tx$pct_vap_hispanic <- tx$vap_hispanic / tx$total_vap
tx$pct_vap_native <- tx$vap_native / tx$total_vap
tx$pct_vap_aapi <- tx$vap_aapi / tx$total_vap

# ---- 4. Compute overall SES indicators ----

# Median HH income
tx$med_hh_inc <- tx$B19013_001E

# Pct HH income > 100K
hh_total <- tx$B19001_001E
tx$pct_inc_100k <- (tx$B19001_014E + tx$B19001_015E +
                     tx$B19001_016E + tx$B19001_017E) / hh_total

# Pct HH income > 125K
tx$pct_inc_125k <- (tx$B19001_015E + tx$B19001_016E +
                     tx$B19001_017E) / hh_total

# Poverty rate
tx$pct_poverty <- tx$B17001_002E / tx$B17001_001E

# Child poverty rate
child_below <- rowSums(tx[, e(sprintf("B17001_%03d", 4:9)), drop = FALSE], na.rm = TRUE) +
               rowSums(tx[, e(sprintf("B17001_%03d", 18:23)), drop = FALSE], na.rm = TRUE)
child_above <- rowSums(tx[, e(sprintf("B17001_%03d", 33:38)), drop = FALSE], na.rm = TRUE) +
               rowSums(tx[, e(sprintf("B17001_%03d", 47:52)), drop = FALSE], na.rm = TRUE)
child_total <- child_below + child_above
tx$pct_poverty_child <- ifelse(child_total > 0, child_below / child_total, NA)

# Adult poverty rate
adult_below <- rowSums(tx[, e(sprintf("B17001_%03d", 10:16)), drop = FALSE], na.rm = TRUE) +
               rowSums(tx[, e(sprintf("B17001_%03d", 24:30)), drop = FALSE], na.rm = TRUE)
adult_above <- rowSums(tx[, e(sprintf("B17001_%03d", 39:45)), drop = FALSE], na.rm = TRUE) +
               rowSums(tx[, e(sprintf("B17001_%03d", 53:59)), drop = FALSE], na.rm = TRUE)
adult_total <- adult_below + adult_above
tx$pct_poverty_adult <- ifelse(adult_total > 0, adult_below / adult_total, NA)

# Education: less than HS
less_hs <- rowSums(tx[, e(sprintf("B15003_%03d", 2:16)), drop = FALSE], na.rm = TRUE)
educ_total <- tx$B15003_001E
tx$pct_less_hs <- less_hs / educ_total

# Education: bachelor's or higher
bachelors_plus <- tx$B15003_022E + tx$B15003_023E + tx$B15003_024E + tx$B15003_025E
tx$pct_bachelor <- bachelors_plus / educ_total

# Unemployment
tx$pct_unemployed <- tx$B23025_005E / tx$B23025_003E

# SNAP
tx$pct_snap <- tx$B22010_002E / tx$B22010_001E

# Disability (18-64)
dis_total <- tx$B18101_006E + tx$B18101_008E
dis_with <- tx$B18101_007E + tx$B18101_009E
tx$pct_disabled <- dis_with / dis_total

# Uninsured (19-64)
unins <- tx$B27010_017E + tx$B27010_033E + tx$B27010_050E + tx$B27010_066E
tx$pct_uninsured <- unins / tx$B27010_001E

# ---- 5. Correlation analysis ----

race_vars <- c("pct_vap_white", "pct_vap_black", "pct_vap_hispanic",
               "pct_vap_native", "pct_vap_aapi")

ses_indicators <- c("med_hh_inc", "pct_inc_100k", "pct_inc_125k",
                     "pct_snap", "pct_poverty", "pct_poverty_child",
                     "pct_poverty_adult", "pct_less_hs", "pct_bachelor",
                     "pct_unemployed", "pct_disabled", "pct_uninsured")

ses_labels <- c("Median HH Income", "Pct Income >$100K", "Pct Income >$125K",
                "Pct Receiving SNAP", "Pct Below Poverty", "Pct Child Poverty",
                "Pct Adult Poverty", "Pct Less than HS", "Pct Bachelor's+",
                "Pct Unemployed", "Pct Disabled", "Pct Uninsured")

# Filter to tracts with reasonable VAP (>50 people)
tx_clean <- tx %>%
  filter(total_vap > 50)

cat("\nTracts with VAP > 50:", nrow(tx_clean), "of", nrow(tx), "\n")

# Compute correlation matrix
cor_data <- tx_clean[, c(race_vars, ses_indicators)]

# Replace Inf/NaN with NA
for (col in names(cor_data)) {
  cor_data[[col]] <- ifelse(is.infinite(cor_data[[col]]) |
                            is.nan(cor_data[[col]]),
                            NA, cor_data[[col]])
}

cor_mat <- cor(cor_data, use = "pairwise.complete.obs")

# Extract race vs SES correlations
race_ses_cor <- cor_mat[ses_indicators, race_vars]

cat("\n====================================================\n")
cat("CORRELATION MATRIX: Racial Composition (VAP) vs SES\n")
cat("State: Texas | Geography: Census Tracts | Year: 2022\n")
cat("====================================================\n\n")

# Print formatted
race_short <- c("White", "Black", "Hispanic", "Native", "AAPI")
colnames(race_ses_cor) <- race_short

result_df <- data.frame(
  Indicator = ses_labels,
  round(race_ses_cor, 3),
  stringsAsFactors = FALSE
)
print(result_df, row.names = FALSE)

# ---- 6. Strongest correlations per racial group ----

cat("\n\n====================================================\n")
cat("STRONGEST CORRELATIONS BY RACIAL GROUP\n")
cat("====================================================\n")

for (i in seq_along(race_vars)) {
  rv <- race_vars[i]
  race_name <- race_short[i]
  cors <- race_ses_cor[, i]
  sorted <- sort(abs(cors), decreasing = TRUE)

  cat("\n--- Pct VAP", race_name, "---\n")
  for (j in 1:min(5, length(sorted))) {
    ind_name <- names(sorted)[j]
    ind_label <- ses_labels[match(ind_name, ses_indicators)]
    r <- cors[ind_name]
    cat(sprintf("  %d. %-28s r = %+.3f\n", j, ind_label, r))
  }
}

# ---- 7. Composite Indices (standardized) ----

cat("\n\n====================================================\n")
cat("COMPOSITE INDICES\n")
cat("====================================================\n\n")

# Standardize (z-score) each indicator
std <- function(x) {
  x_clean <- x
  x_clean[is.infinite(x_clean) | is.nan(x_clean)] <- NA
  (x_clean - mean(x_clean, na.rm = TRUE)) / sd(x_clean, na.rm = TRUE)
}

# Income/Wealth Index: high = better off
# (+) median income, (+) pct_inc_100k, (-) pct_snap, (-) pct_poverty
tx_clean$z_med_inc <- std(tx_clean$med_hh_inc)
tx_clean$z_inc_100k <- std(tx_clean$pct_inc_100k)
tx_clean$z_snap <- std(tx_clean$pct_snap)
tx_clean$z_poverty <- std(tx_clean$pct_poverty)

tx_clean$income_index <- (tx_clean$z_med_inc + tx_clean$z_inc_100k -
                           tx_clean$z_snap - tx_clean$z_poverty) / 4

# Education Index: high = better educated
# (+) pct_bachelor, (-) pct_less_hs
tx_clean$z_bachelor <- std(tx_clean$pct_bachelor)
tx_clean$z_less_hs <- std(tx_clean$pct_less_hs)
tx_clean$education_index <- (tx_clean$z_bachelor - tx_clean$z_less_hs) / 2

# Employment Index: high = better employed
# (-) pct_unemployed
tx_clean$z_unemployed <- std(tx_clean$pct_unemployed)
tx_clean$employment_index <- -tx_clean$z_unemployed

# Health Index: high = healthier
# (-) pct_disabled, (-) pct_uninsured
tx_clean$z_disabled <- std(tx_clean$pct_disabled)
tx_clean$z_uninsured <- std(tx_clean$pct_uninsured)
tx_clean$health_index <- -(tx_clean$z_disabled + tx_clean$z_uninsured) / 2

# Overall SES Index (mean of all 4)
tx_clean$ses_index <- (tx_clean$income_index + tx_clean$education_index +
                        tx_clean$employment_index + tx_clean$health_index) / 4

# Correlate indices with racial composition
index_vars <- c("income_index", "education_index", "employment_index",
                "health_index", "ses_index")
index_labels <- c("Income Index", "Education Index", "Employment Index",
                   "Health Index", "Overall SES Index")

index_data <- tx_clean[, c(race_vars, index_vars)]
for (col in names(index_data)) {
  index_data[[col]] <- ifelse(is.infinite(index_data[[col]]) |
                               is.nan(index_data[[col]]),
                               NA, index_data[[col]])
}

index_cor <- cor(index_data, use = "pairwise.complete.obs")
index_race_cor <- index_cor[index_vars, race_vars]
colnames(index_race_cor) <- race_short

index_df <- data.frame(
  Index = index_labels,
  round(index_race_cor, 3),
  stringsAsFactors = FALSE
)

cat("Correlations: Composite SES Indices vs Racial Composition (VAP)\n")
cat("(Positive = higher index = better SES outcomes)\n\n")
print(index_df, row.names = FALSE)

# ---- 8. Mean index values by racial majority ----

cat("\n\n====================================================\n")
cat("MEAN SES INDEX BY TRACT RACIAL MAJORITY\n")
cat("====================================================\n\n")

tx_clean$majority <- ifelse(tx_clean$pct_vap_white > 0.5, "White Majority",
                     ifelse(tx_clean$pct_vap_black > 0.5, "Black Majority",
                     ifelse(tx_clean$pct_vap_hispanic > 0.5, "Hispanic Majority",
                     ifelse(tx_clean$pct_vap_aapi > 0.5, "AAPI Majority",
                     ifelse(tx_clean$pct_vap_native > 0.5, "Native Majority",
                     "No Majority")))))

majority_summary <- tx_clean %>%
  group_by(majority) %>%
  summarise(
    n_tracts = n(),
    income_idx = round(mean(income_index, na.rm = TRUE), 3),
    education_idx = round(mean(education_index, na.rm = TRUE), 3),
    employment_idx = round(mean(employment_index, na.rm = TRUE), 3),
    health_idx = round(mean(health_index, na.rm = TRUE), 3),
    ses_idx = round(mean(ses_index, na.rm = TRUE), 3),
    med_income = round(median(med_hh_inc, na.rm = TRUE), 0),
    .groups = "drop"
  ) %>%
  arrange(desc(ses_idx))

print(as.data.frame(majority_summary), row.names = FALSE)

# ---- 9. Key SES means by majority type ----

cat("\n\n====================================================\n")
cat("MEAN SES INDICATORS BY TRACT RACIAL MAJORITY\n")
cat("====================================================\n\n")

ses_majority <- tx_clean %>%
  group_by(majority) %>%
  summarise(
    n = n(),
    med_inc = round(median(med_hh_inc, na.rm = TRUE), 0),
    pct_100k = round(mean(pct_inc_100k, na.rm = TRUE) * 100, 1),
    pct_pov = round(mean(pct_poverty, na.rm = TRUE) * 100, 1),
    pct_child_pov = round(mean(pct_poverty_child, na.rm = TRUE) * 100, 1),
    pct_lt_hs = round(mean(pct_less_hs, na.rm = TRUE) * 100, 1),
    pct_ba = round(mean(pct_bachelor, na.rm = TRUE) * 100, 1),
    pct_unemp = round(mean(pct_unemployed, na.rm = TRUE) * 100, 1),
    pct_dis = round(mean(pct_disabled, na.rm = TRUE) * 100, 1),
    pct_unins = round(mean(pct_uninsured, na.rm = TRUE) * 100, 1),
    .groups = "drop"
  ) %>%
  arrange(desc(med_inc))

print(as.data.frame(ses_majority), row.names = FALSE)

cat("\n\nDone.\n")
