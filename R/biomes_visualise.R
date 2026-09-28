#' Visualise the biomes workflow (ranking, map and biome composition)
#'
#' Produces the publication figure of the *biomes* workflow for a set of
#' occurrence records. Up to three panels are drawn and combined:
#'
#' * **rank**: the data-driven ranking of the biome schemes
#'   ([biomes_rank()]): the composite score per scheme next to the
#'   criterion values it averages (coverage, effective number of biomes,
#'   granularity), all on the common 0 to 1 scale that enters the
#'   composite (the min-max rescaled values). Schemes are labelled by their
#'   biome scheme number
#'   and source, e.g. `25 (Ramankutty & Foley, 1999)`; the composite bar
#'   of the best scheme and, in each criterion panel, the bar with the
#'   best value of that criterion are outlined in red. All compared
#'   schemes are shown unless `top_n` cuts the list.
#' * **map**: the occurrence records (points) mapped over the chosen
#'   biome scheme, with the number of records per biome optionally
#'   appended to the legend labels.
#' * **barplot**: the number of occurrence records (left) and species
#'   (right) per biome, with the biome names in the centre. Bars use the
#'   same colour per biome as the map; off-map records ("no biome") are
#'   grey.
#'
#' Which panels are drawn is controlled by `panels`. When several panels
#' are combined into one figure, the panel letters (a, b, c) are assigned
#' in drawing order and written into the panel titles ("a: ..."), so
#' selecting only `rank` and `barplot` labels them (a) and (b).
#'
#' @param x A data frame with longitude/latitude columns, an `sf` spatial
#'   object, or a `terra::SpatVector` of point geometries.
#' @param scheme Integer in `1:31` (biome scheme number). If `NULL`
#'   (default), the best-fitting scheme is chosen by [biomes_rank()]
#'   (within `definition`).
#' @param definition Character. Biome definition to rank within when
#'   `scheme` is `NULL`; passed to [biomes_rank()]. Default `"all"`.
#' @param biome Optional single-layer `terra::SpatRaster`. If supplied it
#'   is mapped directly and only the `map` panel is available (no ranking).
#' @param lon,lat Column names of longitude / latitude in `x`
#'   (data frame only). Defaults `"decimalLongitude"`/`"decimalLatitude"`.
#' @param panels Character vector, any subset of `c("rank", "map",
#'   "barplot")` (default all three). Panels are drawn and lettered in
#'   this order.
#' @param top_n Integer or `NULL` (default). If given, only the `top_n`
#'   top-ranked schemes are shown in the `rank` panel; `NULL` shows all
#'   compared schemes.
#' @param titles Logical. If `TRUE` (default), each panel carries a
#'   left-aligned title: "Ranked biome schemes" (or "Top n ranked biome
#'   schemes" with `top_n`), "Spatial projection for <reference>" and
#'   "Occurrence and species number for <reference>", where the reference
#'   is the source of the chosen scheme, e.g. "Ramankutty & Foley (1999)".
#'   With `FALSE` no titles are drawn and the panel letters are placed in
#'   the top-left corners instead.
#' @param legend_counts Logical. If `TRUE`, append the number of records
#'   per biome to the map legend labels. Default `FALSE` (biome names
#'   only).
#' @param legend Logical. If `TRUE` (default), draw the biome colour
#'   legend on the map panel.
#' @param point_color Colour of the occurrence points. Default `"#B20000"`.
#' @param point_size Numeric size of the occurrence points. Default `0.25`.
#' @param combine Logical. When more than one panel is drawn: `TRUE`
#'   (default) combines them into one lettered figure (a, b, c); `FALSE`
#'   returns a **named list** of the individual panels (no letters).
#'   Ignored for a single panel (always returned as a bare plot).
#' @param verbose Logical. Passed to [biomes_rank()]. Default `FALSE`.
#'
#' @return For a single panel, a `ggplot` object (`map`) or a `cowplot`
#'   object (`rank`, `barplot`). For several panels: a combined `cowplot`
#'   object when `combine = TRUE` (default), or a named list of the
#'   individual panels (`rank`, `map`, `barplot`) when `combine = FALSE`.
#'   Print to display or save with [ggplot2::ggsave()].
#'
#' @examples
#' \donttest{
#' data("bombacoideae_occurrences")
#' # full figure (rank + map + barplot), best scheme chosen automatically
#' biomes_visualise(bombacoideae_occurrences)
#'
#' # only the map, for a fixed scheme
#' biomes_visualise(bombacoideae_occurrences, scheme = 1, panels = "map")
#'
#' # map + barplot for the best vegetation scheme
#' biomes_visualise(bombacoideae_occurrences, definition = "vegetation",
#'                  panels = c("map", "barplot"))
#' }
#'
#' @export
biomes_visualise <- function(
    x,
    scheme        = NULL,
    definition    = "all",
    biome         = NULL,
    lon           = "decimalLongitude",
    lat           = "decimalLatitude",
    panels        = c("rank", "map", "barplot"),
    top_n         = NULL,
    titles        = TRUE,
    legend_counts = FALSE,
    legend        = TRUE,
    point_color   = "#B20000",
    point_size    = 0.25,
    combine       = TRUE,
    verbose       = FALSE
) {

  # ----------------------------------------------------- assertions
  checkmate::assert_true(
    any(c("data.frame", "sf", "SpatVector") %in% class(x)),
    .var.name = "x"
  )
  panels <- unique(match.arg(panels, c("rank", "map", "barplot"),
                             several.ok = TRUE))
  panels <- c("rank", "map", "barplot")[c("rank", "map", "barplot") %in% panels]
  if (!is.null(scheme)) checkmate::assert_int(scheme, lower = 1L, upper = 31L)
  if (!is.null(biome)) checkmate::assert_class(biome, "SpatRaster")
  if (!is.null(top_n)) checkmate::assert_int(top_n, lower = 1L)
  checkmate::assert_flag(titles)
  checkmate::assert_flag(legend_counts)
  checkmate::assert_flag(legend)
  checkmate::assert_string(point_color)
  checkmate::assert_number(point_size, lower = 0)
  checkmate::assert_flag(combine)

  for (pkg in c("sf", "ggplot2", "viridis", "tidyterra")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop(sprintf("Package '%s' is required for biomes_visualise().", pkg),
           call. = FALSE)
    }
  }

  # A custom raster cannot be ranked -> only the map panel is meaningful.
  # (Restrict BEFORE the cowplot check, so a custom-raster map never needs it.)
  if (!is.null(biome)) {
    if (!all(panels == "map")) {
      warning("`biome` was supplied; only the 'map' panel is drawn.",
              call. = FALSE)
    }
    panels <- "map"
  }
  if (length(panels) == 0L) {
    stop("`panels` must select at least one of 'rank', 'map', 'barplot'.",
         call. = FALSE)
  }

  # The rank and barplot panels are themselves multi-part; they and any
  # multi-panel figure need cowplot. A lone map does not.
  needs_cowplot <- length(panels) > 1L || any(c("rank", "barplot") %in% panels)
  if (needs_cowplot && !requireNamespace("cowplot", quietly = TRUE)) {
    stop("Package 'cowplot' is required for the 'rank'/'barplot' panels and ",
         "to combine panels. Install it with install.packages('cowplot').",
         call. = FALSE)
  }

  # ----------------------------------------------------- ranking (if needed)
  ranking <- NULL
  need_rank <- ("rank" %in% panels) || (is.null(scheme) && is.null(biome))
  if (need_rank) {
    ranking <- biomes_rank(x, definition = definition,
                           lon = lon, lat = lat, verbose = verbose)
    if (is.null(scheme)) {
      scheme <- as.integer(attr(ranking, "best_scheme"))
      if (is.na(scheme)) {
        stop("biomes_rank() could not identify a best scheme.", call. = FALSE)
      }
    }
  }
  if (is.null(scheme) && is.null(biome)) {
    stop("Provide `scheme`, or allow ranking to choose one.", call. = FALSE)
  }

  # ----------------------------------------------------- raster + palette
  # One biome -> colour palette shared by the map and the barplot.
  ras <- NULL; palette <- NULL; scheme_idx <- NA_integer_
  if (any(c("map", "barplot") %in% panels)) {
    if (is.null(biome)) {
      ras <- biomes_get()[[as.integer(scheme)]]
      scheme_idx <- as.integer(scheme)
    } else {
      ras <- biome
    }
    if (terra::nlyr(ras) != 1L) {
      stop("biomes_visualise() expects a single biome scheme layer.",
           call. = FALSE)
    }
    palette <- .biome_palette(ras, scheme_idx)
  }

  scheme_ref <- .scheme_reference(scheme_idx)

  # ----------------------------------------------------- build panels
  # Panel letters are written into the titles ("a: ...") when several
  # panels are combined into one figure. A single panel, or a list of
  # panels (`combine = FALSE`), carries no letter.
  use_letters <- combine && length(panels) > 1L && titles
  prefix <- stats::setNames(rep("", length(panels)), panels)
  if (use_letters) prefix[] <- paste0(letters[seq_along(panels)], ": ")

  plots <- list()
  if ("rank" %in% panels) {
    plots$rank <- .biomes_panel_rank(ranking, top_n = top_n, title = titles,
                                     prefix = prefix[["rank"]])
  }
  if ("map" %in% panels) {
    map_title <- if (!titles) NULL else if (!is.na(scheme_idx)) {
      paste0(prefix[["map"]], "Spatial projection for ", scheme_ref)
    } else paste0(prefix[["map"]], "Spatial projection")
    plots$map <- .biomes_panel_map(
      x, ras = ras, scheme_idx = scheme_idx, palette = palette,
      lon = lon, lat = lat, title = map_title,
      legend = legend, legend_counts = legend_counts,
      point_color = point_color, point_size = point_size
    )
  }
  if ("barplot" %in% panels) {
    bar_title <- if (!titles) NULL else if (!is.na(scheme_idx)) {
      paste0(prefix[["barplot"]], "Occurrence and species number for ",
             scheme_ref)
    } else paste0(prefix[["barplot"]], "Occurrence and species number")
    plots$barplot <- .biomes_panel_barplot(
      x, scheme = scheme, biome = biome, lon = lon, lat = lat,
      palette = palette, title = bar_title
    )
  }
  plots <- plots[c("rank", "map", "barplot")]
  plots <- plots[!vapply(plots, is.null, logical(1))]

  if (length(plots) == 1L) return(plots[[1]])
  if (!combine) return(plots)   # named list of individual panels, no letters

  if (use_letters) {
    cowplot::plot_grid(
      plotlist    = plots,
      ncol        = 1,
      rel_heights = ifelse(names(plots) == "map", 1.05, 0.95)
    )
  } else {
    # no titles: letters as cowplot labels in the top-left corners
    cowplot::plot_grid(
      plotlist    = plots,
      ncol        = 1,
      rel_heights = ifelse(names(plots) == "map", 1.05, 0.95),
      labels      = letters[seq_along(plots)],
      label_size  = 14,
      label_x = 0, label_y = 1, hjust = 0, vjust = 1.3
    )
  }
}


# ----------------------------------------------------------------------------
# Shared helpers (internal)
# ----------------------------------------------------------------------------

#' Label "25 (Ramankutty & Foley, 1999)" for a packaged scheme number.
#' @keywords internal
#' @noRd
.scheme_label <- function(scheme_idx) {
  if (length(scheme_idx) == 0L) return(character(0))
  info <- biomes::biomes_information
  vapply(scheme_idx, function(k) {
    if (is.na(k) || k < 1 || k > nrow(info)) return(as.character(k))
    sprintf("%d (%s)", as.integer(k), info$publication[k])
  }, character(1))
}

#' Break a scheme label into two lines when it names several authors
#' ("Ramankutty & Foley", "Higgins et al.") or is very long.
#' @keywords internal
#' @noRd
.wrap_scheme_label <- function(lab) {
  vapply(lab, function(l) {
    if (grepl(" & ", l, fixed = TRUE)) {
      return(sub(" & ", " &\n", l, fixed = TRUE))
    }
    if (grepl(" et al., ", l, fixed = TRUE)) {
      return(sub(" et al., ", " et al.,\n", l, fixed = TRUE))
    }
    if (nchar(l) > 28) {
      return(paste(strwrap(l, width = ceiling(nchar(l) * 0.6)), collapse = "\n"))
    }
    l
  }, character(1), USE.NAMES = FALSE)
}

#' Reference "Ramankutty & Foley (1999)" for a packaged scheme number, from
#' the `publication` field ("Ramankutty & Foley, 1999"). Several references
#' separated by ";" are converted one by one.
#' @keywords internal
#' @noRd
.scheme_reference <- function(scheme_idx) {
  info <- biomes::biomes_information
  vapply(scheme_idx, function(k) {
    if (is.na(k) || k < 1 || k > nrow(info)) return(as.character(k))
    parts <- trimws(strsplit(info$publication[k], ";", fixed = TRUE)[[1]])
    parts <- vapply(parts, function(pp) {
      m <- regexpr(",\\s*[0-9]{4}", pp)
      if (m < 1) return(pp)
      paste0(substr(pp, 1, m - 1), " (",
             trimws(substr(pp, m + 1, nchar(pp))), ")")
    }, character(1), USE.NAMES = FALSE)
    paste(parts, collapse = "; ")
  }, character(1))
}

#' Colour per biome (named by biome name) for one scheme raster.
#' Off-map records are drawn in grey under the name "no_biome".
#' @keywords internal
#' @noRd
.biome_palette <- function(ras, scheme_idx) {
  ras_vals <- terra::unique(ras)[[1]]
  ras_vals <- sort(ras_vals[!is.na(ras_vals)])
  if (!is.na(scheme_idx)) {
    cls  <- .layer_lookup(scheme_idx, biomes::biomes_legend)
    labs <- cls[ras_vals]
    miss <- is.na(labs)
    labs[miss] <- paste0("azonal (raster value: ", ras_vals[miss], ")")
  } else {
    labs <- paste0("raster value: ", ras_vals)
  }
  cols <- viridis::viridis(length(ras_vals), option = "D")
  names(cols) <- labs
  attr(cols, "values") <- ras_vals
  cols
}

#' Put a centred bold title above a (cowplot) panel.
#' @keywords internal
#' @noRd
.with_title <- function(p, title) {
  if (is.null(title)) return(p)
  t <- cowplot::ggdraw() +
    cowplot::draw_label(title, x = 0.01, hjust = 0, fontface = "bold",
                        size = 11)
  cowplot::plot_grid(t, p, ncol = 1, rel_heights = c(0.08, 1))
}

#' Thousands separator for axis ticks and bar labels.
#' @keywords internal
#' @noRd
.fmt_big <- function(z) {
  format(abs(z), big.mark = ",", scientific = FALSE, trim = TRUE)
}


# ----------------------------------------------------------------------------
# Panel builders (internal)
# ----------------------------------------------------------------------------

#' Ranking panel (a): composite score + the raw criteria it averages.
#' Composite bar (schemes labelled "no. (source)", best scheme outlined in
#' red) plus one zoomed bar per criterion, sharing one scheme order; in
#' each criterion panel the scheme with the best value of THAT criterion
#' is outlined.
#' @keywords internal
#' @noRd
.biomes_panel_rank <- function(ranking, top_n = 5, title = TRUE, prefix = "") {
  if (is.null(ranking)) {
    stop("The 'rank' panel needs a ranking; do not pass a custom `biome`.",
         call. = FALSE)
  }
  rk <- as.data.frame(ranking)
  rk <- rk[!is.na(rk$composite_score), , drop = FALSE]
  criteria <- attr(ranking, "criteria")
  if (is.null(criteria)) criteria <- "coverage"

  n_all <- nrow(rk)
  if (!is.null(top_n) && !is.null(rk$rank)) {
    rk <- rk[order(rk$rank), , drop = FALSE]
    rk <- rk[rk$rank <= top_n, , drop = FALSE]
  }
  n_s <- nrow(rk)

  # scheme labels "25 (Ramankutty &\nFoley, 1999)": two lines when there are
  # several authors, so the label column stays narrow; ascending composite
  # so the best scheme sits at the TOP
  rk$lab <- .wrap_scheme_label(.scheme_label(rk$scheme))
  rk$scheme_f <- factor(rk$lab, levels = rk$lab[order(rk$composite_score,
                                                      -rk$rank)])
  rk$ypos <- as.numeric(rk$scheme_f)

  ysize <- if (n_s >= 25) 5 else if (n_s >= 15) 6.5 else 8
  bar_h <- if (n_s >= 15) 0.4 else 0.35     # half bar height (bar width 0.7)

  no_grid_y <- ggplot2::theme(
    panel.grid.major.y = ggplot2::element_blank(),
    panel.grid.minor   = ggplot2::element_blank()
  )
  drop_y <- ggplot2::theme(axis.text.y = ggplot2::element_blank(),
                           axis.ticks.y = ggplot2::element_blank())

  # red box around the bar(s) with the best value; drawn as a rectangle from
  # `x0` (the visible start of the bars) so that all four sides are visible
  outline_best <- function(d, x0) {
    fin  <- is.finite(d$value)
    if (!any(fin)) return(NULL)
    best <- d[fin & d$value == max(d$value[fin]), , drop = FALSE]
    if (nrow(best) == 0L) return(NULL)
    best$x0 <- x0
    ggplot2::geom_rect(
      data = best,
      ggplot2::aes(xmin = .data$x0, xmax = .data$value,
                   ymin = .data$ypos - bar_h, ymax = .data$ypos + bar_h),
      fill = NA, colour = "red", linewidth = 0.7, inherit.aes = FALSE
    )
  }


  # all bars on one 0-1 axis; the value is printed right of the bar
  x_axis <- function() {
    list(
      ggplot2::scale_x_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1),
                                  labels = c("0", "0.25", "0.5", "0.75", "1")),
      ggplot2::coord_cartesian(xlim = c(-0.02, 1.22), expand = FALSE)
    )
  }
  val_lab <- function(z) ifelse(is.na(z), "n/a", formatC(z, format = "f", digits = 2))

  # composite score, best highlighted and outlined in red
  d_comp <- data.frame(scheme_f = rk$scheme_f, ypos = rk$ypos,
                       value = rk$composite_score, is_best = rk$is_best)
  d_comp$x0 <- 0
  # all sub-panels use the same continuous y positions (1..n_s) so their
  # rows line up exactly when combined with cowplot
  y_scale <- function(labels = NULL) {
    ggplot2::scale_y_continuous(breaks = rk$ypos, labels = labels,
                                limits = c(0.5, n_s + 0.5), expand = c(0, 0))
  }
  p_comp <- ggplot2::ggplot(d_comp) +
    ggplot2::geom_rect(
      data = d_comp[!is.na(d_comp$value), , drop = FALSE],
      ggplot2::aes(xmin = .data$x0, xmax = .data$value,
                   ymin = .data$ypos - bar_h, ymax = .data$ypos + bar_h,
                   fill = .data$is_best)) +
    outline_best(d_comp, 0) +
    ggplot2::geom_text(ggplot2::aes(x = pmax(.data$value, 0, na.rm = TRUE),
                                    y = .data$ypos,
                                    label = val_lab(.data$value)),
                       hjust = -0.15, size = 2.3, colour = "grey20",
                       na.rm = TRUE) +
    ggplot2::scale_fill_manual(
      values = c(`TRUE` = "#1b9e77", `FALSE` = "grey70"), guide = "none") +
    y_scale(labels = stats::setNames(as.character(rk$scheme_f), rk$ypos)) +
    x_axis() +
    ggplot2::labs(x = "Composite score", y = "Biome scheme") +
    ggplot2::theme_minimal(base_size = 11) + no_grid_y +
    ggplot2::theme(axis.text.y = ggplot2::element_text(size = ysize),
                   plot.margin = ggplot2::margin(6, 6, 2, 12))

  # axis titles: criterion name plus its symbol in the companion paper
  crit_pretty <- list(
    coverage         = quote(Coverage ~ (italic(C))),
    effective_biomes = quote(Effective ~ biomes ~ (italic(E))),
    granularity      = quote(Granularity ~ (italic(G)))
  )
  crit_col <- c(coverage = "#0072B2", effective_biomes = "#E69F00",
                granularity = "#009E73")

  crit_bar <- function(key) {
    v <- rk[[paste0(key, "_scaled")]]
    if (is.null(v)) return(NULL)
    d <- data.frame(scheme_f = rk$scheme_f, ypos = rk$ypos, value = v)
    d$x0 <- 0
    ggplot2::ggplot(d) +
      ggplot2::geom_rect(
        data = d[!is.na(d$value), , drop = FALSE],
        ggplot2::aes(xmin = .data$x0, xmax = .data$value,
                     ymin = .data$ypos - bar_h, ymax = .data$ypos + bar_h),
        fill = unname(crit_col[key])) +
      outline_best(d, 0) +
      ggplot2::geom_text(ggplot2::aes(x = pmax(.data$value, 0, na.rm = TRUE),
                                      y = .data$ypos,
                                      label = val_lab(.data$value)),
                         hjust = -0.15, size = 2.3, colour = "grey20") +
      y_scale() +
      x_axis() +
      ggplot2::labs(x = crit_pretty[[key]], y = NULL) +
      ggplot2::theme_minimal(base_size = 11) + no_grid_y + drop_y +
      ggplot2::theme(plot.margin = ggplot2::margin(6, 6, 2, 6))
  }

  crit_plots <- lapply(criteria, crit_bar)
  crit_plots <- crit_plots[!vapply(crit_plots, is.null, logical(1))]

  # give the composite panel room for the (wrapped) scheme labels
  lab_w <- max(nchar(unlist(strsplit(rk$lab, "\n", fixed = TRUE))), 8)
  grid <- cowplot::plot_grid(
    plotlist   = c(list(p_comp), crit_plots),
    nrow       = 1, align = "h", axis = "tb",
    rel_widths = c(1.35 + 0.05 * (lab_w - 8), rep(1, length(crit_plots)))
  )

  ttl <- NULL
  if (isTRUE(title)) {
    ttl <- if (n_s < n_all) {
      sprintf("%sTop %d ranked biome schemes", prefix, n_s)
    } else {
      paste0(prefix, "Ranked biome schemes")
    }
  }
  .with_title(grid, ttl)
}


#' Map panel (b): occurrence records over one biome scheme.
#' @keywords internal
#' @noRd
.biomes_panel_map <- function(x, ras, scheme_idx, palette, lon, lat, title,
                              legend, legend_counts,
                              point_color, point_size) {

  if (inherits(x, "data.frame") && !inherits(x, "sf")) {
    checkmate::assert_subset(c(lon, lat), choices = names(x), .var.name = "x")
    keep <- is.finite(x[[lon]]) & is.finite(x[[lat]])
    if (!any(keep)) stop("No records with finite coordinates in `x`.",
                         call. = FALSE)
    pts_sf <- sf::st_as_sf(x[keep, , drop = FALSE],
                           coords = c(lon, lat), crs = 4326)
  } else if (inherits(x, "sf")) {
    pts_sf <- x
  } else {
    pts_sf <- sf::st_as_sf(x)
  }
  pts_proj <- sf::st_transform(pts_sf, sf::st_crs(terra::crs(ras)))
  pts_v  <- terra::project(terra::vect(pts_proj), terra::crs(ras))
  ex_pts <- terra::extract(ras, pts_v)
  raw_pt <- ex_pts[[setdiff(names(ex_pts), "ID")[1]]]

  all_vals <- attr(palette, "values")
  base_lab <- names(palette)
  n_per <- vapply(all_vals, function(v) sum(raw_pt == v, na.rm = TRUE),
                  integer(1))
  plot_labels <- if (legend_counts) {
    paste0(base_lab, " (", .fmt_big(n_per), ")")
  } else base_lab
  biome_colors <- stats::setNames(unname(palette), plot_labels)

  ras_fac <- ras
  levels(ras_fac) <- data.frame(ID = all_vals, biome = plot_labels)

  # shrink the legend when there are many biomes, so a long legend is
  # not clipped at the top/bottom of the map.
  nbiome  <- length(all_vals)
  key_cm  <- if (nbiome >= 25) 0.28 else if (nbiome >= 15) 0.36 else 0.5
  txt_pt  <- if (nbiome >= 25) 6    else if (nbiome >= 15) 7.5  else 9

  p <- ggplot2::ggplot() +
    tidyterra::geom_spatraster(data = ras_fac) +
    ggplot2::scale_fill_manual(
      name     = NULL,
      values   = biome_colors,
      breaks   = plot_labels,
      na.value = "transparent",
      drop     = FALSE,
      guide    = if (legend) ggplot2::guide_legend(ncol = 1) else "none"
    ) +
    ggplot2::geom_sf(data = pts_proj, color = point_color,
                     alpha = 1, size = point_size, inherit.aes = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(
      legend.position = if (legend) "right" else "none",
      legend.text     = ggplot2::element_text(size = txt_pt),
      legend.key.size = ggplot2::unit(key_cm, "cm"),
      plot.title      = ggplot2::element_text(size = 11, face = "bold",
                                              hjust = 0)
    )
  if (!is.null(title)) p <- p + ggplot2::ggtitle(title)
  p
}


#' Barplot panel (c): records (left) and species (right) per biome, with
#' the biome names centred between the two mirrored bar panels. Bars are
#' coloured like the map; "no biome" is grey.
#' @keywords internal
#' @noRd
.biomes_panel_barplot <- function(x, scheme, biome, lon, lat,
                                  palette = NULL, title = NULL) {

  # align the species vector with the classified rows
  species <- NULL
  if (inherits(x, "data.frame") && !inherits(x, "sf")) {
    if (all(c(lon, lat) %in% names(x))) {
      keep <- is.finite(x[[lon]]) & is.finite(x[[lat]])
      x <- x[keep, , drop = FALSE]
    }
    if ("species" %in% names(x)) species <- as.character(x[["species"]])
  } else if (inherits(x, "sf")) {
    if ("species" %in% names(x)) species <- as.character(x[["species"]])
  } else if (inherits(x, "SpatVector")) {
    xdf <- terra::as.data.frame(x)
    if ("species" %in% names(xdf)) species <- as.character(xdf[["species"]])
  }

  cls_df <- suppressMessages(suppressWarnings(
    biomes_classify(x = x, scheme = scheme, biome = biome,
                    lon = lon, lat = lat, value = "name", append = FALSE)
  ))
  name_col <- grep("_name$", names(cls_df), value = TRUE)[1]
  if (is.na(name_col)) {
    stop("Classification produced no biome names for the barplot panel.",
         call. = FALSE)
  }
  biome_cls <- cls_df[[name_col]]

  rec <- as.data.frame(table(biome = biome_cls), stringsAsFactors = FALSE)
  names(rec) <- c("biome", "n_records")
  have_species <- !is.null(species) && length(species) == length(biome_cls)
  if (have_species) {
    sp_tab <- tapply(species, biome_cls, function(s) {
      s <- s[!is.na(s) & nzchar(s)]; length(unique(s))
    })
    sp <- data.frame(biome = names(sp_tab), n_species = as.integer(sp_tab),
                     stringsAsFactors = FALSE)
    df <- merge(rec, sp, by = "biome", all = TRUE)
  } else {
    df <- rec; df$n_species <- NA_integer_
  }
  df$n_records[is.na(df$n_records)] <- 0L
  df$n_species[is.na(df$n_species)] <- 0L
  df <- df[order(-df$n_records), , drop = FALSE]
  df$biome_f   <- factor(df$biome, levels = rev(df$biome))   # most records on top
  df$biome_lab <- ifelse(df$biome == "no_biome", "No biome", df$biome)

  # colours: same as the map per biome, grey for off-map records
  fill_cols <- rep("#2C7A7B", nrow(df))
  if (!is.null(palette)) {
    hit <- match(df$biome, names(palette))
    fill_cols[!is.na(hit)] <- unname(palette[hit[!is.na(hit)]])
  }
  fill_cols[df$biome == "no_biome"] <- "grey60"
  names(fill_cols) <- df$biome
  fill_scale <- ggplot2::scale_fill_manual(values = fill_cols, guide = "none")

  no_grid_y <- ggplot2::theme(panel.grid.major.y = ggplot2::element_blank(),
                              panel.grid.minor   = ggplot2::element_blank())
  drop_y <- ggplot2::theme(axis.text.y = ggplot2::element_blank(),
                           axis.ticks.y = ggplot2::element_blank())

  # If there is no species information, fall back to a single records bar
  # with the biome names on the y-axis.
  if (!have_species || all(df$n_species == 0L)) {
    p <- ggplot2::ggplot(df, ggplot2::aes(x = .data$n_records, y = .data$biome_f,
                                          fill = .data$biome)) +
      ggplot2::geom_col() + fill_scale +
      ggplot2::geom_text(ggplot2::aes(label = .fmt_big(.data$n_records)),
                         hjust = -0.15, size = 2.6) +
      ggplot2::scale_x_continuous(expand = ggplot2::expansion(mult = c(0, 0.15)),
                                  labels = .fmt_big) +
      ggplot2::scale_y_discrete(labels = stats::setNames(df$biome_lab, df$biome_f)) +
      ggplot2::labs(x = "Number of occurrence records", y = NULL) +
      ggplot2::theme_minimal(base_size = 10) + no_grid_y
    return(.with_title(p, title))
  }

  rec_max <- max(df$n_records); sp_max <- max(df$n_species)

  # (left) records, mirrored to the left
  p_rec <- ggplot2::ggplot(df, ggplot2::aes(y = .data$biome_f, x = -.data$n_records,
                                            fill = .data$biome)) +
    ggplot2::geom_col(orientation = "y") + fill_scale +
    ggplot2::geom_text(ggplot2::aes(label = .fmt_big(.data$n_records)),
                       hjust = 1.15, size = 2.5) +
    ggplot2::scale_x_continuous(limits = c(-rec_max * 1.30, 0),
                                breaks = function(l) {
                                  b <- pretty(l); b[abs(b) <= rec_max]
                                },
                                labels = .fmt_big, expand = c(0, 0)) +
    ggplot2::labs(x = "Number of occurrence records", y = NULL) +
    ggplot2::theme_minimal(base_size = 10) + no_grid_y + drop_y +
    ggplot2::theme(plot.margin = ggplot2::margin(6, 1, 2, 2))

  # (centre) biome names
  p_lab <- ggplot2::ggplot(df, ggplot2::aes(y = .data$biome_f, x = 0)) +
    ggplot2::geom_text(ggplot2::aes(label = .data$biome_lab), size = 2.5) +
    ggplot2::scale_x_continuous(limits = c(-1, 1), expand = c(0, 0)) +
    ggplot2::labs(x = NULL, y = NULL) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(6, 0, 2, 0))

  # (right) species, growing to the right
  p_sp <- ggplot2::ggplot(df, ggplot2::aes(y = .data$biome_f, x = .data$n_species,
                                           fill = .data$biome)) +
    ggplot2::geom_col(orientation = "y") + fill_scale +
    ggplot2::geom_text(ggplot2::aes(label = .data$n_species), hjust = -0.15,
                       size = 2.5) +
    ggplot2::scale_x_continuous(limits = c(0, sp_max * 1.30), expand = c(0, 0)) +
    ggplot2::labs(x = "Number of species", y = NULL) +
    ggplot2::theme_minimal(base_size = 10) + no_grid_y + drop_y +
    ggplot2::theme(plot.margin = ggplot2::margin(6, 2, 2, 1))

  grid <- cowplot::plot_grid(p_rec, p_lab, p_sp, nrow = 1, align = "h",
                             axis = "tb", rel_widths = c(1, 0.9, 1))
  .with_title(grid, title)
}
