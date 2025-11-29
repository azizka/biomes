#' Load package biome data and example files
#'
#' Loads the 31 biome layers provided by the package as raster stack.
#'
#' @return Returns a list with any or all of: raster, legend, info and example
#' @examples
#' # Load the default biome raster stack
#' biomes_raster <- biomes_get()
#'
#' @importFrom terra rast
#' @export
biomes_get <- function(...) {

  # Assertion: no arguments allowed
  checkmate::assert_true(
    length(list(...)) == 0,
    .var.name = "biomes_get() does not take any arguments"
  )

  rasterfile <- system.file("extdata/Biomes_Inventory_RasterStack.tif",
                            package = "biomes")

  out <- terra::rast(rasterfile)
  return(out)
}
