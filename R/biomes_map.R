#' Plot Occurrence Points on Biome Map
#'
#' Visualizes occurrence points on biome maps for selected raster layers (Optional detailed output with legend and pie chart).
#'
#' @param x Data frame containing occurrence records.
#' @param lon Name of the longitude column. Default: "decimalLongitude".
#' @param lat Name of the latitude column. Default: "decimalLatitude".
#' @param world_extent Logical; TRUE for global map, FALSE to crop map to the extent of occurrence points.
#' @param layer Integer vector of raster layer indices (one or more).
#' @param detail Logical; TRUE for detailed plot with legend and pie chart, FALSE for map only. Default: TRUE.
#' @param show_plot Logical; if TRUE, plots are displayed; if FALSE, only returned as objects. Default: FALSE.
#'
#' @importFrom cowplot get_legend plot_grid
#' @importFrom viridis viridis
#' @importFrom ggtext element_markdown
#' @importFrom sf st_as_sf st_transform st_bbox
#' @importFrom terra rast crs nlyr ext crop values
#' @importFrom ggforce geom_arc_bar
#' @importFrom dplyr mutate
#' @importFrom grid unit
#'
#' @export
biomes_map <- function(
    x,
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    world_extent = TRUE,
    layer = 1,
    detail = TRUE,
    show_plot = FALSE
) {
  r_path <- system.file("extdata", "Biome_Inventory_RasterStack.tif", package = "biomer")
  if (!file.exists(r_path) || r_path == "") stop("Raster file not found.")
  r_stack <- terra::rast(r_path)
  legendpath <- system.file("extdata", "biome_legend.rds", package = "biomer")
  if (!file.exists(legendpath) || legendpath == "") stop("Legend RDS file not found.")
  legend <- readRDS(legendpath)

  plot_list <- list()

  for (ly in layer) {
    message("Create Map for Layer ", ly, " ...")
    if (ly > terra::nlyr(r_stack)) stop("Layer index ", ly, "  too large for raster stack.")
    r <- r_stack[[ly]]
    leg_row <- legend[legend$layer == ly, ]
    source_info <- leg_row$source[1]
    biome_labels <- unname(unlist(leg_row[, grep("^id_[0-9]+$", names(leg_row))]))
    biome_labels <- biome_labels[!is.na(biome_labels)]

    pts_sf <- sf::st_as_sf(x, coords = c(lon, lat), crs = 4326)
    pts_sf_proj <- sf::st_transform(pts_sf, crs = terra::crs(r))
    biome_id_hit <- terra::extract(r, sf::st_coordinates(pts_sf_proj))[, 1]
    fund_count <- as.data.frame(table(biome_id_hit))
    names(fund_count) <- c("biome_id", "n_fund")
    fund_count$biome_id <- as.integer(as.character(fund_count$biome_id))

    # Grid to DF
    biome_id_col <- names(r)[1]
    r_df <- as.data.frame(r, xy = TRUE)

    # cut
    if (!world_extent) {
      bounds <- sf::st_bbox(pts_sf_proj)
      buff_x <- 0.1 * (bounds$xmax - bounds$xmin)
      buff_y <- 0.1 * (bounds$ymax - bounds$ymin)
      xlim <- c(bounds$xmin - buff_x, bounds$xmax + buff_x)
      ylim <- c(bounds$ymin - buff_y, bounds$ymax + buff_y)
      r_df <- r_df[r_df$x >= xlim[1] & r_df$x <= xlim[2] & r_df$y >= ylim[1] & r_df$y <= ylim[2], ]
    } else {
      xlim <- range(r_df$x, na.rm = TRUE)
      ylim <- range(r_df$y, na.rm = TRUE)
    }

    biome_ids_active <- sort(unique(na.omit(r_df[[biome_id_col]])))
    legend_ids <- as.integer(gsub("id_", "", names(leg_row)[grep("^id_[0-9]+$", names(leg_row))]))
    biome_labels_active <- biome_labels[match(biome_ids_active, legend_ids)]
    biome_colors_active <- viridis::viridis(length(biome_ids_active), option = "D")
    n_fund_vec_active <- sapply(biome_ids_active, function(bid) {
      v <- fund_count$n_fund[fund_count$biome_id == bid]
      if (length(v) == 0) 0 else v
    })
    plot_labels_active <- paste0(biome_labels_active, " (", n_fund_vec_active, ")")
    r_df$biome_label <- factor(plot_labels_active[match(r_df[[biome_id_col]], biome_ids_active)],
                               levels = plot_labels_active)
    subtitle_txt <- paste0("Layer ", ly, " (<i>", source_info, "</i>)")

    n_leg <- length(plot_labels_active)

    mapplot <- ggplot() +
      geom_tile(data = r_df, aes(x = x, y = y, fill = biome_label)) +
      scale_fill_manual("Biomes (N)", values = biome_colors_active, labels = plot_labels_active, guide = "none") +
      geom_sf(data = pts_sf_proj, color = "#B20000", alpha = 1, size = 0.2, inherit.aes = FALSE) +
      coord_sf(xlim = xlim, ylim = ylim, expand = FALSE) +
      theme_void() +
      theme(
        legend.position = "none",
        plot.title = element_text(size = 11, face = "bold", hjust = 0.5),
        plot.subtitle = ggtext::element_markdown(size = 9, hjust = 0.5)
      ) +
      labs(
        title = "Biome Map",
        subtitle = subtitle_txt
      )

    if (detail) {
      map_with_leg <- ggplot() +
        geom_tile(data = r_df, aes(x = x, y = y, fill = biome_label, show.legend = FALSE)) +
        scale_fill_manual("Biomes", values = biome_colors_active, labels = plot_labels_active, guide = guide_legend(ncol = 1)) +
        theme_void() +
        theme(
          legend.position = "right",
          legend.title = element_text(size = if (n_leg > 15) 8 else 10),
          legend.text = element_text(size = if (n_leg > 15) 6 else 8),
          legend.key.size = grid::unit(if (n_leg > 15) 0.12 else 0.2, "cm"),
          legend.margin = margin(0,0,0,5)
        )
      legend_grob <- cowplot::get_legend(map_with_leg)

      pie_df <- data.frame(
        label = plot_labels_active,
        count = n_fund_vec_active,
        stringsAsFactors = FALSE
      )
      pie_df <- pie_df[pie_df$count > 0, ]
      pie_df$fraction <- pie_df$count / sum(pie_df$count)
      pie_df$show_label <- pie_df$fraction >= 0.05
      pie_df$label_text <- paste0(round(100 * pie_df$fraction, 1), "%")
      pie_df <- dplyr::mutate(
        pie_df,
        angle = 2 * pi * (cumsum(fraction) - fraction/2),
        start = c(0, head(cumsum(fraction), -1)),
        end = cumsum(fraction),
        line_x = sin(angle) * 0.80,
        line_y = cos(angle) * 0.80,
        label_x = sin(angle) * 1.3,
        label_y = cos(angle) * 1.3
      )

      if (nrow(pie_df) == 0) {
        pieplot <- ggplot() + theme_void()
      } else {
        pieplot <- ggplot(pie_df) +
          ggforce::geom_arc_bar(
            aes(
              start = start * 2 * pi, end = end * 2 * pi, r0 = 0.35, r = 0.8,
              fill = factor(label, levels = plot_labels_active), x0 = 0, y0 = 0
            ), color = NA
          ) +
          scale_fill_manual(values = biome_colors_active, guide = "none") +
          coord_fixed(xlim = c(-0.9, 0.9), ylim = c(-0.9, 0.9), clip = "off") +
          theme_void() +
          theme(plot.margin = margin(t = 20, r = 0, b = 0, l = 0)) +
          geom_segment(
            data = subset(pie_df, show_label),
            aes(x = line_x, y = line_y, xend = label_x, yend = label_y),
            color = "grey30", linewidth = 0.3
          ) +
          geom_label(
            data = subset(pie_df, show_label),
            aes(x = label_x, y = label_y, label = label_text),
            size = 2.5,
            fontface = "bold",
            fill = "white",
            color = "black",
            label.size = NA,
            label.padding = grid::unit(0.03, "lines")
          )
      }
      right_panel <- cowplot::plot_grid(
        pieplot, legend_grob,
        ncol = 1,
        align = "v",
        rel_heights = c(0.6, 1.4),
        axis = "r"
      )
      final_combined <- cowplot::plot_grid(
        mapplot, right_panel,
        ncol = 2,
        rel_widths = c(2.4, 1)
      )
      if (show_plot) print(final_combined)
      plot_list[[paste0("layer_", ly)]] <- final_combined
    } else {
      if (show_plot) print(mapplot)
      plot_list[[paste0("layer_", ly)]] <- mapplot
    }
  }
  invisible(plot_list)
}
