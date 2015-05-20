
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(RColorBrewer)

shinyServer(function(input, output) {

  output$clusterPlot <- renderPlot({
    dataset <- switch(input$dataset,
                      "Iris" = iris,
                      "Seatbelts" = Seatbelts,
                      "Titanic" = data.frame(Titanic)[,c(1,2,3,5,4)],
                      "UCB Admissions" = data.frame(UCBAdmissions)[,c(2,3,4,1)])
      
    distFunc <- input$distFunc
    clustFunc <- input$clustFunc
    pca <- input$usePCA
    showLabels <- input$useLastAttrAsLabel
    heatmapPalette <- colorRampPalette(brewer.pal(9, "OrRd"))
    
    uniqueResNames <- unique(dataset[,ncol(dataset)])
    uniqueResNames <- uniqueResNames[order(uniqueResNames)]
    sampleResNamesPalette <- colorRampPalette(brewer.pal(min(9, length(uniqueResNames)), "Set1"))
    colors <- sampleResNamesPalette(length(uniqueResNames))
    topRowColors <- as.character(dataset[,ncol(dataset)])
    
    for (i in 1:nrow(dataset)) {
        topRowColors[i] <- colors[which(uniqueResNames == topRowColors[i])]
    }
    
    dataMatrix <- data.matrix(dataset[,-ncol(dataset)])
    dataMatrix[is.na(dataMatrix)] <- 0
    
    if(pca == TRUE){
        pc <- prcomp(dataMatrix, scale=TRUE)
        
        components <- pc[[1]]^2
        numOfComponents <- 0
        
        repeat{
            numOfComponents <- numOfComponents + 1
            varianceExplained <- sum(components[1:numOfComponents])/sum(components)
            
            if(varianceExplained >= (input$minVarianceExplained)/100.0){
                break;
            }
        }
        dataMatrix <- pc$x[,1:numOfComponents]
    } else {
        dataMatrix <- scale(dataMatrix)
    }
    
    dist.fun <- function(x) dist(x, method=distFunc)
    hclust.fun <- function(x) hclust(x, method=clustFunc)

    result = tryCatch({
        heatmap(dataMatrix, RowSideColors = topRowColors, col=heatmapPalette(1000), hclustfun=hclust.fun, distfun=dist.fun)
        if (showLabels == TRUE) {
            par(lend = 1) 
            legend("topright",
                   legend = uniqueResNames,
                   col = colors,
                   lty= 1,
                   lwd = 10)
        }
    },
    error=function(cond) {
        signalCondition(simpleError("Not enough variance - try adding more variance to view plot. Using too little variance results in less than 2 principal components. With less than 2 components there are no attributes to cluster."))
    })
    result
    
  })

})
