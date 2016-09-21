
library(choroplethr)

mydat <- read.csv('/Data/Github/Analytics-and-Research/IA_county_maps.csv')
head(mydat)
mydat2 <- mydat[,c(2,4)]
names(mydat2) <- c("region","value")
mydat2$region <- mydat2$region + 19*1000
nulls_data <- data.frame(region=c(19091, 19119, 19173, 19117, 19053, 19159), value=rep(0,6))
names(nulls_data) <- c("region","value")
mydat2 <- rbind(mydat2, nulls_data)

#county_choropleth(mydat2, title="Bank Asset Concentrations by County", legend="Assets", state_zoom="iowa")


library(RColorBrewer)
library(highcharter)
library("dplyr")
data(uscountygeojson)
#haha, janky >>>
mydat2$code <- paste0("us-ia-",sprintf("%03d", mydat2$region -19000))


dclass <- data_frame(from = seq(0, 1e6, by = 2e5),
                     to = c(seq(2e5, 1e6, by=2e5), max(mydat2$value)),
                     color = brewer.pal(6, "Blues"))
dclass <- list.parse3(dclass)

highchart() %>% 
  hc_title(text = "Bank Asset Concentrations by County, 2015") %>% 
  hc_add_series_map(uscountygeojson, mydat2, name="Assets",
                    value = "value", joinBy = "code", allAreas=FALSE) %>% 
  hc_colorAxis(dataClasses = dclass) %>% 
  hc_legend(layout = "vertical", align = "right",
            floating = TRUE, valueDecimals = 0,
            valueSuffix = "") %>% 
  hc_mapNavigation(enabled = TRUE)

?hc_add_series
