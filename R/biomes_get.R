#' Load package biome data and example files
#'
#' Loads the 31 biome layers provided by the package as raster stack.
#'
#' @return Returns a list with any or all of: raster, legend, info and example
#' @examples
#' \dontrun{
#' info <- biomes_get()
#' }
#' @importFrom terra rast
#' @export
biomes_get <- function() {
  rasterfile <- system.file("extdata/Biome_Inventory_RasterStack.tif",
                            package = "biomes")

  out <- terra::rast(rasterfile)
  return(out)
}
