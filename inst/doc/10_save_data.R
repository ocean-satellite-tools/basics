## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(eval = FALSE)

## ----create_dir---------------------------------------------------------------
#  fil_dir <- file.path(here::here(), "inst", "extdata")
#  if(!dir.exists(fil_dir)) dir.create(fil_dir)

## -----------------------------------------------------------------------------
#  crs.wintri <- "+proj=wintri +lon_0=0 +lat_1=0 +x_0=0 +y_0=0 +datum=WGS84 +units=km +no_defs"

## -----------------------------------------------------------------------------
#  lats <- c(40.375, 50.375)
#  lons <- c(-141.875, -120.875)
#  df_info <- rerddap::info("ncdcOisst21Agg_LonPM180")
#  df <- rerddap::griddap("ncdcOisst21Agg_LonPM180", latitude = lats, longitude = lons, time = c("2021-06-19", "2021-06-19"), fields = "sst")$data

## -----------------------------------------------------------------------------
#  df2 <- data.frame(x=df$lon, y=df$lat, z=df$sst)
#  ras <- raster::rasterFromXYZ(df2, crs = "+proj=longlat")

## -----------------------------------------------------------------------------
#  ras.wintri <- raster::projectRaster(ras, crs=crs.wintri, over=TRUE)
#  lats.wintri <- raster::bbox(ras.wintri)[1,]
#  lons.wintri <- raster::bbox(ras.wintri)[2,]

## -----------------------------------------------------------------------------
#  data_dir <- file.path(here::here(), "data", "sample_raster.rda")
#  sample_raster <- list(df=df, raster=ras, lats=lats, lons=lons, ras.wintri, lats.wintri, lons.wintri, crs.wintri)
#  save(sample_raster, file=data_dir)

## -----------------------------------------------------------------------------
#  world <- rnaturalearth::ne_countries(scale = "small", returnclass = "sp")
#  # Get rid of interior boundaries
#  world <- rgeos::gUnaryUnion(world)

## -----------------------------------------------------------------------------
#  world.wintri <- sp::spTransform(world, crs.wintri)

## -----------------------------------------------------------------------------
#  buff1 <- rgeos::gBuffer(world.wintri, width = 300, byid = TRUE)
#  # erase the inner world polygon
#  e <- raster::erase(buff1, world.wintri)
#  # Use the `remove.holes()` function to get only the outer line.
#  e300 <- spatialEco::remove.holes(spatialEco::remove.holes(e))
#  el300 <- as(e300, "SpatialLines")

## -----------------------------------------------------------------------------
#  df300 <- c()
#  n <- length(el300@lines[[1]]@Lines)
#  for (i in 1:n) {
#    df300 <- rbind(df300, cbind(el300@lines[[1]]@Lines[[i]]@coords, ID = i))
#  }

## -----------------------------------------------------------------------------
#  buffer300.wintri <- list(line = el300, polygon = e300, df = df, crs = crs.wintri)

## -----------------------------------------------------------------------------
#  only.holes <- function (x)
#  {
#    if (!any(which(utils::installed.packages()[, 1] %in% "maptools")))
#      stop("please install maptools package before running this function")
#    xp <- slot(x, "polygons")
#    holes <- lapply(xp, function(x) sapply(methods::slot(x, "Polygons"),
#                                           methods::slot, "hole"))
#    res <- lapply(1:length(xp), function(i) methods::slot(xp[[i]],
#                                                          "Polygons")[holes[[i]]])
#    IDs <- row.names(x)
#    x.fill <- sp::SpatialPolygons(lapply(1:length(res), function(i) sp::Polygons(res[[i]],
#                                                                                 ID = IDs[i])), proj4string = sp::CRS(sp::proj4string(x)))
#    methods::slot(x.fill, "polygons") <- lapply(methods::slot(x.fill,
#                                                              "polygons"), maptools::checkPolygonsHoles)
#    methods::slot(x.fill, "polygons") <- lapply(methods::slot(x.fill,
#                                                              "polygons"), "comment<-", NULL)
#    pids <- sapply(methods::slot(x.fill, "polygons"), function(x) methods::slot(x, "ID"))
#    x.fill <- sp::SpatialPolygonsDataFrame(x.fill, data.frame(row.names = pids,
#                                                              ID = 1:length(pids)))
#    return(x.fill)
#  }

## -----------------------------------------------------------------------------
#  buff20 <- rgeos::gBuffer(el300, width=280)

## -----------------------------------------------------------------------------
#  e20 <- only.holes(buff20)
#  el20 <- as(e20, "SpatialLines")

## -----------------------------------------------------------------------------
#  df20 <- c()
#  n <- length(el20@lines[[1]]@Lines)
#  for (i in 1:n) {
#    df20 <- rbind(df20, cbind(el20@lines[[1]]@Lines[[i]]@coords, ID = i))
#  }

## -----------------------------------------------------------------------------
#  numOfPoints  <-  rgeos::gLength(el20) / 100
#  sample.pts.100km <- sp::spsample(el20, n = numOfPoints, type = "regular")

## -----------------------------------------------------------------------------
#  save(crs.wintri, file = file.path(here::here(), "data/crs_wintri.rda"))
#  save(world, world.wintri, file = file.path(here::here(), "data/world.rda"))
#  buffer300 <- list(wintri = list(line = el300, polygon = e300, df = df300, crs = crs.wintri))
#  buffer20 <- list(wintri = list(line = el20, polygon = e20, df = df20, crs = crs.wintri))
#  save(buffer300, file = file.path(here::here(), "data/buffer300.rda"))
#  save(buffer20, file = file.path(here::here(), "data/buffer20.rda"))

