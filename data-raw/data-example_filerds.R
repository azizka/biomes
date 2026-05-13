# Build data/biomes_example.rda from a cleaned GBIF download.
# Run this from the project root, e.g. with:
#   source("data-raw/data-example_filerds.R")

library(readr)
library(usethis)

biomes_example <- readr::read_csv(
  "test_environment/data/FINAL_cleaned_occurrences_plus_additions.csv",
  show_col_types = FALSE
)
biomes_example <- as.data.frame(biomes_example)

# Keep only the columns used by examples and vignettes.
biomes_example <- biomes_example[, c(
  "genus", "species", "countryCode",
  "decimalLongitude", "decimalLatitude"
)]

usethis::use_data(biomes_example, overwrite = TRUE)
