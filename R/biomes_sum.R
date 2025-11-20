#' Summarize Taxon per biome and layer
#'
#' Lists the count of records within each biome and layer in long format, with optional filtering.
#'
#' @param x Data frame with occurrence records.
#' @param group_col Column name for grouping. Default: "species".
#' @param lon Column name for longitude. Default: "decimalLongitude".
#' @param lat Column name for latitude. Default: "decimalLatitude".
#' @param layer Integer vector of raster layer indices.
#' @param raster Path to raster stack or SpatRaster.
#' @param legend Path to lookup table (RDS) or data.frame.
#' @param presence_min_n Minimum records in biome for presence (default: 1).
#' @param presence_min_prop Optional proportion (0-1) for minimum species share in biome.
#' @return data.frame: layer, species, biome, value (count).
#' @export
biomes_sum <- function(
    x,
    group_col = "species",
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    layer,
    raster = system.file("extdata", "Biome_Inventory_RasterStack.tif", package = "biomes"),
    legend = system.file("extdata", "biome_legend.rds", package = "biomes"),
    presence_min_n = 1,
    presence_min_prop = NULL
) {
  # Assign biomes to occurrences
  biomes_tab <- biomes_assign(
    x,
    lon = lon,
    lat = lat,
    layer = layer,
    raster = raster,
    legend = legend
  )
  # Always wrap single layer output
  if (is.vector(biomes_tab)) {
    biome_colname <- paste0("layer_", layer, "_biome")
    biomes_tab <- setNames(data.frame(biomes_tab, stringsAsFactors = FALSE), biome_colname)
  }
  data_with_biomes <- cbind(x, biomes_tab)

  # Build long-format table for all layers
  long_list <- list()
  for (i in seq_along(layer)) {
    biome_col <- paste0("layer_", layer[i], "_biome")
    tbl <- as.data.frame(
      table(
        species = data_with_biomes[[group_col]],
        biome   = data_with_biomes[[biome_col]],
        useNA   = "ifany"
      ),
      stringsAsFactors = FALSE
    )
    names(tbl)[3] <- "value"
    # Add layer column
    tbl$layer <- layer[i]
    # Remove zero counts
    tbl <- tbl[tbl$value > 0, ]
    # Reset rownames
    rownames(tbl) <- NULL
    long_list[[i]] <- tbl[, c("layer", "species", "biome", "value")]
  }
  res_long <- do.call(rbind, long_list)
  rownames(res_long) <- seq_len(nrow(res_long))

  # Apply threshold filtering
  if (!is.null(presence_min_prop)) {
    # For each species, ignore biomes with < min_prop occurrences relative to total for that species
    res_long <- do.call(rbind, lapply(
      split(res_long, list(res_long$layer, res_long$species), drop = TRUE),
      function(df) df[df$value >= max(presence_min_n, ceiling(nrow(df) * presence_min_prop)), ]
    ))
    rownames(res_long) <- seq_len(nrow(res_long))
  } else {
    res_long <- res_long[res_long$value >= presence_min_n, ]
    rownames(res_long) <- seq_len(nrow(res_long))
  }

  # Sort by species for readability
  res_long <- res_long[order(res_long$layer, res_long$species), ]
  rownames(res_long) <- seq_len(nrow(res_long))
  return(res_long)
}
