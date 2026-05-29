###############################################################
# Pct Minority (combined) vs SES Index Correlations
# Builds on tract_correlations.R output
# State: Texas, Census Tracts, ACS 2022
###############################################################

library(tidycensus)
library(dplyr)

# ---- 1. Pull data (same as before) ----

race_suffixes <- c("B", "C", "D", "E", "H", "I")
race_labels <- c("black", "native", "asian", "nhpi", "white", "hispanic")

total_vap_male <- sprintf("B01001_%03d", 7:25)
total_vap_female <- sprintf("B01001_%03d", 31:49)

race_vap_vars <- c()
for (sfx in race_suffixes) {
  race_vap_vars <- c(race_vap_vars,
    paste0("B01001", sfx, "_001"),
    sprintf("B01001%s_%03d", sfx, 7:16),
    sprintf("B01001%s_%03d", sfx, 22:31))
}

e <- function(var) paste0(var, "E")

ses_vars <- c(
  "B19013_001",
  "B19001_001", "B19001_014", "B19001_015", "B19001_016", "B19001_017",
  "B17001_001", "B17001_002",
  sprintf("B17001_%03d", 4:9), sprintf("B17001_%03d", 18:23),
  sprintf("B17001_%03d", 33:38), sprintf("B17001_%03d", 47:52),
  sprintf("B17001_%03d", 10:16), sprintf("B17001_%03d", 24:30),
  sprintf("B17001_%03d", 39:45), sprintf("B17001_%03d", 53:59),
  "B15003_001", sprintf("B15003_%03d", 2:16),
  "B15003_017", "B15003_022", "B15003_023", "B15003_024", "B15003_025",
  "B23025_001", "B23025_003", "B23025_005",
  "B22010_001", "B22010_002",
  "B27010_001", "B27010_017", "B27010_033", "B27010_050", "B27010_066"
)

all_vars <- unique(c("B01001_001", total_vap_male, total_vap_female,
                     race_vap_vars, ses_vars))

cat("Fetching TX tract data...\n")
tx <- get_acs(geography = "tract", variables = all_vars,
              state = "TX", year = 2022, survey = "acs5", output = "wide")
cat("Retrieved", nrow(tx), "tracts\n")

# ---- 2. Compute VAP ----

tx$total_vap <- rowSums(tx[, e(total_vap_male), drop = FALSE], na.rm = TRUE) +
                rowSums(tx[, e(total_vap_female), drop = FALSE], na.rm = TRUE)

for (i in seq_along(race_suffixes)) {
  sfx <- race_suffixes[i]
  lbl <- race_labels[i]
  male_v <- e(sprintf("B01001%s_%03d", sfx, 7:16))
  female_v <- e(sprintf("B01001%s_%03d", sfx, 22:31))
  tx[[paste0("vap_", lbl)]] <- rowSums(tx[, male_v, drop = FALSE], na.rm = TRUE) +
                                 rowSums(tx[, female_v, drop = FALSE], na.rm = TRUE)
}
tx$vap_aapi <- tx$vap_asian + tx$vap_nhpi

tx$pct_vap_white    <- tx$vap_white / tx$total_vap
tx$pct_vap_black    <- tx$vap_black / tx$total_vap
tx$pct_vap_hispanic <- tx$vap_hispanic / tx$total_vap
tx$pct_vap_native   <- tx$vap_native / tx$total_vap
tx$pct_vap_aapi     <- tx$vap_aapi / tx$total_vap

# Combined minority percentages
tx$pct_vap_minority     <- 1 - tx$pct_vap_white
tx$pct_vap_black_hisp   <- tx$pct_vap_black + tx$pct_vap_hispanic
tx$pct_vap_nonwhite_noaapi <- tx$pct_vap_black + tx$pct_vap_hispanic + tx$pct_vap_native

# ---- 3. Compute SES indicators ----

safe_div <- function(num, denom) ifelse(denom == 0 | is.na(denom), NA_real_, num / denom)

hh_total <- tx$B19001_001E
tx$med_hh_inc     <- tx$B19013_001E
tx$pct_inc_100k   <- safe_div(tx$B19001_014E + tx$B19001_015E + tx$B19001_016E + tx$B19001_017E, hh_total)
tx$pct_inc_125k   <- safe_div(tx$B19001_015E + tx$B19001_016E + tx$B19001_017E, hh_total)
tx$pct_poverty    <- safe_div(tx$B17001_002E, tx$B17001_001E)

child_below <- rowSums(tx[, e(sprintf("B17001_%03d", 4:9)), drop=F], na.rm=T) +
               rowSums(tx[, e(sprintf("B17001_%03d", 18:23)), drop=F], na.rm=T)
child_above <- rowSums(tx[, e(sprintf("B17001_%03d", 33:38)), drop=F], na.rm=T) +
               rowSums(tx[, e(sprintf("B17001_%03d", 47:52)), drop=F], na.rm=T)
tx$pct_poverty_child <- safe_div(child_below, child_below + child_above)

adult_below <- rowSums(tx[, e(sprintf("B17001_%03d", 10:16)), drop=F], na.rm=T) +
               rowSums(tx[, e(sprintf("B17001_%03d", 24:30)), drop=F], na.rm=T)
adult_above <- rowSums(tx[, e(sprintf("B17001_%03d", 39:45)), drop=F], na.rm=T) +
               rowSums(tx[, e(sprintf("B17001_%03d", 53:59)), drop=F], na.rm=T)
tx$pct_poverty_adult <- safe_div(adult_below, adult_below + adult_above)

less_hs <- rowSums(tx[, e(sprintf("B15003_%03d", 2:16)), drop=F], na.rm=T)
tx$pct_less_hs    <- safe_div(less_hs, tx$B15003_001E)
bach_plus <- tx$B15003_022E + tx$B15003_023E + tx$B15003_024E + tx$B15003_025E
tx$pct_bachelor   <- safe_div(bach_plus, tx$B15003_001E)
tx$pct_unemployed <- safe_div(tx$B23025_005E, tx$B23025_003E)
tx$pct_snap       <- safe_div(tx$B22010_002E, tx$B22010_001E)
unins <- tx$B27010_017E + tx$B27010_033E + tx$B27010_050E + tx$B27010_066E
tx$pct_uninsured  <- safe_div(unins, tx$B27010_001E)

# ---- 4. Composite indices (standardized) ----

tx_clean <- tx %>% filter(total_vap > 50)
cat("Tracts with VAP > 50:", nrow(tx_clean), "\n")

std <- function(x) {
  x[is.infinite(x) | is.nan(x)] <- NA
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

tx_clean$income_index     <- (std(tx_clean$med_hh_inc) + std(tx_clean$pct_inc_100k) -
                               std(tx_clean$pct_snap) - std(tx_clean$pct_poverty)) / 4
tx_clean$education_index  <- (std(tx_clean$pct_bachelor) - std(tx_clean$pct_less_hs)) / 2
tx_clean$employment_index <- -std(tx_clean$pct_unemployed)
tx_clean$health_index     <- -(std(tx_clean$pct_uninsured)) # just uninsured, skip disability
tx_clean$ses_index        <- (tx_clean$income_index + tx_clean$education_index +
                               tx_clean$employment_index + tx_clean$health_index) / 4

# ---- 5. Correlation: individual race % vs SES ----

race_vars <- c("pct_vap_white", "pct_vap_black", "pct_vap_hispanic",
               "pct_vap_native", "pct_vap_aapi")
combined_vars <- c("pct_vap_minority", "pct_vap_black_hisp", "pct_vap_nonwhite_noaapi")

ses_indicators <- c("med_hh_inc", "pct_inc_100k", "pct_inc_125k",
                     "pct_snap", "pct_poverty", "pct_poverty_child",
                     "pct_poverty_adult", "pct_less_hs", "pct_bachelor",
                     "pct_unemployed", "pct_uninsured")

ses_labels <- c("Median HH Income", "Pct Income >$100K", "Pct Income >$125K",
                "Pct Receiving SNAP", "Pct Below Poverty", "Pct Child Poverty",
                "Pct Adult Poverty", "Pct Less than HS", "Pct Bachelor's+",
                "Pct Unemployed", "Pct Uninsured")

index_vars <- c("income_index", "education_index", "employment_index",
                "health_index", "ses_index")
index_labels <- c("Income Index", "Education Index", "Employment Index",
                   "Health Index", "Overall SES Index")

all_x <- c(race_vars, combined_vars)

# Clean Inf/NaN
cor_cols <- c(all_x, ses_indicators, index_vars)
for (col in cor_cols) {
  tx_clean[[col]][is.infinite(tx_clean[[col]]) | is.nan(tx_clean[[col]])] <- NA
}

cor_full <- cor(tx_clean[, cor_cols], use = "pairwise.complete.obs")

# ---- 6. Print: Individual SES indicators ----

cat("\n================================================================\n")
cat("CORRELATIONS: Racial Composition (VAP %) vs SES Indicators\n")
cat("Texas Census Tracts, ACS 2022, N =", nrow(tx_clean), "\n")
cat("================================================================\n\n")

col_labels <- c("White", "Black", "Hispanic", "Native", "AAPI",
                "All Minority", "Black+Hisp", "Blk+Hisp+Nat")

ses_cor <- cor_full[ses_indicators, all_x]
colnames(ses_cor) <- col_labels

result <- data.frame(Indicator = ses_labels, round(ses_cor, 3), stringsAsFactors = FALSE,
                     check.names = FALSE)
print(result, row.names = FALSE)

# ---- 7. Print: Composite indices ----

cat("\n================================================================\n")
cat("CORRELATIONS: Racial Composition (VAP %) vs Composite Indices\n")
cat("(Positive index = better SES outcomes)\n")
cat("================================================================\n\n")

idx_cor <- cor_full[index_vars, all_x]
colnames(idx_cor) <- col_labels

idx_result <- data.frame(Index = index_labels, round(idx_cor, 3), stringsAsFactors = FALSE,
                         check.names = FALSE)
print(idx_result, row.names = FALSE)

# ---- 8. Decile analysis: SES by minority percentage ----

cat("\n================================================================\n")
cat("SES BY DECILE OF PERCENT MINORITY (VAP)\n")
cat("================================================================\n\n")

tx_clean$minority_decile <- ntile(tx_clean$pct_vap_minority, 10)

decile_summary <- tx_clean %>%
  group_by(minority_decile) %>%
  summarise(
    n = n(),
    min_pct_minority = round(min(pct_vap_minority, na.rm = TRUE) * 100, 1),
    max_pct_minority = round(max(pct_vap_minority, na.rm = TRUE) * 100, 1),
    med_income    = round(median(med_hh_inc, na.rm = TRUE), 0),
    pct_pov       = round(mean(pct_poverty, na.rm = TRUE) * 100, 1),
    pct_child_pov = round(mean(pct_poverty_child, na.rm = TRUE) * 100, 1),
    pct_lt_hs     = round(mean(pct_less_hs, na.rm = TRUE) * 100, 1),
    pct_ba        = round(mean(pct_bachelor, na.rm = TRUE) * 100, 1),
    pct_unemp     = round(mean(pct_unemployed, na.rm = TRUE) * 100, 1),
    pct_snap      = round(mean(pct_snap, na.rm = TRUE) * 100, 1),
    pct_unins     = round(mean(pct_uninsured, na.rm = TRUE) * 100, 1),
    ses_idx       = round(mean(ses_index, na.rm = TRUE), 3),
    .groups = "drop"
  )

cat("Decile | Min-Max Minority% |   N | Med Inc | Pov% | ChPov | <HS% |  BA+ | Unemp | SNAP | Unins | SES Idx\n")
cat(strrep("-", 115), "\n")
for (i in 1:nrow(decile_summary)) {
  r <- decile_summary[i, ]
  cat(sprintf("  %2d   |   %4.1f%% - %5.1f%%  | %3d | $%6s | %4.1f | %5.1f | %4.1f | %4.1f |  %4.1f | %4.1f | %5.1f | %+.3f\n",
    r$minority_decile,
    r$min_pct_minority, r$max_pct_minority,
    r$n,
    formatC(r$med_income, format = "d", big.mark = ","),
    r$pct_pov, r$pct_child_pov, r$pct_lt_hs, r$pct_ba,
    r$pct_unemp, r$pct_snap, r$pct_unins, r$ses_idx))
}

# ---- 9. Same decile analysis for Black+Hispanic specifically ----

cat("\n================================================================\n")
cat("SES BY DECILE OF PERCENT BLACK + HISPANIC (VAP)\n")
cat("================================================================\n\n")

tx_clean$bh_decile <- ntile(tx_clean$pct_vap_black_hisp, 10)

bh_summary <- tx_clean %>%
  group_by(bh_decile) %>%
  summarise(
    n = n(),
    min_bh = round(min(pct_vap_black_hisp, na.rm = TRUE) * 100, 1),
    max_bh = round(max(pct_vap_black_hisp, na.rm = TRUE) * 100, 1),
    med_income    = round(median(med_hh_inc, na.rm = TRUE), 0),
    pct_pov       = round(mean(pct_poverty, na.rm = TRUE) * 100, 1),
    pct_child_pov = round(mean(pct_poverty_child, na.rm = TRUE) * 100, 1),
    pct_lt_hs     = round(mean(pct_less_hs, na.rm = TRUE) * 100, 1),
    pct_ba        = round(mean(pct_bachelor, na.rm = TRUE) * 100, 1),
    pct_unemp     = round(mean(pct_unemployed, na.rm = TRUE) * 100, 1),
    pct_snap      = round(mean(pct_snap, na.rm = TRUE) * 100, 1),
    pct_unins     = round(mean(pct_uninsured, na.rm = TRUE) * 100, 1),
    ses_idx       = round(mean(ses_index, na.rm = TRUE), 3),
    .groups = "drop"
  )

cat("Decile | Min-Max Blk+Hisp% |   N | Med Inc | Pov% | ChPov | <HS% |  BA+ | Unemp | SNAP | Unins | SES Idx\n")
cat(strrep("-", 115), "\n")
for (i in 1:nrow(bh_summary)) {
  r <- bh_summary[i, ]
  cat(sprintf("  %2d   |   %4.1f%% - %5.1f%%  | %3d | $%6s | %4.1f | %5.1f | %4.1f | %4.1f |  %4.1f | %4.1f | %5.1f | %+.3f\n",
    r$bh_decile,
    r$min_bh, r$max_bh,
    r$n,
    formatC(r$med_income, format = "d", big.mark = ","),
    r$pct_pov, r$pct_child_pov, r$pct_lt_hs, r$pct_ba,
    r$pct_unemp, r$pct_snap, r$pct_unins, r$ses_idx))
}

# ---- 10. R-squared summary ----

cat("\n================================================================\n")
cat("R-SQUARED: How much SES variation is explained by racial composition?\n")
cat("================================================================\n\n")

cat(sprintf("%-28s | Pct Minority | Pct Blk+Hisp | Pct White\n", "SES Variable"))
cat(strrep("-", 80), "\n")
for (i in seq_along(ses_indicators)) {
  r_min <- cor_full[ses_indicators[i], "pct_vap_minority"]
  r_bh  <- cor_full[ses_indicators[i], "pct_vap_black_hisp"]
  r_w   <- cor_full[ses_indicators[i], "pct_vap_white"]
  cat(sprintf("%-28s |    R2 = %.3f |    R2 = %.3f |  R2 = %.3f\n",
    ses_labels[i], r_min^2, r_bh^2, r_w^2))
}

cat(sprintf("\n%-28s |    R2 = %.3f |    R2 = %.3f |  R2 = %.3f\n",
  "Overall SES Index",
  cor_full["ses_index", "pct_vap_minority"]^2,
  cor_full["ses_index", "pct_vap_black_hisp"]^2,
  cor_full["ses_index", "pct_vap_white"]^2))

cat("\nDone.\n")
