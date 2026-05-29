#' @title Visualize Factor 5 SES Disparities
#' @description Generates ggplot2 bar or dot charts showing SES indicator
#'   values across racial/ethnic groups.
#'
#' @param data Output from \code{\link{f5_fetch}}.
#' @param ref_group Reference group. Default: \code{"white"}.
#' @param compare_groups Character vector of comparison groups. Default: all
#'   groups in data except the reference.
#' @param type Plot type: \code{"bar"} (grouped bar chart, default) or
#'   \code{"dot"} (Cleveland dot plot).
#' @param indicators Character vector of indicator IDs to plot. Default: all
#'   proportion-based indicators (excludes median income for cleaner scaling).
#'
#' @return A \code{ggplot2} object.
#'
#' @examples
#' \dontrun{
#' dat <- f5_fetch(state = "MS", geography = "county")
#' f5_plot(dat, ref_group = "white", compare_groups = "black")
#' f5_plot(dat,
#'   ref_group = "white",
#'   compare_groups = c("black", "hispanic"),
#'   type = "dot"
#' )
#' }
#'
#' @export
#' @importFrom ggplot2 ggplot aes geom_bar labs theme_minimal element_text
#' @importFrom dplyr %>% mutate filter select summarise
#' @importFrom rlang .data
f5_plot <- function(data,
                    ref_group = "white",
                    compare_groups = NULL,
                    type = "bar",
                    indicators = NULL) {
  groups <- attr(data, "groups")
  if (is.null(compare_groups)) {
    compare_groups <- setdiff(groups, ref_group)
  }

  meta <- indicator_meta()
  if (is.null(indicators)) {
    # Default: proportion-based indicators only (better scale)
    meta <- meta[meta$summary_type == "proportion", ]
  } else {
    meta <- meta[meta$id %in% indicators, ]
  }

  all_groups <- c(ref_group, compare_groups)

  # Build long-format summary data
  plot_data <- do.call(rbind, lapply(seq_len(nrow(meta)), function(i) {
    ind_id <- meta$id[i]
    do.call(rbind, lapply(all_groups, function(grp) {
      col_name <- paste0(ind_id, "_", grp)
      vals <- data[[col_name]]
      vals <- vals[!is.na(vals)]
      if (length(vals) == 0) {
        return(NULL)
      }

      if (meta$summary_type[i] == "median") {
        val <- stats::median(vals)
      } else {
        val <- mean(vals)
      }

      data.frame(
        indicator = meta$label[i],
        group = group_display_name(grp),
        value = val,
        stringsAsFactors = FALSE
      )
    }))
  }))

  if (is.null(plot_data) || nrow(plot_data) == 0) {
    stop("No data available for the selected indicators and groups.")
  }

  # Order indicators as in metadata
  plot_data$indicator <- factor(plot_data$indicator, levels = rev(meta$label))
  # Order groups: ref first
  grp_levels <- c(
    group_display_name(ref_group),
    sapply(compare_groups, group_display_name)
  )
  plot_data$group <- factor(plot_data$group, levels = grp_levels)

  year <- attr(data, "year")
  geo <- attr(data, "geography")
  subtitle <- paste0("ACS ", year, ", ", geo, "-level data")

  if (type == "dot") {
    p <- ggplot2::ggplot(
      plot_data,
      ggplot2::aes(
        x = .data$value,
        y = .data$indicator,
        color = .data$group,
        shape = .data$group
      )
    ) +
      ggplot2::geom_point(size = 3) +
      ggplot2::scale_x_continuous(labels = scales_pct_label) +
      ggplot2::labs(
        title = "Factor 5: SES Indicators by Race/Ethnicity",
        subtitle = subtitle,
        x = NULL,
        y = NULL,
        color = "Group",
        shape = "Group"
      ) +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        legend.position = "bottom",
        axis.text.y = ggplot2::element_text(size = 10)
      )
  } else {
    p <- ggplot2::ggplot(
      plot_data,
      ggplot2::aes(
        x = .data$indicator,
        y = .data$value,
        fill = .data$group
      )
    ) +
      ggplot2::geom_bar(stat = "identity", position = "dodge") +
      ggplot2::scale_y_continuous(labels = scales_pct_label) +
      ggplot2::coord_flip() +
      ggplot2::labs(
        title = "Factor 5: SES Indicators by Race/Ethnicity",
        subtitle = subtitle,
        x = NULL,
        y = NULL,
        fill = "Group"
      ) +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        legend.position = "bottom",
        axis.text.y = ggplot2::element_text(size = 10)
      )
  }

  p
}

#' Simple percentage label function (avoids scales dependency)
#' @keywords internal
scales_pct_label <- function(x) {
  paste0(round(x * 100, 1), "%")
}
