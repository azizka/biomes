#' Count occurrences per biome
#'
#' Summarizes the number of occurrence records in each biome and layer, outputting a long-format table.
#'
#' @param x Data frame with occurrence records.
#' @param value Display names or ID
#' @return data.frame, columns: layer, biome, number of records
#' @export
biomes_biome_tab <- function(x,
                             value = "names"){
  #Assertions
  # Assert that x is a data.frame and contains the necessary columns

  # select relevant columns
  # MAKE SURE THIS WORKS WITH DIFERENT SELECTIONS AND DIFFERENT NUMEBR OF LAYERS
  if(value == "names"){
    dat <- x[, which(grepl("_name", names(x)))]
  }else if(value == "ID"){
    dat <- x[, which(!grepl("_name", names(x)))]
    dat <- dat[, which(grepl("Biome_Inventory_layer", names(dat)))]
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
