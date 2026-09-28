# Build data/bombacoideae_occurrences.rda, the worked example of the
# biomes manuscript: 17,030 cleaned occurrence records of the plant
# subfamily Bombacoideae (Malvaceae), 185 species, from Zizka et al. (2020).
# Run this from the package root, e.g. with:
#   source("data-raw/data-bombacoideae_occurrences.R")
#
# Source file: ../einreichen/bombacoideae_occurrences.csv (not part of the
# package). Only the columns needed by the workflow are kept.

library(readr)
library(usethis)

raw <- readr::read_csv(
  "../einreichen/bombacoideae_occurrences.csv",
  show_col_types = FALSE
)
raw <- as.data.frame(raw)

bombacoideae_occurrences <- data.frame(
  species          = raw$species,
  decimalLongitude = raw$decimallongitude,
  decimalLatitude  = raw$decimallatitude,
  countryCode      = raw$country,   # ISO 3166-1 alpha-3
  stringsAsFactors = FALSE
)

stopifnot(
  nrow(bombacoideae_occurrences) == 17030L,
  length(unique(bombacoideae_occurrences$species)) == 185L,
  all(is.finite(bombacoideae_occurrences$decimalLongitude)),
  all(is.finite(bombacoideae_occurrences$decimalLatitude))
)

usethis::use_data(bombacoideae_occurrences, overwrite = TRUE, compress = "xz")
