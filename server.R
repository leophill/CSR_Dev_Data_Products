###############################################
# Define server logic required to draw graphs #
###############################################

# Required library

library(ggvis)

#Option to control the display of context errors

options(shiny.suppressMissingContextError=FALSE)

# Main function

shinyServer(
        function(input, output, session) {
                
                # Create a reactiveValues object
                vflag <- reactiveValues()
                
                # Initialoze status to false
                vflag$status <- FALSE
                
                # This observer updates the status of vflag when user selects frequency option
                obs <- observe({
                        if (input$frequency == 'Daily') vflag$status <- TRUE
                        else if (input$frequency == 'Monthly')
                                vflag$status <- FALSE
                        })    
                
                # When the client ends the session, suspend the observer.
                session$onSessionEnded(function() {
                        obs$suspend()
                })                
                
                # reactive function to draw an area or a bar chart according to user choice of statistics frequency
                dfstat <- reactive( {
                        if (vflag$status) {
                                filter(dailydata, DB_NAME == input$dbname & MTYPE == input$metric & MDATE >= as.Date(input$sdate, '%d/%m/%Y') & MDATE <= as.Date(input$edate, '%d/%m/%Y')) %>%
                                mutate (ID = 1:n()) %>%
                                        ggvis(x = ~MDATE, y = ~0, y2 = ~MVALUE) %>%
                                        scale_nominal("stroke", range = c("blue", "green", "yellow")) %>% 
                                        scale_nominal("fill", range = c("blue", "green", "yellow")) %>% 
                                        scale_nominal("fill.hover", range = c("lightblue", "lightgreen","white")) %>% 
                                        hide_legend("stroke") %>%
                                        add_legend("fill", title = "CAPACITY METRICS") %>%
                                        auto_group() %>%     
                                        layer_ribbons(opacity:=0.6, stroke = ~MNAME, fill = ~MNAME, fill.hover := "lightblue") %>%
                                        add_axis("x", title = "Event Date", orient = "bottom", title_offset = 50) %>%
                                        add_axis("y", title = "Metric Value", orient = "left", title_offset = 50) %>%
                                        set_options(width = 720, height = 340)
                        }
                        else {
                                filter(dailydata, DB_NAME == input$dbname & MTYPE == input$metric & MDATE >= as.Date(input$sdate, '%d/%m/%Y') & MDATE <= as.Date(input$edate, '%d/%m/%Y')) %>%
                                mutate (MDATE = as.Date(paste0("01/", format(MDATE, "%m/%Y")), "%d/%m/%Y")) %>% group_by(DB_NAME, MTYPE, MNAME, MLEVEL, MDATE) %>% 
                                summarise(MVALUE = median(MVALUE)) %>% mutate(MDATE = factor(MDATE, labels=format(MDATE, "%b-%Y"), ordered=T)) %>%
                                        ggvis(x = ~factor(MDATE), y = ~MVALUE) %>%
                                        scale_nominal("stroke", range = c("blue", "green", "yellow")) %>% 
                                        scale_nominal("fill", range = c("blue", "green","yellow")) %>% 
                                        scale_nominal("fill.hover", range = c("lightblue", "lightgreen","white")) %>% 
                                        hide_legend("stroke") %>%
                                        add_legend("fill", title = "CAPACITY METRICS") %>%  
                                        layer_bars(stroke = ~MLEVEL, fill = ~MNAME, fill.hover := "lightblue") %>%
                                        add_axis("x", title = "Event Date", orient = "bottom", title_offset = 50) %>%
                                        add_axis("y", title = "Metric Value", orient = "left", title_offset = 50) %>%
                                        set_options(width = 720, height = 340)     
                        }
                })
                
                
                dfstat %>% bind_shiny("mplot") 
                
})