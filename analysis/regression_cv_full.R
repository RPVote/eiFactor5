###############################################################
# Regression + CV: Predict Racial Composition
# IVs: 11 SES + 5 Housing + Pct Foreign Born
# State: Texas, Census Tracts, ACS 2022
###############################################################

library(tidycensus)
library(dplyr)

# ---- 1. Pull data ----

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

housing_vars <- c(
  "B25077_001",  # Median property value
  "B25064_001",  # Median gross rent
  "B25003_001",  # Total occupied housing units
  "B25003_002",  # Owner-occupied
  "B25003_003",  # Renter-occupied
  "B25071_001",  # Median gross rent as pct of HH income
  "B25092_001"   # Median owner costs as pct of HH income
)

# Foreign born
foreign_born_vars <- c(
  "B05002_001",  # Total population
  "B05002_013"   # Foreign born
)

all_vars <- unique(c("B01001_001", total_vap_male, total_vap_female,
                     race_vap_vars, ses_vars, housing_vars, foreign_born_vars))

cat("Total variables:", length(all_vars), "\n")
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

# ---- 3. Compute indicators ----

safe_div <- function(num, denom) ifelse(denom == 0 | is.na(denom), NA_real_, num / denom)

hh_total <- tx$B19001_001E
tx$med_hh_inc       <- tx$B19013_001E
tx$pct_inc_100k     <- safe_div(tx$B19001_014E + tx$B19001_015E + tx$B19001_016E + tx$B19001_017E, hh_total)
tx$pct_inc_125k     <- safe_div(tx$B19001_015E + tx$B19001_016E + tx$B19001_017E, hh_total)
tx$pct_poverty      <- safe_div(tx$B17001_002E, tx$B17001_001E)

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
tx$pct_less_hs      <- safe_div(less_hs, tx$B15003_001E)
bach_plus <- tx$B15003_022E + tx$B15003_023E + tx$B15003_024E + tx$B15003_025E
tx$pct_bachelor     <- safe_div(bach_plus, tx$B15003_001E)
tx$pct_unemployed   <- safe_div(tx$B23025_005E, tx$B23025_003E)
tx$pct_snap         <- safe_div(tx$B22010_002E, tx$B22010_001E)
unins <- tx$B27010_017E + tx$B27010_033E + tx$B27010_050E + tx$B27010_066E
tx$pct_uninsured    <- safe_div(unins, tx$B27010_001E)

# Housing
tx$med_property_val  <- tx$B25077_001E
tx$med_gross_rent    <- tx$B25064_001E
tx$pct_owner_occ     <- safe_div(tx$B25003_002E, tx$B25003_001E)
tx$med_rent_burden   <- tx$B25071_001E
tx$med_owner_burden  <- tx$B25092_001E

# Foreign born
tx$pct_foreign_born  <- safe_div(tx$B05002_013E, tx$B05002_001E)

# ---- 4. Analysis setup ----

iv_ses <- c("med_hh_inc", "pct_inc_100k", "pct_inc_125k",
            "pct_snap", "pct_poverty", "pct_poverty_child",
            "pct_poverty_adult", "pct_less_hs", "pct_bachelor",
            "pct_unemployed", "pct_uninsured")

iv_housing <- c("med_property_val", "med_gross_rent", "pct_owner_occ",
                "med_rent_burden", "med_owner_burden")

iv_foreign <- c("pct_foreign_born")

# Three model specifications
iv_m1 <- iv_ses                                     # SES only
iv_m2 <- c(iv_ses, iv_housing)                      # SES + Housing
iv_m3 <- c(iv_ses, iv_housing, iv_foreign)           # SES + Housing + Foreign Born

iv_labels <- c(
  "Med HH Income", "Pct >$100K", "Pct >$125K",
  "Pct SNAP", "Pct Poverty", "Pct Child Pov",
  "Pct Adult Pov", "Pct <HS", "Pct Bachelor+",
  "Pct Unemployed", "Pct Uninsured",
  "Med Property Val", "Med Gross Rent", "Pct Owner-Occ",
  "Med Rent Burden", "Med Owner Burden",
  "Pct Foreign Born"
)

dv_names <- c("pct_vap_white", "pct_vap_black", "pct_vap_hispanic",
              "pct_vap_native", "pct_vap_aapi")
dv_labels <- c("Pct White", "Pct Black", "Pct Hispanic",
               "Pct Native", "Pct AAPI")

# Clean and filter
analysis_cols <- c(dv_names, iv_m3)
dat <- tx[, c("GEOID", "total_vap", analysis_cols)]
for (col in analysis_cols) {
  dat[[col]][is.infinite(dat[[col]]) | is.nan(dat[[col]])] <- NA
}
dat <- dat[complete.cases(dat[, analysis_cols]) & dat$total_vap > 50, ]
cat("\nComplete cases:", nrow(dat), "tracts\n")

# ---- 5. Bivariate correlation: pct_foreign_born ----

cat("\n================================================================\n")
cat("BIVARIATE CORRELATIONS: Pct Foreign Born vs Racial Composition\n")
cat("================================================================\n\n")

cat(sprintf("Mean Pct Foreign Born: %.1f%%\n", mean(dat$pct_foreign_born) * 100))
cat(sprintf("SD:                    %.1f%%\n", sd(dat$pct_foreign_born) * 100))
cat(sprintf("Range:                 %.1f%% - %.1f%%\n\n",
  min(dat$pct_foreign_born) * 100, max(dat$pct_foreign_born) * 100))

for (i in seq_along(dv_names)) {
  r <- cor(dat$pct_foreign_born, dat[[dv_names[i]]], use = "pairwise.complete.obs")
  cat(sprintf("  Pct Foreign Born x %-15s  r = %+.3f\n", dv_labels[i], r))
}

# ---- 6. Three-model comparison ----

cat("\n\n================================================================\n")
cat("MODEL COMPARISON: SES vs SES+Housing vs SES+Housing+ForeignBorn\n")
cat("Texas Census Tracts, N =", nrow(dat), "\n")
cat("================================================================\n\n")

fml_m1 <- paste(iv_m1, collapse = " + ")
fml_m2 <- paste(iv_m2, collapse = " + ")
fml_m3 <- paste(iv_m3, collapse = " + ")

cat(sprintf("%-12s | %10s | %10s | %10s | %10s | %10s\n",
  "DV", "R2 (SES)", "R2 (+Hous)", "R2 (+FB)", "Gain Hous", "Gain FB"))
cat(strrep("-", 75), "\n")

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]

  m1 <- lm(as.formula(paste(dv, "~", fml_m1)), data = dat)
  m2 <- lm(as.formula(paste(dv, "~", fml_m2)), data = dat)
  m3 <- lm(as.formula(paste(dv, "~", fml_m3)), data = dat)

  r2_1 <- summary(m1)$r.squared
  r2_2 <- summary(m2)$r.squared
  r2_3 <- summary(m3)$r.squared

  cat(sprintf("%-12s | %10.4f | %10.4f | %10.4f | %+10.4f | %+10.4f\n",
    lbl, r2_1, r2_2, r2_3, r2_2 - r2_1, r2_3 - r2_2))
}

# ---- 7. Full regression: SES + Housing + Foreign Born ----

cat("\n\n================================================================\n")
cat("FULL REGRESSION: SES + Housing + Foreign Born\n")
cat("================================================================\n")

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]

  mod <- lm(as.formula(paste(dv, "~", fml_m3)), data = dat)
  s <- summary(mod)

  cat("\n------------------------------------------------------------\n")
  cat("DV:", lbl, "| R2 =", round(s$r.squared, 4),
      "| Adj R2 =", round(s$adj.r.squared, 4),
      "| RMSE =", round(sqrt(mean(s$residuals^2)), 4), "\n")
  cat("------------------------------------------------------------\n")

  coefs <- as.data.frame(s$coefficients)
  coefs$sig <- ifelse(coefs[,4] < 0.001, "***",
               ifelse(coefs[,4] < 0.01, "**",
               ifelse(coefs[,4] < 0.05, "*",
               ifelse(coefs[,4] < 0.1, ".", ""))))

  cat(sprintf("%-22s %12s %10s %10s %5s\n", "Variable", "Estimate", "Std.Err", "t-value", ""))
  cat(strrep("-", 65), "\n")
  for (j in 1:nrow(coefs)) {
    cat(sprintf("%-22s %12.6f %10.6f %10.3f %5s\n",
      rownames(coefs)[j], coefs[j,1], coefs[j,2], coefs[j,3], coefs[j,5]))
  }
}

# ---- 8. Cross-validation: all three models ----

cat("\n\n================================================================\n")
cat("CROSS-VALIDATION: 80/20, 100 Reps, All Three Models\n")
cat("================================================================\n\n")

set.seed(42)
n_reps <- 100
n <- nrow(dat)
n_test <- round(n * 0.2)

cv_results <- data.frame(
  dv = character(), model = character(), rep = integer(),
  r2_train = numeric(), r2_test = numeric(),
  rmse_test = numeric(), mae_test = numeric(),
  stringsAsFactors = FALSE
)

model_specs <- list(
  "SES" = fml_m1,
  "SES+Housing" = fml_m2,
  "SES+Hous+FB" = fml_m3
)

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]

  for (r in 1:n_reps) {
    test_idx <- sample(1:n, n_test)
    train_d <- dat[-test_idx, ]
    test_d <- dat[test_idx, ]

    for (mname in names(model_specs)) {
      fml <- as.formula(paste(dv, "~", model_specs[[mname]]))
      mod <- lm(fml, data = train_d)

      train_pred <- predict(mod, newdata = train_d)
      test_pred <- predict(mod, newdata = test_d)

      r2_train <- 1 - sum((train_d[[dv]] - train_pred)^2) / sum((train_d[[dv]] - mean(train_d[[dv]]))^2)
      r2_test <- 1 - sum((test_d[[dv]] - test_pred)^2) / sum((test_d[[dv]] - mean(test_d[[dv]]))^2)
      rmse_test <- sqrt(mean((test_d[[dv]] - test_pred)^2))
      mae_test <- mean(abs(test_d[[dv]] - test_pred))

      cv_results <- rbind(cv_results, data.frame(
        dv = dv, model = mname, rep = r,
        r2_train = r2_train, r2_test = r2_test,
        rmse_test = rmse_test, mae_test = mae_test,
        stringsAsFactors = FALSE
      ))
    }
  }
}

cat(sprintf("%-12s | %-14s | %7s | %7s | %8s | %7s\n",
  "DV", "Model", "R2_trn", "R2_tst", "RMSE_tst", "MAE_tst"))
cat(strrep("-", 70), "\n")

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]

  for (mt in names(model_specs)) {
    sub <- cv_results[cv_results$dv == dv & cv_results$model == mt, ]
    cat(sprintf("%-12s | %-14s | %7.4f | %7.4f | %8.4f | %7.4f\n",
      lbl, mt,
      mean(sub$r2_train), mean(sub$r2_test),
      mean(sub$rmse_test), mean(sub$mae_test)))
  }
  cat(strrep("-", 70), "\n")
}

# ---- 9. Prediction accuracy comparison ----

cat("\n\n================================================================\n")
cat("PREDICTION ACCURACY: Single 80/20 Split\n")
cat("================================================================\n\n")

set.seed(123)
test_idx <- sample(1:n, n_test)
train_d <- dat[-test_idx, ]
test_d <- dat[test_idx, ]

cat(sprintf("%-12s | %-14s | %7s | %7s | %7s | %7s\n",
  "DV", "Model", "Med|e|", "+/-5pp", "+/-10pp", "+/-15pp"))
cat(strrep("-", 70), "\n")

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]

  for (mname in names(model_specs)) {
    fml <- as.formula(paste(dv, "~", model_specs[[mname]]))
    mod <- lm(fml, data = train_d)
    pred <- predict(mod, newdata = test_d)
    resid <- abs(test_d[[dv]] - pred)

    cat(sprintf("%-12s | %-14s | %5.1f%% | %5.1f%% | %5.1f%% | %5.1f%%\n",
      lbl, mname,
      median(resid) * 100,
      mean(resid <= 0.05) * 100,
      mean(resid <= 0.10) * 100,
      mean(resid <= 0.15) * 100))
  }
  cat(strrep("-", 70), "\n")
}

# ---- 10. Standardized coefficients ----

cat("\n\n================================================================\n")
cat("STANDARDIZED COEFFICIENTS: Full Model (SES+Housing+ForeignBorn)\n")
cat("================================================================\n\n")

dat_std <- dat
for (iv in iv_m3) {
  dat_std[[iv]] <- (dat_std[[iv]] - mean(dat_std[[iv]], na.rm = TRUE)) /
                    sd(dat_std[[iv]], na.rm = TRUE)
}

cat(sprintf("%-22s", "Variable"))
for (lbl in dv_labels) cat(sprintf(" | %11s", lbl))
cat("\n")
cat(strrep("-", 22 + length(dv_labels) * 14), "\n")

std_coefs <- list()
for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  fml <- as.formula(paste(dv, "~", fml_m3))
  mod <- lm(fml, data = dat_std)
  std_coefs[[dv]] <- coef(mod)[-1]
}

for (j in seq_along(iv_m3)) {
  iv <- iv_m3[j]
  lbl <- iv_labels[j]
  cat(sprintf("%-22s", lbl))
  for (i in seq_along(dv_names)) {
    beta <- std_coefs[[dv_names[i]]][iv]
    cat(sprintf(" | %+10.4f ", beta))
  }
  cat("\n")
}

cat("\nDone.\n")
