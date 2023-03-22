 library(shiny)

library( shinyWidgets )

library(ggplot2)

df=read.delim('./groups_and_institutions.csv', sep=',')
basicPage(
    selectInput("select", "Select columns to display",c( 'is_coi_pred','is_register_pred','is_fund_pred','is_open_code','is_open_data'), multiple = FALSE),
    selectInput("institutioner", "Select institutions/groups to display",as.list(unique(df$short_name)), multiple = TRUE),
   # numericInput("rangelow", "What minimum percentage would you like", 0, min = 1, max = 100),
	#	numericInput("rangehigh", "What maximum percentage would you like", 100, min = 1, max = 100),
	downloadButton('foo'),


    h2('The Karolinska Data'),
    h4('The PubMed Central Open Access publications from all publications found using the search query karolinska[affiliation] was assessed algorithmically regarding transparency for presence of Conflict of Interest disclosures, Funding disclosures, Registration (of protocols), Code Sharing, and Data Sharing respectively')
    plotOutput('PLOT')
    
  )