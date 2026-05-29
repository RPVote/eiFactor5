###############################################################
# Regression + CV: Predict Racial Composition from SES + Housing
# Adds: median property value, median rent, homeownership rate,
#       housing cost burden
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

# Housing variables
housing_vars <- c(
  "B25077_001",  # Median property value (owner-occupied)
  "B25064_001",  # Median gross rent
  "B25003_001",  # Total occupied housing units (tenure)
  "B25003_002",  # Owner-occupied units
  "B25003_003",  # Renter-occupied units
  "B25071_001",  # Median gross rent as pct of HH income
  "B25092_001",  # Median selected monthly owner costs as pct of HH income (with mortgage)
  "B25077_001"   # (duplicate, will be unique'd)
)

all_vars <- unique(c("B01001_001", total_vap_male, total_vap_female,
                     race_vap_vars, ses_vars, housing_vars))

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

# ---- 3. Compute SES + Housing indicators ----

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

# Housing indicators
tx$med_property_val  <- tx$B25077_001E
tx$med_gross_rent    <- tx$B25064_001E
tx$pct_owner_occ     <- safe_div(tx$B25003_002E, tx$B25003_001E)
tx$med_rent_burden   <- tx$B25071_001E   # median rent as pct of income
tx$med_owner_burden  <- tx$B25092_001E   # median owner costs as pct of income (w/ mortgage)

# ---- 4. Prepare analysis data ----

# Original 11 SES IVs (same as before)
iv_ses <- c("med_hh_inc", "pct_inc_100k", "pct_inc_125k",
            "pct_snap", "pct_poverty", "pct_poverty_child",
            "pct_poverty_adult", "pct_less_hs", "pct_bachelor",
            "pct_unemployed", "pct_uninsured")

# New housing IVs
iv_housing <- c("med_property_val", "med_gross_rent", "pct_owner_occ",
                "med_rent_burden", "med_owner_burden")

# Combined
iv_all <- c(iv_ses, iv_housing)

iv_labels_all <- c(
  "Med HH Income", "Pct >$100K", "Pct >$125K",
  "Pct SNAP", "Pct Poverty", "Pct Child Pov",
  "Pct Adult Pov", "Pct <HS", "Pct Bachelor+",
  "Pct Unemployed", "Pct Uninsured",
  "Med Property Val", "Med Gross Rent", "Pct Owner-Occ",
  "Med Rent Burden", "Med Owner Burden"
)

dv_names <- c("pct_vap_white", "pct_vap_black", "pct_vap_hispanic",
              "pct_vap_native", "pct_vap_aapi")
dv_labels <- c("Pct White", "Pct Black", "Pct Hispanic",
               "Pct Native", "Pct AAPI")

# Clean and filter
analysis_cols <- c(dv_names, iv_all)
dat <- tx[, c("GEOID", "total_vap", analysis_cols)]
for (col in analysis_cols) {
  dat[[col]][is.infinite(dat[[col]]) | is.nan(dat[[col]])] <- NA
}
dat <- dat[complete.cases(dat[, analysis_cols]) & dat$total_vap > 50, ]
cat("\nComplete cases:", nrow(dat), "tracts\n")

# ---- 5. Compare models: SES only vs SES + Housing ----

cat("\n================================================================\n")
cat("MODEL COMPARISON: SES Only vs SES + Housing\n")
cat("Texas Census Tracts, N =", nrow(dat), "\n")
cat("================================================================\n\n")

iv_formula_ses <- paste(iv_ses, collapse = " + ")
iv_formula_all <- paste(iv_all, collapse = " + ")

cat(sprintf("%-15s | %7s %7s | %7s %7s | %7s  | %s\n",
  "DV", "R2_SES", "AdjR2", "R2_ALL", "AdjR2", "R2 Gain", "F-test p"))
cat(strrep("-", 95), "\n")

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]

  fml_ses <- as.formula(paste(dv, "~", iv_formula_ses))
  fml_all <- as.formula(paste(dv, "~", iv_formula_all))

  mod_ses <- lm(fml_ses, data = dat)
  mod_all <- lm(fml_all, data = dat)

  s_ses <- summary(mod_ses)
  s_all <- summary(mod_all)

  # F-test for nested models
  f_test <- anova(mod_ses, mod_all)
  f_p <- f_test$`Pr(>F)`[2]

  gain <- s_all$r.squared - s_ses$r.squared

  cat(sprintf("%-15s | %7.4f %7.4f | %7.4f %7.4f | %+7.4f | %s\n",
    lbl,
    s_ses$r.squared, s_ses$adj.r.squared,
    s_all$r.squared, s_all$adj.r.squared,
    gain,
    ifelse(f_p < 0.001, "< 0.001 ***",
    ifelse(f_p < 0.01, sprintf("%.4f **", f_p),
    ifelse(f_p < 0.05, sprintf("%.4f *", f_p),
    sprintf("%.4f", f_p))))))
}

# ---- 6. Full coefficients for SES + Housing models ----

cat("\n\n================================================================\n")
cat("FULL REGRESSION RESULTS: SES + Housing Model\n")
cat("================================================================\n")

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]

  fml_all <- as.formula(paste(dv, "~", iv_formula_all))
  mod <- lm(fml_all, data = dat)
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

# ---- 7. Cross-validation comparison ----

cat("\n\n================================================================\n")
cat("CROSS-VALIDATION COMPARISON: 80/20, 100 Reps\n")
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

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  fml_ses <- as.formula(paste(dv, "~", iv_formula_ses))
  fml_all <- as.formula(paste(dv, "~", iv_formula_all))

  for (r in 1:n_reps) {
    test_idx <- sample(1:n, n_test)
    train <- dat[-test_idx, ]
    test <- dat[test_idx, ]

    for (model_type in c("SES", "SES+Housing")) {
      fml <- if (model_type == "SES") fml_ses else fml_all
      mod <- lm(fml, data = train)

      train_pred <- predict(mod, newdata = train)
      test_pred <- predict(mod, newdata = test)

      r2_train <- 1 - sum((train[[dv]] - train_pred)^2) / sum((train[[dv]] - mean(train[[dv]]))^2)
      r2_test <- 1 - sum((test[[dv]] - test_pred)^2) / sum((test[[dv]] - mean(test[[dv]]))^2)
      rmse_test <- sqrt(mean((test[[dv]] - test_pred)^2))
      mae_test <- mean(abs(test[[dv]] - test_pred))

      cv_results <- rbind(cv_results, data.frame(
        dv = dv, model = model_type, rep = r,
        r2_train = r2_train, r2_test = r2_test,
        rmse_test = rmse_test, mae_test = mae_test,
        stringsAsFactors = FALSE
      ))
    }
  }
}

# Summary table
cat(sprintf("%-15s | %-12s | %7s | %7s | %8s | %7s\n",
  "DV", "Model", "R2_trn", "R2_tst", "RMSE_tst", "MAE_tst"))
cat(strrep("-", 75), "\n")

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]

  for (mt in c("SES", "SES+Housing")) {
    sub <- cv_results[cv_results$dv == dv & cv_results$model == mt, ]
    cat(sprintf("%-15s | %-12s | %7.4f | %7.4f | %8.4f | %7.4f\n",
      lbl, mt,
      mean(sub$r2_train), mean(sub$r2_test),
      mean(sub$rmse_test), mean(sub$mae_test)))
  }
  cat(strrep("-", 75), "\n")
}

# ---- 8. Prediction accuracy comparison ----

cat("\n\n================================================================\n")
cat("PREDICTION ACCURACY: Pct of Tracts Within +/- X Pct Points\n")
cat("(Single 80/20 split)\n")
cat("================================================================\n\n")

set.seed(123)
test_idx <- sample(1:n, n_test)
train <- dat[-test_idx, ]
test <- dat[test_idx, ]

cat(sprintf("%-15s | %-12s | %7s | %7s | %7s | %7s | %7s\n",
  "DV", "Model", "Med|e|", "+/-5pp", "+/-10pp", "+/-15pp", "+/-20pp"))
cat(strrep("-", 85), "\n")

for (i in seq_along(dv_names)) {
  dv <- dv_names[i]
  lbl <- dv_labels[i]

  for (mt in c("SES", "SES+Housing")) {
    fml <- if (mt == "SES") as.formula(paste(dv, "~", iv_formula_ses)) else
                             as.formula(paste(dv, "~", iv_formula_all))
    mod <- lm(fml, data = train)
    pred <- predict(mod, newdata = test)
    resid <- abs(test[[dv]] - pred)
    med_err <- median(resid)

    cat(sprintf("%-15s | %-12s | %6.1f%% | %5.1f%% | %5.1f%% | %5.1f%% | %5.1f%%\n",
      lbl, mt,
      med_err * 100,
      mean(resid <= 0.05) * 100,
      mean(resid <= 0.10) * 100,
      mean(resid <= 0.15) * 100,
      mean(resid <= 0.20) * 100))
  }
  cat(strrep("-", 85), "\n")
}

# ---- 9. Standardized betas for SES+Housing model ----

cat("\n\n================================================================\n")
cat("STANDARDIZED COEFFICIENTS: SES + Housing Model\n")
cat("================================================================\n\n")

dat_std <- dat
for (iv in iv_all) {
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
  fml <- as.formula(paste(dv, "~", iv_formula_all))
  mod <- lm(fml, data = dat_std)
  std_coefs[[dv]] <- coef(mod)[-1]
}

for (j in seq_along(iv_all)) {
  iv <- iv_all[j]
  lbl <- iv_labels_all[j]
  cat(sprintf("%-22s", lbl))
  for (i in seq_along(dv_names)) {
    beta <- std_coefs[[dv_names[i]]][iv]
    cat(sprintf(" | %+10.4f ", beta))
  }
  cat("\n")
}

# ---- 10. Bivariate correlations for housing vars ----

cat("\n\n================================================================\n")
cat("BIVARIATE CORRELATIONS: Housing Variables vs Racial Composition\n")
cat("================================================================\n\n")

housing_labels <- c("Med Property Value", "Med Gross Rent", "Pct Owner-Occupied",
                     "Med Rent Burden", "Med Owner Burden")

cat(sprintf("%-22s", "Housing Variable"))
for (lbl in dv_labels) cat(sprintf(" | %11s", lbl))
cat("\n")
cat(strrep("-", 22 + length(dv_labels) * 14), "\n")

for (j in seq_along(iv_housing)) {
  hv <- iv_housing[j]
  lbl <- housing_labels[j]
  cat(sprintf("%-22s", lbl))
  for (i in seq_along(dv_names)) {
    r <- cor(dat[[hv]], dat[[dv_names[i]]], use = "pairwise.complete.obs")
    cat(sprintf(" | %+10.3f ", r))
  }
  cat("\n")
}

cat("\nDone.\n")
