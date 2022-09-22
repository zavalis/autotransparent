library(ggplot2)
library(reshape2)
years=c(2017,2018,2019,2020,2021)
karolinska=c(8547,7921,9326,10362,10595)
lund=c(4692,6263,4778,5238,5414)
orebro=c(855,905,991,1136,1227)
umea=c(2288,2023,2212,2371,2487)
uppsala=c(5103,5110,5300,5711,5920)
linkoping=c(1819,1872,2080,2194,2188)
gbg=c(4729,5010,5320,5793,5969)

df=data.frame(Publication_Year=years,karolinska=karolinska,lund=lund,orebro=orebro,umea=umea,uppsala=uppsala,linkoping=linkoping,gbg=gbg)

df_melt=melt(df,id='Publication_Year')

colnames(df_melt)[2] <- 'Institution'

ggplot(df_melt, aes(Publication_Year, value, color = Institution)) +geom_line()+xlab('Publication Year')+ylab('No. of Publications')+theme_bw()
