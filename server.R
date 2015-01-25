library(datasets)

shinyServer(
    function(input, output) {
        lmcar<-lm(mpg ~ wt + am, mtcars)
        output$oweight <- renderPrint({input$weight})
        output$oam <- renderPrint({input$am})
        output$orfac<-renderText({input$rfac})
        predMPG<-reactive({ predict(lmcar, 
                                    data.frame(wt=c(max(min(input$weight,6.0),1.0)),
                                               am=c(as.numeric(input$am=="manual"))
                                               )
                                    )
                            })
        indauto<- (mtcars$am == 0)
        indmanu<- (mtcars$am == 1)
        lmcarauto<-reactive({ lm(mpg ~ wt, mtcars[indauto,]) })
        lmcarmanu<-reactive({ lm(mpg ~ wt, mtcars[indmanu,]) })
        lmcarboth<-reactive({ lm(mpg ~ wt, mtcars) })
        output$prediction <- renderText({
            input$goButton
            isolate(predMPG())
        })
        output$predrange <- renderText({
            input$goButton
            isolate(c((1.0-input$rfac)*{predMPG()}, 
              (1.0+input$rfac)*{predMPG()}))
        })
        output$pointlineplot <- renderPlot({
            if(length(input$amcb) > 0) {
                swt <- mtcars$wt
                smpg <- mtcars$mpg
                lmplot<-lmcarboth()
                xstr<-'weight for both (lb/1000)'
                ystr<-'MPG (miles/gallon)'
                tstr<-input$figtitle
                if (length(input$amcb) == 1 ) {
                    if (input$amcb[1] == 'automatic') {
                        ind <- indauto
                        lmplot<-lmcarauto()
                        xstr<-'weight for automatic (lb/1000)'
                    } else {
                        ind<- indmanu 
                        lmplot<-lmcarmanu()
                        xstr<-'weight for manual (lb/1000)'
                    }
                    swt<-mtcars$wt[ind]
                    smpg<-mtcars$mpg[ind]   
                } 
                plot(swt, smpg, col="red", pch=19, xlab=xstr, ylab=ystr, main=tstr)
                intercept = lmplot$coeff[1]
                slope = lmplot$coeff[2]
                abline(c(intercept,slope),col="darkgrey",lwd=3)
            }
        })
    } 
)
