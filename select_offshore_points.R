## ---------------------------------------------------------------------------------------------
data("sample_raster", package="basics")
df <- sample_raster$df
ras <- sample_raster$raster
lons <- sample_raster$lons
lats <- sample_raster$lats


## ---------------------------------------------------------------------------------------------
require(raster)
require(ggplot2)


## ---------------------------------------------------------------------------------------------
world <- rnaturalearth::ne_countries(scale = "small", returnclass = "sp")
world <- rgeos::gUnaryUnion(world)


## ---------------------------------------------------------------------------------------------
newcrs <- "+proj=wintri +lon_0=0 +lat_1=0 +x_0=0 +y_0=0 +datum=WGS84 +units=km +no_defs"
mworld <- sp::spTransform(world, newcrs)
mras <- projectRaster(ras, crs=newcrs, over=TRUE)
mpts <- sp::SpatialPoints(cbind(lons, lats), proj4string=sp::CRS("+proj=longlat"))
mpts <- sp::spTransform(mpts, newcrs)


## ---------------------------------------------------------------------------------------------
buff1 <- rgeos::gBuffer(mworld, width = 300, byid=TRUE)
e<-raster::erase(buff1, mworld)
plot(e)


## ---------------------------------------------------------------------------------------------
e300 <- spatialEco::remove.holes(spatialEco::remove.holes(e))
plot(e300)


## ---------------------------------------------------------------------------------------------
plot(e300)
plot(mworld, add=TRUE, col="grey")


## ---------------------------------------------------------------------------------------------
el <- as(mworld, "SpatialLines")
el <- raster::crop(el, mpts@bbox)
set.seed(123)
pts <- sp::spsample(el, n = 1, type = "regular")


## ---------------------------------------------------------------------------------------------
plot(e300, border="red", axes=TRUE, xlim=mpts@bbox[1,], ylim=mpts@bbox[2,])
plot(mworld, add=TRUE, col="grey")
plot(pts, add=TRUE, pch=19)


## ---------------------------------------------------------------------------------------------
el300 <- as(e300, "SpatialLines")
close_pt <- maptools::snapPointsToLines(pts, el300, maxDist=500)
plot(mworld)
plot(close_pt, add=TRUE, pch=19, col="red")
plot(pts, add=TRUE, pch=19)


## ---------------------------------------------------------------------------------------------
el300 <- as(e300, "SpatialLines")
df <- c()
n <- length(el300@lines[[1]]@Lines)
for (i in 1:n){
  df <- rbind(df, cbind(el300@lines[[1]]@Lines[[i]]@coords, ID=i))
}
close_pt <- maptools::nearestPointOnLine(df, pts@coords)
close_pt <- sp::SpatialPoints(matrix(close_pt, ncol=2), proj4string=CRS(newcrs))


## ---------------------------------------------------------------------------------------------
plot(e300, border="red", axes=TRUE, xlim=mpts@bbox[1,], ylim=mpts@bbox[2,])
plot(mworld, add=TRUE, col="grey")
plot(pts, add=TRUE, pch=19)
plot(close_pt, add=TRUE, pch=1)


## ---------------------------------------------------------------------------------------------
plot(mras, axes=TRUE, xlim=bbox(mras)[1,], ylim=bbox(mras)[2,])
plot(e300, border="red", add=TRUE)
plot(mworld, add=TRUE, col="grey")
plot(pts, add=TRUE, pch=19)
plot(close_pt, add=TRUE, pch=1)


## ---------------------------------------------------------------------------------------------
raster::extract(mras, close_pt)


## ---------------------------------------------------------------------------------------------
circle_pt <- raster::buffer(close_pt, width = 100)


## ----echo=FALSE-------------------------------------------------------------------------------
plot(mras, axes=TRUE, xlim=bbox(mras)[1,], ylim=bbox(mras)[2,])
plot(e300, border="red", add=TRUE)
plot(mworld, add=TRUE, col="grey")
plot(pts, add=TRUE, pch=19)
plot(close_pt, add=TRUE, pch=19, col="red")
plot(circle_pt, add=TRUE)


## ---------------------------------------------------------------------------------------------
vals <- raster::extract(mras, circle_pt)[[1]]
vals


## ---------------------------------------------------------------------------------------------
mean(vals, na.rm=TRUE)


## ----eval=FALSE-------------------------------------------------------------------------------
## crs.wintri <- newcrs
## save(crs.wintri, file=file.path(here::here(), "data/crs_wintri.rda"))
## world.wintri <- mworld
## save(world.wintri, file=file.path(here::here(),"data/world_wintri.rda"))
## save(world, file=file.path(here::here(), "data/world.rda"))
## buffer300.wintri <- list(buf_line = el300, buf_poly = e300, buf_df = df, crs = newcrs)
## save(buffer300.wintri, file=file.path(here::here(), "data/buffer300_wintri.rda"))

