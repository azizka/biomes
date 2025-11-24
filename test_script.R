library(biomer)


test <- biomes_get()


data(biome_information)

biome_information <- readRDS("data/biome_information.rds")

use_data(biome_information)
use_data_raw("inst/extdata/biomer_information.xlsx")


biome_legend<- readRDS("data/biome_legend.rds")
use_data(biome_legend)
use_data_raw("data/biome_legend.rds")


biomes_example<- readRDS("data/example_file.rds")
use_data(biomes_example)
use_data_raw("data/example_filerds")

biome_legend <- readRDS("inst/extdata/biome_legend.rds")

usethis::use_data(biome_legend)


    check_is_package("use_data()")
    objs <- get_objs_from_dots(dots(...))
    original_minimum_r_version <- pkg_minimum_r_version()
    serialization_minimum_r_version <- if (version < 3)
        "2.10"
    else "3.5"
    if (is.na(original_minimum_r_version) || original_minimum_r_version <
        serialization_minimum_r_version) {
        use_dependency("R", "depends", serialization_minimum_r_version)
    }
    if (internal) {
        use_directory("R")
        paths <- path("R", "sysdata.rda")
        objs <- list(objs)
    }
    else {
        use_directory("data")
        paths <- path("data", objs, ext = "rda")
        desc <- proj_desc()
        if (!desc$has_fields("LazyData")) {
            ui_bullets(c(v = "Setting {.field LazyData} to {.val true} in {.path DESCRIPTION}."))
            desc$set(LazyData = "true")
            desc$write()
        }
    }
    check_files_absent(proj_path(paths), overwrite = overwrite)
    ui_bullets(c(v = "Saving {.val {unlist(objs)}} to {.val {paths}}."))
    if (!internal) {
        ui_bullets(c(`_` = "Document your data (see {.url https://r-pkgs.org/data.html})."))
    }
    envir <- parent.frame()
    mapply(save, list = objs, file = proj_path(paths), MoreArgs = list(envir = envir,
        compress = compress, version = version, ascii = ascii))
    invisible()




# biomer compare with own records
data(biomer_example)
sp_to_biom <- biomer_compare(taxon = "Talpa europaea")

# download from gbif
sp_to_biom <- biomer_compare(taxon = c("Talpa europaea", "Vulpes vulpes"), limit = 500)

sp_to_biom$mapplot
sp_to_biom$barplot


biomer_info <- biomer_get()
sp_to_biom <- biomer_compare(x = biomer_info$example,
                             layer = 24)

sp_to_biom$mapplot
sp_to_biom$barplot

# multiple layers
sp_to_biom <- biomer_compare(x = biomer_info$example,
                             layer = c(23,24))

sp_to_biom$mapplot
sp_to_biom$barplot


biomer_info <- biomer_get()
df_counts <- biomer_count(
  biomer_info$example,
  group_col = "species",
  lon = "decimalLongitude",
  lat = "decimalLatitude",
  layer = c(2, 31),
  presence_min_n = 1
)
