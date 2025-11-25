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

For multiple biome layers:
```{r}
class <- biomes_example %>%
  biomes_classify(biome = layers[[c(1, 17)]])

biomes_example %>%
  bind_cols(class) %>%
  select(species, contains("Biome_Inventory")) %>%
  pivot_longer(cols = contains("Biome_Inventory"),
               names_to = "layer",
               values_to = "value") %>%
  distinct() %>%
  group_by(layer, value) %>%
  count()
```

## Compare bime definitions for specific datasets

You may want to compare the differences of two biome definitions for a given 
occurrence dataset. For two definitions a levelplot based on th enumber of occurrences
can show the number of overlapp between different biomes between both deifnitions.

```{r}
library(ggplot)
library(biomes)
library(viridis)

data(biomes_example)
layers <- biomes_get()

class <- biomes_classify(x = biomes_example,
                         biome = layers[[c(1,25)]])

tab <- table(t[, names(t)[2]],
             t[, names(t)[3]]) %>% 
  data.frame()


ggplot()+
  geom_raster(data = tab,
              aes(x = Var1,
                  y = Var2,
                  fill = log(Freq)))+
  scale_fill_viridis()+
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, 
                                   vjust = 0.5, 
                                   hjust = 1))
```
For comparison of multiple biome definitions a multivariant analyses, for instance a PCoA can 
help to identify clusters of similar biomes accross definitions.

```{r}
library(vegan)
library(tidyverse)

# occurrence to biome classificaiton
class <- biomes_classify(x = biomes_example,
                         biome = layers[[c(1,12, 25)]])

# get number of occurrences per species per biome
test <- biomes_example %>%
  bind_cols(class)%>%
  select(species, contains("Biome_Inventory")) %>%
  pivot_longer(cols = contains("Biome_Inventory"),
               names_to = "layer",
               values_to = "value") %>%
  group_by(layer, value, species) %>%
  count() %>%
  pivot_wider(id_cols = c(value,layer),
              names_from = species,
              values_from = n)

# preapre data for ordination
dat <- test[,-c(1:2)]
dat[is.na(dat)] <- 0

# ordination
ord <- metaMDS(dat, trace = FALSE)
plo <- data.frame(cbind(ord$points,
                        test[,c(1,2)]))

# visualize first 2 axes
ggplot()+
  geom_text(data = plo,
             aes(x = MDS1,
                 y = MDS2,
                 label = value,
                 color = layer))+
  theme_bw()

```


## Reference
Fischer J-C, Waltenowitz A, Beierkuhnlein C (2022) The biome inventory - Standardizing global biogeographical units. Global Ecology and Biogeography31(11):2172-2183: [https://doi.org/10.1111/geb.13574](https://onlinelibrary.wiley.com/doi/full/10.1111/geb.13574)

## Citation
```r
citation("biomes")
```

Groß H, Zizka A (2025): biomes: Analysis of Taxon Distributions in Global Biomes. R package, Version 0.9. [https://github.com/azizka/biomes](https://github.com/azizka/biomes). 
