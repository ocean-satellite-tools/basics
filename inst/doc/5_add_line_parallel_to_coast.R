## -----------------------------------------------------------------------------
data("sample_raster", package="basics")
df <- sample_raster$df
ras <- sample_raster$raster
lons <- sample_raster$lons
lats <- sample_raster$lats

## -----------------------------------------------------------------------------
require(raster)
require(ggplot2)

## ----echo=FALSE---------------------------------------------------------------
only.holes <- function (x) 
{
  if (!any(which(utils::installed.packages()[, 1] %in% "maptools"))) 
    stop("please install maptools package before running this function")
  xp <- slot(x, "polygons")
  holes <- lapply(xp, function(x) sapply(methods::slot(x, "Polygons"), 
                                         methods::slot, "hole"))
  res <- lapply(1:length(xp), function(i) methods::slot(xp[[i]], 
                                                        "Polygons")[holes[[i]]])
  IDs <- row.names(x)
  x.fill <- sp::SpatialPolygons(lapply(1:length(res), function(i) sp::Polygons(res[[i]], 
                                                                               ID = IDs[i])), proj4string = sp::CRS(sp::proj4string(x)))
  methods::slot(x.fill, "polygons") <- lapply(methods::slot(x.fill, 
                                                            "polygons"), maptools::checkPolygonsHoles)
  methods::slot(x.fill, "polygons") <- lapply(methods::slot(x.fill, 
                                                            "polygons"), "comment<-", NULL)
  pids <- sapply(methods::slot(x.fill, "polygons"), function(x) methods::slot(x, "ID"))
  x.fill <- sp::SpatialPolygonsDataFrame(x.fill, data.frame(row.names = pids, 
                                                            ID = 1:length(pids)))
  return(x.fill)
}

## -----------------------------------------------------------------------------
# Step 1
newcrs <- "+proj=wintri +lon_0=0 +lat_1=0 +x_0=0 +y_0=0 +datum=WGS84 +units=km +no_defs"
# Step 2 World coastline in meters
data("world", package="basics")
mworld <- sp::spTransform(world, newcrs)
# Step 3
buff300 <- rgeos::gBuffer(mworld, width = 300, byid=TRUE)
# Step 4
e <-raster::erase(buff300, mworld)

## -----------------------------------------------------------------------------
# Step 5
e300 <- spatialEco::remove.holes(spatialEco::remove.holes(e))

## -----------------------------------------------------------------------------
plot(e, border="red")
plot(e300, add=TRUE)
plot(mworld, add=TRUE, col="grey")

## -----------------------------------------------------------------------------
pts <- sp::SpatialPoints(cbind(lons, lats), proj4string = sp::CRS("+proj=longlat"))
mpts <- sp::spTransform(pts, newcrs)
plot(e300, border="red", axes=TRUE, xlim=mpts@bbox[1,], ylim=mpts@bbox[2,])
plot(mworld, add=TRUE, col="grey")

## -----------------------------------------------------------------------------
el300 <- as(e300, "SpatialLines")
buff20 <- rgeos::gBuffer(el300, width=280)

## -----------------------------------------------------------------------------
plot(buff20)
plot(el300, add=TRUE, col="red")

## -----------------------------------------------------------------------------
e20 <- only.holes(buff20)
el20 <- as(e20, "SpatialLines")

## -----------------------------------------------------------------------------
plot(el20)
plot(el300, add=TRUE, col="red")

## -----------------------------------------------------------------------------
plot(el20, col="black", axes=TRUE, xlim=mpts@bbox[1,], ylim=mpts@bbox[2,])
plot(el300, add=TRUE, col="red")
plot(mworld, add=TRUE, col="grey")

## -----------------------------------------------------------------------------
numOfPoints  <-  rgeos::gLength(el20) / 100
sample.pts <- sp::spsample(el20, n = numOfPoints, type = "regular")

## -----------------------------------------------------------------------------
plot(el20, col="black", axes=TRUE, xlim=mpts@bbox[1,], ylim=mpts@bbox[2,])
plot(el300, add=TRUE, col="red")
plot(mworld, add=TRUE, col="grey")
plot(sample.pts, add=TRUE, pch=1)
title("sample points every 100 km")

## -----------------------------------------------------------------------------
only.holes <- function (x) 
{
  if (!any(which(utils::installed.packages()[, 1] %in% "maptools"))) 
    stop("please install maptools package before running this function")
  xp <- slot(x, "polygons")
  holes <- lapply(xp, function(x) sapply(methods::slot(x, "Polygons"), 
                                         methods::slot, "hole"))
  res <- lapply(1:length(xp), function(i) methods::slot(xp[[i]], 
                                                        "Polygons")[holes[[i]]])
  IDs <- row.names(x)
  x.fill <- sp::SpatialPolygons(lapply(1:length(res), function(i) sp::Polygons(res[[i]], 
                                                                               ID = IDs[i])), proj4string = sp::CRS(sp::proj4string(x)))
  methods::slot(x.fill, "polygons") <- lapply(methods::slot(x.fill, 
                                                            "polygons"), maptools::checkPolygonsHoles)
  methods::slot(x.fill, "polygons") <- lapply(methods::slot(x.fill, 
                                                            "polygons"), "comment<-", NULL)
  pids <- sapply(methods::slot(x.fill, "polygons"), function(x) methods::slot(x, "ID"))
  x.fill <- sp::SpatialPolygonsDataFrame(x.fill, data.frame(row.names = pids, 
                                                            ID = 1:length(pids)))
  return(x.fill)
}

