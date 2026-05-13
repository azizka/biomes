#' Classify occurrences into biomes
#'
#' For each occurrence record, assigns a biome label based on its spatial
#' position and one or more biome raster layers. One row of the returned
#' data frame corresponds to one row (one occurrence record) of `x`.
#'
#' @param x A data frame (with longitude and latitude columns), an `sf`
#'   spatial object, or a `terra::SpatVector` of point geometries.
#' @param biome A `terra::SpatRaster` with one or more biome layers. If
#'   `NULL` (the default), the 31 layers shipped with the package are used.
#' @param lon Column name of longitude in `x` (only used if `x` is a
#'   non-spatial data frame). Default: "decimalLongitude".
#' @param lat Column name of latitude in `x` (only used if `x` is a
#'   non-spatial data frame). Default: "decimalLatitude".
#' @param value Character. One of `"ID"`, `"name"`, or `"both"`. Controls
#'   whether the returned data frame contains the raw raster value
#'   (`"ID"`), the biome name (`"name"`), or both (`"both"`).
#' @param raster_file Optional path to a custom biome raster stack file
#'   or a `SpatRaster`. Only used if `biome` is `NULL`.
#'
#' @return A data frame with one row per record in `x`. Columns are named
#'   after the input layers, with the suffix `_value` for the raster value
#'   and `_name` for the biome name. For raster values without a name in
#'   the legend (typically azonal classes encoded with high values),
#'   `_name` falls back to `"azonal (raster value: X)"`.
#'
#' @examples
#' # Load example occurrence data
#' data("biomes_example")
#'
#' # Classify occurrences and return biome names (uses the 31 default layers)
#' biomes_classify(
#'   x     = biomes_example,
#'   lon   = "decimalLongitude",
#'   lat   = "decimalLatitude",
#'   value = "name"
#' )
#'
#' # Single layer, both raster value and biome name
#' layers <- biomes_get()
#' biomes_classify(
#'   x     = biomes_example,
#'   biome = layers[[1]],
#'   value = "both"
#' )
#'
#' @importFrom terra nlyr rast sources
#' @importFrom readr parse_number
#' @export
biomes_classify <- function(
    x,
    biome = NULL,
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    value = "name",
    raster_file = NULL
) {

  # Assertions: x is either an sf spatial object, a SpatVector or a data frame
  checkmate::assert_true(
    any(c("data.frame", "sf", "SpatVector") %in% class(x)),
    .var.name = "x"
  )

  # Assertions: x contains the lat and long columns if a (non-sf) data frame
  if (inherits(x, "data.frame") && !inherits(x, "sf")) {
    checkmate::assert_subset(c(lon, lat), choices = names(x), .var.name = "x")
    checkmate::assert_numeric(x[[lon]], any.missing = FALSE)
    checkmate::assert_numeric(x[[lat]], any.missing = FALSE)
  }

  # Assertions: biome is a terra raster or raster stack
  if (!is.null(biome)) {
    checkmate::assert_class(biome, "SpatRaster")
  }

  # Assertions: raster_file must be NULL, a path to a tif, or a SpatRaster
  if (!is.null(raster_file)) {
    if (is.character(raster_file)) {
      checkmate::assert_file_exists(raster_file)
    } else {
      checkmate::assert_class(raster_file, "SpatRaster")
    }
  }

  # Assertions: value
  checkmate::assert_choice(value, c("ID", "name", "both"))

  # Give users the option to not provide biomes and load the defaults
  # instead, or a custom raster file.
  if (is.null(biome)) {
    if (is.null(raster_file)) {
      message("no biome file or layer provided using default biomes")
      raster_file <- system.file(
        "extdata",
        "Biomes_Inventory_RasterStack.tif",
        package = "biomes"
      )
    }
    biome <- terra::rast(raster_file)
  }

  # Prepare points (project coordinates)
  if (is.data.frame(x) && !inherits(x, "sf")) {
    warning("Coordinates provided as data.frame, assuming WGS84 as CRS")
    pts <- terra::vect(
      as.data.frame(x),
      geom = c(lon, lat),
      crs  = "EPSG:4326"
    )
  } else if (inherits(x, "SpatVector") || inherits(x, "sf")) {
    pts <- x
  }

  # Use the packaged legend if the default raster is in use.
  default_raster <- system.file(
    "extdata",
    "Biomes_Inventory_RasterStack.tif",
    package = "biomes"
  )
  legend_df <- if (identical(terra::sources(biome), default_raster)) {
    biomes::biomes_legend
  } else {
    NULL
  }

  # Extract raster values at each point. terra::extract() adds a leading
  # "ID" column with the point index plus one column per raster layer.
  biome_id   <- terra::extract(biome, pts)
  layer_cols <- setdiff(names(biome_id), "ID")

  # Print a short summary of which biome layers were used (#62).
  layer_idx <- suppressWarnings(readr::parse_number(layer_cols))
  if (!is.null(legend_df) && all(!is.na(layer_idx))) {
    message(sprintf(
      "Classified %d record(s) against %d biome layer(s):",
      nrow(biome_id), length(layer_cols)
    ))
    for (i in seq_along(layer_idx)) {
      idx <- layer_idx[i]
      pub <- if (idx >= 1 && idx <= nrow(biomes::biomes_information)) {
        biomes::biomes_information[[idx, "publication"]]
      } else {
        NA
      }
      message(sprintf("  - %s (%s)", layer_cols[i], pub))
    }
  } else {
    message(sprintf(
      "Classified %d record(s) against %d layer(s): %s",
      nrow(biome_id), length(layer_cols),
      paste(layer_cols, collapse = ", ")
    ))
  }

  # Build a data frame of layer values (drop terra's point-id column and
  # rename to the user-facing "<layer>_value" pattern).
  value_df <- biome_id[, layer_cols, drop = FALSE]
  names(value_df) <- paste0(layer_cols, "_value")

  # If we cannot match the layer to the packaged legend, return raw values.
  if (is.null(legend_df) || value == "ID") {
    if (value == "ID" || is.null(legend_df)) {
      if (value != "ID" && is.null(legend_df)) {
        warning(
          "biome names are only available for the default raster; ",
          "returning raster values instead of names."
        )
      }
      return(value_df)
    }
  }

  # Build a parallel data frame of biome names.
  name_df <- as.data.frame(
    lapply(layer_cols, function(layer_name) {
      layer_index <- readr::parse_number(layer_name)
      lookup      <- unlist(legend_df[layer_index, -c(1:2)])
      raw_values  <- value_df[[paste0(layer_name, "_value")]]

      out <- lookup[raw_values]
      # Fall back for raster values not present in the legend (azonal
      # classes encoded with high values like 90+).
      missing <- which(is.na(out) & !is.na(raw_values))
      if (length(missing) > 0) {
        out[missing] <- paste0("azonal (raster value: ", raw_values[missing], ")")
      }
      out
    }),
    stringsAsFactors = FALSE
  )
  names(name_df) <- paste0(layer_cols, "_name")

  if (value == "name") {
    return(name_df)
  }

  # value == "both": interleave so that for each layer the *_value column
  # is followed by its *_name column.
  interleaved <- as.list(rep(NA, 2 * length(layer_cols)))
  for (i in seq_along(layer_cols)) {
    interleaved[[2 * i - 1]] <- value_df[[i]]
    interleaved[[2 * i]]     <- name_df[[i]]
  }
  out <- as.data.frame(interleaved, stringsAsFactors = FALSE)
  names(out) <- as.vector(rbind(names(value_df), names(name_df)))
  out
}
