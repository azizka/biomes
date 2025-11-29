#' Print information for sleected biome definitions
#'
#' For each occurrence record, assigns a biome label based on spatial position and raster layer.
#'
#' @param x the layer for which information should be displayed
#'
#' @return prints information to screen
#'
#' @examples
#' # Print information for all biome definitions
#' biomes_info()
#'
#' # Print information for the first three biomes
#' biomes_info(1:3)
#'
#' @export
biomes_info <- function(x = NULL) {

  # Assertions: validate x (biome indices 1–31)
  if (!is.null(x)) {
    checkmate::assert_integerish(
      x,
      lower = 1,
      upper = 31,
      any.missing = FALSE,
      .var.name = "x"
    )
  }

  if (is.null(x)) {
    idx <- 1:31
  } else {
    idx <- x
  }

  sapply(X = idx, FUN = info_grabber)

  invisible(NULL)
}
