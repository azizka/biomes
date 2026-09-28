# data-raw/data-biome_definition.R
# Add the `biome_definition` column to biomes_information: the concept on
# which each of the 31 biome schemes delimits its biomes (climate,
# vegetation, land cover, ecoregions, integrative, anthropogenic). The
# grouping is derived from the `criteria_for_biome_assignment` and
# `methodology` fields (Fischer et al. 2022). Run from the package root,
# after data-raw/data-biome_information-rds.R.

load("data/biomes_information.rda")   # loads object `biomes_information`

biome_definition <- c(
  "vegetation",    #  1 Global vegetation patterns of the past 140,000 yrs (LPJ-GUESS DGVM)
  "land_cover",    #  2 Copernicus Global Land Cover
  "climate",       #  3 Koeppen-Geiger climate classification
  "vegetation",    #  4 Global mapping of potential natural vegetation (ML)
  "ecoregion",     #  5 Ecoregion-based approach (Dinerstein et al.)
  "integrative",   #  6 Zhang et al. 2017: K-means on temperature, precipitation AND NDVI
  "climate",       #  7 Climate clustering (dynamic time warping)
  "climate",       #  8 Climate clustering (Euclidean)
  "vegetation",    #  9 Functional biomes
  "vegetation",    # 10 Earth's vegetation (potential natural dominant vegetation)
  "climate",       # 11 Climate K-means clustering
  "climate",       # 12 High-resolution bioclimate map (42 parameters)
  "ecoregion",     # 13 FAO global ecological zones
  "land_cover",    # 14 Global Land Cover by national mapping organizations
  "land_cover",    # 15 ISLSCP II UMD global land cover
  "anthropogenic", # 16 Anthropogenic transformation of the biomes (anthromes, Ellis et al.)
  "land_cover",    # 17 GlobCover
  "land_cover",    # 18 MODIS collection 5 global land cover
  "ecoregion",     # 19 Terrestrial ecoregions of the world
  "climate",       # 20 Updated Koeppen-Geiger climate classification
  "land_cover",    # 21 GLC2000
  "vegetation",    # 22 Potential natural vegetation + biogeochemical modelling
  "ecoregion",     # 23 Terrestrial ecoregions of the world (Olson et al. 2001)
  "land_cover",    # 24 Global land cover characteristics from NDVI
  "vegetation",    # 25 Historical changes in global land cover (potential natural vegetation)
  "climate",       # 26 Holdridge life zones (bioclimatic)
  "integrative",   # 27 Ecozones of the Earth (Schultz)
  "integrative",   # 28 Landscape belts of the Earth
  "integrative",   # 29 Atlas of biogeography
  "integrative",   # 30 Communities and ecosystems (Whittaker)
  "integrative"    # 31 Vegetation and climate (Walter)
)

stopifnot(length(biome_definition) == nrow(biomes_information))

# harmonise column names of older builds
old_new <- c(number_of_classes_zonal_azonal = "number_of_biomes_zonal_azonal",
             criteria_for_class_assignment  = "criteria_for_biome_assignment")
for (nm in names(old_new)) {
  if (nm %in% names(biomes_information)) {
    names(biomes_information)[names(biomes_information) == nm] <- old_new[[nm]]
  }
}
biomes_information$scheme_type <- NULL
biomes_information$biome_definition <- biome_definition

save(biomes_information, file = "data/biomes_information.rda", compress = "xz")

cat("biome_definition counts:\n")
print(table(biome_definition))
