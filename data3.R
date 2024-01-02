tryCatch(library('pacman'),
         error=function(e){
           install.packages('pacman')
           library('pacman')
         })
pacman::p_load(data.table, ggplot2, tidyverse, bit64, dplyr, tidytable, DataExplorer)


# 데이터 불러오기
setwd("C:/Users/신지윤/Desktop/3학년 2학기/도모빌/term project/DataAnalysis")
df <- read.csv("data.csv", header=T, encoding="UTF-8")

# wide form을 long form으로
colnames(df)[c(9:23)] <- c('Bus_cost', 'Bus_IVT', 'Bus_access', 'Bus_delay_min', 'Bus_delay_max',
                           'PM_cost', 'PM_IVT', 'PM_access',
                           'Walk_IVT',
                           'DRT_cost', 'DRT_IVT', 'DRT_IVT_max', 'DRT_access', 'DRT_delay_min', 'DRT_delay_max')

df$Walk_access <- 0
df$DRT_IVT_max <- 5/df$DRT_IVT
df$PM_cost <- df$PM_cost/df$PM_IVT

df <- subset(df, select=-c(Bus_delay_min, Bus_delay_max, DRT_delay_min, DRT_delay_max))

long <- reshape(df,
                direction='long',
                v.names=c('access', 'IVT'),
                varying=list(c('Bus_access', 'PM_access', 'Walk_access', 'DRT_access'),
                             c('Bus_IVT', 'PM_IVT', 'Walk_IVT', 'DRT_IVT')
                             ),
                times=c('Bus', 'PM', 'Walk', 'DRT'))


long <- data.frame(long[, c(16, 1, 7, 13, 8, 2:6, 14, 15, 9:12)])

colnames(long)[c(1, 4)] <- c("Choice_ID", "mode")

long[which(long$mode!='DRT'), 'DRT_IVT_max'] <- 0
long[which(long$mode!='Bus'), 'Bus_cost'] <- 0
long[which(long$mode!='PM'), 'PM_cost'] <- 0
long[which(long$mode!='DRT'), 'DRT_cost'] <- 0

write_csv(long, file="SP_long_2.csv")
