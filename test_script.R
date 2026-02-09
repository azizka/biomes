library(biomes)
library(sf)
library(terra)

data(biomes_example)

# biomes_get
layers <- biomes_get()

data(biomes_information)

layers[[1]]
biomes_information[1,]

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
biomes_example %>%
  biomes_classify() %>%
  biomes_biome_tab()

# species number per biome
class <- biomes_example %>%
  biomes_classify(biome = layers[[1]])

biomes_example %>%
  bind_cols(class) %>%
  group_by(species, biome_name) %>%
  count()

# species per biome multiple biomes
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



# species numbers per biome
library(tidyverse)

class <- biomes_example %>%
  biomes_classify(biome = layers[[1]])

biomes_example %>%
  bind_cols(class) %>%
  group_by(species, biome_name) %>%
  count()

# bioem compare
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

# Ordination
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

