setwd("/Users/jtudela/Documents/pruebas/intensidad_luminosa_peru")
pacman::p_load(raster, tmap, shiny, shinyjs, data.table, haven, janitor)

# Carga de bases ----------------------------------------------------------
ntl = raster("F152007.v4b.global.stable_lights.avg_vis.tif")
# plot(ntl)
peru = getData('GADM', country = 'PER', level = 1)

provs = st_read("/Users/jtudela/Documents/Tesis/data/mapas/PROVINCIAS.shp")
provs = st_make_valid(provs)

# Intensidad luminosa prom. por provincia --------------------------------
z = raster::extract(x = ntl, y= provs.fix,fun =mean , df=TRUE) # toma su tiempo (2 min)

provs_ntl = cbind.data.frame(as.data.frame(provs)[1:4], z) %>% 
  as.data.table() %>%  clean_names()

colnames(provs_ntl)[3] <- c("provs")
colnames(provs_ntl)[6] <- c("ntl")

write_dta(provs_ntl, file.path(getwd(), "intensidad_luminosa_provincial.dta"))

# Gráfico -----------------------------------------------------------------
peru_ntl <- crop(ntl, peru)

rm(ntl)
# plot(peru_ntl)
# plot(hfp_meso)
# plot(provs, add = TRUE)

tm_shape(peru_ntl) + 
  tm_raster(palette = "-Greys", title = "Intensidad luminosa") + 
  tm_shape(provs.fix) + 
  tm_borders(col = "Blue", lwd = .15, alpha = 0.5, lty = "solid") +
  tm_layout( legend.frame = TRUE, legend.position =c("left","bottom" ), legend.title.size = 0.8, legend.width= -0.35)
