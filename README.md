# biomer: User-Friendly Species-to-Biome Classification v0.9
**biomer** provides raster layers of 31 commonly used biome definitions (from Fischer et al, 2022) at 10 x10 km resolutino globally.
Furthermore contains two functions to classify species occurrences and species into these biomes and visualize. 
Works with user-provided occurrences or a species name, in which case occurrences are downloaded from www.gbif.org 
and cleaned automatically.

---

## Installation

```r
# install.packages("devtools")
devtools::install_github("azizka/biomer")
``` 

---

## In a nutshell
The `biomer_compare()` function performs occurrence download through visualization for a supplied taxon:

```r
sp_to_biom <- biomer_compare(taxon = "Talpa europaea")
``` 

The output is a list containing both the ready-to-use plots (`$mapplot`, `$barplot`) and tabular summary data for all biomes.

---

## Step-by-step with existing occurrence records

1. Load biome legend and example dataset

```r
biomer_info <- biomer_get()
```

2. Tabulate biome presence by group.

```r
df_counts <- biomer_count(
  biomer_info$example, 
  group_col = "species",
  lon = "decimalLongitude",
  lat = "decimalLatitude",
  layer = c(2, 31),
  presence_min_n = 1
)
```

3. Visualize

```r
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

## Reference
Fischer J-C, Waltenowitz A, Beierkuhnlein C (2022) The biome inventory - Standardizing global biogeographical units. Global Ecology and Biogeography31(11):2172-2183: [https://doi.org/10.1111/geb.13574](https://onlinelibrary.wiley.com/doi/full/10.1111/geb.13574)


## Citation
```r
library(biomer)
citation("biomer")
```

Groß H, Zizka A (2025): biomer: Analysis of Taxon Distributions in Global Biomes. R package, Version 0.9. [https://github.com/azizka/biomer](https://github.com/azizka/biomer). 
