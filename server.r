shinyServer(
  function(input, output) {
    streamFlow <- read.csv("05594000discharge.csv", skip=13142, header=FALSE, sep="\t")
    #remove any provisional data
    streamFlow <- subset(streamFlow, V5 == "A")
    #remove last column
    streamFlow <- streamFlow[,1:4]   
    #rename columns
    colnames(streamFlow) <- c("agency", "site", "date", "discharge")
    #Change class of "date" column
    streamFlow$date <- as.Date(streamFlow$date)
    
    output$nDays <- renderPrint({input$nDays})
    
    output$StreamGraph <- renderPlot({
      #Calculate moving average
      Phil <- rep(1/input$nDays, input$nDays)
      AvgDischarge <- filter(streamFlow$discharge, Phil, sides=1)
      streamFlow$average <- AvgDischarge
      
      if (input$datOn == TRUE){
      plot(streamFlow$date, streamFlow$discharge, type="l", col=grey(.5), ylab="Discharge (cubic feet per sec)", xlab="Year", ylim= c(0,input$ymax), xlim = c(input$xmin, input$xmax), xaxt="n")
      axis.Date(1, at = seq(input$xmin, input$xmax, 365))
      grid(col="blue")
      lines(streamFlow$date, AvgDischarge, col="red", lwd=2)
      }
      else {
        plot(streamFlow$date, AvgDischarge, type="l", col="red", lwd=2, ylab="Discharge (cubic feet per sec)", xlab="Year", ylim= c(0,input$ymax), xlim = c(input$xmin, input$xmax), xaxt="n")
        axis.Date(1, at = seq(input$xmin, input$xmax, 365))
        grid(col="blue")
      }
    })
    
    output$maxList <- renderPrint({
      #Calculate moving average
      Phil <- rep(1/input$nDays, input$nDays)
      AvgDischarge <- filter(streamFlow$discharge, Phil, sides=1)
      streamFlow$average <- AvgDischarge
      selectedData <- subset(streamFlow, date > input$xmin)
      selectedData <- subset(selectedData, date < input$xmax)
      selectedData <- selectedData[order(selectedData$discharge, decreasing=TRUE),]
      #Outputs the dates of the five largest discharges
      rownames(selectedData) <- NULL
      selectedData[1:10, 3:4]
    })

    output$minList <- renderPrint({
      #Calculate moving average
      Phil <- rep(1/input$nDays, input$nDays)
      AvgDischarge <- filter(streamFlow$discharge, Phil, sides=1)
      streamFlow$average <- AvgDischarge
      selectedData <- subset(streamFlow, date > input$xmin)
      selectedData <- subset(selectedData, date < input$xmax)
      selectedData <- selectedData[order(selectedData$discharge, decreasing=TRUE),]
      rownames(selectedData) <- NULL
      selectedData[(nrow(selectedData)-9):nrow(selectedData), 3:4]
    })
    
    
    output$IlMap <- renderPlot({
      library(maps)
      IL <- map('state', region='illinois', plot=FALSE)
      plot(IL, type='line', xaxt="n", yaxt="n", ann=FALSE)
      xLocal <- c(-89.49)
      yLocal <- c(38.61)
      points(xLocal, yLocal, col="blue", pch=16)
    }, width=175, height=285)
  
  }
  
)