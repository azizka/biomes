# biomes: User-Friendly Species-to-Biome Classification v0.9
**biomes** provides raster layers of 31 commonly used biome definitions (from Fischer et al, 2022) at 10 x10 km resolution globally.
Furthermore contains convenience functions for biogeographic analyses, classifying user-provided species occurrences and species into these biomes and visualize. 

---

## Installation

```r
library(devtools)
devtools::install_github("azizka/biomes")
library(biomes)
``` 

---
## 1. Load biome legend and example dataset

```r
layers <- biomes_get()
```

You can obtain the metadata via the `biomes_information` dataset, where each row corresponds to one layer in the object obtained with `biomes_get()` 

```{r}
data(biomes_information)

layers[[1]]
biomes_information[1,]

```

Alternatively you can display meta data for individual layers using the `biomes_info` function.

```{r}
biomes_info(1)
biomes_info(c(1,14,21)) # simultaneously for multiple biome layers
biomes_info() # simultaneously for multiple biome layers
```

The package further contains convenience functions for analyses using biomes common in biogeography.

## 2. classify occurrence records into biomes
Based on geographic coordinates occurrence records can be classified into biomes. 

```r
data(biomes_example)

biomes_classify(x = biomes_example)
```

You can chose individual layers via the biome argument. For instance, the layers 1 and 25.

```r
data(biomes_example)
layers <- biomes_get()

biomes_classify(x = biomes_example,
                biome = layers[[c(1,25)]])
```

You can also chose to display the ID of the biomes rather than the names, via the `value` argument.
Further you can specify the column names of the coordinates in x, via the `lon` and `lat` arguments.

```r
data(biomes_example)
layers <- biomes_get()

biomes_classify(x = biomes_example,
                biome = layers[[1]],
                lon = "decimalLongitude",
                lat = "decimalLatitude",
                value = "ID")
```
## 3. Tabulate the number of occurrences per biome

```{r}
library(tidyverse)
biomes_example %>% 
  biomes_classify() %>% 
  biomes_biome_tab()
```
You can also set a minimum threshold to count species presence in a biome via the `min.occ` argument. 


## 4. Visualize
```{r}

```

## Species per biome
Often it is relevant to know the numebr of species per biom, you can easily use the biomes package together with basic data wrangling using the tidyverse package to answer this question.

For a single layer:
```{r}
library(tidyverse)

class <- biomes_example %>%
  biomes_classify(biome = layers[[1]])

biomes_example %>%
  bind_cols(class) %>%
  group_by(species, biome_name) %>% 
  count()
  
```

For multiple layers at the same time:

```{r}
library(tidyverse)

class <- biomes_example %>%
  biomes_classify(biome = layers[[c(1, 17)]])
```

## Reference
Fischer J-C, Waltenowitz A, Beierkuhnlein C (2022) The biome inventory - Standardizing global biogeographical units. Global Ecology and Biogeography31(11):2172-2183: [https://doi.org/10.1111/geb.13574](https://onlinelibrary.wiley.com/doi/full/10.1111/geb.13574)

## Citation
```r
citation("biomes")
```

Groß H, Zizka A (2025): biomes: Analysis of Taxon Distributions in Global Biomes. R package, Version 0.9. [https://github.com/azizka/biomes](https://github.com/azizka/biomes). 
