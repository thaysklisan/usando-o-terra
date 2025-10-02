### gerando pontos aleatorios e buffers (area de influencia) ###
# carregar pacotes
library(terra)

#carregar dados
bahia_wgs <- vect("outputs/dados/bahia_wgs84.gpkg")
temp_mask <- rast("outputs/dados/temp_anual_bahia.tif")

# Amostra de pontos aleatorios na Bahia (grade simples)
set.seed(1)
pts <- spatSample(bahia_wgs, size = 200, method = "random")
plot(bahia_wgs, col="grey90")
points(pts, pch=20, cex=.6)

# Buffer de 2 km nos pontos
buf2k <- buffer(pts, width = 2000)
plot(bahia_wgs, col="grey90")
plot(buf2k, add=TRUE, border="red")
