#' Classify occurrences into biomes
#'
#' For each occurrence record, assigns a biome label based on spatial position and raster layer.
#'
#' @param x Data frame with at least longitude and latitude and a taxon column for grouping.
#' @param biome a terra raster SpatRaster object, if NULL all the raster layers provided by the package are used.
#' @param lon Column name for longitude. Default: "decimalLongitude".
#' @param lat Column name for latitude. Default: "decimalLatitude".
#' @param value character string. Defining the return. c("ID", "name", "both")
#' @param raster_file if biome is not provided a path to a custom biome raster stack file or a SpatRaster.
#'
#' @return Depending on the value argument either a data.frame with the ID of the
#' biome or the name of biome for each occurrence record in x, or both. Incase of multiple biome layers,
#' columns reflect different layers.
#' @importFrom terra nlyr rast sources
#' @importFrom readr parse_number
#' @export
biomes_classify <- function(
    x,
    biome = NULL,
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    value = "name",
    raster_file = NULL
) {

  #assertions
  # assert that x is either am sf spatial object, a spatraster or a dataframe
  ##assert that x contains the lat and long columns if a data.frame
  ## assert that x and y< are numeric if x is a data.frame
  ##assert that biome is a terra raster or raster stack

  # Give users the option to not provide biomes and load the defaults instead or a custom file
   if(is.null(biome)){
     if(is.null(raster_file)){
       message("no biome file or layer provided using default biomes")
       raster_file <- system.file("extdata",
                                  "Biome_Inventory_RasterStack.tif",
                                  package = "biomes")
     }
     biome <- terra::rast(raster_file)
   }

  # Prepare points (project coordinates)
  if(is.data.frame(x) & !any(is(x) == "sf")){
    warning("Coordinates provided as data.frame, assuming WGS84 as CRS")
    pts <- terra::vect(x,
                       geom = c(lon, lat),
                       crs = "EPSG:4326")
  }else if(any(is(x) == "SpatVector") |
          any(is(x) == "sf")){
    # if x is a terra object
    pts <- x
  }

  # Display biome names if default biomes are used
  if(terra::sources(biome) == system.file("extdata",
                                          "Biome_Inventory_RasterStack.tif",
                                          package = "biomes")){
    legend_df <- biomes::biome_legend
  }

  biome_id <- terra::extract(biome,
                             pts)

  # add in biome names if required by the value argument
  if(terra::nlyr(biome) == 1){
    if(value == "ID"){
      ass <- biome_id
    }else if(value == "name" | value == "both"){
      id_get <- readr::parse_number(names(biome_id[2]))
      biome_name <- data.frame(biome_name = unlist(legend_df[id_get, -(1:2)])[biome_id[,2]])
      ass <- biome_name
    }
    if(value == "both"){
      ass <- data.frame(cbind(biome_id,
                              biome_name))
    }
  }else{
    if(value == "ID"){
      ass <- biome_id
    }else{
      ass <- biome_id
      for(i in 2:length(names(biome_id))){
        id_get <- readr::parse_number(names(biome_id)[i])
        biome_name <- unlist(legend_df[id_get, -(1:2)])[biome_id[, i]]
        ass <- cbind(ass,
                     biome_name)
        names(ass)[i+ncol(biome_id)-1] <- paste(names(ass)[i], "_name", sep = "")
      }
      ass <- ass[, c(names(ass)[1],
                   sort(names(ass)[-1]))]
    }
    if(value == "name"){
      sel <- which(grepl("_name", names(ass)))
      ass <- ass[, c(1, sel) ]
    }
  }
   return(ass)
}
