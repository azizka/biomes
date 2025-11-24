library(biomes)
library(sf)
library(terra)

data(biomes_example)

# biomes_get
layers <- biomes_get()

# biomes_info
biomes_info(1)
biomes_info(c(1,14,21)) # simultaneously for multiple biome layers
biomes_info() # simultaneously for multiple biome layers


# biomes_classify
biomes_classify(x = biomes_example,
                lon = "decimalLongitude",
                lat = "decimalLatitude")


biomes_classify(x = biomes_example,
                biome = layers[[c(1,25)]],
                lon = "decimalLongitude",
                lat = "decimalLatitude")

biomes_classify(x = biomes_example,
                biome = layers[[1]],
                lon = "decimalLongitude",
                lat = "decimalLatitude",
                value = "ID")

biomes_classify(x = biomes_example,
                biome = layers[[1]],
                lon = "decimalLongitude",
                lat = "decimalLatitude",
                value = "both")

test <- biomes_classify(x = biomes_example,
                biome = layers[[c(1:3)]],
                lon = "decimalLongitude",
                lat = "decimalLatitude",
                value = "both")

t_sf <- st_as_sf(biomes_example,
         coords = c("decimalLongitude", "decimalLatitude"),
         crs = "EPSG:4326")

biomes_classify(x = t_sf,
                biome = layers[[c(1)]],
                value = "ID")

t_terra  <- terra::vect(biomes_example,
                        geom = c(lon, lat),
                        crs = "EPSG:4326")

biomes_classify(x = t_terra,
                biome = layers[[c(1)]],
                value = "ID")

# biomes_biome_tab
library(tidyverse)

class <- biomes_example %>%
  biomes_classify(biome = layers[[1]])

biomes_examples %>%
  bind_cols(class) %>%




data(biomes_information)

biome_information <- readRDS("data/biome_information.rds")

use_data(biome_information)
use_data_raw("inst/extdata/biomer_information.xlsx")


biome_legend<- readRDS("data/biome_legend.rds")
use_data(biome_legend)
use_data_raw("data/biome_legend.rds")


biomes_example<- readRDS("data/example_file.rds")
use_data(biomes_example)
use_data_raw("data/example_filerds")

biome_legend <- readRDS("inst/extdata/biome_legend.rds")

# biomer compare with own records
data(biomer_example)
sp_to_biom <- biomer_compare(taxon = "Talpa europaea")

# download from gbif
sp_to_biom <- biomer_compare(taxon = c("Talpa europaea", "Vulpes vulpes"), limit = 500)

sp_to_biom$mapplot
sp_to_biom$barplot


biomer_info <- biomer_get()
sp_to_biom <- biomer_compare(x = biomer_info$example,
                             layer = 24)

sp_to_biom$mapplot
sp_to_biom$barplot

# multiple layers
sp_to_biom <- biomer_compare(x = biomer_info$example,
                             layer = c(23,24))

sp_to_biom$mapplot
sp_to_biom$barplot


biomer_info <- biomer_get()
df_counts <- biomer_count(
  biomer_info$example,
  group_col = "species",
  lon = "decimalLongitude",
  lat = "decimalLatitude",
  layer = c(2, 31),
  presence_min_n = 1
)
