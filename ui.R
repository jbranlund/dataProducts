library(shiny)
shinyUI(fluidPage(
  
    titlePanel("Using moving averages to find patterns in stream discharge"),
  
    sidebarPanel(
      p("The graph shows stream discharge (the average volume of 
        water flowing through a given area in a day) for Shoal Creek near Breese, Illinois. 
        Any patterns are hidden by the data's complexity, and a moving average can be 
        calculated to simplify the data (and hopefully clarify patterns). Use the input boxes below to 
        specify the number of days used in the moving average. You can also zoom into or out of the graph 
        by changing the axes limits."),
      numericInput('nDays', 'Number of days to include in moving average',value =10, min=5, max=1000),
      numericInput('ymax', 'Maximum y-value of the plot', value=8000, min=1, max=22200),
      dateInput('xmin', 'First year displayed in the plot', value=as.Date("1940-01-01")),
      dateInput('xmax', 'Last year displayed in the plot'),
      checkboxInput('datOn', 'Check here to show raw data in graph', value=TRUE)
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plot",
          p('Data is shown in grey (click the check box to hide or display). The red line shows the moving average calculated for the number of days:'),
          verbatimTextOutput("nDays"),
      
          plotOutput('StreamGraph'),
          
          p('Click the Summary or Data Sources tabs for more information.')
          ),
      
        
        tabPanel("Summary",
          h4('Moving averages'),
          p('For any given date, the moving average is the mean of the discharge from that date
            as well as the previous', em ('n'), 'days, where', em ('n'), 'is the number of days input. Because each value is an average
            of many days, the moving average acts to smooth the data. The calculation uses the', strong ('filter'), 'command in R.'),
          h4('About the plot'),
          p('The USGS (United States Geological Survey) continually measures the amount of water 
             flowing through a stream (discharge). Values of daily average discharge are tabulated and
             available online. The maximum and minimum values displayed in the graph are listed below. 
            Discharge is measured in cubic feet per second.'),
          
          p('The ten highest measured discharge values that are shown in the graph are:'),
          
          verbatimTextOutput('maxList'),
          
          p('The ten lowest measured discharge values that are shown in the graph are:'),
          
          verbatimTextOutput('minList')
        ),
        
        tabPanel("Data sources",
          p('Data for USGS Gage Station 05594000 (location shown on map below). This data, as well as data for other gage stations, is available from:', a (href='http://waterdata.usgs.gov/nwis', 'http://waterdata.usgs.gov/nwis')),
          
          plotOutput('IlMap')
          )
    )
    )
  ))