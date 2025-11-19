#' Assign biome to occurrences
#'
#' For each occurrence record, assigns a biome label based on spatial position and raster layer.
#'
#' @param x Data frame with at least longitude and latitude and a taxon column for grouping.
#' @param lon Column name for longitude. Default: "decimalLongitude".
#' @param lat Column name for latitude. Default: "decimalLatitude".
#' @param layer Integer vector of raster layer indices to use.
#' @param raster Path to the biome raster stack file or a SpatRaster.
#' @param legend Path to the biome lookup table (RDS) or a data frame.
#'
#' @return For one layer: named vector (biome with occurrence count). For multiple: data.frame with columns layer, biome, occ_count.
#' @export
biomes_assign <- function(
    x,
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    layer,
    raster = system.file("extdata", "Biome_Inventory_RasterStack.tif", package = "biomer"),
    legend = system.file("extdata", "biome_legend.rds", package = "biomer")
) {

  # Load raster stack and legend
  r_stack <- if (inherits(raster, "SpatRaster")) raster else terra::rast(raster)
  legend_df <- if (is.character(legend)) readRDS(legend) else legend

  # Prepare points (project coordinates)
  pts <- terra::vect(x, geom = c(lon, lat), crs = "EPSG:4326")

  # Extract biome names for each layer
  biome_names <- list()
  for (i in seq_along(layer)) {
    lyr <- layer[i]
    if (lyr < 1L || lyr > terra::nlyr(r_stack)) stop("Layer ", lyr, " is out of range")
    r_biome <- r_stack[[lyr]]
    pts_proj <- terra::project(pts, terra::crs(r_biome))
    biome_id <- terra::extract(r_biome, pts_proj)[,2]
    legend_layer <- legend_df[legend_df$layer == lyr,,drop=FALSE]
    biome_cols <- grep("^id_", names(legend_layer), value=TRUE)
    names_vec <- unname(unlist(legend_layer[1, biome_cols]))
    id_to_name <- setNames(names_vec, seq_along(biome_cols))
    biome_name <- id_to_name[as.character(biome_id)]
    biome_names[[i]] <- as.character(biome_name)
  }
  # Output
  if (length(layer) == 1L) {
    return(biome_names[[1]])
  } else {
    result <- as.data.frame(biome_names, stringsAsFactors=FALSE)
    colnames(result) <- paste0("layer_", layer, "_biome")
    stopifnot(nrow(result) == nrow(x))
    return(result)
  }
}

