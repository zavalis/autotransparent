# LIBRARIES BELOW
# in case it is needed
#install.packages('x')
#install.packages('x', version = "0.7.8", repos = "http://cran.us.r-project.org")

{
if (!require("rstudioapi")) install.packages("rstudioapi")
library("rstudioapi") 
setwd(dirname(getActiveDocumentContext()$path))
.libPaths('../../../lib')
library(rtransparent)
library(oddpub)
library(metareadr)
library(beepr)
library(parallel)
library(doParallel)
library(ggplot2)
library(reshape2)
library(stringr, lib.loc='/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library')

#install.packages('SparkR')

}

#defining the rootpath, and filelist
rootpath <- getwd()
pmcidlist

downloads= function(filename){
  pmcidfilename=paste0(filename,".csv")
  pmcidlist<-read.delim(pmcidfilename, header = TRUE, sep=',')
  pmcidlist=pmcidlist$PMCID
  pmcnumber<-list()
  for (i in pmcidlist){
    go=str_replace(i,'PMC','')
    pmcnumber=c(pmcnumber,go)
  }
  
  pmcnumber=sample (pmcnumber, size=5, replace =F)

  
  filenames=paste0('./publications/PMC',as.character(pmcnumber),'.xml')
  mapply(metareadr::mt_read_pmcoa,pmcid=pmcnumber,file_name=filenames)
  
}

pmcnumber
checkdiff= function(loc){
  filelist <- list.files(paste0('./',loc,'/'), pattern='*.xml', all.files=FALSE, full.names=FALSE)
  pmcidfilename=paste0("./",loc,".csv")
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
  
  filenames=paste0('./publications/PMC',as.character(pmcnumber),'.xml')

  mapply(metareadr::mt_read_pmcoa,pmcid=pmcnumber,file_name=filenames)
}

mclapply('search',downloads)
beep()

# CONSIDER DOING THE TRY EXCEPT FUNCTION TO GET THE SAME RESULT AND 
# AVOID HAVING TO GO THROUGH IT ALL
tryDownloadsPMC=function(pmcnumber,loc){
  tryCatch(downloadspmc, 
           error=function(e) print(e))}
# fix the above function so that it automatically skips and of course saves the errors

codendata=function(loc){
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


resttransparency=function(loc){
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
