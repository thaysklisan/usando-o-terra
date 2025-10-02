### carregando dados espaciais e reprojetando ###

# Pacotes
library(terra)   # operações espaciais (vetor e raster)
library(geobr)   # obter shapes do Brasil (municípios/estados/biomas)
# Opcionalmente, use 'geodata' para baixar WorldClim como SpatRaster
# (apenas aquisição — as análises serão com terra)
if (!requireNamespace("geodata", quietly = TRUE)) {
  message("Pacote 'geodata' não encontrado. Instale com install.packages('geodata') para baixar WorldClim.")
}

# criar diretorios
dir.create("data", showWarnings = FALSE)
dir.create("data/shapes", recursive = TRUE, showWarnings = FALSE)
dir.create("data/rasters", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/figuras", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/dados", recursive = TRUE, showWarnings = FALSE)


#Shapes via geobr (dados vetoriais)
# baixar estado da Bahia
bahia <- geobr::read_state(code_state = "BA", year = 2020, simplified = TRUE)
bahia_v <- vect(bahia)  # converter para SpatVector

# Município de Camacan (BA) como area de estudo
lookup_muni(name_muni = "Camacan")
camacan <- geobr::read_municipality(code_muni = 2905602, year = 2020, simplified = TRUE)
camacan_v <- vect(camacan)

#qual o sistema de coordenadas
crs(camacan_v)

# plotando os vetores
plot(bahia_v, col = "gray90")
plot(camacan_v, add = TRUE, col = "darkblue")

# Obtendo dados abioticos
# Raster WorldClim (12 bandas de temperatura média mensal)
# Requer o pacote 'geodata' para download (gera SpatRaster já no formato do terra)
if (requireNamespace("geodata", quietly = TRUE)) {
  wc_tavg <- geodata::worldclim_global(var = "tavg", res = 10, path = "data/rasters")
  # 'wc_tavg' é multibanda (12 camadas: meses)
  wc_tavg
} else {
  # fallback: gerar um raster sintético para fins didáticos (se geodata não estiver disponível)
  set.seed(42)
  wc_tavg <- rast(ext( -41, -37, -16, -13), resolution = 0.01, crs = "EPSG:4674") # WGS84 / SIRGAS 2000
  wc_tavg <- c(wc_tavg, wc_tavg, wc_tavg) # 3 bandas de exemplo
  names(wc_tavg) <- paste0("tavg_", 1:nlyr(wc_tavg))
  values(wc_tavg) <- runif(ncell(wc_tavg) * nlyr(wc_tavg), min = 18, max = 28)
  wc_tavg
}

# Definir um CRS métrico apropriado (UTM zona 23S para Camacan/BA)
crs_wgs84 <- "EPSG:4326"

#reprojetanda para a zona adequada
bahia_wgs   <- project(bahia_v, crs_wgs84)
camacan_wgs  <- project(camacan_v, crs_wgs84)

crs(bahia_wgs)


# Exportar resultados
writeVector(bahia_wgs,  "outputs/dados/bahia_wgs84.gpkg", overwrite=TRUE)
writeVector(camacan_wgs,  "outputs/dados/camacan_wgs84.gpkg", overwrite=TRUE)
writeRaster(wc_tavg, "outputs/dados/prep_mensal.tif", overwrite=TRUE)
