###############################################
# Make data visible to both server.R and ui.R #
###############################################

# Required library
library(dplyr)

dfmetrics <- read.csv("DB_Cap_Perf_Dataset.csv", stringsAsFactors = FALSE)
dfmetrics$MVALUE <- as.numeric(dfmetrics$MVALUE)
dailydata <- dfmetrics %>% group_by(DB_NAME, MTYPE, MNAME, MLEVEL, MDATE=as.Date(MTIME, '%d.%m.%Y')) %>% summarise(MVALUE = median(MVALUE))
dailydata$MLEVEL[dailydata$MNAME == 'USER I/O WAIT TIME' | dailydata$MNAME == 'DB USED SIZE (MB)' ] <- 2
dailydata$MLEVEL[dailydata$MNAME == 'DATABASE CPU'] <- 3
dailydata$MLEVEL <- as.factor(dailydata$MLEVEL)

c_db_name <- unique(dailydata$DB_NAME)
c_db_name <- c_db_name[order(c_db_name)]
c_metric_type <- unique(dailydata$MTYPE)
c_metric_type  <- c_metric_type[order(c_metric_type)]
c_date_range <- unique(dailydata$MDATE)
c_date_range  <- as.character(c_date_range[order(c_date_range)], '%d/%m/%Y')
first_date_range <- c_date_range[1]
last_date_range <- c_date_range[length(c_date_range)]

dflag <- TRUE
