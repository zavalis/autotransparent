# TABLE CREATION IN CSV
library(dplyr)

code_df=read.delim('./code.csv', sep=',')
rest_df=read.delim('./rest.csv', sep=',')
combined=merge(x = code_df, y = rest_df, by = "pmid", all = TRUE)

search=read.delim('./bib_pmc.csv', sep=',')
search_combined=merge(x = search, y = combined, by = "pmid", all = TRUE)

colnames(search_combined)

select_combined=search_combined %>%
  select(c(1,2,13,14,25,26,27,28,29,43,42,68,67,114,113))

write.csv(select_combined, 'transparency.csv')

# read df
df=select_combined

# TABLE 1
# to get the sum of journals' publications
table(df$is_open_code)


# antar att NAs är false
df$is_open_code[is.na(df$is_open_code)]=FALSE
df$is_open_data[is.na(df$is_open_data)]=FALSE

## overall transparency
write.csv(df  %>% 
  summarise_at(c("is_open_code", "is_open_data","is_register_pred", "is_coi_pred","is_fund_pred"), ~paste0(sum(.x), '/ 415 (', round(sum(.x) * 100 / n()), ')')),'./table_transp_overall.csv')


### by year
write.csv(df %>% group_by(publication_year) %>% 
  summarise_at(c("is_open_code", "is_open_data","is_register_pred", "is_coi_pred","is_fund_pred"), ~paste0(sum(.x), '(', round(sum(.x) * 100 / n()), ')')),'./table_transp_year.csv') # change the nas.

### by last author affiliation
write.csv(df %>% group_by(last_author) %>% 
            summarise_at(c("is_open_code", "is_open_data","is_register_pred", "is_coi_pred","is_fund_pred"), ~paste0(sum(.x), '(', round(sum(.x) * 100 / n()), ')')),'./transp_last_au.csv') # change the nas.

write.csv(table(df$publication_year), 'year.csv')
write.csv(table(df$last_author), 'last_au.csv')



df2=read.csv('cns.csv')

df2$is_open_code[is.na(df2$is_open_code)]=FALSE
df2$is_open_data[is.na(df2$is_open_data)]=FALSE

df2[df2=='True']=TRUE
df2[df2=='False']=FALSE
df2[df2=='TRUE']=TRUE
df2[df2=='FALSE']=FALSE
df2$is_coi_pred=as.logical(df2$is_coi_pred)
df2$is_fund_pred=as.logical(df2$is_fund_pred)
df2$is_register_pred=as.logical(df2$is_register_pred)
df2$is_open_code=as.logical(df2$is_open_code)
df2$is_open_data=as.logical(df2$is_open_data)


divpsylist=as.list(search$pmid)
df2=(df2%>%filter(!pmid %in% divpsylist))

summary(df2)
write.csv(df2  %>% 
            summarise_at(c("is_open_code", "is_open_data","is_register_pred", "is_coi_pred","is_fund_pred"), ~paste0(sum(.x), '/ 1195 (', round(sum(.x) * 100 / n()), ')')),'./table_transp_overall_cns.csv')

write.csv(df2 %>% group_by(Publication.Year) %>% 
            summarise_at(c("is_open_code", "is_open_data","is_register_pred", "is_coi_pred","is_fund_pred"), ~paste0(sum(.x), '(', round(sum(.x) * 100 / n()), ')')),'./table_transp_year_cns.csv') # change the nas.

write.csv(table(df2$Publication.Year),'publication_year_cns.csv')


# TABLE 1
# to get the sum of journals' publications
table(df$is_open_code)


# antar att NAs är false
df$is_open_code[is.na(df$is_open_code)]=FALSE
df$is_open_data[is.na(df$is_open_data)]=FALSE

  