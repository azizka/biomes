#' Internal package setup for biomes
#'
#' This file declares global variables for NSE-heavy code (dplyr, tidyr,
#' ggplot2) to silence R CMD check NOTES, and lists package-level imports
#' that are used across multiple functions.
#'
#' @keywords internal
#' @name biomes_globals
#'
#' @importFrom grDevices colorRampPalette
#' @importFrom stats setNames end reorder start
#' @importFrom utils capture.output head
NULL

# Silence R CMD check "no visible binding for global variable" NOTES
utils::globalVariables(c(
  "decimalLatitude", "decimalLongitude", "species", "biome", "count",
  "n_species", "total_occurrences", "val",  "biome_id", "biome_label", "biome_name",
  "number_species", "number_occurrences", "n", "present", "taxon",
  "label", "label_text", "label_x", "label_y", "line_x", "line_y", "angle", "fraction",
  "start", "end", "show_label", "y", "n",

  # helper columns produced by other packages
  ".summary",

  # dplyr/tidyr pronouns & magrittr pipes
  ".data", "%>%", ":=",

  # plot-related (ggplot2, cowplot, etc.)
  "unit", "guide_legend", "reorder", "geom_text"
))
