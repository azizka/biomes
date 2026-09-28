#' Metadata for the 31 biome schemes
#'
#' A data frame containing descriptive metadata for each of the 31 biome
#' classifications shipped with the package. Each row corresponds to one
#' biome layer in the raster stack returned by [biomes_get()], in the same
#' order. The metadata is derived from the inventory compiled by
#' Fischer et al. (2022).
#'
#' This is the raw metadata table. For an interactive, human-readable
#' summary of one or more classifications, see [biomes_info()].
#'
#' @format A data frame with 31 rows and 12 columns:
#' \describe{
#'   \item{publication}{Original publication of the biome scheme.}
#'   \item{name_of_classification}{Full name of the biome scheme.}
#'   \item{criteria_for_biome_assignment}{Criteria used to assign biomes.}
#'   \item{methodology}{Methodology used to derive the biome classification.}
#'   \item{scheme_number}{Biome scheme number (1-31); index of the
#'     corresponding layer in the raster stack returned by [biomes_get()].}
#'   \item{background_and_specifications}{Free-text background information
#'     about the classification scheme.}
#'   \item{number_of_biomes_zonal_azonal}{Total number of biomes
#'     in the classification, with the split between zonal and azonal
#'     biomes in parentheses.}
#'   \item{cover_deviation_percent}{Deviation of the total area covered by
#'     this classification from the mean area of all 31 classifications,
#'     in percent.}
#'   \item{original_file_format}{File format of the original data source
#'     (e.g. raster, shapefile).}
#'   \item{source}{URL or citation of the original data source.}
#'   \item{access_date}{Date on which the original data source was accessed.}
#'   \item{biome_definition}{The concept on which the scheme delimits its
#'     biomes, one of `"climate"`, `"vegetation"`, `"land_cover"`,
#'     `"ecoregion"`, `"integrative"` (a synthesis of several criteria or
#'     data sources), or `"anthropogenic"`. Used by [biomes_rank()] to rank
#'     schemes within the group sharing one biome definition.}
#' }
#' @source Fischer J-C, Walentowitz A, Beierkuhnlein C (2022) The biome
#'   inventory - Standardizing global biogeographical units.
#'   Global Ecology and Biogeography 31(11): 2172-2183.
#'   \doi{10.1111/geb.13574}
"biomes_information"


#' Example occurrence dataset: Bombacoideae
#'
#' Cleaned occurrence records of the plant subfamily Bombacoideae
#' (Malvaceae): the example dataset used in the README, the vignettes and
#' the function examples, and the worked example of the *biomes*
#' publication. The
#' subfamily is a well-studied case of biome conservatism at the
#' savanna-forest interface. The records were compiled and cleaned by
#' Zizka et al. (2020) from GBIF, BIEN, speciesLink, RAINBIO and further
#' sources.
#'
#' @format A data frame with 17,030 rows and 4 columns:
#' \describe{
#'   \item{species}{Scientific species name (185 species).}
#'   \item{decimalLongitude}{Decimal longitude in WGS84.}
#'   \item{decimalLatitude}{Decimal latitude in WGS84.}
#'   \item{countryCode}{ISO 3166-1 alpha-3 country code of the record.}
#' }
#' @source Zizka A, Carvalho-Sobrinho JG, Pennington RT, Queiroz LP,
#'   Alcantara S, Baum DA, Bacon CD, Antonelli A (2020) Transitions between
#'   biomes are common and directional in Bombacoideae (Malvaceae).
#'   Journal of Biogeography 47(6): 1310-1321.
#'   \doi{10.1111/jbi.13815}
#' @examples
#' data("bombacoideae_occurrences")
#' head(bombacoideae_occurrences)
#' length(unique(bombacoideae_occurrences$species))
"bombacoideae_occurrences"


#' Legend (biome names) for the 31 biome schemes
#'
#' A data frame mapping the raster values used in each of the 31 biome
#' layers to human-readable biome names. Each row corresponds to one
#' layer in the raster stack returned by [biomes_get()], in the same order.
#' Columns `id_1`, `id_2`, ... give the biome names for raster values
#' 1, 2, ..., respectively. Cells are `NA` for classifications with fewer
#' biomes than the maximum across all classifications.
#'
#' @format A data frame with 31 rows and 41 columns:
#' \describe{
#'   \item{layer}{Index of the layer in the raster stack returned by
#'     [biomes_get()].}
#'   \item{source}{Short reference to the publication that defines the
#'     classification.}
#'   \item{id_1, id_2, id_3, id_4, id_5, id_6, id_7, id_8, id_9, id_10,
#'     id_11, id_12, id_13, id_14, id_15, id_16, id_17, id_18, id_19,
#'     id_20, id_21, id_22, id_23, id_24, id_25, id_26, id_27, id_28,
#'     id_29, id_30, id_31, id_32, id_33, id_34, id_35, id_36, id_37,
#'     id_38, id_39}{Biome names for raster values 1 through 39.
#'     `NA` if the classification has fewer biomes.}
#' }
#' @source Fischer J-C, Walentowitz A, Beierkuhnlein C (2022) The biome
#'   inventory - Standardizing global biogeographical units.
#'   Global Ecology and Biogeography 31(11): 2172-2183.
#'   \doi{10.1111/geb.13574}
"biomes_legend"
