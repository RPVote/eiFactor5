#' @title Pairwise Statistical Comparisons
#' @description Runs pairwise statistical tests between a reference group and
#'   a comparison group across all 12 SES indicators.
#'
#' @param data Output from \code{\link{f5_fetch}}.
#' @param ref_group Reference group. Default: \code{"white"}.
#' @param compare_group Single comparison group (e.g., \code{"black"}).
#' @param indicators Character vector of indicator IDs. Default: all 12.
#'
#' @return A data.frame with one row per indicator and columns:
#'   \itemize{
#'     \item \code{indicator}: Indicator ID
#'     \item \code{label}: Display label
#'     \item \code{ref_mean}: Mean (or median for income) of reference group
#'     \item \code{compare_mean}: Mean (or median) of comparison group
#'     \item \code{diff}: Difference (ref - compare)
#'     \item \code{t_stat}: Welch's t-statistic (NA if N = 1)
#'     \item \code{p_value}: p-value (NA if N = 1)
#'     \item \code{significant}: Logical, TRUE if p < 0.05
#'   }
#'
#' @examples
#' \dontrun{
#' dat <- f5_fetch(state = "GA", geography = "county")
#' f5_compare(dat, ref_group = "white", compare_group = "black")
#' }
#'
#' @export
#' @importFrom stats t.test
f5_compare <- function(data,
                       ref_group = "white",
                       compare_group,
                       indicators = NULL) {

  groups <- attr(data, "groups")
  if (is.null(groups)) {
    stop("'data' must be output from f5_fetch() with group metadata.")
  }
  if (!ref_group %in% groups) {
    stop("ref_group '", ref_group, "' not in data.")
  }
  if (!compare_group %in% groups) {
    stop("compare_group '", compare_group, "' not in data.")
  }

  meta <- indicator_meta()
  if (!is.null(indicators)) {
    meta <- meta[meta$id %in% indicators, ]
  }

  n_obs <- nrow(data)
  results <- vector("list", nrow(meta))

  for (i in seq_len(nrow(meta))) {
    ind_id <- meta$id[i]
    ref_vals <- data[[paste0(ind_id, "_", ref_group)]]
    cmp_vals <- data[[paste0(ind_id, "_", compare_group)]]

    ref_clean <- ref_vals[!is.na(ref_vals)]
    cmp_clean <- cmp_vals[!is.na(cmp_vals)]

    if (meta$summary_type[i] == "median") {
      ref_stat <- if (length(ref_clean) > 0) stats::median(ref_clean) else NA_real_
      cmp_stat <- if (length(cmp_clean) > 0) stats::median(cmp_clean) else NA_real_
    } else {
      ref_stat <- if (length(ref_clean) > 0) mean(ref_clean) else NA_real_
      cmp_stat <- if (length(cmp_clean) > 0) mean(cmp_clean) else NA_real_
    }

    d <- ref_stat - cmp_stat
    t_val <- NA_real_
    p_val <- NA_real_

    if (n_obs > 1 && length(ref_clean) > 1 && length(cmp_clean) > 1) {
      tt <- tryCatch(
        stats::t.test(ref_vals, cmp_vals, na.action = na.omit),
        error = function(e) NULL
      )
      if (!is.null(tt)) {
        t_val <- as.numeric(tt$statistic)
        p_val <- tt$p.value
      }
    }

    results[[i]] <- data.frame(
      indicator = ind_id,
      label = meta$label[i],
      ref_mean = ref_stat,
      compare_mean = cmp_stat,
      diff = d,
      t_stat = t_val,
      p_value = p_val,
      significant = ifelse(is.na(p_val), NA, p_val < 0.05),
      stringsAsFactors = FALSE
    )
  }

  do.call(rbind, results)
}
