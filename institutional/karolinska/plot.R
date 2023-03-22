library(ggplot2)
library(reshape2)

# CHECK OUT HOW TO AFFECT THIS
plotpyear_institution=function(df,indicator,rangelow,rangehigh){
  p=ggplot(df, aes(x=Publication.Year, y=.data[[indicator]], fill= Group)) +
    geom_line(aes(color= Group)) + 
      geom_line(data=df[df$Group=="CNS",], aes(colour=Group), size = 1, alpha = .9) +

    geom_point(aes(color = Group)) + 
    theme_bw()+ylim(rangelow, rangehigh)
    
    if (grepl('data',indicator))
    {return(p+labs(title='Data sharing over time for the Karolinska departments')+
              
              xlab('Year')+ylab('Data sharing (%)'))}
  if (grepl('code',indicator))
  {return(p+labs(title='Code sharing over time for the Karolinska departments')+
            xlab('Year')+ylab('Code sharing (%)'))}
  
  if (grepl('coi',indicator)==TRUE){return(p+labs(title='Conflict of interest statements over time for the Karolinska departments')+
                                             xlab('Year')+ylab('COI statement (%)'))}
  if (grepl('fund',indicator)){return(p+labs(title='Funding statements over time for the Karolinska departments')+
                                        xlab('Year')+ylab('Funding statement (%)'))}
  if (grepl('register',indicator)){return(p+labs(title='Registrations over time for the Karolinska departments')+
                                            xlab('Year')+ylab('Registrations (%)'))}
}
# går att ställa in gränserna för x


# get each indicator development for the institutions
df=read.delim('./cns_pres_data.csv', header = TRUE, sep=',')

plotpyear_institution(df,'is_open_data',0,40)

df=read.delim('./publications_cns_pres.csv', header = TRUE, sep=',')

ggplot(df, aes(x=Publication.Year, y=Count, fill= Group)) +
    geom_line(aes(color= Group))+theme_bw()