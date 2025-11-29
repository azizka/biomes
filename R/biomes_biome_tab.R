#' Count occurrences per biome
#'
#' Summarizes the number of occurrence records in each biome and layer, outputting a long-format table.
#'
#' @param x Data frame with occurrence records.
#' @param value Display names or ID
#' @return data.frame, columns: layer, biome, number of records
#'
#' @examples
#' # Load example occurrence data
#' data("biomes_example")
#'
#' # Classify occurrences into biomes (names)
#' classified_names <- biomes_classify(
#'   x     = biomes_example,
#'   value = "name"
#' )
#'
#' # Count records per biome (using biome names)
#' biomes_biome_tab(classified_names, value = "names")
#'
#' # Classify occurrences into biomes (IDs)
#' classified_ids <- biomes_classify(
#'   x     = biomes_example,
#'   value = "ID"
#' )
#'
#' # Count records per biome (using biome IDs)
#' biomes_biome_tab(classified_ids, value = "ID")
#'
#' @export
biomes_biome_tab <- function(x,
                             value = "names"){

  # Assertions: x must be a data.frame
  checkmate::assert_data_frame(x, min.rows = 1)

  # Assertions: x must have an ID column
  checkmate::assert_true(
    "ID" %in% names(x),
    .var.name = "x must contain a column named 'ID'"
  )

  # Assertions: value must be "names" or "ID"
  checkmate::assert_choice(value, c("names", "ID"))


  # select relevant columns
  # MAKE SURE THIS WORKS WITH DIFERENT SELECTIONS AND DIFFERENT NUMEBR OF LAYERS
  if(value == "names"){
    dat <- x[, which(grepl("_name", names(x)))]
  }else if(value == "ID"){
    dat <- x[, which(!grepl("_name", names(x)))]
    dat <- dat[, which(grepl("Biomes_Inventory_layer", names(dat)))]
  }

  # count occurrences pr biome
  tab <- apply(dat, 2, FUN = "table")

  tab2 <- list()
  for(i in 1:length(tab)){
    tab2[[i]] <- data.frame(tab[[i]])
    tab2[[i]]$layer <- names(tab)[i]
  }

  out <- do.call(rbind, tab2)
  out <- out[,c(3,1,2)]
  names(out) <- c("layer", "biome", "n")

  #return value
  return(out)
}
