#' Load package biome data and example files
#'
#' Loads the raster stack and legend as list elements,
#' optionally displays PNG maps from a single zip file,
#' and provides an option to load an example .rds dataset.
#'
#' @param raster Logical. If TRUE (default), loads and returns biome raster as list element.
#' @param legend Logical. If TRUE (default), loads and returns biome legend as list element.
#' @param info Logical. If TRUE (default), loads and returns a table summarizing all available biome classifications for comparison.
#' @param example Logical. If TRUE, load and return example_file.rds in the list.
#' @return Returns a list with any or all of: raster, legend, info and example
#' @examples
#' \dontrun{
#' info <- biomes_get()
#' }
#' @export
biomes_get <- function(raster = TRUE,
                       legend = TRUE,
                       info = TRUE,
                       example = TRUE) {
  out <- list()
  data_dir <- file.path("data")

  # Load raster stack if requested
  if (raster) {
    rasterfile <- system.file("extdata/Biome_Inventory_RasterStack.tif", package = "biomes")
    if (file.exists(rasterfile)) {
      biome_raster <- terra::rast(rasterfile)
      out$raster <- biome_raster
    } else {
      message("biome_raster file not found.")
    }
  }

  # Load legend file if requested
  if (legend) {
    legendfile <- system.file("extdata/biome_legend.rds", package = "biomes")
    if (file.exists(legendfile)) {
      biome_legend <- readRDS(legendfile)
      out$legend <- biome_legend
    } else {
      message("biome_legend file not found.")
    }
  }

  # Load information file
  if (info) {
    infofile <- file.path(data_dir, "biome_information.rds")
    if (file.exists(infofile)) {
      biome_info <- readRDS(infofile)
      out$info <- biome_info
    } else {
      message("biome_information.rds file not found.")
    }
  }

  # Load example rds file if requested
  if (example) {
    example_file <- file.path(data_dir, "example_file.rds")
    if (file.exists(example_file)) {
      example_data <- readRDS(example_file)
      out$example <- example_data
    } else {
      warning("example_file.rds not found in extdata.")
    }
  }

  return(out)
}
