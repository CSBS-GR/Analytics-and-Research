#' ---
#' title: "Examiners Benchmarking Research\n For Minnesota Banking Department"
#' author: "CSBS Analytics and Research"
#' date: "Jan 31, 2017"
#' ---
#' 
#+ warning=F, message=F, echo=F
options("digits"=3)
#' Overview
#' ========
#'   
#' The purpose of this study is to find a correlation between the number of 
#' examiners and some key characteristics of the bank that are regulated in
#' the state.
#' 
#' Data Description
#' ================
#'   
#' Data Overview
#' -------------
#'   
#' *Data range***:** 2013,2014,2015.
#' 
#' We consolidated the profile data and Statistics on Depository
#' Institutions (SDI) as of Q4 of each year.
#' 
#' *Source:*
#'   
#' 1.  FDIC website.
#' https://www5.fdic.gov/sdi/main.asp?formname=customddownload
#' 
#' 2.  Profile Data.
#' 
#' Relevant variables:
#' -------------------
#'   
#' *Explanatory variable*:
#'   
#' - Number of examiners by state (Profile)
#' 
#' *Independent variable*:
#'   
#' - Aggregate assets under supervision by the department (SDI)
#' 
#' - Number of state chartered banks by state (SDI)
#'   
#'   
#'   
#' Datasets Sample:
#' ----------------
#+ echo=F, comment=NA, message=F
library(car)
library(dplyr)
library(lattice)
library(caret)
library(zoo)
setwd('H:/Examiner Resource Model')
sdi <- read.csv('SDI_ERM.csv',stringsAsFactors = F)
pf <- read.csv('pf_erm.csv',stringsAsFactors = F)
# land <- read.csv("State Size.csv",stringsAsFactors = F)
# pf <- dplyr::full_join(pf,land,by="STATE")
#' ### SDI
#+ echo=F, comment=NA
head(sdi)
#' ### Profile Survey
#+ echo=F, comment=NA
head(pf)
#' Methodology
#' ===========
#'   
#' # Data Imputation
#' The data imputation comprises of two steps:
#' *Step 1*:  Replacing each NA with values from linear interpolation
#' *Step 2*:  Replacing each NA with aggregated values. This allows imputing by the group means.
#' (placeholder for mathematical interpretation).  
#' Step 1
#' $$ y = y_0 + (x - x_0) \frac{y_1 - y_0}{x_1 - x_0} $$
#' Step 2
#' $$ x = E(x_0 + x_1) $$
#' # Data Cleaning  
#' 1. Threshold for defining "invalid response":
#'   * Change in Number of Examiner exceed 10 as compared with the median in a state department. (alternative solution available)
#' 1. Remove invalid responses and re-apply data imputation methods mentioned in _Data Imputation_ section.
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

#' Here is a preview for the combined data and Plot Matrix with density plots and trend lines to explore correlations 
#' among variables:

#' 1.The states in the year that has 0 number of examiner or missing value
#' are replaced with the average of the other years' data value for the
#' same state.
#' 
#' 2. If the number of examiners reported by state agencies has a
#' difference of more than 10 from the previous year, it is considered as
#' bad data. We replaced the bad data with the average of good data for the
#' same state.
#' 
#' 3. Guam is deleted from the dataset because it only has two years' data
#' records.

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
#'   
#' 1.  There is a linear relationship between the independent variables and
#' dependent variables.
#' 
#' 2.  The independent variables are not random. There is no exact linear
#' relationship between any independent variables.
#' 
#' 3.  The locations of the banks will not have a significant impact on the
#' time of examining work.
#' 
#' 4.  All the states follow similar examining process.
#' 
#' 5.  The CAMELS rating of previous year doesn't have a significant impact
#' on the time of examination for the current year.
#' 
#' 6.  Bank examiners of all the states meet the similar
#' productivity standards.
#' 
#' 7.  The diversity of the bank assets is already considered in bank size,
#' thus will not have a significant impact on the time of
#' examining work.
#' 
#' **Model:** Multi-variate Model.
#' 
#' The multi-variate linear regression model is defined as
#' 
#' $$y_{i} = \alpha + \beta_{i}x_{i} + \epsilon_{i}$$
#'  
#' in which $\epsilon_i$ is the error or residual associated with observation _i_. 


#' We drew the data distribution in R. After removing the outlier New York,
#' we can see a linear relationship.
#+ echo=F
scatterplot(rdb$SDI_TOTAL_ASSET,rdb$N_INT_EXAMINER,xlab="State Total Asset",ylab="Number of Examiner")
scatterplot(rdb$N_SDI_BANK,rdb$N_INT_EXAMINER,xlab="Number of State Chartered Bank",ylab="Number of Examiner")
#+ echo=F, comment=NA
# lm1 <- lm(N_INT2_EXAMINER~SDI_TOTAL_ASSET+N_SDI_BANK+YEAR,rdb)
# lm1 <- lm(N_INT2_EXAMINER~SDI_TOTAL_ASSET+BANK_DENSITY+YEAR,rdb)
# summary(lm1)
# The model summary above indicates **YEAR** is not significant in the model and can be safely removed. The number of asterisks 
# represents the degree of significance where *** indicates strong correlation and . indicates weaker correlation. Among all these variables,
#  **Bank Total Asset** (*SDI_TOTAL_ASSET*) is the most significant one.

#' **Model from R**
#+ echo=F, comment=NA
lm2 <- lm(N_INT2_EXAMINER~SDI_TOTAL_ASSET+N_SDI_BANK,rdb)
# lm2 <- lm(N_INT2_EXAMINER~SDI_TOTAL_ASSET+BANK_DENSITY,rdb)
# lmFit <- train(N_PF_EXAMINER~SDI_TOTAL_ASSET+N_SDI_BANK,rdb,method = "lm",trControl=trainControl(method="LOOCV"))
# rdb$N_PRED_EXAMINER <- floor(lmFit$pred$pred)
# data.frame(State=rdb$STATE,Current=rdb$N_PF_EXAMINER,Benchmark=round(lm2$fitted.values),stringsAsFactors = F,row.names = NULL)
summary(lm2)
#' The second linear model excludes YEAR from the model. The significance of *SDI_TOTAL_ASSET* remains. Thus, the Number of 
#' Examiner for a State Department can be approximated with the following linear equation:
#' $$ Number\ of\ Examiner = `r lm2$coefficients[2]` * Total\ Asset + `r lm2$coefficients[3]` * Number\ of\ Bank + `r lm2$coefficients[1]` $$
#'
#' We first included year in our model, which turned out to be not
#' significant. The number of asterisks represents the degree of
#' significance where \*\*\* indicates strong correlation and \*indicates
#' weak correlation. After we excluded YEAR from the model, the
#' significance of *SDI\_TOTAL\_ASSET* remains. Among all these variables,
#' **Bank Total Asset** (*SDI\_TOTAL\_ASSET*) is the most significant one.
#' The R-square shows the percentage of the data that are captured in the
#' trend. According to the result shown above, 77% of the data are
#' explained in this model.
#' 
#' In consequence, the Number of Examiner for a State Department can be
#' approximated with the following linear equation:
#'   
#'   $$Number\ of\ Examiner = `r lm2$coefficients[2]` * Total\ Asset + `r lm2$coefficients[3]`*Number\ of\ Bank + `r lm2$coefficients[1]`$$
#'   
#'   The equation shows that the coefficient for total assets is
#' $`r lm2$coefficients[2]`$ It indicates that, other variables
#' remaining the same, for each 1 billion assets increase, there should be
#' about 3 more examiners. The coefficient for number of banks is 0.14. It
#' indicates that, other variables remaining the same, for each increase of
#' 100 banks, there should be 14 more examiners.
#' 
#' Minnesota had 257 banks, \$2,393,685,847 total bank assets and 21
#' examiners as of Dec 31^st^. After we input these numbers in the formula,
#' we get the number 24. Therefore, the estimated benchmark from Minnesota
#' in 2015 is 24.
#' 
#' Conclusion
#' ==========
#'   
#'   The map below shows the difference between the number of examiners that
#' the state should have and the number of examiners the state currently
#' has. A negative number means understaff. In general, the study found
#' that Minnesota appeared to be understaffed by 3 examiners in 2015.
#' 
#' For future improvement, we will consider risk and geographical factors.
#' 
#' Appendix
#' ========
#+ fig.width=10, fig.height=10, echo=F
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
write.csv(map1,'result1.csv',row.names = F)
write.csv(map2,'result2.csv',row.names = F)
rdb$N_PRED_EXAMINER <- round(lm2$fitted.values)
rdb$N_DIFF_EXAMINER <- round(lm2$residuals)
write.csv(rdb,'EXAMINER_SDI+PF+PRED.csv',row.names=F)
# system("update-p-drive.bat")