#' Occurrence records by biome for multiple layers
#'
#' Assign biome information from one or more raster layers to occurrence records, and summarize taxon presence.
#'
#' @param x Data frame with at least longitude and latitude and a taxon column for grouping.
#' @param group_col Column name in `x` to use for grouping (e.g. "species", "family", "genus", etc.). Default: "species".
#' @param lon Column name for longitude. Default: "decimalLongitude".
#' @param lat Column name for latitude. Default: "decimalLatitude".
#' @param layer Integer vector of raster layer indices to use.
#' @param raster Path to the biome raster stack file or a SpatRaster.
#' @param legend Path to the biome lookup table (RDS) or a data frame.
#' @param presence_min_n Minimum number of records to count a taxon as present in a biome. Default: 1.
#' @param presence_min_prop Optional threshold proportion for presence.
#'
#' @return Two list objects:
#'   - biomer_taxon_summary: A table (or a list of tables for multiple layers) that shows which taxa (as specified by the grouping column, e.g., "species" or "genus") occur in which biomes, with presence indicated for each biome class.
#'   - counts_per_biome: A table (or list of tables) that summarizes for each biome layer the number of unique taxa and the total number of occurrence records in each biome class, with clearly labeled columns for biome name, number of taxa and number of occurrences.
#'
#' @examples
#' \dontrun{
#' result <- biomer_count(
#'   x = df,
#'   group_col = "species",
#'   lon = "decimalLongitude",
#'   lat = "decimalLatitude",
#'   layer = c(1, 3, 31),
#'   presence_min_n = 1,
#'   presence_min_prop = NULL
#' )
#'
#' # For single layer output, e.g.:
#' res_single <- biomer_count(
#'   x = df,
#'   species = "species",
#'   lon = "decimalLongitude",
#'   lat = "decimalLatitude",
#'   layer = 1
#' )
#'
#' # Access the results (when multiple layers)
#' result$biomer_taxon_summary$layer_1
#' result$counts_per_biome$layer_1
#' }
#'
#' @importFrom dplyr group_by filter left_join summarise mutate select distinct n_distinct
#' @importFrom tidyr pivot_wider
#' @importFrom terra rast extract nlyr vect project
#' @importFrom dplyr n
#' @importFrom dplyr transmute
#' @importFrom dplyr %>%
#' @export
biomer_count <- function(
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
  # Assertions
  if (!is.data.frame(x)) stop("`x` must be a data.frame.")
  if (!is.character(group_col) || length(group_col) != 1L) stop("`group_col` must be a single column name (character).")
  if (!is.character(lon) || length(lon) != 1L) stop("`lon` must be a single column name (character).")
  if (!is.character(lat) || length(lat) != 1L) stop("`lat` must be a single column name (character).")
  if (!group_col %in% names(x)) stop("Column `", group_col, "` not found in `x`.")
  if (!lon %in% names(x)) stop("Column `", lon, "` not found in `x`.")
  if (!lat %in% names(x)) stop("Column `", lat, "` not found in `x`.")
  if (!is.numeric(layer) || length(layer) < 1L) stop("`layer` must be integer(s).")
  if (!(is.character(raster) && length(raster) == 1L) && !inherits(raster, "SpatRaster")) stop("`raster` must be a file path or SpatRaster.")
  if (is.character(raster) && !file.exists(raster)) stop("Raster file not found: ", raster)
  if (is.character(legend) && length(legend) == 1L) {
    if (!file.exists(legend)) stop("Legend file not found: ", legend)
    legend_df <- readRDS(legend)
  } else if (is.data.frame(legend)) {
    legend_df <- legend
  } else {
    stop("`legend` must be a path to biome_legend.rds or a data.frame.")
  }
  if (length(presence_min_n) != 1L || !is.numeric(presence_min_n) || is.na(presence_min_n) || presence_min_n < 1)
    stop("`presence_min_n` must be a single numeric value >= 1.")
  if (!is.null(presence_min_prop)) {
    if (length(presence_min_prop) != 1L || !is.numeric(presence_min_prop) ||
        is.na(presence_min_prop) || presence_min_prop <= 0 || presence_min_prop > 1) {
      stop("`presence_min_prop` must be NULL or a number in (0, 1].")
    }
  }

  # Raster loading
  r_stack <- if (inherits(raster, "SpatRaster")) raster else rast(raster)

  # Prepare outputs as lists
  taxon_summary_list <- list()
  counts_per_biome_list <- list()

  # Work for each layer
  for (ly in layer) {
    if (ly < 1L || ly > nlyr(r_stack)) stop("Layer ", ly, " is out of range for raster stack.")
    r_biome <- r_stack[[ly]]

    # Project points
    pts_wgs <- vect(x, geom = c(lon, lat), crs = "EPSG:4326")
    pts_proj <- project(pts_wgs, crs(r_biome))
    biome_ids <- terra::extract(r_biome, pts_proj)[,2]

    # Legend mapping
    legend_layer <- legend_df[legend_df$layer == ly, , drop = FALSE]
    if (nrow(legend_layer) == 0L) stop("Layer ", ly, " not found in legend!")
    biome_cols <- grep("^id_", names(legend_layer), value = TRUE)
    if (length(biome_cols) == 0) stop("Legend for layer ", ly, " missing id_* columns!")
    biome_names <- unname(unlist(legend_layer[1, biome_cols]))
    id_to_name <- setNames(biome_names, seq_along(biome_cols))

    # Base table
    base <- data.frame(
      taxon = x[[group_col]],
      biome_id = biome_ids,
      stringsAsFactors = FALSE
    )
    base <- base[!is.na(base$biome_id) & !is.na(base$taxon),, drop = FALSE]

    # Count per taxon x biome
    sp_biome_counts <- base %>%
      group_by(taxon, biome_id) %>%
      summarise(
        n = n(),
        .groups = "drop"
      )
    # totals per taxon
    sp_totals <- sp_biome_counts %>%
      group_by(taxon) %>%
      summarise(n_total = sum(n), .groups = "drop")
    sp_biome_counts <- left_join(sp_biome_counts, sp_totals, by = "taxon")
    if (!is.null(presence_min_prop)) {
      sp_biome_counts$threshold <- pmax(
        presence_min_n,
        ceiling(presence_min_prop * sp_biome_counts$n_total)
      )
    } else {
      sp_biome_counts$threshold <- presence_min_n
    }
    sp_biome_counts$present <- sp_biome_counts$n >= sp_biome_counts$threshold
    sp_biome_counts$biome_name <- unname(id_to_name[as.character(sp_biome_counts$biome_id)])

    # presence matrix: taxon x biome_name
    presence_mat <- sp_biome_counts %>%
      filter(present) %>%
      transmute(taxon, biome_name, val = 1L) %>%
      distinct(taxon, biome_name, .keep_all = TRUE) %>%   # doppelte Keys eliminieren
      tidyr::pivot_wider(
        names_from  = biome_name,
        values_from = val,
        values_fn   = list(val = max),                    # falls doch Duplikate vorhanden
        values_fill = list(val = 0L)                      # Fill-Value als Liste und Integer
      )
    names(presence_mat)[1] <- group_col


    taxon_summary_list[[paste0("layer_", ly)]] <- presence_mat

    # per-biome metrics
    species_per_biome <- sp_biome_counts %>%
      filter(present) %>%
      group_by(biome_name) %>%
      summarise(
        number_taxon = n_distinct(taxon),
        .groups = "drop"
      )
    colnames(species_per_biome)[2] <- paste0("number_", group_col)

    occ_per_biome <- base %>%
      group_by(biome_id) %>%
      summarise(
        number_occurrences = n(),
        .groups = "drop"
      )
    occ_per_biome$biome_name <- unname(id_to_name[as.character(occ_per_biome$biome_id)])
    occ_per_biome <- occ_per_biome[, c("biome_name", "number_occurrences")]

    species_col <- paste0("number_", group_col)
    counts_per_biome <- left_join(
      species_per_biome, occ_per_biome, by = "biome_name"
    ) %>%
      group_by(biome_name) %>%
      summarise(
        number_species = sum(.data[[species_col]], na.rm=TRUE),
        number_occurrences = sum(number_occurrences, na.rm=TRUE),
        .groups = "drop"
      )

    counts_per_biome_list[[paste0("layer_", ly)]] <- counts_per_biome
  }
  # If only one layer: return table directly
  if (length(layer) == 1L) {
    return(list(
      biomer_taxon_summary = taxon_summary_list[[1]],
      counts_per_biome = counts_per_biome_list[[1]]
    ))
  } else {
    return(list(
      biomer_taxon_summary = taxon_summary_list,
      counts_per_biome = counts_per_biome_list
    ))
  }
}
