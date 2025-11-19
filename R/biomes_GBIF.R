#' Download and filter GBIF occurrences for multiple taxa
#'
#' Retrieve occurrence records for one or multiple taxa from GBIF.
#'
#' Coordinates can optionally be cleaned using `CoordinateCleaner`. No files
#' are written.
#'
#' @param taxon One or more scientific names to query (species, genus etc.). Required.
#' @param filter_clean Logical. If `TRUE`, run basic spatial cleaning on
#'   coordinates using `CoordinateCleaner::clean_coordinates()`. Default: `FALSE`.
#' @param filter_sea Logical. If `TRUE`, also filter occurrences that fall in
#'   the sea (`tests` includes "seas"). Default: `FALSE`.
#' @param year_min Optional integer. Minimum event year for records to keep.
#' @param year_max Optional integer. Maximum event year for records to keep.
#' @param country Optional character vector. One or more country ISO 3166-1 alpha-2 codes to filter occurrences by country.
#' @param limit Optional integer. Record limit passed to `rgbif::occ_search()` (per taxon).
#'
#' @return Data frame of GBIF occurrences after optional cleaning.
#'
#' @examples
#' \dontrun{
#' dat <- biomer_GBIF(
#'   taxon = c("Solemyida", "Bufo bufo"),
#'   year_min = 2000,
#'   year_max = 2024,
#'   limit = 5000
#' )
#' }
#'
#' @export
#'
#' @importFrom rgbif name_backbone occ_search
#' @importFrom CoordinateCleaner clean_coordinates
#' @importFrom dplyr filter
biomer_GBIF <- function(
    taxon,
    filter_clean = FALSE,
    filter_sea = FALSE,
    year_min = NULL,
    year_max = NULL,
    country = NULL,
    limit = NULL
) {
  # ------------------------------------------------------------------------
  # Assertions
  # ------------------------------------------------------------------------
  # taxon kommt als character vector (muss mind. 1 sein)
  if (missing(taxon) || !is.character(taxon) || length(taxon) < 1L ||
      any(is.na(taxon)) || any(nchar(taxon) == 0)) {
    stop("`taxon` must be a non-empty character vector of taxon names.")
  }
  if (!is.logical(filter_clean) || length(filter_clean) != 1L ||
      is.na(filter_clean)) {
    stop("`filter_clean` must be TRUE or FALSE.")
  }
  if (!is.logical(filter_sea) || length(filter_sea) != 1L ||
      is.na(filter_sea)) {
    stop("`filter_sea` must be TRUE or FALSE.")
  }
  if (!is.null(year_min)) {
    if (!is.numeric(year_min) || length(year_min) != 1L ||
        is.na(year_min)) {
      stop("`year_min` must be NULL or a single numeric value.")
    }
  }
  if (!is.null(year_max)) {
    if (!is.numeric(year_max) || length(year_max) != 1L ||
        is.na(year_max)) {
      stop("`year_max` must be NULL or a single numeric value.")
    }
  }
  if (!is.null(limit)) {
    if (!is.numeric(limit) || length(limit) != 1L ||
        is.na(limit) || limit <= 0) {
      stop("`limit` must be NULL or a single positive number.")
    }
    if (limit > 100000) {
      stop("The maximum allowed value for 'limit' in occ_search() is 100000.")
    }
  }

  # ------------------------------------------------------------------------
  # Build year filter
  # ------------------------------------------------------------------------
  year_str <- NULL
  if (!is.null(year_min) && !is.null(year_max)) {
    year_str <- sprintf("%d,%d", as.integer(year_min), as.integer(year_max))
  } else if (!is.null(year_min) && is.null(year_max)) {
    year_str <- sprintf("%d,3000", as.integer(year_min))
  } else if (is.null(year_min) && !is.null(year_max)) {
    year_str <- sprintf("0,%d", as.integer(year_max))
  }

  # ------------------------------------------------------------------------
  # Resolve all taxonKeys
  # ------------------------------------------------------------------------
  taxon_info <- lapply(taxon, function(t) {
    message("Resolving taxon key from GBIF backbone for: ", t)
    name_info <- rgbif::name_backbone(name = t)
    if (is.null(name_info$usageKey)) {
      stop(sprintf("GBIF did not return a valid taxonKey for `%s`.", t))
    }
    list(
      name = name_info$scientificName,
      rank = name_info$rank,
      key = name_info$usageKey
    )
  })

  # ------------------------------------------------------------------------
  # Fetch data: loop over all taxonKeys
  # ------------------------------------------------------------------------
  all_occ_data <- lapply(taxon_info, function(ti) {
    message(
      sprintf(
        "Found taxon: %s (rank: %s, key: %s)",
        ti$name, ti$rank, ti$key
      )
    )
    message("Querying GBIF via occ_search() for taxonKey: ", ti$key)
    res <- rgbif::occ_search(
      taxonKey = ti$key,
      hasCoordinate = TRUE,
      hasGeospatialIssue = FALSE,
      year = year_str,
      country = country,
      limit = limit
    )
    res$data
  })

  occ_data <- do.call(rbind, all_occ_data)
  if (is.null(occ_data) || nrow(occ_data) == 0L) {
    message("No records returned by occ_search().")
    return(data.frame())
  }
  message(sprintf("Retrieved %d occurrence records in total.", nrow(occ_data)))

  # ------------------------------------------------------------------------
  # Coordinate cleaning (optional)
  # ------------------------------------------------------------------------
  if (isTRUE(filter_clean)) {
    message("Cleaning coordinates with CoordinateCleaner...")
    occ_data <- dplyr::filter(
      occ_data,
      !is.na(decimalLatitude),
      !is.na(decimalLongitude)
    )
    cc_tests <- if (isTRUE(filter_sea)) {
      c("capitals", "centroids", "equal", "gbif", "institutions", "outliers", "zeros", "seas")
    } else {
      c("capitals", "centroids", "equal", "gbif", "institutions", "outliers", "zeros")
    }
    flags <- CoordinateCleaner::clean_coordinates(
      x = occ_data,
      lat = "decimalLatitude",
      lon = "decimalLongitude",
      countries = "countryCode",
      species = "species",
      tests = cc_tests
    )
    occ_data <- occ_data[flags$.summary, , drop = FALSE]
  }

  # ------------------------------------------------------------------------
  # Return cleaned (or raw) dataset
  # ------------------------------------------------------------------------
  occ_data
}
