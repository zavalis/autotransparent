.libPaths('./lib')
library(rcrossref, lib.loc='./lib')
library(rtransparent,lib.loc='./lib')
library(oddpub,lib.loc='./lib')
library(metareadr,lib.loc='./lib')
library(stringr, lib.loc='./lib')
library(plyr, lib.loc='./lib')
library(crminer)
library(beepr, lib.loc='./lib')
library(readr)
library(tidyverse)

old_path <- Sys.getenv("PATH")
Sys.setenv(PATH = paste(old_path, "/opt/homebrew/bin", sep = ":"))

# Extract txt from pdf
setwd("~/Desktop/test cardio")

filepath='./publications/'
getfilelist=function(loc,filetype){
  filelist <- as.list(list.files(loc, pattern=paste0('*.',filetype), all.files=FALSE, full.names=FALSE))
  return(filelist=paste0(loc, filelist))
}

# går det att parallelisera for loops?
read_pdf=function(filelist){for (i in filelist) {
  i=paste0('./publications/',i)
  article=rt_read_pdf(i) 
  write(article, paste0(str_replace(i, '.pdf','.txt')))}}


filelistpdf=getfilelist(filepath,'pdf')
mclapply(filelist,read_pdf)
filelistpdf=getfilelist(filepath,'txt')

# CODE AND DATA TRANSPARENCY
code_df=foreach::foreach(x = filelist,.combine='rbind.fill') %dopar%{
  ## Use the same library paths as the master R session
  .libPaths(libs[1])
  rtransparent::rt_data_code(x)
}
# WRITE FILE
write.csv(code_df,paste0("./output/codesharing_",loc,".csv"), row.names = FALSE); beep()


# COI & FUNDING DISCLOSURES AS WELL AS REGISTRATIONS
resr_df=foreach::foreach(x = filelist,.combine='rbind.fill')%dopar%{
  ## Use the same library paths as the master R session
  .libPaths(libs[1])
  rtransparent::rt_all(x)}
# WRITE FILE
write.csv(resr_df,paste0("./output/resttransp_",loc,".csv"), row.names = FALSE); beep()


beep()

filelisttxt= list.files('./publications', pattern='*.txt', all.files=FALSE, full.names=FALSE)
count=1
for (i in filelisttxt){
  i=paste0('./publications/',i)
  count=count+1
  #article <- rt_all(i)
  article <- rt_data_code(i)
  if (!exists("articles.data")) {
    articles.data <- article
  }



