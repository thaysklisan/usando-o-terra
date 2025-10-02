### recortar e mascarar raster pelo municipio ###

# carregar pacotes
library(terra)

#carregar dados
bahia_wgs <- vect("outputs/dados/bahia_wgs84.gpkg")
temp_mensal <- rast("outputs/dados/prep_mensal.tif")

# Recortar pela extensão da Bahia
temp_crop <- crop(temp_mensal, bahia_wgs)
plot(temp_crop)

# Aplicar máscara para manter apenas o polígono da Bahia
temp_mask <- mask(temp_crop, bahia_wgs)

# Visualizar
plot(temp_mask)

#plotando apenas o primeiro mes
plot(temp_mask[[1]], main="WorldClim (tavg mês 1) — Bahia")
plot(bahia_wgs, add=TRUE, border="black")

writeRaster(temp_mask, "outputs/dados/temp_anual_bahia.tif", overwrite=TRUE, gdal="COMPRESS=DEFLATE")
