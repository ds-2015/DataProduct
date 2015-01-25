library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Car MPG Prediction"), 
    sidebarPanel(
        h3('Inputs for Prediction'),
        p("Input car weight and transmission for prediction. Set Prediction Range Factor (f), 
so the prediction range is [(1.0-f)*predictvalue, (1.0+f)*predictvalue]. 
Click the Go! button to update the prediction."),
        numericInput('weight', "Car Weight (lb/1000), recommended range: [1,6]", 3.0, min=1.0, max=6.0, step=0.01),
        radioButtons('am', 'Car Transmission', c("automatic", "manual")),
        sliderInput("rfac", 'Prediction Range Factor (f)', ticks=FALSE,
                    value=0.25, min=0, max = 0.5, step = 0.01),
        actionButton("goButton", "Go!"),
        h3('Inputs for Data Plot'),
        p("Choose which observations are plotted. If 'automatic' is checked, 
the observations with automatic transmission are plotted; if 'manual' is checked, 
the observations with manual transmission are plotted. If both are checked, 
all the observations are plotted. If none is checked, there is no plot. Set plot title."), 
        checkboxGroupInput("amcb", 'Data with Transmission', 
                           c("automatic", "manual"), 
                           selected=c("automatic", "manual")),
        textInput("figtitle", "Input Your Own Plot Title")
    ), 
    mainPanel(
        includeMarkdown("readme.Rmd"),
        h3('Results of Prediction'), 
        h4('You entered weight (lb/1000)'),
        verbatimTextOutput("oweight"), 
        h4(' with transmission: '), 
        verbatimTextOutput("oam"),  
        h4("Which resulted in a prediction of MPG (miles/gallon)"), 
        verbatimTextOutput("prediction"), 
        h4("Prediction range: "),
        verbatimTextOutput("predrange"), 
        h3('Data Plot'),
        plotOutput('pointlineplot')
    )
))
