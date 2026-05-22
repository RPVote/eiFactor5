#' @title Choropleth Map of SES Indicators
#' @description Generates a choropleth map showing the spatial distribution of
#'   a single SES indicator for a chosen racial/ethnic group.
#'
#' @param data Output from \code{\link{f5_fetch}} with \code{geometry = TRUE}.
#' @param indicator SES indicator ID to map (e.g., \code{"pct_below_poverty"}).
#'   See \code{\link{f5_indicators}} for valid IDs.
#' @param group Racial/ethnic group to map (e.g., \code{"native"}).
#' @param title Optional plot title. If \code{NULL}, auto-generated.
#' @param palette Color palette name for \code{scale_fill_viridis_c}.
#'   Default: \code{"viridis"}.
#'
#' @return A \code{ggplot2} object.
#'
#' @details
#' The \code{data} argument must have been created with
#' \code{f5_fetch(..., geometry = TRUE)} so that spatial geometry is available
#' for mapping.
#'
#' @examples
#' \dontrun{
#' dat <- f5_fetch(state = "NM", county = c("049","039","055"),
#'                 geography = "tract", geometry = TRUE,
#'                 groups = c("white", "native"))
#' f5_map(dat, indicator = "pct_below_poverty", group = "native")
#' }
#'
#' @export
#' @importFrom ggplot2 ggplot geom_sf aes labs theme_minimal
f5_map <- function(data,
                   indicator,
                   group,
                   title = NULL,
                   palette = "viridis") {

  if (!inherits(data, "sf")) {
    stop("'data' must have geometry. Use f5_fetch(..., geometry = TRUE).")
  }

  col_name <- paste0(indicator, "_", group)
  if (!col_name %in% names(data)) {
    stop("Column '", col_name, "' not found in data. ",
         "Check indicator and group names.")
  }

  meta <- indicator_meta()
  ind_label <- meta$label[meta$id == indicator]
  if (length(ind_label) == 0) ind_label <- indicator
  grp_label <- group_display_name(group)

  if (is.null(title)) {
    title <- paste0(ind_label, " - ", grp_label)
  }

  year <- attr(data, "year")
  geo <- attr(data, "geography")
  subtitle <- paste0("ACS ", year, ", ", geo, "-level")

  is_pct <- meta$summary_type[meta$id == indicator] == "proportion"

  p <- ggplot2::ggplot(data) +
    ggplot2::geom_sf(ggplot2::aes(fill = .data[[col_name]]),
                     color = "white", size = 0.1) +
    ggplot2::labs(
      title = title,
      subtitle = subtitle,
      fill = ind_label
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank()
    )

  if (length(is_pct) > 0 && is_pct) {
    p <- p + ggplot2::scale_fill_viridis_c(
      option = palette,
      labels = scales_pct_label,
      na.value = "grey80"
    )
  } else {
    p <- p + ggplot2::scale_fill_viridis_c(
      option = palette,
      labels = function(x) paste0("$", formatC(x, format = "f",
                                                digits = 0, big.mark = ",")),
      na.value = "grey80"
    )
  }

  p
}
