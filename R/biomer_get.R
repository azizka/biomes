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
#' biomer_info <- biomer_get()
#' }
#' @export
biomer_get <- function(raster = TRUE,
                       legend = TRUE,
                       info = TRUE,
                       example = TRUE) {
  out <- list()

  # Load raster stack if requested
  if (raster) {
    rasterfile <- system.file("extdata/Biome_Inventory_RasterStack.tif", package = "biomer")
    if (file.exists(rasterfile)) {
      biome_raster <- terra::rast(rasterfile)
      out$raster <- biome_raster
    } else {
      message("biome_raster file not found.")
    }
  }

  # Load legend file if requested
  if (legend) {
    legendfile <- system.file("extdata/biome_legend.rds", package = "biomer")
    if (file.exists(legendfile)) {
      biome_legend <- readRDS(legendfile)
      out$legend <- biome_legend
    } else {
      message("biome_legend file not found.")
    }
  }

  # Load information file
  if (info) {
    infofile <- system.file("extdata/biomer_information.xlsx", package = "biomer")
    if (!file.exists(infofile)) infofile <- "biomer_information.xlsx" # fallback to working directory
    if (file.exists(infofile)) {
      if (!requireNamespace("readxl", quietly = TRUE)) stop("Package 'readxl' required for info table.")
      biome_info <- readxl::read_excel(infofile)
      out$info <- biome_info
    } else {
      message("biomer_information.xlsx file not found.")
    }
  }

  # Load example rds file if requested
  if (example) {
    example_file <- system.file("extdata/example_file.rds", package = "biomer")
    if (file.exists(example_file)) {
      example_data <- readRDS(example_file)
      out$example <- example_data
    } else {
      warning("example_file.rds not found in extdata.")
    }
  }

  return(out)
}
