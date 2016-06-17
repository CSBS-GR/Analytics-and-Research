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


# -- SQL CODE:
# SELECT  /*csv*/
# UNINUMBR,
# CERT,
# namefull,
# RSSDHCR,
# NAMEHCR,
# ASSET,
# CASE WHEN CERT IN (628,3510,3511,7213) THEN 1 ELSE 0 END AS TOP4,
# CASE when CERT IN (628,3510,3511,7213, 6548, 6384, 639,14,4297,18409) THEN 1 ELSE 0 end AS TOP10,
# SIMS_LATITUDE,
# SIMS_LONGITUDE
# FROM MDS_SOD
# where year= 2015
#  --END of SQL CODE


# for US Map

us <- map_data("state")
us <- fortify(us, region="region")


# read your data and filter out points not in CONUS

setwd("C:\\Data\\Github\\Analytics-and-Research")
read_csv("allbranches.csv") %>%
  filter(SIMS_LONGITUDE>=-124.848974 & SIMS_LONGITUDE<=-66.885444,
         SIMS_LATITUDE>=24.396308 & SIMS_LATITUDE<=49.384358) -> data
data$TopBanks <- ""
data[data$TOP10==1,"TopBanks"] = "Top 10 Banks"
data[data$TOP10==0,"TopBanks"] = "All Other Banks"

gg <- ggplot()
gg <- gg + geom_map(data=us, map=us,
                    aes(x=long, y=lat, map_id=region, group=group),
                    fill="#ffffff", color="#7f7f7f", size=0.5)
gg <- gg + geom_point(data=data,
                      aes(x=SIMS_LONGITUDE, y=SIMS_LATITUDE, color=factor(TopBanks)),
                      size=0.3, alpha=2/10)
gg <- gg + geom_point(data=data[data$TOP10==1,],
                      aes(x=SIMS_LONGITUDE, y=SIMS_LATITUDE), color="green",
                      size=0.3, alpha=1/10)
gg <- gg + coord_map("albers", lat0=39, lat1=45)
gg <- gg + theme_map() + guides(colour = guide_legend(override.aes = list(size=c(4,4), alpha=c(0.9,0.9) ))) +
  scale_color_discrete(name="Top 10 Banks vs Rest of Field")
gg

ggsave("all4.png",gg, width = 10, height =10)
