#' @title Factor 5 Comparison Table
#' @description Creates a publication-ready comparison table of SES indicators
#'   across racial/ethnic groups with summary statistics and significance tests.
#'
#' @param data Output from \code{\link{f5_fetch}}.
#' @param ref_group Reference group for comparisons. Default: \code{"white"}.
#' @param compare_groups Character vector of groups to compare against the
#'   reference. Default: all groups in the data except the reference.
#' @param indicators Character vector of indicator IDs to include (e.g.,
#'   \code{"pct_snap"}, \code{"med_hh_inc"}). Default: all 12 indicators.
#'   See \code{\link{f5_indicators}} for valid IDs.
#'
#' @return A data.frame with columns:
#'   \itemize{
#'     \item \code{Indicator}: Display label for the SES variable
#'     \item One column per group with summary statistics (median for income,
#'       mean for proportions)
#'     \item For each comparison group: \code{Diff}, \code{t_stat}, and
#'       \code{p_value} columns
#'   }
#'
#' @details
#' When multiple sub-geographies are present (N > 1), summary statistics are
#' computed as:
#' \itemize{
#'   \item Median Household Income: median across sub-geographies
#'   \item All other indicators (proportions): mean across sub-geographies
#' }
#' Statistical significance is assessed via Welch's t-test. For single
#' geography data (N = 1), point estimates and differences are reported
#' without p-values.
#'
#' @examples
#' \dontrun{
#' dat <- f5_fetch(state = "MS", geography = "county")
#' f5_table(dat, ref_group = "white", compare_groups = "black")
#'
#' # Multiple comparison groups, select indicators
#' f5_table(dat, ref_group = "white",
#'          compare_groups = c("black", "hispanic"),
#'          indicators = c("med_hh_inc", "pct_below_poverty", "pct_bachelor"))
#' }
#'
#' @export
#' @importFrom stats median sd t.test
f5_table <- function(data,
                     ref_group = "white",
                     compare_groups = NULL,
                     indicators = NULL) {

  groups <- attr(data, "groups")
  if (is.null(groups)) {
    stop("'data' must be output from f5_fetch() with group metadata.")
  }

  if (!ref_group %in% groups) {
    stop("ref_group '", ref_group, "' not found in data. ",
         "Available groups: ", paste(groups, collapse = ", "))
  }

  if (is.null(compare_groups)) {
    compare_groups <- setdiff(groups, ref_group)
  } else {
    missing <- setdiff(compare_groups, groups)
    if (length(missing) > 0) {
      stop("compare_groups not in data: ", paste(missing, collapse = ", "))
    }
  }

  meta <- indicator_meta()
  if (!is.null(indicators)) {
    meta <- meta[meta$id %in% indicators, ]
    if (nrow(meta) == 0) {
      stop("No valid indicators specified. See f5_indicators() for options.")
    }
  }

  n_obs <- nrow(data)

  # Build the result table
  result <- data.frame(Indicator = meta$label, stringsAsFactors = FALSE)

  # Compute summary stat for each group
  all_groups <- c(ref_group, compare_groups)
  for (grp in all_groups) {
    col_vals <- character(nrow(meta))
    for (i in seq_len(nrow(meta))) {
      ind_id <- meta$id[i]
      col_name <- paste0(ind_id, "_", grp)
      vals <- data[[col_name]]
      vals <- vals[!is.na(vals)]

      if (length(vals) == 0) {
        col_vals[i] <- "NA"
      } else if (meta$summary_type[i] == "median") {
        col_vals[i] <- fmt_dollar(stats::median(vals))
      } else {
        col_vals[i] <- fmt_pct(mean(vals))
      }
    }
    result[[group_display_name(grp)]] <- col_vals
  }

  # Add difference and significance tests for each comparison group
  for (cgrp in compare_groups) {
    diff_col <- character(nrow(meta))
    tstat_col <- character(nrow(meta))
    pval_col <- character(nrow(meta))

    for (i in seq_len(nrow(meta))) {
      ind_id <- meta$id[i]
      ref_vals <- data[[paste0(ind_id, "_", ref_group)]]
      cmp_vals <- data[[paste0(ind_id, "_", cgrp)]]

      ref_clean <- ref_vals[!is.na(ref_vals)]
      cmp_clean <- cmp_vals[!is.na(cmp_vals)]

      if (length(ref_clean) == 0 || length(cmp_clean) == 0) {
        diff_col[i] <- "NA"
        tstat_col[i] <- "NA"
        pval_col[i] <- "NA"
        next
      }

      if (meta$summary_type[i] == "median") {
        ref_stat <- stats::median(ref_clean)
        cmp_stat <- stats::median(cmp_clean)
      } else {
        ref_stat <- mean(ref_clean)
        cmp_stat <- mean(cmp_clean)
      }
      d <- ref_stat - cmp_stat

      if (meta$summary_type[i] == "median") {
        diff_col[i] <- fmt_dollar(d)
      } else {
        diff_col[i] <- fmt_pct(d)
      }

      # T-test requires N > 1 for both groups
      if (n_obs > 1 && length(ref_clean) > 1 && length(cmp_clean) > 1) {
        tt <- tryCatch(
          stats::t.test(ref_vals, cmp_vals, na.action = na.omit),
          error = function(e) NULL
        )
        if (!is.null(tt)) {
          tstat_col[i] <- round(tt$statistic, 3)
          pval_col[i] <- format.pval(tt$p.value, digits = 3, eps = 0.001)
        } else {
          tstat_col[i] <- "NA"
          pval_col[i] <- "NA"
        }
      } else {
        tstat_col[i] <- "--"
        pval_col[i] <- "--"
      }
    }

    cgrp_label <- group_display_name(cgrp)
    ref_label <- group_display_name(ref_group)
    result[[paste0(ref_label, "-", cgrp_label)]] <- diff_col
    result[[paste0("t (", cgrp_label, ")")]] <- tstat_col
    result[[paste0("p (", cgrp_label, ")")]] <- pval_col
  }

  result
}
