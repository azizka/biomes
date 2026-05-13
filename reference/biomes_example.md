# Example species occurrence dataset

A cleaned subset of species occurrence records downloaded from GBIF,
used in examples and vignettes to demonstrate biome classification.

## Usage

``` r
biomes_example
```

## Format

A data frame with 29,104 rows and 5 columns:

- genus:

  Genus name.

- species:

  Scientific species name.

- countryCode:

  ISO 3166-1 alpha-2 country code of the record.

- decimalLongitude:

  Decimal longitude in WGS84.

- decimalLatitude:

  Decimal latitude in WGS84.

## Source

Records downloaded and cleaned from the Global Biodiversity Information
Facility (GBIF). See `inst/extdata/GBIF_example_citation.txt` for the
full citation.
