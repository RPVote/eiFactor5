###############################################################
# Regression + Cross-Validation: Predict Racial Composition
# from SES Indicators
# DV: pct_vap_white, pct_vap_black, pct_vap_hispanic,
#     pct_vap_native, pct_vap_aapi
# IV: 11 SES indicators (drop disability - bad data)
# State: Texas, Census Tracts, ACS 2022
###############################################################

library(tidycensus)
library(dplyr)

# ---- 1. Pull and compute data (same as before) ----

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

# Compute VAP
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

# Compute SES
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

# ---- 2. Prepare analysis data ----

iv_names <- c("med_hh_inc", "pct_inc_100k", "pct_inc_125k",
              "pct_snap", "pct_poverty", "pct_poverty_child",
              "pct_poverty_adult", "pct_less_hs", "pct_bachelor",
              "pct_unemployed", "pct_uninsured")

dv_names <- c("pct_vap_white", "pct_vap_black", "pct_vap_hispanic",
              "pct_vap_native", "pct_vap_aapi")

dv_labels <- c("Pct White (VAP)", "Pct Black (VAP)", "Pct Hispanic (VAP)",
               "Pct Native (VAP)", "Pct AAPI (VAP)")

# Filter to valid tracts
analysis_cols <- c(dv_names, iv_names)
dat <- tx[, c("GEOID", analysis_cols)]
for (col in analysis_cols) {
  dat[[col]][is.infinite(dat[[col]]) | is.nan(dat[[col]])] <- NA
}
dat <- dat[complete.cases(dat[, analysis_cols]), ]
dat <- dat[tx$total_vap[match(dat$GEOID, tx$GEOID)] > 50, ]
cat("\nComplete cases with VAP > 50:", nrow(dat), "tracts\n")

# ---- 3. Full-sample OLS regressions ----

cat("\n================================================================\n")
cat("FULL-SAMPLE OLS REGRESSION: SES Indicators -> Racial Composition\n")
cat("Texas Census Tracts, N =", nrow(dat), "\n")
cat("================================================================\n")

iv_formula <- paste(iv_names, collapse = " + ")

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]

  fml <- as.formula(paste(dv, "~", iv_formula))
  mod <- lm(fml, data = dat)
  s <- summary(mod)

  cat("\n------------------------------------------------------------\n")
  cat("DV:", lbl, "\n")
  cat("------------------------------------------------------------\n")
  cat(sprintf("R-squared:     %.4f\n", s$r.squared))
  cat(sprintf("Adj R-squared: %.4f\n", s$adj.r.squared))
  cat(sprintf("F-statistic:   %.1f (df = %d, %d), p < 2.2e-16\n",
    s$fstatistic[1], s$fstatistic[2], s$fstatistic[3]))
  cat(sprintf("RMSE:          %.4f\n", sqrt(mean(s$residuals^2))))
  cat(sprintf("Mean DV:       %.4f\n", mean(dat[[dv]])))
  cat(sprintf("SD DV:         %.4f\n", sd(dat[[dv]])))

  # Print coefficients
  coefs <- as.data.frame(s$coefficients)
  coefs$sig <- ifelse(coefs[,4] < 0.001, "***",
               ifelse(coefs[,4] < 0.01, "**",
               ifelse(coefs[,4] < 0.05, "*",
               ifelse(coefs[,4] < 0.1, ".", ""))))

  cat("\nCoefficients:\n")
  cat(sprintf("%-22s %12s %10s %10s %5s\n", "Variable", "Estimate", "Std.Err", "t-value", ""))
  cat(strrep("-", 65), "\n")
  for (j in 1:nrow(coefs)) {
    cat(sprintf("%-22s %12.6f %10.6f %10.3f %5s\n",
      rownames(coefs)[j], coefs[j,1], coefs[j,2], coefs[j,3], coefs[j,5]))
  }
  cat("Signif: *** p<0.001, ** p<0.01, * p<0.05, . p<0.1\n")
}

# ---- 4. Cross-validation: 80/20 split, repeated 100 times ----

cat("\n\n================================================================\n")
cat("CROSS-VALIDATION: 80% Train / 20% Test, 100 Repetitions\n")
cat("================================================================\n\n")

set.seed(42)
n_reps <- 100
n <- nrow(dat)
n_test <- round(n * 0.2)

# Storage for results
cv_results <- data.frame(
  dv = character(),
  rep = integer(),
  r2_train = numeric(),
  r2_test = numeric(),
  rmse_train = numeric(),
  rmse_test = numeric(),
  mae_test = numeric(),
  cor_test = numeric(),
  stringsAsFactors = FALSE
)

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  fml <- as.formula(paste(dv, "~", iv_formula))

  for (r in 1:n_reps) {
    test_idx <- sample(1:n, n_test)
    train <- dat[-test_idx, ]
    test <- dat[test_idx, ]

    mod <- lm(fml, data = train)

    # Train metrics
    train_pred <- predict(mod, newdata = train)
    train_actual <- train[[dv]]
    ss_res_train <- sum((train_actual - train_pred)^2)
    ss_tot_train <- sum((train_actual - mean(train_actual))^2)
    r2_train <- 1 - ss_res_train / ss_tot_train
    rmse_train <- sqrt(mean((train_actual - train_pred)^2))

    # Test metrics
    test_pred <- predict(mod, newdata = test)
    test_actual <- test[[dv]]
    ss_res_test <- sum((test_actual - test_pred)^2)
    ss_tot_test <- sum((test_actual - mean(test_actual))^2)
    r2_test <- 1 - ss_res_test / ss_tot_test
    rmse_test <- sqrt(mean((test_actual - test_pred)^2))
    mae_test <- mean(abs(test_actual - test_pred))
    cor_test <- cor(test_actual, test_pred)

    cv_results <- rbind(cv_results, data.frame(
      dv = dv, rep = r,
      r2_train = r2_train, r2_test = r2_test,
      rmse_train = rmse_train, rmse_test = rmse_test,
      mae_test = mae_test, cor_test = cor_test,
      stringsAsFactors = FALSE
    ))
  }
}

# Summarize CV results
cat(sprintf("%-20s | %7s | %7s | %7s | %8s | %8s | %7s | %7s\n",
  "DV", "R2_trn", "R2_tst", "Drop", "RMSE_trn", "RMSE_tst", "MAE_tst", "Cor_tst"))
cat(strrep("-", 100), "\n")

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]
  sub <- cv_results[cv_results$dv == dv, ]

  r2_trn <- mean(sub$r2_train)
  r2_tst <- mean(sub$r2_test)
  drop <- r2_trn - r2_tst
  rmse_trn <- mean(sub$rmse_train)
  rmse_tst <- mean(sub$rmse_test)
  mae_tst <- mean(sub$mae_test)
  cor_tst <- mean(sub$cor_test)

  cat(sprintf("%-20s | %7.4f | %7.4f | %7.4f | %8.4f | %8.4f | %7.4f | %7.4f\n",
    lbl, r2_trn, r2_tst, drop, rmse_trn, rmse_tst, mae_tst, cor_tst))
}

# ---- 5. Distribution of test R2 across reps ----

cat("\n\n================================================================\n")
cat("DISTRIBUTION OF TEST R-SQUARED ACROSS 100 CV REPETITIONS\n")
cat("================================================================\n\n")

cat(sprintf("%-20s | %7s | %7s | %7s | %7s | %7s\n",
  "DV", "Min", "Q25", "Median", "Q75", "Max"))
cat(strrep("-", 70), "\n")

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]
  r2s <- cv_results$r2_test[cv_results$dv == dv]
  q <- quantile(r2s)
  cat(sprintf("%-20s | %7.4f | %7.4f | %7.4f | %7.4f | %7.4f\n",
    lbl, q[1], q[2], q[3], q[4], q[5]))
}

# ---- 6. Single 80/20 split: detailed residual analysis ----

cat("\n\n================================================================\n")
cat("SINGLE 80/20 SPLIT: PREDICTION ACCURACY DETAIL\n")
cat("================================================================\n\n")

set.seed(123)
test_idx <- sample(1:n, n_test)
train <- dat[-test_idx, ]
test <- dat[test_idx, ]

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]
  fml <- as.formula(paste(dv, "~", iv_formula))

  mod <- lm(fml, data = train)
  test$pred <- predict(mod, newdata = test)
  test$resid <- test[[dv]] - test$pred

  cat("--- ", lbl, "---\n")
  cat(sprintf("  Train R2:              %.4f\n", summary(mod)$r.squared))

  ss_res <- sum(test$resid^2)
  ss_tot <- sum((test[[dv]] - mean(test[[dv]]))^2)
  test_r2 <- 1 - ss_res / ss_tot
  cat(sprintf("  Test R2:               %.4f\n", test_r2))
  cat(sprintf("  Test RMSE:             %.4f\n", sqrt(mean(test$resid^2))))
  cat(sprintf("  Test MAE:              %.4f\n", mean(abs(test$resid))))
  cat(sprintf("  Test cor(actual,pred): %.4f\n", cor(test[[dv]], test$pred)))

  # Residual quantiles
  rq <- quantile(abs(test$resid), probs = c(0.5, 0.75, 0.9, 0.95))
  cat(sprintf("  |Residual| median:     %.4f (%.1f pct pts)\n", rq[1], rq[1]*100))
  cat(sprintf("  |Residual| 75th:       %.4f (%.1f pct pts)\n", rq[2], rq[2]*100))
  cat(sprintf("  |Residual| 90th:       %.4f (%.1f pct pts)\n", rq[3], rq[3]*100))
  cat(sprintf("  |Residual| 95th:       %.4f (%.1f pct pts)\n", rq[4], rq[4]*100))

  # Within-X pct points accuracy
  for (threshold in c(0.05, 0.10, 0.15)) {
    pct_within <- mean(abs(test$resid) <= threshold) * 100
    cat(sprintf("  Within +/-%d pct pts:   %.1f%% of tracts\n",
      as.integer(threshold * 100), pct_within))
  }
  cat("\n")
}

# ---- 7. Variable importance (standardized betas) ----

cat("\n================================================================\n")
cat("STANDARDIZED COEFFICIENTS (VARIABLE IMPORTANCE)\n")
cat("================================================================\n\n")

# Standardize all IVs
dat_std <- dat
for (iv in iv_names) {
  dat_std[[iv]] <- (dat_std[[iv]] - mean(dat_std[[iv]], na.rm = TRUE)) /
                    sd(dat_std[[iv]], na.rm = TRUE)
}

cat(sprintf("%-22s", "Variable"))
for (lbl in dv_labels) cat(sprintf(" | %15s", lbl))
cat("\n")
cat(strrep("-", 22 + length(dv_labels) * 18), "\n")

std_coefs <- list()
for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  fml <- as.formula(paste(dv, "~", iv_formula))
  mod <- lm(fml, data = dat_std)
  std_coefs[[dv]] <- coef(mod)[-1]  # drop intercept
}

for (iv in iv_names) {
  cat(sprintf("%-22s", iv))
  for (i in seq_along(dv_names)) {
    beta <- std_coefs[[dv_names[i]]][iv]
    cat(sprintf(" | %+14.4f ", beta))
  }
  cat("\n")
}

cat("\nDone.\n")
