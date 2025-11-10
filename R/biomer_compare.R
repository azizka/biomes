#' Compare biome occurrences across multiple layers
##' Compare biome occurrences across multiple layers
#'
#' @param taxon Scientific name for querying GBIF (character). Default is FALSE.
#' @param x A data.frame with coordinates. Used if taxon is FALSE.
#' @param lon Longitude column name.
#' @param lat Latitude column name.
#' @param layer Integer vector of biome layer(s) to use.
#' @param limit Optional integer. Maximum number of records to fetch (passed to biomer_GBIF). Default is NULL.
#' @details
#' If `taxon` is specified and `limit > 100000`, an error is thrown. To get more records, use biomer_GBIF directly with the download workflow.
#' @export
biomer_compare <- function(
    taxon = FALSE,
    x = NULL,
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    layer = 1,
    limit = 100000
) {
  if (!is.null(limit) && limit > 100000) {
    stop("Values greater than 100,000 for 'limit' are not supported in biomer_compare(). Use biomer_GBIF(use_download = TRUE, ...) for large downloads.")
  }

  raw_data <- NULL
  if (!identical(taxon, FALSE)) {
    raw_data <- biomer_GBIF(
      taxon = taxon,
      use_download = FALSE,
      limit = limit
    )
    x <- raw_data
  } else {
    if (is.null(x)) stop("Either taxon or x must be provided.")
    raw_data <- x
  }

  layer <- unique(layer)
  ngroups <- length(layer)

  get_layer_entry <- function(layer_id) {
    count <- biomer_count(
      x = x,
      lon = lon,
      lat = lat,
      layer = layer_id
    )
    plot <- biomer_plot(
      x = x,
      lon = lon,
      lat = lat,
      layer = layer_id,
      plot_type = "both",
      show_plot = FALSE
    )
    layername <- paste0("layer_", layer_id)
    list(
      biomer_taxon_summary = count$biomer_taxon_summary,
      counts_per_biome     = count$counts_per_biome,
      mapplot              = plot$mapplot[[layername]],
      barplot              = plot$barplot[[layername]]
    )
  }

  if (ngroups == 1) {
    layer_result <- get_layer_entry(layer[1])
    out <- c(layer_result, list(biomer_GBIF_data = raw_data))
  } else {
    result_list <- lapply(layer, get_layer_entry)
    names(result_list) <- paste0("layer_", layer)
    out <- c(result_list, list(biomer_GBIF_data = raw_data))
  }


    return(out)
}
