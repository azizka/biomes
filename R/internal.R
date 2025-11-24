info_grabber <- function(num){

  out <- biomes::biomes_information[num,]

  nams <- unlist(biome_legend[num, -c(1:2)])
  nams <- nams[!is.na(nams)]
  nams <- paste(nams, collapse = ", ")

  cat(sprintf("\nName: %s (%s) \n", out$`Name of classification`, out$Publication))

  cat("\n")

  cat(sprintf("Criteria: %s\n", out$`Criteria for class assignment`))

  cat("\n")

  cat(sprintf("Methodology: %s\n", out$Methodology))

  cat("\n")

  cat(sprintf("Description: %s\n", out$`Background and specifications`))

  cat("\n")

  cat(sprintf("Number of biomes: %s\n", out$`Number of classes (zonal/azonal)`))

  cat("\n")

  cat(sprintf("Names of biomes: %s\n", nams))

  cat("\n-----\n")
}
