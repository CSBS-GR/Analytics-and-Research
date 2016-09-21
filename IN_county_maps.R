
library(choroplethr)

mydat <- read.csv('/Data/Github/Analytics-and-Research/IN_county_maps.csv')
head(mydat)
mydat2 <- mydat[,c(2,3,4)]
names(mydat2) <- c("region","bankcount","value")
mydat2$region <- mydat2$region + 18*1000
na_region=c(18051, 18079, 18095, 18115, 18125, 18139, 18153, 18183, 18009, 18011, 18021, 18049, 18075, 18093, 18099, 18145, 18165, 18005, 18027, 18041, 18171, 18061, 18081, 18083, 18123, 18155, 18029, 18121, 18135, 18149, 18151, 18159, 18161, 18169, 18175, 18091, 18101, 18013, 18015, 18025)
nulls_data <- data.frame(region=na_region,bankcount=rep(0,length(na_region)), value=rep(0,length(na_region)))
names(nulls_data) <- c("region","bankcount","value")
mydat2 <- rbind(mydat2, nulls_data)

county_choropleth(mydat2, title="Bank Asset Concentrations by County", legend="Assets", state_zoom="indiana")


library(RColorBrewer)
library(highcharter)
library("dplyr")
data(uscountygeojson)
#haha, janky >>>
mydat2$code <- paste0("us-in-",sprintf("%03d", mydat2$region -18000))


dclass <- data_frame(from = seq(0, 1e6, by = 2e5),
                     to = c(seq(2e5, 1e6, by=2e5), max(mydat2$value)),
                     color = brewer.pal(6, "Blues"))
dclass <- list.parse3(dclass)

highchart() %>% 
  hc_title(text = "Bank Asset Concentrations by County, 2015") %>% 
  hc_add_series_map(uscountygeojson, mydat2, name="Assets", dataLabels=list(enabled = TRUE,
                                                                            format = '{point.properties.name}'),
                    value = "value", joinBy = "code", allAreas=FALSE) %>% 
 # hc_add_series_map(uscountygeojson, mydat2, name="Banks", dataLabels=list(enabled = TRUE,
 #                                            format = '{bankcount}'),joinBy = "code", allAreas=FALSE) %>% 
  hc_colorAxis(dataClasses = dclass) %>% 
  hc_legend(layout = "vertical", align = "right",
            floating = TRUE, valueDecimals = 0,
            valueSuffix = "") %>% 
  hc_mapNavigation(enabled = TRUE)

?hc_add_series
