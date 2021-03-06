#' ---
#' title: "Examiners Benchmarking Research\n for Minnesota Banking Department"
#' author: "CSBS Analytics and Research"
#' date: "`r format(Sys.time(), '%d %B, %Y')`"
#' output:
#'     pdf_document:
#'       fig_caption: true
#'       
#' ---
#' 
#+ warning=F, message=F, echo=F
options("digits"=3)
#' Executive Summary
#' =================
#' This study applies statistical models to benchmark the number of bank examiners employed by each state banking department vs.
#' the number of banks and the total assets under supervision in each state. Benchmarking in this way provides a guideline as to
#' where a particular state stands in terms of examiner resource when compared with other states. There is a statistically significant
#' correlation between the number of examiners and both the total amount of assets under supervision as well as the number of 
#' state banks. The models uses 2015 data. The preliminary results show that the subject agency, the Minnesota Department of
#' Commerce, is understaffed by 29 examiners when compared to other states across the US. These findings are in alignment with those
#' of the Examiner Resource Model -- a simple comparison tool developed by CSBS.
#' ![overview](map.png)
#' 
#' 
#' Purpose
#' =======
#'   
#' The purpose of this study is to determine whether there is a correlation between the number of examiners, number of bank 
#' charters, and total assets under supervision for a given state banking department. This will allow for a state by state 
#' comparison, allowing one to determine the staffing needs of the Minnesota Department of Commerce.
#' 
#' Data Description
#' ================
#'   
#' Data Overview
#' -------------
#'   
#' 
#' The study uses consolidated 2015 Profile of State Chartered Banking data and Statistics on Depository Institutions (SDI), 
#' a publicly available bank data source, as of Q4 2015.
#' 
#' *Source:*
#'   
#' 1.  FDIC website.
#' https://www5.fdic.gov/sdi/main.asp?formname=customddownload
#' 
#' 2.  Profile of State Chartered Banking Data.
#' 
#' Relevant variables:
#' -------------------
#'   
#' *Explanatory variable*:
#'   
#' - Number of Examiners by State (N_PF_EXAMINER)
#' 
#' *Independent variable*:
#'   
#' - Aggregate assets under supervision by the department (SDI_TOTAL_ASSET)
#' 
#' - Number of state chartered banks by state (N_SDI_BANK)
#'   
#'   
#+ echo=F, comment=NA, message=F
library(car)
library(dplyr)
library(lattice)
library(caret)
library(zoo)
setwd('H:/ERM Lab')
sdi <- read.csv('SDI_ERM.csv',stringsAsFactors = F)
pf <- read.csv('pf_erm.csv',stringsAsFactors = F)
# land <- read.csv("State Size.csv",stringsAsFactors = F)
# pf <- dplyr::full_join(pf,land,by="STATE")
#' Methodology
#' ===========
#' 
#' 
#+ echo=F, warning=F
sdi <- sdi[,-2]
pf <- pf[,c(1:3)] %>% group_by(YEAR,STATE) %>% summarise(N_PF_EXAMINER=sum(N_PF_EXAMINER)) %>% arrange(STATE,YEAR)

pf$N_PF_EXAMINER[pf$N_PF_EXAMINER==0] <- NA

rdb <- dplyr::full_join(pf,sdi,by=c("YEAR","STATE")) 
rdb$N_PF_EXAMINER[is.na(rdb$N_PF_EXAMINER)&rdb$STATE=="District of Columbia"] <- 
  rdb$N_PF_EXAMINER[rdb$YEAR==2014&rdb$STATE=="District of Columbia"]

rdb$N_SDI_BANK[is.na(rdb$N_SDI_BANK)&rdb$STATE=="District of Columbia"] <- 
  rdb$N_SDI_BANK[rdb$YEAR==2014&rdb$STATE=="District of Columbia"]

rdb$SDI_TOTAL_ASSET[is.na(rdb$SDI_TOTAL_ASSET)&rdb$STATE=="District of Columbia"] <- 
  rdb$SDI_TOTAL_ASSET[rdb$YEAR==2014&rdb$STATE=="District of Columbia"]

rdb$N_PF_EXAMINER[is.na(rdb$N_PF_EXAMINER)&rdb$STATE=="Iowa"] <- 
  rdb$N_PF_EXAMINER[rdb$YEAR==2014&rdb$STATE=="Iowa"]

rdb$N_SDI_BANK[is.na(rdb$N_SDI_BANK)&rdb$STATE=="Iowa"] <- 
  rdb$N_SDI_BANK[rdb$YEAR==2014&rdb$STATE=="Iowa"]

rdb$SDI_TOTAL_ASSET[is.na(rdb$SDI_TOTAL_ASSET)&rdb$STATE=="Iowa"] <- 
  rdb$SDI_TOTAL_ASSET[rdb$YEAR==2014&rdb$STATE=="Iowa"]

rdb <- rdb %>% 
  arrange(STATE,YEAR) %>% group_by(STATE) %>% 
  mutate(N_INT_EXAMINER = 
           round(na.aggregate(
             na.approx(N_PF_EXAMINER,na.rm=F),
    by=STATE, FUN = max, na.rm=F)),
         N_REF_EXAMINER = 
          round(na.aggregate(
            na.approx(N_PF_EXAMINER,na.rm=F),
    by=STATE, FUN = mean, na.rm=F)))



#+ echo=F
rm(pf,sdi)
rdb <- subset(rdb,subset=rdb$YEAR==2015)
rdb <- subset(rdb,subset = rdb$N_INT_EXAMINER > 0)
rdb <- subset(rdb,subset = rdb$STATE!='New York' & rdb$STATE!='Guam')

# splom(rdb[,c(3,4,5)],groups=rdb$YEAR)
ame <- function(x) {
  abs(x-median(x,na.rm=F))
}
error <- NULL
for (state in unique(rdb$STATE)) {
  error <- append(error,ame(rdb$N_REF_EXAMINER[rdb$STATE %in% state]))
}
rdb$error <- error
rdb$N_INT_EXAMINER <- ifelse(rdb$error<10,rdb$N_INT_EXAMINER,NA)
rdb <- rdb %>% group_by(STATE) %>% mutate(N_INT2_EXAMINER = 
                                     round(na.aggregate(
                                       na.approx(N_INT_EXAMINER,na.rm=F),
                                       by=STATE, FUN = max, na.rm=F)))
# rdb$BANK_DENSITY <- (rdb$N_SDI_BANK / rdb$Land)
#' Assumptions: 
#' -------------
#' The following assumptions were made when constructing this model. Individual circumstances may vary from these assumptions
#' and so should be kept in mind when interpreting the results.
#'   
#' 1. There is a linear relationship between the independent variables and dependent variables.
#' 
#' 2. The independent variables are not random. There is no exact linear relationship between any independent variables.
#' 
#' 3. The locations of the banks will not have a significant impact on the time of examining work.
#' 
#' 4. All the states follow similar examining process.
#' 
#' 5. The CAMELS rating of previous year doesn't have a significant impact on the time of examination for the current year[^1].
#' 
#' [^1]: It is widely understood among bank regulators that the financial condition of the institution is a driving factor of 
#' examination resources. In times of economic stress, the demands on an agency's bank examination staff increase.
#' 
#' 6. Bank examiners of all the states meet the similar productivity standards.
#' 
#' 7. The diversity of the bank assets is already considered in bank size, thus will not have a significant impact on the time
#' of examining work.
#' 
#' Model: Multiple Linear Regression Model
#' --------------------------
#' A multiple linear regression model is defined as
#' 
#' $$y_{i} = \alpha + \beta_{i}x_{i} + \epsilon_{i}$$
#'  
#' in which $\epsilon_i$ is the error or residual associated with observation _i_. 
#' 
#' Profile of State Chartered Banking Data for District of Columbia and Iowa were not available for 2015. Data from 2014 were used
#' for these two states.
#' 
#' The data distribution was drawn in R. After removing New York as the outlier, we observed a linear relationship between aggregated
#' total asset chartered by state and number of state examiner.  
#+ echo=F
scatterplot(rdb$SDI_TOTAL_ASSET/1e6,rdb$N_INT_EXAMINER,xlab="Total Asset Chartered by State (Billion $)",ylab="Number of Examiner")
#' _Figure 1_
#+ echo=F
scatterplot(rdb$N_SDI_BANK,rdb$N_INT_EXAMINER,xlab="Number of State Chartered Bank",ylab="Number of Examiner")
#' _Figure 2_
#+ echo=F, comment=NA
# lm1 <- lm(N_INT2_EXAMINER~SDI_TOTAL_ASSET+N_SDI_BANK+YEAR,rdb)
# lm1 <- lm(N_INT2_EXAMINER~SDI_TOTAL_ASSET+BANK_DENSITY+YEAR,rdb)
# summary(lm1)
#'  
#' **Model Output from R**
#+ echo=F, comment=NA
lm2 <- lm(N_INT2_EXAMINER~SDI_TOTAL_ASSET+N_SDI_BANK,rdb)
# lm2 <- lm(N_INT2_EXAMINER~SDI_TOTAL_ASSET+BANK_DENSITY,rdb)
# lmFit <- train(N_PF_EXAMINER~SDI_TOTAL_ASSET+N_SDI_BANK,rdb,method = "lm",trControl=trainControl(method="LOOCV"))
# rdb$N_PRED_EXAMINER <- floor(lmFit$pred$pred)
# data.frame(State=rdb$STATE,Current=rdb$N_PF_EXAMINER,Benchmark=round(lm2$fitted.values),stringsAsFactors = F,row.names = NULL)
sum_lm2 <- summary(lm2)
sum_lm2
#' 
#' The number of asterisks represents the degree of significance where \*\*\* indicates strong correlation and \* indicates
#' weak correlation. Both variables are significant in our model. *Aggregate assets under supervision by the department* 
#' (*SDI\_TOTAL\_ASSET*) is the most significant variable. The R-square indicates the percentage of data captured in the trend.
#' According to the output shown above, `r round(100*sum_lm2$r.squared)`% of the data are explained in this model. In other words, 
#' the dominant variable in determining the staffing size of a state banking agency is the total bank assets chartered by that agency. 
#' The number of banks chartered by a state banking agency is a secondary, but important, factor. 
#' 
#' In consequence, the Number of Examiner for a State Department can be approximated with the following linear equation:
#'   
#' $$Number\ of\ Examiner = `r lm2$coefficients[2]` * Total\ Asset + `r lm2$coefficients[3]`*Number\ of\ Bank + `r lm2$coefficients[1]`$$
#'   
#' The equation shows that the coefficient for total assets is
#' $`r lm2$coefficients[2]`$. It indicates that, other variables
#' remaining the same, for each \$10 billion assets increase, there should be
#' about `r round(10e9*lm2$coefficients[2]/1000,1)` more examiners. The coefficient for number of banks is 
#' `r lm2$coefficients[3]`. It indicates that, other variables remaining the same, for each increase of 10 banks, there should be 
#' `r round(10*lm2$coefficients[3],1)` more examiners.
#' 
#' Minnesota chartered `r rdb$N_SDI_BANK[rdb$STATE=="Minnesota"]` banks, \$$`r 1000*rdb$SDI_TOTAL_ASSET[rdb$STATE=="Minnesota"]`$ 
#' holding over \$`r round(1000*rdb$SDI_TOTAL_ASSET[rdb$STATE=="Minnesota"]/10e9)` billion in total bank assets and employed 
#' `r rdb$N_PF_EXAMINER[rdb$STATE=="Minnesota"]` examiners as of Dec 31^st^, 2015.
#' 
#' Conclusion
#' ==========
#'   
#' The model finds that in 2015, the estimated number of examiners needed in Minnesota, given its relatively high number of 
#' charters and its sizeable assert base, was approximately 50. Accordingly, Minnesota appeared to be understaffed by 
#' `r -1*round(lm2$residuals[23])` examiners in 2015.
#' 
#' 
#' Appendix
#' ========
#' Figure 3 displays the number of examiners gap and the percentage of examiners gap for each reporting state banking department.  
#' 
#' 
#' ![img](MSTR_bar.png)
#' _Figure 3_  
#+ fig.width=10, fig.height=10, echo=F, eval=F
scatterplotMatrix(~N_INT2_EXAMINER+N_SDI_BANK+SDI_TOTAL_ASSET|YEAR,
                  data=rdb, main="Correlation Grouped in Years")
par(mfrow=c(2,2))
plot(lm2)
#+ echo=F, comment=NA
map1 <- subset(data.frame(State=rdb$STATE,Value=round(lm2$residuals),stringsAsFactors = F),subset=rdb$YEAR==2015)
map2 <- subset(data.frame(State=rdb$STATE,Value=lm2$residuals*100/rdb$N_PF_EXAMINER,stringsAsFactors = F),subset=rdb$YEAR==2015)
map1$State <- sapply(map1$State,function(x){state.abb[grep(x,state.name)][1]})
map2$State <- sapply(map2$State,function(x){state.abb[grep(x,state.name)][1]})
map1$State[is.na(map1$State)] <- "PR"
map2$State[is.na(map2$State)] <- "PR"
write.csv(map1,'easymap1.csv',row.names = F)
write.csv(map2,'easymap2.csv',row.names = F)
rdb$N_PRED_EXAMINER <- round(lm2$fitted.values)
rdb$N_DIFF_EXAMINER <- round(lm2$residuals)
write.csv(rdb,'EXAMINER_SDI+PF+PRED.csv',row.names=F)
# system("update-p-drive.bat")