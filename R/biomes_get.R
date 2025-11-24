#' Load package biome data and example files
#'
#' Loads the 31 biome layers provided by the package as raster stack.
#'
#' @return Returns a list with any or all of: raster, legend, info and example
#' @examples
#' \dontrun{
#' info <- biomes_get()
#' }
#' @export#'
#' @importFrom terra rast

biomes_get <- function() {
  # Load raster stack
  rasterfile <- system.file("extdata/Biome_Inventory_RasterStack.tif",
                            package = "biomes")

  out <- terra::rast(rasterfile)
  return(out)
}

#
#
#
# biomes_get <- function(raster = TRUE,
#                        legend = TRUE,
#                        info = TRUE,
#                        example = TRUE) {
#   out <- list()
#   data_dir <- file.path("data")
#
#   # Load raster stack if requested
#   if (raster) {
#     rasterfile <- system.file("extdata/Biome_Inventory_RasterStack.tif", package = "biomes")
#     if (file.exists(rasterfile)) {
#       biome_raster <- terra::rast(rasterfile)
#       out$raster <- biome_raster
#     } else {
#       message("biome_raster file not found.")
#     }
#   }
#
#   # Load legend file if requested
#   if (legend) {
#     legendfile <- system.file("extdata/biome_legend.rds", package = "biomes")
#     if (file.exists(legendfile)) {
#       biome_legend <- readRDS(legendfile)
#       out$legend <- biome_legend
#     } else {
#       message("biome_legend file not found.")
#     }
#   }
#
#   # Load information file
#   if (info) {
#     infofile <- file.path(data_dir, "biome_information.rds")
#     if (file.exists(infofile)) {
#       biome_info <- readRDS(infofile)
#       out$info <- biome_info
#     } else {
#       message("biome_information.rds file not found.")
#     }
#   }
#
#   # Load example rds file if requested
#   if (example) {
#     example_file <- file.path(data_dir, "example_file.rds")
#     if (file.exists(example_file)) {
#       example_data <- readRDS(example_file)
#       out$example <- example_data
#     } else {
#       warning("example_file.rds not found in extdata.")
#     }
#   }
#
#   return(out)
# }
