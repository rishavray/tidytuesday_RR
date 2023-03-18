#Lets get the data
library(tidytuesdayR)
library(tidyverse)
library(ggdoctheme)
library(sf)
library(rmapshaper)
library(ggrepel)
library(rnaturalearth)
sf_use_s2(FALSE)

#numbats = readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-03-07/numbats.csv')
#write.csv(numbats, "data/numbats.csv")
numbats = read.csv("data/numbats.csv")

#Using the natural earth shape data for plotting
au_map = st_read("data/au_map.shp")
#au_map = st_as_sf(countries110) |> 
#  filter(admin == "Australia")
#write_sf(au_map, "data/au_map.shp")

#This code contains the modified colour guide plotting code.
ggplot() +
geom_sf(data = au_map, fill = "white", lwd = 0.5)+
geom_point(data = numbats |> filter(!is.na(wday)), aes(x = decimalLongitude, y = decimalLatitude), size = 2, colour = "red")+
#guides(colour = guide_colourbar(title = "Temperature", barheight = 0.6, barwidth = 15, ticks = FALSE,
#    title.position = "top", title.hjust = 0.5))+
theme_void()+
theme(legend.direction = "horizontal", legend.position = "top")+
labs(x = NULL, y = NULL, title = "Numbat viewing in Australia")

ggsave("plots/map.png")
