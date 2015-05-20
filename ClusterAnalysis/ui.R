library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Cluster analysis with PCA option"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        selectInput("dataset", "Dataset", c("Iris", "Titanic", "Seatbelts", "UCB Admissions")),
        selectInput("distFunc", "Distance function", c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski")),
        selectInput("clustFunc", "Agglomeration method", c("average", "ward.D", "ward.D2", "single", "complete", "mcquitty", "median", "centroid")),
        checkboxInput("usePCA", "Use PCA before clustering", TRUE),
        checkboxInput("useLastAttrAsLabel", "Show class label legend", TRUE),
        sliderInput("minVarianceExplained",
                  "Minumum variance explained (%):",
                  min = 0,
                  max = 100,
                  value = 97)
    ),

    # Plot
    mainPanel(
        h3("Howto"),
        p("This simple application helps you visualize the effect of using 
          different distance functions, agglomeration methods, and principal 
          component analysis on hierarchical clustering. The application will
          calculate the appropriate number of principle components, perform
          hierarchical clustering, and output a heatmap to this page."),
        p("All you have to do is:"),
        strong("Choose a dataset"),("from a given list on the left"),
        br(),
        strong("Choose a distance function"),(", which will be used to perform clustering"),
        br(),
        strong("Choose an agglomeration function"),(", which will be used to merge clusters"),
        br(),
        ("Define whether to"),strong("use PCA"),(" or not"),
        br(),
        strong("Adjust"), (" display options"),
        br(),
        ("When using PCA,"), strong(" define how much variance should be explained"),
        br(), br(),
        p("Happy exploring!"),
        h3("Result"),
        plotOutput("clusterPlot")
    )
  )
))
