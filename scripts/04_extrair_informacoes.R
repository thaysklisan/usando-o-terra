### Extrair e resumir informações ecológicas ###
# carregar pacotes
library(terra)

#carregar dados
bahia_wgs <- vect("outputs/dados/bahia_wgs84.gpkg")
temp_mask <- rast("outputs/dados/temp_anual_bahia.tif")

#calcular a media de precipitacao anual
mean_annual <- app(temp_mask, fun = mean, na.rm = TRUE)

# Estatística zonal: média por zona (ex.: buffers de 2 km como zonas)
# Usando extract() com `fun`
buff_stats <- extract(temp_mask[[1]], buf2k, fun = mean, na.rm = TRUE)
head(buff_stats)

#visualizacao
plot(temp_mask [[1]])
plot(bahia_wgs, add=T)
points(pts, pch=20, cex=.6)
plot(buf2k, add=TRUE, border="red")


writeRaster(temp_mask, "outputs/dados/temp_bahia.tif", overwrite=TRUE)

