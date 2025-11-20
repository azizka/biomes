#' Barplot of Biome Assignments from Occurrence Records
#'
#' Visualizes the distribution of occurrence records across biomes as a horizontal barplot for each selected raster layer.
#'
#' @param x Data frame containing occurrence records (must include longitude and latitude columns).
#' @param lon Name of the longitude column. Default is "decimalLongitude".
#' @param lat Name of the latitude column. Default is "decimalLatitude".
#' @param layer Integer vector specifying raster layer indices (can be multiple).
#' @param show_plot Logical; if TRUE, plots are displayed; if FALSE, only returned as objects. Default: FALSE.
#'
#' @return Invisibly returns a named list of ggplot objects for all plotted layers (e.g. $layer_1, $layer_2, ...).
#' @examples
#' biomes_barplot(df_occurrences, layer = c(1,2))
#' @importFrom ggplot2 ggplot geom_bar scale_fill_manual coord_flip labs theme_minimal theme element_text
#' @importFrom ggtext element_markdown
#' @importFrom sf st_as_sf st_transform
#' @importFrom terra rast crs values
#' @importFrom viridis viridis
#' @export
biomes_barplot <- function(
    x,
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    layer = 1,
    show_plot = FALSE
) {

  r_path <- system.file("extdata", "Biome_Inventory_RasterStack.tif", package = "biomes")
  legendpath <- system.file("extdata", "biome_legend.rds", package = "biomes")
  r_stack <- terra::rast(r_path)
  legend <- readRDS(legendpath)

  barplot_list <- list()
  for (ly in layer) {
    message("Create Barplot for Layer ", ly, " ...")
    r <- r_stack[[ly]]
    leg_row <- legend[legend$layer == ly, ]
    biome_labels <- unname(unlist(leg_row[, grep("^id_[0-9]+$", names(leg_row))]))
    biome_labels <- biome_labels[!is.na(biome_labels)]
    biome_colors <- viridis::viridis(length(biome_labels), option = "D")
    source_str <- as.character(leg_row$source)[1]

    pts_sf <- sf::st_as_sf(x, coords = c(lon, lat), crs = 4326)
    pts_proj <- sf::st_transform(pts_sf, crs = terra::crs(r))
    biome_id_hit <- terra::extract(r, sf::st_coordinates(pts_proj))[, 1]
    fund_count <- as.data.frame(table(biome_id_hit))
    names(fund_count) <- c("biome_id", "n_fund")
    fund_count$biome_id <- as.integer(as.character(fund_count$biome_id))
    biome_ids <- sort(unique(terra::values(r)))
    n_fund_vec <- sapply(biome_ids, function(bid) {
      v <- fund_count$n_fund[fund_count$biome_id == bid]
      if (length(v) == 0) 0 else v
    })
    plot_labels <- paste0(biome_labels, " (", n_fund_vec, ")")
    bar_data <- data.frame(
      label = plot_labels,
      count = n_fund_vec,
      color = biome_colors
    )

    # Sort by count
    bar_data <- bar_data[order(bar_data$count, decreasing = TRUE), ]
    bar_data$label <- factor(bar_data$label, levels = bar_data$label)

    # Markdown subtitle: only source italic
    subtitle_txt <- paste0("Layer ", ly, " (<i>", source_str, "</i>)")

    barplot <- ggplot(bar_data, aes(x = label, y = count, fill = label)) +
      geom_bar(stat = "identity", width = 0.7) +
      scale_fill_manual(values = bar_data$color, guide = "none") +
      coord_flip() +
      labs(
        x = NULL,
        y = "Occurrences",
        title = "Biome Occurrence Barplot",
        subtitle = subtitle_txt
      ) +
      theme_minimal(base_size = 11) +
      theme(
        axis.text.y = element_text(size = if (length(biome_labels) > 18) 5 else 9),
        plot.title = element_text(size = 15, hjust = 0),
        plot.subtitle = ggtext::element_markdown(size = 10, hjust = 0)
      )
    if (show_plot) print(barplot)
    barplot_list[[paste0("layer_", ly)]] <- barplot
  }
  invisible(barplot_list)
}
