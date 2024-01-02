setwd("C:/Users/신지윤/Desktop/3학년 2학기/도모빌/term project/DataAnalysis")

library(mlogit)

df <- read.csv("SP_long_2.csv", header=TRUE)

# 더미변수 생성
df[which(df$gender==2), "gender"] <- 0 #1: 여성, 2: 남성
df[which(df$undergrad==2), "undergrad"] <- 0 #1: 학부생, 2: 대학원생
df[which(df$PM_exp==2), "PM_exp"] <- 0 #1: 있다, 2: 없다
df[which(df$r_type!=1), "r_type"] <- 0 #1: 본가에서 통학, 신촌동과 연희동 외 지역에서 자취 2: 신촌동 또는 연희동에서 자취 3: 교내 기숙사 거주주

# mode_num column 생성
df$mode_num <- 1
df <- within(df, {
  mode_num[mode=="PM"] <- 2
  mode_num[mode=="Walk"] <- 3
  mode_num[mode=="DRT"] <- 4
})

# choice column 생성
df$Choice <- "no"
df <- within(df, {
  Choice[choice==mode_num] <- "yes"
})

# 필요한 데이터만 추출
df <- df[, c(1:4, 6:16, 18)]

df <- df[!duplicated(df), ]
na_count <- sum(is.na(df))
print(na_count)

df <- df[order(df$Choice_ID),]

# mlogit.data 형태로 변환하기
mydata <- mlogit.data(df,
                      shape='long',
                      choice='Choice',
                      alt.var='mode')
mydata

# multinomial logit model specification
mymodel <- mlogit(Choice~access+DRT_IVT_max+DRT_cost+PM_cost+Bus_cost|gender+age+undergrad+r_type+PM_exp|IVT,
                  reflevel="DRT",
                  constPar=c("Bus_cost"),
                  data=mydata)
mymodel

summary(mymodel)


AIC(mymodel)