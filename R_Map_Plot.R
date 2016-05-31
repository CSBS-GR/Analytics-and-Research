library(ggplot2)
library(readr) 
library(dplyr)
library(maps)
library(maptools)
library(mapproj)
library(rgeos)
library(rgdal)
library(RColorBrewer)
library(ggplot2)

setwd("/Data")

# for theme_map

theme_map <- function(base_size=9, base_family="") {
  require(grid)
  theme_bw(base_size=base_size, base_family=base_family) %+replace%
    theme(axis.line=element_blank(),
          axis.text=element_blank(),
          axis.ticks=element_blank(),
          axis.title=element_blank(),
          panel.background=element_blank(),
          panel.border=element_blank(),
          panel.grid=element_blank(),
          panel.margin=unit(0, "lines"),
          plot.background=element_blank(),
          legend.justification = c(0,0), 
          legend.position = c(0,0)
    )
}

# for US Map

us <- map_data("state")
us <- fortify(us, region="region")


# read your data 

read_csv("akbanks.csv")  -> data

gg <- ggplot() 
gg <- gg + geom_map(data=us, map=us,
                    aes(x=long, y=lat, map_id=region, group=group),
                    fill="#ffffff", color="#7f7f7f", size=0.5) +theme_map()
gg <- gg + geom_point(data=data,
                      aes(x=SIMS_LONGITUDE, y=SIMS_LATITUDE, size=as.factor(bkmo), color=bank),
                      alpha=8/10) 

gg <- gg + coord_map("albers", lat0=39, lat1=45)
gg <- gg +   scale_color_discrete(name="Bank Name") + guides(size=FALSE) + scale_size_manual(values=c(3,10))   + 
  theme(legend.text = element_text(size = 16, face = "bold")) +
  guides(colour = guide_legend(override.aes = list(size=c(10,10,10), alpha=c(0.9,0.9,.9) )))+
  theme(legend.title = element_text(size=18, face = "bold"))
gg



ggsave("all3.png",gg, width = 10, height =10)




