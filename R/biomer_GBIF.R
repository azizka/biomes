#' Download and filter GBIF occurrences for a taxon
#'
#' Retrieve occurrence records for a given taxon from GBIF.
#'
#' By default this uses `rgbif::occ_search()`, which does not require a GBIF
#' account. If `use_download = TRUE`, it uses the GBIF download API via
#' `rgbif::occ_download()`, which requires GBIF credentials and can return
#' larger datasets.
#'
#' Coordinates can optionally be cleaned using `CoordinateCleaner`. No files
#' are written unless `write_files = TRUE`.
#'
#' @param taxon Scientific name to query (species, genus, etc.). Required.
#' @param use_download Logical. If `TRUE`, use the GBIF download workflow
#'   (`occ_download`) instead of `occ_search`. `occ_download` is recommended
#'   for large or complete datasets (over 100,000 records) and when a citable
#'   GBIF download (with DOI) is needed. Default: `FALSE`.
#' @param username GBIF username (only used if `use_download = TRUE`).
#' @param pwd GBIF password (only used if `use_download = TRUE`).
#' @param email GBIF account email (only used if `use_download = TRUE`).
#' @param write_files Logical. If `TRUE`, write outputs such as citation text,
#'   the raw GBIF CSV, and the cleaned CSV to disk. Default: `FALSE` (only used if `use_download = TRUE`).
#' @param save_dir Directory used for saving outputs when `write_files = TRUE`.
#'   Default: `"data/GBIF"`.
#' @param filter_clean Logical. If `TRUE`, run basic spatial cleaning on
#'   coordinates using `CoordinateCleaner::clean_coordinates()`. Default: `FALSE`.
#' @param filter_sea Logical. If `TRUE`, also filter occurrences that fall in
#'   the sea (`tests` includes "seas"). Default: `FALSE`.
#' @param year_min Optional integer. Minimum event year for records to keep.
#' @param year_max Optional integer. Maximum event year for records to keep.
#'@param country Optional character vector. One or more country ISO 3166-1 alpha-2 codes to filter occurrences by country.

#' @param limit Optional integer. Record limit passed to `rgbif::occ_search()`.
#'
#' @return A data frame of GBIF occurrences after optional cleaning.
#'
#' @examples
#' \dontrun{
#' dat <- biomer_GBIF(
#'   taxon = "Solemyida",
#'   year_min = 2000,
#'   year_max = 2024,
#'   limit = 5000
#' )
#' }
#'
#' @export
#'

#' @importFrom rgbif name_backbone occ_search occ_download occ_download_wait
#' @importFrom rgbif occ_download_get occ_download_import pred pred_gte pred_lte
#' @importFrom rgbif gbif_citation
#' @importFrom CoordinateCleaner clean_coordinates
#' @importFrom dplyr filter
#' @importFrom readr read_tsv write_csv
#' @importFrom utils unzip
biomer_GBIF <- function(
    taxon,
    use_download = FALSE,
    username = NULL,
    pwd = NULL,
    email = NULL,
    write_files = FALSE,
    save_dir = "data/GBIF",
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
  # taxon
  if (missing(taxon) || !is.character(taxon) || length(taxon) != 1L ||
      is.na(taxon) || nchar(taxon) == 0) {
    stop("`taxon` must be a single non-empty character string.")
  }

  # logical flags
  if (!is.logical(use_download) || length(use_download) != 1L ||
      is.na(use_download)) {
    stop("`use_download` must be TRUE or FALSE.")
  }
  if (!is.logical(write_files) || length(write_files) != 1L ||
      is.na(write_files)) {
    stop("`write_files` must be TRUE or FALSE.")
  }
  if (!is.logical(filter_clean) || length(filter_clean) != 1L ||
      is.na(filter_clean)) {
    stop("`filter_clean` must be TRUE or FALSE.")
  }
  if (!is.logical(filter_sea) || length(filter_sea) != 1L ||
      is.na(filter_sea)) {
    stop("`filter_sea` must be TRUE or FALSE.")
  }

  # save_dir
  if (!is.character(save_dir) || length(save_dir) != 1L ||
      is.na(save_dir) || nchar(save_dir) == 0) {
    stop("`save_dir` must be a single non-empty directory path string.")
  }

  # year_min / year_max
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

  # limit
  if (!is.null(limit)) {
    if (!is.numeric(limit) || length(limit) != 1L ||
        is.na(limit) || limit <= 0) {
      stop("`limit` must be NULL or a single positive number.")
    }
  }

  # GBIF credentials are only required if use_download = TRUE
  if (isTRUE(use_download)) {
    if (is.null(username) || !is.character(username) ||
        length(username) != 1L || is.na(username) || nchar(username) == 0) {
      stop("`username` is required when `use_download = TRUE`.")
    }
    if (is.null(pwd) || !is.character(pwd) ||
        length(pwd) != 1L || is.na(pwd) || nchar(pwd) == 0) {
      stop("`pwd` is required when `use_download = TRUE`.")
    }
    if (is.null(email) || !is.character(email) ||
        length(email) != 1L || is.na(email) || nchar(email) == 0) {
      stop("`email` is required when `use_download = TRUE`.")
    }
  }


  # Assertion für occ_search()-limit
  if (!isTRUE(use_download)) {
    if (is.null(limit)) {
      stop("You must set argument 'limit' (max. 100000) when use_download = FALSE (occ_search workflow).")
    } else if (limit > 100000) {
      stop("The maximum allowed value for 'limit' in occ_search() is 100000. For larger datasets use use_download = TRUE.")
    }
  }


  # ------------------------------------------------------------------------
  # Resolve taxonKey
  # ------------------------------------------------------------------------

  message("Resolving taxon key from GBIF backbone...")
  name_info <- rgbif::name_backbone(name = taxon)

  if (is.null(name_info$usageKey)) {
    stop("GBIF did not return a valid taxonKey for `taxon`.")
  }

  taxon_key <- name_info$usageKey
  taxon_rank <- name_info$rank

  message(
    sprintf(
      "Found taxon: %s (rank: %s, key: %s)",
      name_info$scientificName,
      taxon_rank,
      taxon_key
    )
  )

  # ------------------------------------------------------------------------
  # Build year filter
  # ------------------------------------------------------------------------

  year_str <- NULL

  if (!is.null(year_min) && !is.null(year_max)) {
    # range [year_min, year_max]
    year_str <- sprintf("%d,%d", as.integer(year_min), as.integer(year_max))
  } else if (!is.null(year_min) && is.null(year_max)) {
    # [year_min, 3000]
    year_str <- sprintf("%d,3000", as.integer(year_min))
  } else if (is.null(year_min) && !is.null(year_max)) {
    # [0, year_max]
    year_str <- sprintf("0,%d", as.integer(year_max))
  }

  # ------------------------------------------------------------------------
  # Ensure output directory if we will be writing
  # ------------------------------------------------------------------------

  if (isTRUE(write_files)) {
    dir.create(save_dir, showWarnings = FALSE, recursive = TRUE)
  }

  # ------------------------------------------------------------------------
  # Fetch data: occ_search (default) vs occ_download (bulk)
  # ------------------------------------------------------------------------

  if (!isTRUE(use_download)) {
    # lightweight search via occ_search
    message("Querying GBIF via occ_search()...")

    res <- rgbif::occ_search(
      taxonKey = taxon_key,
      hasCoordinate = TRUE,
      hasGeospatialIssue = FALSE,
      year = year_str,
      limit = limit
    )

    occ_data <- res$data

    if (is.null(occ_data) || nrow(occ_data) == 0L) {
      message("No records returned by occ_search().")
      return(data.frame())
    }

  } else {
    # full download workflow
    message("Requesting GBIF download via occ_download()...")

    preds <- list(
      rgbif::pred("taxonKey", taxon_key),
      rgbif::pred("hasCoordinate", TRUE),
      rgbif::pred("hasGeospatialIssue", FALSE)
    )

    if (!is.null(year_min)) {
      preds <- append(
        preds,
        list(rgbif::pred_gte("year", as.integer(year_min)))
      )
    }

    if (!is.null(year_max)) {
      preds <- append(
        preds,
        list(rgbif::pred_lte("year", as.integer(year_max)))
      )
    }

    if (!is.null(country)) {
      if (length(country) > 1) {
        preds <- append(
          preds,
          list(rgbif::pred_in("country", country))
        )
      } else {
        preds <- append(
          preds,
          list(rgbif::pred("country", country))
        )
      }
    }



    dl <- do.call(
      rgbif::occ_download,
      c(
        preds,
        list(
          format = "SIMPLE_CSV",
          user = username,
          pwd = pwd,
          email = email
        )
      )
    )

    rgbif::occ_download_wait(dl)

    dl_key <- dl[[1]]

    # choose target path for download artifacts
    out_path <- if (isTRUE(write_files)) {
      save_dir
    } else {
      tempdir()
    }

    # write citation text if requested
    if (isTRUE(write_files)) {
      message("Saving GBIF citation...")
      cit <- rgbif::gbif_citation(dl_key)
      cit_text <- capture.output(print(cit))
      writeLines(
        cit_text,
        file.path(out_path, paste0(dl_key, "_citation.txt"))
      )
    }

    message("Fetching and unpacking GBIF download...")
    rgbif::occ_download_get(
      key = dl_key,
      overwrite = TRUE,
      path = out_path
    )

    zip_path <- file.path(out_path, paste0(dl_key, ".zip"))

    files_unzipped <- utils::unzip(
      zipfile = zip_path,
      exdir = out_path
    )

    csv_file <- files_unzipped[grepl("\\.csv$", files_unzipped)][1]

    if (length(csv_file) == 0L || is.na(csv_file)) {
      stop("Could not locate CSV in the GBIF download archive.")
    }

    occ_data <- readr::read_tsv(
      csv_file,
      guess_max = 100000
    )
  }

  message(
    sprintf(
      "Retrieved %d occurrence records.",
      nrow(occ_data)
    )
  )

  # ------------------------------------------------------------------------
  # Coordinate cleaning (optional)
  # ------------------------------------------------------------------------

  if (isTRUE(filter_clean)) {
    message("Cleaning coordinates with CoordinateCleaner...")

    # basic NA filter before CoordinateCleaner
    occ_data <- dplyr::filter(
      occ_data,
      !is.na(decimalLatitude),
      !is.na(decimalLongitude)
    )

    cc_tests <- if (isTRUE(filter_sea)) {
      c(
        "capitals",
        "centroids",
        "equal",
        "gbif",
        "institutions",
        "outliers",
        "zeros",
        "seas"
      )
    } else {
      c(
        "capitals",
        "centroids",
        "equal",
        "gbif",
        "institutions",
        "outliers",
        "zeros"
      )
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

    # if we are in download mode and write_files = TRUE we emit cleaned CSV
    if (isTRUE(write_files) && isTRUE(use_download)) {
      out_csv <- file.path(save_dir, "gbif_filtered.csv")
      readr::write_csv(occ_data, out_csv)
      message(
        sprintf(
          "Saved filtered data to: %s",
          normalizePath(out_csv, winslash = "/")
        )
      )
    }
  }

  # ------------------------------------------------------------------------
  # Return cleaned (or raw) dataset
  # ------------------------------------------------------------------------

  occ_data
}

