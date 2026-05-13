#' Load the packaged biome raster stack
#'
#' Loads the 31 biome layers shipped with the package as a
#' `terra::SpatRaster` stack.
#'
#' @param ... Reserved for future use. Currently no arguments are
#'   accepted; passing any will raise an error.
#'
#' @return A `terra::SpatRaster` with 31 layers, one per biome
#'   classification (in the same order as the rows of
#'   [`biomes_information`]).
#'
#' @examples
#' # Load the default biome raster stack
#' biomes_raster <- biomes_get()
#' biomes_raster
#'
#' @importFrom terra rast
#' @export
biomes_get <- function(...) {

  # Assertion: no arguments allowed
  checkmate::assert_true(
    length(list(...)) == 0,
    .var.name = "biomes_get() does not take any arguments"
  )

  rasterfile <- system.file(
    "extdata/Biomes_Inventory_RasterStack.tif",
    package = "biomes"
  )

  terra::rast(rasterfile)
}
