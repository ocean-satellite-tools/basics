## -----------------------------------------------------------------------------
data("sample_raster", package="basics")
df <- sample_raster$df
ras <- sample_raster$raster
lons <- sample_raster$lons
lats <- sample_raster$lats

## -----------------------------------------------------------------------------
require(raster)
require(ggplot2)

## -----------------------------------------------------------------------------
world <- rnaturalearth::ne_countries(scale = "small", returnclass = "sp")
world <- rgeos::gUnaryUnion(world)

## -----------------------------------------------------------------------------
plot(raster::crop(world, raster::extent(lons[1], lons[2], lats[1], lats[2])))

## -----------------------------------------------------------------------------
buff1 <- raster::buffer(world, width = 1, dissolve = TRUE)
e<-erase(buff1, world)
plot(e, col="red", axes=TRUE)

## -----------------------------------------------------------------------------
plot(raster::crop(e, raster::extent(lons[1], lons[2], lats[1], lats[2])), col="red", axes=TRUE)

## -----------------------------------------------------------------------------
# Step 1
newcrs <- "+proj=wintri +lon_0=0 +lat_1=0 +x_0=0 +y_0=0 +datum=WGS84 +units=km +no_defs"
# Step 2
x <- sp::spTransform(world, newcrs)
# Step 3
buff1 <- rgeos::gBuffer(x, width = 100)
e<-raster::erase(buff1, x)

## -----------------------------------------------------------------------------
mpts <- SpatialPoints(cbind(lons, lats), proj4string=CRS("+proj=longlat"))
mpts <- sp::spTransform(mpts, newcrs)

## -----------------------------------------------------------------------------
crop_e <- raster::crop(e, raster::extent(mpts))
plot(crop_e, col="red", axes=TRUE)
plot(x, add=TRUE, col="grey")

## -----------------------------------------------------------------------------
plot(sp::spTransform(crop_e, crs(world)), axes=TRUE, col="red")
plot(world, add=TRUE, col="grey")

## -----------------------------------------------------------------------------
# Step 1
newcrs <- "+proj=wintri +lon_0=0 +lat_1=0 +x_0=0 +y_0=0 +datum=WGS84 +units=km +no_defs"
# Step 2
x <- sp::spTransform(world, newcrs)
# Step 3
buff1 <- rgeos::gBuffer(x, width = 350, byid=TRUE)
buff2 <- rgeos::gBuffer(x, width = 250, byid=TRUE)
e<-raster::erase(buff1, buff2)

## -----------------------------------------------------------------------------
plot(e, col="red", axes=TRUE, xlim=mpts@bbox[1,], ylim=mpts@bbox[2,])
plot(x, add=TRUE, col="grey")

## -----------------------------------------------------------------------------
plot(ras)
plot(sp::spTransform(crop_e, crs(world)), axes=TRUE, col="red", add=TRUE)
plot(world, add=TRUE, col="grey")

## -----------------------------------------------------------------------------
# Step 1
newcrs <- "+proj=wintri +lon_0=0 +lat_1=0 +x_0=0 +y_0=0 +datum=WGS84 +units=km +no_defs"
# Step 2
x <- sp::spTransform(world, newcrs)
# Step 3
buff1 <- rgeos::gBuffer(x, width = 300, byid=TRUE)
e<-raster::erase(buff1, x)

## -----------------------------------------------------------------------------
nohole_e <- spatialEco::remove.holes(spatialEco::remove.holes(e))

## -----------------------------------------------------------------------------
plot(e, border="red")
plot(nohole_e, add=TRUE)
plot(x, add=TRUE, col="grey")

## -----------------------------------------------------------------------------
plot(e, border="red", axes=TRUE, xlim=mpts@bbox[1,], ylim=mpts@bbox[2,])
plot(x, add=TRUE, col="grey")

