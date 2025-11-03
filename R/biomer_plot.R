#' Plot biome distribution and heatmap for occurrence records
#'
#' Visualize occurrence points together with assigned biomes, overview pie chart, and/or barplot for one or more raster layers.
#'
#' @param x Data frame with occurrence records (must include longitude and latitude columns).
#' @param lon Name of longitude column. Default: "decimalLongitude".
#' @param lat Name of latitude column. Default: "decimalLatitude".
#' @param world_extent Logical; if TRUE, show whole world, otherwise crop to points. Default: TRUE.
#' @param plot_type Plot type: "both", "Map", or "Barplot".
#' @param layer Integer vector for raster layer indices (can be multiple).
#' @param save_path Optional: base file path to save plot (PNG/JPG, without extension; extensions and descriptors are added automatically).
#' @param show_plot Logical; if TRUE (default), plot is displayed in RStudio.
#' @param save_list Logical; if TRUE, the function returns a named list with `mapplot` and `barplot` ggplot objects for each requested layer. If FALSE (default), plots are not collected in a return list.

#'
#' @importFrom terra rast extract nlyr values crs
#' @importFrom sf st_as_sf st_transform st_coordinates
#' @importFrom dplyr mutate
#' @importFrom ggplot2 ggplot aes geom_tile scale_fill_manual geom_sf theme_void theme element_text ggtitle coord_fixed margin geom_segment geom_label geom_bar scale_y_continuous theme_minimal labs coord_flip scale_fill_manual ggsave element_blank expansion
#' @importFrom ggforce geom_arc_bar
#' @importFrom viridis viridis
#' @importFrom cowplot ggdraw draw_plot
#' @importFrom grid unit
#' @importFrom ggplot2 guide_legend
#' @importFrom ggplot2 geom_text
#'
#' @import ggplot2
#'
#' @export
biomer_plot <- function(
    x,
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    world_extent = TRUE,
    plot_type = c("both", "Map", "Barplot"),
    layer = 1,
    save_path = NULL,
    show_plot = FALSE,
    save_list = TRUE
) {
  # --- Assertions ---
  if (!is.data.frame(x)) stop("`x` must be a data.frame.")
  if (!is.character(lon) || length(lon) != 1L) stop("`lon` must be a single column name (character).")
  if (!is.character(lat) || length(lat) != 1L) stop("`lat` must be a single column name (character).")
  if (!lon %in% names(x)) stop("Column `", lon, "` not found in `x`.")
  if (!lat %in% names(x)) stop("Column `", lat, "` not found in `x`.")
  if (!is.logical(world_extent) || length(world_extent) != 1L || is.na(world_extent)) stop("`world_extent` must be a single logical value.")

  plot_type <- match.arg(plot_type)
  if (!is.numeric(layer) || length(layer) < 1L || any(is.na(layer))) stop("`layer` must be integers, not NA, and at least length 1.")
  if (!all(layer %% 1 == 0 & layer > 0)) stop("`layer` must contain positive integer indices.")

  if (!is.null(save_path)) {
    if (!is.character(save_path) || length(save_path) != 1L) stop("`save_path` must be a single character string or NULL.")
    save_path_noext <- sub("\\.[a-zA-Z]{3,4}$", "", save_path) # remove extension if given
  }
  if (!is.logical(show_plot) || length(show_plot) != 1L || is.na(show_plot)) stop("`show_plot` must be a single logical value.")

  # --- Load Raster and Legend ---
  r_path <- system.file("extdata", "Biome_Inventory_RasterStack.tif", package = "biomer")
  if (!file.exists(r_path) || r_path == "") stop("Raster file not found at expected package location.")
  r_stack <- rast(r_path)
  legendpath <- system.file("extdata", "biome_legend.rds", package = "biomer")
  if (!file.exists(legendpath) || legendpath == "") stop("Legend RDS file not found at expected package location.")
  legend <- readRDS(legendpath)

  # --- Loop over layers ---
  mapplot_list <- list()
  barplot_list <- list()

  for (ly in layer) {
    message("Creating map for layer ", ly, " ...")
    if (ly > nlyr(r_stack)) stop("Layer index ", ly, " is out of bounds for the raster stack with ", nlyr(r_stack), " layers.")
    r <- r_stack[[ly]]
    leg_row <- legend[legend$layer == ly, ]
    if (nrow(leg_row) == 0) stop("No legend row found for layer ", ly)
    source_info <- leg_row$source[1]
    biome_labels <- unname(unlist(leg_row[, grep("^id_[0-9]+$", names(leg_row))]))
    biome_labels <- biome_labels[!is.na(biome_labels)]
    n_biomes <- length(biome_labels)
    if (n_biomes == 0) stop("No biome labels found for layer ", ly)
    biome_colors <- viridis(n_biomes, option = "D")

    pts_sf <- st_as_sf(x, coords = c(lon, lat), crs = 4326)
    pts_sf_proj <- st_transform(pts_sf, crs = crs(r))
    biome_id_hit <- terra::extract(r, st_coordinates(pts_sf_proj))[,1]
    fund_count <- as.data.frame(table(biome_id_hit))
    names(fund_count) <- c("biome_id", "n_fund")
    fund_count$biome_id <- as.integer(as.character(fund_count$biome_id))

    biome_ids <- sort(unique(values(r)))
    n_fund_vec <- sapply(biome_ids, function(bid) {
      v <- fund_count$n_fund[fund_count$biome_id == bid]
      if (length(v) == 0) 0 else v
    })
    plot_labels <- paste0(biome_labels, " (", n_fund_vec, ")")

    # Pie chart data
    pie_df <- data.frame(
      label = plot_labels,
      count = n_fund_vec,
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

    # Pie chart
    pieplot <- if (nrow(pie_df) == 0) {
      ggplot() + theme_void()
    } else {
      ggplot(pie_df) +
        ggforce::geom_arc_bar(
          aes(
            start = start * 2 * pi, end = end * 2 * pi, r0 = 0.35, r = 0.8,
            fill = factor(label, levels = label), x0 = 0, y0 = 0
          ),
          color = NA
        ) +
        scale_fill_manual(values = biome_colors[plot_labels %in% pie_df$label], guide = "none") +
        coord_fixed(xlim = c(-0.9, 0.9), ylim = c(-0.9, 0.9), clip = "off") +
        theme_void() +
        theme(plot.margin = margin(15, 60, 15, 60)) +
        geom_segment(
          data = subset(pie_df, show_label),
          aes(x = line_x, y = line_y, xend = label_x, yend = label_y),
          color = "grey30", linewidth = 0.3
        ) +
        geom_label(
          data = subset(pie_df, show_label),
          aes(x = label_x, y = label_y, label = label_text),
          size = 3.5,
          fontface = "bold",
          fill = "white",
          color = "black",
          label.size = NA,
          label.padding = unit(0.05, "lines")
        )
    }

    # Raster dataframe
    biome_id_col <- names(r)[1]
    r_df <- as.data.frame(r, xy = TRUE)
    r_df$biome_label <- factor(plot_labels[match(r_df[[biome_id_col]], biome_ids)], levels = plot_labels)
    main_title <- paste0("Biome Map (Layer ", ly, ") - source: ", source_info)

    # Main map plot
    mapplot_full <- ggplot() +
      geom_tile(data = r_df, aes(x = x, y = y, fill = biome_label))+
      scale_fill_manual("Biomes (Number Occ.)", values = biome_colors, labels = plot_labels, guide = guide_legend(ncol = 1)) +
      geom_sf(data = pts_sf_proj, color = "#B20000", alpha = 1, size = 0.2, inherit.aes = FALSE) +
      theme_void() +
      theme(
        legend.position = "right",
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 10),
        legend.key.size = unit(0.6, "cm"),
        plot.title = element_text(size = 18, face = "bold", hjust = 0.5)
      ) +
      ggtitle(main_title)
    finalplot <- cowplot::ggdraw(mapplot_full) +
      cowplot::draw_plot(pieplot, x = 0.57, y = 0.60, width = 0.2, height = 0.2, scale = 1)

    # Barplot
    message("Creating barplot for layer ", ly, " ...")
    legend_df <- pie_df
    offset <- max(legend_df$count) * 0.03
    barplot <- ggplot(legend_df, aes(x = reorder(label, -count), y = count, fill = factor(label, levels = label))) +
      geom_bar(stat = "identity", width = 0.7) +
      scale_fill_manual(values = biome_colors[plot_labels %in% legend_df$label], name = NULL) +
      geom_text(
        aes(label = label, y = count + offset),
        hjust = 0, size = 4, color = "black"
      ) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.2))) +
      theme_minimal(base_size = 10) +
      theme(
        legend.position = "none",
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        plot.margin = margin(5, 10, 5, 5)
      ) +
      labs(x = "Biomes") +
      coord_flip()

    # mini-map plot for RStudio – wird nun als `mapplot` gespeichert!
    mapplot <- ggplot() +
      geom_tile(data = r_df, aes(x = x, y = y, fill = biome_label)) +
      scale_fill_manual(values = biome_colors, labels = plot_labels) +
      geom_sf(data = pts_sf_proj, color = "#B20000", alpha = 1, size = 0.2, inherit.aes = FALSE) +
      theme_void() +
      theme(
        legend.position = "none",
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5)
      )

    # --- Plot Output / Saving (All permutations) ---
    if (!is.null(save_path)) {
      save_stub <- paste0(save_path_noext, "_layer", ly)
      if (plot_type == "Map" || plot_type == "both") {
        out_path <- paste0(save_stub, "_map.jpg")
        ggsave(filename = out_path, plot = finalplot, width = 16, height = 10, dpi = 1000)
        message("Map plot for layer ", ly, " saved here: ", out_path)
      }
      if (plot_type == "Barplot" || plot_type == "both") {
        out_path <- paste0(save_stub, "_barplot.jpg")
        ggsave(filename = out_path, plot = barplot, width = 16, height = 10, dpi = 1000)
        message("Barplot for layer ", ly, " saved here: ", out_path)
      }
    }
    if (show_plot) {
      if (plot_type == "Map") {
        print(mapplot)
      } else if (plot_type == "Barplot") {
        print(barplot)
      } else if (plot_type == "both") {
        print(mapplot)
        print(barplot)
      }
    }

    # ---- SPEICHERN der Plots JE LAYER in zwei Listen!
    if (save_list) {
      mapplot_list[[paste0("layer_", ly)]] <- mapplot
      barplot_list[[paste0("layer_", ly)]] <- barplot
    }
  }

  # --- RETURN-Block am Ende ---
  if (save_list) {
    plot_list <- list(
      mapplot = mapplot_list,
      barplot = barplot_list
    )
    return(plot_list)
  } else {
    invisible(NULL)
  }
}
