# Example occurrence dataset: Bombacoideae

Cleaned occurrence records of the plant subfamily Bombacoideae
(Malvaceae): the example dataset used in the README, the vignettes and
the function examples, and the worked example of the *biomes*
publication. The subfamily is a well-studied case of biome conservatism
at the savanna-forest interface. The records were compiled and cleaned
by Zizka et al. (2020) from GBIF, BIEN, speciesLink, RAINBIO and further
sources.

## Usage

``` r
bombacoideae_occurrences
```

## Format

A data frame with 17,030 rows and 4 columns:

- species:

  Scientific species name (185 species).

- decimalLongitude:

  Decimal longitude in WGS84.

- decimalLatitude:

  Decimal latitude in WGS84.

- countryCode:

  ISO 3166-1 alpha-3 country code of the record.

## Source

Zizka A, Carvalho-Sobrinho JG, Pennington RT, Queiroz LP, Alcantara S,
Baum DA, Bacon CD, Antonelli A (2020) Transitions between biomes are
common and directional in Bombacoideae (Malvaceae). Journal of
Biogeography 47(6): 1310-1321.
[doi:10.1111/jbi.13815](https://doi.org/10.1111/jbi.13815)

## Examples

``` r
data("bombacoideae_occurrences")
head(bombacoideae_occurrences)
#>                     species decimalLongitude decimalLatitude countryCode
#> 1 Cavanillesia platanifolia        -79.98333         -2.1500         ECU
#> 2    Cavanillesia umbellata        -70.25000        -12.0000         PER
#> 3    Cavanillesia umbellata        -78.63333         -4.5000         PER
#> 4    Cavanillesia umbellata        -76.46666         -2.8000         PER
#> 5    Cavanillesia umbellata        -69.10420        -12.0321         PER
#> 6    Cavanillesia umbellata        -74.30611        -11.1425         PER
length(unique(bombacoideae_occurrences$species))
#> [1] 185
```
