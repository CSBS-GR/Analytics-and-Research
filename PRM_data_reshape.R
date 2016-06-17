library(xlsx)
library(tidyr)


############## 2014 Data Reshape

wb <- loadWorkbook("PRM data yearend 2014.xlsx")

sheetnames <- names(getSheets(wb))
sheetnames_ <- sub(" ","_",sheetnames)

for (i in 1:length(sheetnames)) {
  assign(sheetnames_[i],value = 
           na.omit(cbind(read.xlsx("PRM data yearend 2014 clean.xlsx",sheetIndex = i,stringsAsFactors=F),
                         ROW_VAR=sheetnames[i]))
         %>% gather(COL_VAR,Salary,Actual.Base.Low:Actual.Range.Max)
         )
}

library('data.table')
new_wb <- rbindlist(lapply(parse(text=sheetnames_),eval))
colnames(new_wb) <- c("ACCOUNT","N_INCUMBENT","ROW_VAR","COL_VAR","Salary")
new_wb[new_wb=="--"] <- -1

oldnames <- unique(new_wb$COL_VAR)
newnames <- c("Min_Actual_Salary","Avg_Actual_Salary","Max_Actual_Salary","Min_Base_Range","Mid_Base_Range","Max_Base_Range")

for (i in 1:length(oldnames)) {
  new_wb[new_wb==oldnames[i]] <- newnames[i]
}


wb2 <- read.xlsx("4 left accupations.xlsx",sheetIndex=1,stringsAsFactors=F) %>% gather(NA.,Salary,4:9)
colnames(wb2) <- c("ROW_VAR","ACCOUNT","N_INCUMBENT","COL_VAR","Salary")

wb_combined <- rbind(new_wb,wb2)

write.csv(wb_combined,"PRM data yearend 2014 all.csv")

###############################################################################################################

data <- read.csv("Salary Report Clean Data 2014 and 2015.csv")
data_wide <- data[,-1] %>% spread(COL_VAR,Salary)

selected <- c("Year","Account","ROW_VAR", "N_Incumbents", "Average Actual Salary", "Maximum Actual Salary", "Maximum Base Range", "Mid Base Range", "Minimum Actual Salary", "Minimum Base Range")
data_wide <- subset(data_wide,select=selected)

data2014 <- subset(data_wide, Year==2014)
salary <- subset(data_wide, Year==2015 & is.na(N_Incumbents))
salary$N_Incumbents <- NULL
incum <- subset(data_wide, Year==2015 & !is.na(N_Incumbents), select=c("Year","Account","ROW_VAR","N_Incumbents"))

data2015 <- merge(salary,incum,by=c("Year","Account","ROW_VAR"),all=T)

data_wide_new <- rbind(data2014,data2015)
  
write.csv(data_wide_new,"Salary Report Clean Data 2014 and 2015 wide.csv")
