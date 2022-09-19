# LIBRARIES BELOW
{
if (!require("rstudioapi")) install.packages("rstudioapi")
library("rstudioapi") 
setwd(dirname(getActiveDocumentContext()$path))
.libPaths('./lib')
.libPaths('/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library')
#install.packages('rcrossref')
library(tokenizers)
install.packages('dplyr', version = "0.7.8", repos = "http://cran.us.r-project.org")
install.packages('reshape2')
library(rcrossref,lib.loc='./lib')
library(rtransparent,lib.loc='./lib')
library(rtransparent)
library(SparkR)
library(tidyverse)
install.packages('tidyverse')
library(oddpub)
library(oddpub,lib.loc='./lib')
library(metareadr,lib.loc='./lib')
library(stringr)
library(dplyr)
library(plyr)
library(plyr, lib.loc='./lib')
library(crminer)
#install.packages("beepr")
library(beepr, lib.loc='./lib')
library(beepr)
library(parallel)
library(lme4)
library(doParallel)
library(progressr)
library(doFuture)
library(foreach)
library(SparkR)
library(ggplot2)
library(reshape2)
library(stringr)

#install.packages('SparkR')

}

#defining the rootpath, and filelist
rootpath <- getwd()

downloads= function(loc){
  pmcidfilename=paste0("./pmcoalist_",loc,".csv")
  pmcidlist<-read.delim(pmcidfilename, header = TRUE, sep=',')
  pmcidlist=pmcidlist$PMCID
  pmcnumber<-list()
  for (i in pmcidlist){
    go=str_replace(i,'PMC','')
    pmcnumber=c(pmcnumber,go)
  }
  
  #pmcnumber=as.numeric(unlist(x))
  
  # bugged out ones for link;ping
  pmcnumber=pmcnumber[pmcnumber !=8598927]
  pmcnumber=pmcnumber[pmcnumber !=9189602]
  pmcnumber=pmcnumber[pmcnumber !=9077321]
  pmcnumber=pmcnumber[pmcnumber !=8627649]
  pmcnumber=pmcnumber[pmcnumber !=8577685]
  
  # bugged out ones for umea
  pmcnumber=pmcnumber[pmcnumber !=8611285]
  
  # bugged out ones for orebro
  pmcnumber=pmcnumber[pmcnumber !=8445574]
  pmcnumber=pmcnumber[pmcnumber !=8966968]
  pmcnumber=pmcnumber[pmcnumber !=9347643]
  
  # bugged out ones for uppsala
  pmcnumber=pmcnumber[pmcnumber !=9074899]
  pmcnumber=pmcnumber[pmcnumber !=8456286]

  
  
  
  
  filenames=paste0('./publications_',loc, '/PMC',as.character(pmcnumber),'.xml')
  
  mapply(metareadr::mt_read_pmcoa,pmcid=pmcnumber,file_name=filenames)
  
}

checkdiff= function(loc){
  filelist <- list.files(paste0('./publications_',loc,'/'), pattern='*.xml', all.files=FALSE, full.names=FALSE)
  pmcidfilename=paste0("./pmcoalist_",loc,".csv")
  pmcidlist<-read.delim(pmcidfilename, header = TRUE, sep=',')
  pmcidlist=pmcidlist$PMCID
  pmcnumber<-list()
  for (i in pmcidlist){
    go=str_replace(i,'PMC','')
    pmcnumber=c(pmcnumber,go)}
  downloaded=str_remove(filelist,'PMC')
  downloaded=str_remove(downloaded,'.xml')
  return(setdiff(pmcnumber, downloaded))
  
  }
  
downloadspmc=function(pmcnumber,loc){

  # bugs Uppsala
  pmcnumber=as.integer(pmcnumber)
  pmcnumber=pmcnumber[pmcnumber!=9074899]
  pmcnumber=pmcnumber[pmcnumber!=8456286]
  pmcnumber=pmcnumber[pmcnumber!=8456984]
  pmcnumber=pmcnumber[pmcnumber!=8966968]
  pmcnumber=pmcnumber[pmcnumber!=8484376]
  pmcnumber=pmcnumber[pmcnumber!=9050834]
  pmcnumber=pmcnumber[pmcnumber!=8627649]
  pmcnumber=pmcnumber[pmcnumber!=9306449]
  pmcnumber=pmcnumber[pmcnumber!=8577685]
  pmcnumber=pmcnumber[pmcnumber!=9027952]
  pmcnumber=pmcnumber[pmcnumber!=9372232]
  
  # buggar med gbg
  pmcnumber=pmcnumber[pmcnumber!=8445574]
  pmcnumber=pmcnumber[pmcnumber!=8693323]
  pmcnumber=pmcnumber[pmcnumber!=9067409]
  pmcnumber=pmcnumber[pmcnumber!=9061891]
  pmcnumber=pmcnumber[pmcnumber!=9168950]
  pmcnumber=pmcnumber[pmcnumber!=8791815]
  pmcnumber=pmcnumber[pmcnumber!=8626532]
  pmcnumber=pmcnumber[pmcnumber!=9396711]
  
  filenames=paste0('./publications_',loc, '/PMC',as.character(pmcnumber),'.xml')

  mapply(metareadr::mt_read_pmcoa,pmcid=pmcnumber,file_name=filenames)
}

gbg=checkdiff('gbg')
downloadspmc(gbg,'gbg')
mclapply('gbg',downloads)
beep()

# CONSIDER DOING THE TRY EXCEPT FUNCTION TO GET THE SAME RESULT AND 
# AVOID HAVING TO GO THROUGH IT ALL
tryDownloadsPMC=function(pmcnumber,loc){
  tryCatch(downloadspmc, 
           error=function(e) print(e))}
# fix this function so that it automatically skips the errors
tryDownloadsPMC(uppsala,'uppsala')


libs=.libPaths('./lib')
institutions=c('umea','link','uppsala','orebro','gbg')

dohooptyhoop=function(loc){
filepath=paste0('./publications_',loc,'/')
filelist <- as.list(list.files(filepath, pattern='*.xml', all.files=FALSE, full.names=FALSE))
                        
filelist=paste0(filepath, filelist)
#filelist=tail(filelist,10)                    
cores <- detectCores()
registerDoParallel(cores=cores)
                        
return(foreach::foreach(x = filelist,.combine='rbind.fill') %dopar%{
## Use the same library paths as the master R session
#.libPaths(libs[1])
rtransparent::rt_data_code_pmc(x)
})}
dohooptyhooprest=function(loc){
  filepath=paste0('./publications_',loc,'/')
  filelist <- as.list(list.files(filepath, pattern='*.xml', all.files=FALSE, full.names=FALSE))
  
  filelist=paste0(filepath, filelist)
  #filelist=tail(filelist,10)                    
  cores <- detectCores()
  registerDoParallel(cores=cores)
  
  return(foreach::foreach(x = filelist,.combine='rbind.fill') %dopar%{
    ## Use the same library paths as the master R session
    #.libPaths(libs[1])
    rtransparent::rt_all_pmc(x)
  })}
rbind.fill()
# code and data transparency
for (i in institutions){
  loc=i
  code_df=dohooptyhoop(loc) 
  write.csv(code_df,paste0("./output/codesharing_",loc,".csv"), row.names = FALSE); beep()
};beep();beep();beep()   

# resttransparency
for (i in institutions){
  loc=i
  rest_df=dohooptyhooprest(loc) 
  write.csv(rest_df,paste0("./output/resttransp_",loc,".csv"), row.names = FALSE); beep()
};beep();beep();beep()  




# general transparency
df=read.delim('./general_transparency.csv', header = TRUE, sep=',')
df_melt=melt(df,'Publication.Year')
colnames(df_melt) <- c('Publication.Year','Transparency.indicator','value')
df_melt

ggplot(df_melt,aes(x=Publication.Year, y=value))+geom_line(aes(color=Transparency.indicator))+xlab('Publication Year')+ylab('Transparency indicator (%)')+ylim(70,100)+theme_bw()


# get the sum of publication for each year
df=read.delim('./pubs_year.csv', header = TRUE, sep=',')
df=df%>%filter(Publication.Year!=2022)
ggplot(df,aes(x=Publication.Year, y=Institution.1))+geom_line(aes( color=Institution))+xlab('Publication Year')+ylab('Number of publications')+theme_bw()


# CHECK OUT HOW TO AFFECT THIS
plotpyear_institution=function(df,indicator,rangelow,rangehigh){
  p=ggplot(df, aes(x=Publication.Year, y=.data[[indicator]], fill=Institution)) +
    geom_line(aes(color=Institution)) + 
    geom_point(aes(color = Institution)) + 
    theme_bw()+ylim(rangelow, rangehigh)
    
    if (grepl('data',indicator))
    {return(p+labs(title='Data sharing over time for the Swedish institutions')+
              
              xlab('Year')+ylab('Data sharing (%)'))}
  if (grepl('code',indicator))
  {return(p+labs(title='Code sharing over time for the Swedish institutions')+
            xlab('Year')+ylab('Code sharing (%)'))}
  
  if (grepl('coi',indicator)==TRUE){return(p+labs(title='Conflict of interest statements over time for the Swedish institutions')+
                                             xlab('Year')+ylab('COI statement (%)'))}
  if (grepl('fund',indicator)){return(p+labs(title='Funding statements over time for the Swedish institutions')+
                                        xlab('Year')+ylab('Funding statement (%)'))}
  if (grepl('register',indicator)){return(p+labs(title='Registrations over time for the Swedish institutions')+
                                            xlab('Year')+ylab('Registrations (%)'))}
}
# går att ställa in gränserna för x

install.packages('vctrs')

# get each indicator development for the institutions
df=read.delim('./transparency_grouped_by_institution.csv', header = TRUE, sep=',')
plotpyear_institution(df,'is_open_data',0,40)




# Get the trends over the years...

x<-c(1,2,3,2,1,3,4,2,5,2,6,5,5)
y<-c(5,5,6,2,1,4,4,2,1,2,1,5,5)
cor.test(df$Publication.Year,df$is_open_code, method="kendall")
cor.test(df$Publication.Year,df$is_open_data, method="kendall")
cor.test(df$Publication.Year,df$is_coi_pred, method="kendall")
cor.test(df$Publication.Year,df$is_register_pred, method="kendall", exact=FALSE)
cor.test(df$Publication.Year,df$is_fund_pred, method="kendall", exact=FALSE)


res



rt_all('./publications_pdf/Two-multistate-outbreaks-of-a-reoccurring-Shiga-toxinproducing-Escherichia-coli-strain-associated-with-romaine-lettuce-USA-20182019_2022_Cambridge-University-Press.txt')
