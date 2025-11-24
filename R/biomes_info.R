#' Print information for sleected biome definitions
#'
#' For each occurrence record, assigns a biome label based on spatial position and raster layer.
#'
#' @param x the layer for which information should be displayed
#'
#' @return prints information to screen
#' @export
biomes_info <- function(x) {

  if(exists("x", inherit = FALSE)){
    sapply(X = x,
           FUN = "info_grabber")
  }else{
    sapply(X = 1:nrow(biomes::biomes_information),
           FUN = "info_grabber")
  }
}
