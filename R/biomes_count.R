#' Count occurrences and species per biome
#'
#' Summarizes the number of occurrence records and species in each biome and layer, outputting a long-format table.
#'
#' @param x Data frame with occurrence records.
#' @param group_col Column for grouping/species (default: "species")
#' @param lon Column for longitude (default: "decimalLongitude")
#' @param lat Column for latitude (default: "decimalLatitude")
#' @param layer Integer vector of raster layer indices
#' @param raster Path or SpatRaster object
#' @param legend Path or data.frame as biome lookup
#' @param presence_min_n Minimum occurrences for filtering (default: 1)
#' @param presence_min_prop Optional proportion for filtering (default: NULL)
#' @return Data frame, columns: layer, biome_name, type ("occ_num"/"spec_num"), value
#' @export
biomes_count <- function(
    x,
    group_col = "species",
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    layer = 1,
    raster = system.file("extdata", "Biome_Inventory_RasterStack.tif", package = "biomer"),
    legend = system.file("extdata", "biome_legend.rds", package = "biomer"),
    presence_min_n = 1,
    presence_min_prop = NULL
) {
  # Call biome assignment function
  biomes_tab <- biomes_assign(
    x,
    lon = lon,
    lat = lat,
    layer = layer,
    raster = raster,
    legend = legend
  )

  # Handle single layer: force column name
  if (is.vector(biomes_tab)) {
    biome_colname <- paste0("layer_", layer, "_biome")
    biomes_tab <- data.frame(biome_colname = biomes_tab, stringsAsFactors = FALSE)
    names(biomes_tab) <- biome_colname
  }

  # Attach biome columns to data
  data_with_biomes <- cbind(x, biomes_tab)

  result_list <- list()
  for(i in seq_along(layer)) {
    # Dynamic column name for biome assignment
    biome_col <- paste0("layer_", layer[i], "_biome")
    layer_id <- layer[i]

    # Occurrence counts
    occ <- table(data_with_biomes[[biome_col]])

    # Species counts
    spec <- tapply(data_with_biomes[[group_col]], data_with_biomes[[biome_col]], function(v) length(unique(v)))

    # Make long tables
    df_occ <- data.frame(
      layer = layer_id,
      biome_name = names(occ),
      type = "occ_num",
      value = as.integer(occ),
      stringsAsFactors = FALSE
    )
    df_spec <- data.frame(
      layer = layer_id,
      biome_name = names(spec),
      type = "spec_num",
      value = as.integer(spec),
      stringsAsFactors = FALSE
    )
    result_list[[i]] <- rbind(df_occ, df_spec)
  }

  res_long <- do.call(rbind, result_list)

  # Filter by minimum occurrences, if needed
  occ_filtered <- subset(
    res_long,
    type == "occ_num" & value >= presence_min_n
  )
  res_long <- subset(
    res_long,
    biome_name %in% occ_filtered$biome_name & layer %in% occ_filtered$layer
  )

  rownames(res_long) <- NULL
  return(res_long)
}
