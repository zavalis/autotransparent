library(shiny)
library( shinyWidgets )
library(ggplot2)

df=read.delim('./raw.csv', sep=',')
df=read.delim('./groups_and_institutions.csv', sep=',')

#ggplot(df) + 
#  stat_summary(aes(x = class, y = cyl), 
#               fun.y = function(x) length(x) / length(unique(x)), 
#               geom = "bar")

  ui = basicPage(
    selectInput("select", "Select columns to display",c( 'is_coi_pred','is_register_pred','is_fund_pred','is_open_code','is_open_data'), multiple = FALSE),
    selectInput("institutioner", "Select institutions/groups to display",as.list(unique(df$short_name)), multiple = TRUE),
   # numericInput("rangelow", "What minimum percentage would you like", 0, min = 1, max = 100),
	#	numericInput("rangehigh", "What maximum percentage would you like", 100, min = 1, max = 100),
	downloadButton('foo'),


    h2('The Karolinska Data'),
    plotOutput('PLOT')
    
  )
  
server = function(input, output, session) {

 plotInput <- reactive({
    columns = names(df)
     
      if (!is.null(input$select)) {
        columns = input$select
      }
      rangelow=as.character(input$rangelow)
      rangehigh=as.character(input$rangehigh)
     df=df[df$short_name %in% input$institutioner, ]
     indicator_string=as.character(input$select)
  p=ggplot(df, aes(x=Publication.Year, y=.data[[input$select]], fill= short_name)) +
    geom_line(aes(color= short_name)) + 
    geom_point(aes(color = short_name)) + 
    xlab('Publication Year')+
    theme_bw()#+ylim(0, rangehigh)
    
    if (grepl('data',indicator_string))
  {return(p+labs(title='Data sharing over time for the Karolinska departments')+
            xlab('Year')+ylab('Code sharing (%)'))}
    
    if (grepl('code',indicator_string))
  {return(p+labs(title='Code sharing over time for the Karolinska departments')+
            xlab('Year')+ylab('Code sharing (%)'))}
  
  if (grepl('coi', indicator_string)==TRUE){return(p+labs(title='Conflict of interest statements over time for the Karolinska departments') + xlab('Year')
                                             +ylab('COI statement (%)'))}
  if (grepl('fund', indicator_string)){return(p+labs(title='Funding statements over time for the Karolinska departments')+xlab('Year')
                                        +ylab('Funding statement (%)'))}
  if (grepl('register', indicator_string)){return(p+labs(title='Registrations over time for the Karolinska departments')+
                                            xlab('Year')+ylab('Registrations (%)'))}
  })


    output$PLOT = renderPlot({
      
    print(plotInput())

    })
  output$foo = downloadHandler(
    filename = function() { paste0(input$select, '.png') },
    content = function(file) {
        
        ggsave(file,plot = plotInput(), device = "png",width = 10,  height = 7

        
        )
    }
)


    
  }


  
  
shinyApp(ui=ui, server = server)

runApp()


# test showing a table as well if possible
# create a DF that has the overall groupings AND the separate institutions