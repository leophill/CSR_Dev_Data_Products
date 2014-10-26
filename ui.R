###############################################
# Define user interface elements and logic    #
###############################################

# Required library

library(ggvis)

# Main function

shinyUI(fluidPage(
        
        fluidRow(
                p(),
                img(src = "shiny_apps_lhi.png", align="left", valign="center",height = 50, width = 238),
                h1("Oracle Database Performance Metrics", align="center", valign="center", style = "color:darkblue"),
                hr()
        ),
        fluidRow(
                column(2,
                       selectInput('dbname', 'Database Name', c_db_name),
                       selectInput('metric', 'Metric Class', c_metric_type),
                       selectInput('frequency', 'Stats Frequency', c("Daily", "Monthly"), selected='Daily'),
                       dateInput('sdate', 'Start Interval', value = as.Date(first_date_range, "%d/%m/%Y"), min = as.Date(first_date_range, "%d/%m/%Y"), max = as.Date(last_date_range, "%d/%m/%Y"), format = "dd/mm/yyyy", startview = "month", weekstart = 0, language = "en"),
                       dateInput('edate', 'End Interval', value = as.Date(last_date_range, "%d/%m/%Y"), min = as.Date(first_date_range, "%d/%m/%Y"), max = as.Date(last_date_range, "%d/%m/%Y"), format = "dd/mm/yyyy", startview = "month", weekstart = 0, language = "en")
                ),
                column(10, ggvisOutput("mplot")
                )
        )
))
