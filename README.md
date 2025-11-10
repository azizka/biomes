# biomer: Analysis and Visualization of Taxon Distribution in Biomes
**biomer** is an R package for automated determination, tabulation, and visualization of biological taxon (species, genera, etc.) occurrences in global biomes. It integrates data access, filtering, and graphical reporting for taxonomic occurrences based on rasterized biome layers (x31) and occurrence data such as those from GBIF.

It contains global 10x10 km rasters of the biome definitions digitized by Fischer et al (2022) plus some additional convenience function to classify records and species into biomes.

## Functionality
- **Automated data access:** Direct download of occurrence data from GBIF by scientific name.
- **Flexible filtering:** Restrict by year, country code, maximum number of records, coordinate cleaning, and more.
- **Biome assignment:** Automatic classification of all points to one or more biome layers.
- **Statistical summaries:** Summaries of taxon presence per biome.
- **Visualization:** Geographic maps, summary pie charts, and barplots by biome.
- **Example dataset and raster data:** Example occurrences and all biome information are directly available and loadable from within the package.

---

## Installation

To install the development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("azizka/biomer")
``` 

---

## Easiest Usage: One-liner Analysis
The most convenient “one-liner” analysis uses the `biomer_compare()` function, which performs all steps from download through visualization for a supplied taxon:

```r
biomer_summary <- biomer_compare(taxon = "Talpa europaea")
``` 

The output is a list containing both the ready-to-use plots (`$mapplot`, `$barplot`) and tabular summary data for all biomes.

---

## Data Download & Filtering

For full control during data retrieval, you can restrict by taxon, time window, and more:

```r
df <- biomer_GBIF(
  taxon = "Puma concolor",
  year_min = 2000,
  year_max = 2020,
  limit = 5000
)
```
---

## Advanced Use: Own Data, Biome Tabulation & Visualization

If you already have your own occurrence data or have downloaded records, you can count and visualize biomes separately.
Example:

```r
# Load biome legend and example dataset
biomer_info <- biomer_get()

# Tabulate biome presence by group
df_counts <- biomer_count(
  biomer_info$example,
  group_col = "species",
  lon = "decimalLongitude",
  lat = "decimalLatitude",
  layer = c(2, 31),
  presence_min_n = 1
)

# Generate maps and barplots for selected layers
df_plots <- biomer_plot(
  biomer_info$example,
  lon = "decimalLongitude",
  lat = "decimalLatitude",
  layer = c(1, 2, 15, 22),
  save_list = TRUE
)

# Access plots
df_plots$mapplot
df_plots$barplot
```

Its also possible to show Plots directly (`show_plot = TRUE`) or saved as images.

---

## Data and Example Resources
All relevant raster files (biomes), legends, and an example occurrence dataset can be loaded directly into your environment with

```r
biomer_info <- biomer_get()
```


## Reference
Fischer J-C, Waltenowitz A, Beierkuhnlein C (2022) The biome inventory - Standardizing global biogeographical units. Global Ecology and Biogeography31(11):2172-2183: [https://doi.org/10.1111/geb.13574](https://onlinelibrary.wiley.com/doi/full/10.1111/geb.13574)


## Citation
```r
library(biomer)
citation("biomer")
```

Groß H, Zizka A (2025): biomer: Analysis of Taxon Distributions in Global Biomes. R package, Version 1.0. [https://github.com/azizka/biomer](https://github.com/azizka/biomer). 
