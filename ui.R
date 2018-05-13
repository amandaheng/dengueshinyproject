library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(leaflet)
library(dplyr)
library(DT)
library(rpivotTable)  #must install the package first
library(readxl)
################################################################################
#                             Shiny Dashboard                                  #
################################################################################

###Amanda- shinydashboard
shinyUI(
  fluidPage(dashboardPage(
  dashboardHeader(title = "Malaysia Dengue Outbreak Analyzer & Healthcare Locator", titleWidth = 800),
  dashboardSidebar(
     width = 180,
    sidebarMenu(id="tabs",
                menuItem("Interactive Map", tabName="i_map", icon=icon("globe"), selected=TRUE),
                menuItem("Data Explorer", tabName = "d_explorer", icon=icon("file-excel-o")),
                menuItem("Outbreak Analysis", tabName = "o_analysis", icon=icon("bar-chart")),
                #Trend visualisation tab - addition by Aishah 29 Apr 2018
                menuItem("Trend Visualisation", tabName = "v_trend", icon=icon("area-chart")),
                menuItem("Scatterplot", tabName = "l_graph", icon=icon("line-chart")),
                menuItem("Documentation", tabName = "about", icon=icon("book")),
                menuItem("Source code", icon = icon("file-code-o"), href = "https://github.com/amandaheng/dengueshinyproject"))
  ),
  
  dashboardBody(
    tags$head(
      
###Amanda- styling
      includeCSS("www/custom.css")
    ),
    
    
    tabItems(
### Amanda- First tab content
      tabItem(tabName = "i_map",
              div(class="outer",
                  leafletOutput("mymap", width="100%", height="100%"),
                  
                  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,top = 60, left = "auto", right = "18", bottom = "auto",
                                width = 240, height = "auto", draggable = FALSE,
                                
                                  pickerInput(
                                  inputId = "state", 
                                  label = "Select State(s):", 
                                  selected = options$states,
                                  choices = options$states, 
                                  options = list(
                                    `actions-box` = TRUE,
                                    `selected-text-format` = "count > 1"
                                  ), 
                                  multiple = TRUE
                                ),
                                
                                selectInput("fyear", "From Year:",
                                            2010:2015, selected = 2010),
                                selectInput("fweek", "From Week:",
                                            1:53, selected = 1),
                                selectInput("tyear", "To Year:",
                                            2010:2015, selected = 2015),
                                selectInput("tweek", "To Week:",
                                            1:53, selected = 53),
                                h5("Show:"),
                                checkboxInput("scgov", "Clinic Government", FALSE),
                                checkboxInput("scdesa", "Clinic Desa", FALSE),
                                checkboxInput("sc1m", "Clinic 1M", FALSE),
                                checkboxInput("shos", "Hospital", FALSE),
                                checkboxInput("cluster", "Cluster", FALSE)
                  )
              )
      ),
      
### Amanda- Second tab content
      tabItem(tabName = "d_explorer",
              fluidPage(
                
                titlePanel("Data Explorer"),
                sidebarLayout(
                  conditionalPanel(
                    condition = NULL,
                    sidebarPanel(
                      width = 3,
                      helpText("Please choose the year to see list of dengue data"),
                      selectInput("newdatayear", label = "Select year", choices = 2010:2015)
                    )),
                  mainPanel(dataTableOutput("newtbl"))
                )
              )
      ),
      
###Amanda-  third tab content
      tabItem(tabName = "o_analysis",
              fluidPage(
                
                titlePanel("Dengue Outbreak Analysis"),
                sidebarLayout(
                  
                  conditionalPanel(
                    condition = NULL,
                    sidebarPanel(
                      width=5,
                      selectInput("grafA", label = "Select", choices = c("By Year", "By State", "By Year & State")),
                      conditionalPanel(condition = "input.grafA == 'By Year & State'",
                                       selectInput("fstate", "Select State", stateslist, multiple=TRUE, selected = 'Selangor')
                      )
                      
                    )
                    
                  ),
                  mainPanel(plotOutput("data_plot"),width=12)
                )
              )
      ),
    
### 5th tab content - addition by Aishah 29 Apr 2018
tabItem(tabName = "v_trend",
        fluidPage(
          titlePanel('Trend Visualisation'),
          mainPanel(rpivotTableOutput("trendpivot", width="100%", height="100%"))
        )
),


###Vivian start###    
### Line Graph tab content
tabItem(tabName = "l_graph",
        fluidPage(
          
          titlePanel("Scatterplot - Dengue vs Healthcare"),
          sidebarLayout(
            
            conditionalPanel(
              condition = NULL,
              sidebarPanel(
                width=5,
                selectInput("LineState", "Select State", stateslist, multiple=TRUE, selected = 'Selangor')
              )
              
            ),
            mainPanel(plotOutput("dengue_plot"),width=12)
          )
        )
),

### about tab content
tabItem(tabName = "about",
        fluidPage(
          HTML("
               <h1>Documentation</h1>
                <p>Welcome to the documentation section of this application. You are strongly advised to go through this documentation prior using the application. We will explain the functionality and purpose of every tabs in this application. Let's get started!</p>
                <br/>
                <div style='background-color:white; padding: 5px 10px; border-radius: 5px; margin-bottom: 50px;'>
                  <h4><i class=' fa fa-globe fa-fw'></i><b>Interactive Map</b></h4>
                  <p>We have designed this tab to support visualization on Malaysia dengue hotspot area and healthcare location on an interactive map. You are provided with filters such as States, Year, Week and Healthcare Institution to play with the interactive map.</p>
                  <br/>
                  <h4><i class=' fa fa-file-excel-o fa-fw'></i><b>Outbreak Analysis</b></h4>
                  <p>We have aggregated Malaysia dengue cases in bar chart and prepared filters such as Year and State for users to visualize the data.</p>
                     <br/>
                  <h4><i class=' fa fa-bar-chart-o fa-fw'></i><b>Data Explorer</b></h4>
                  <p>We have tabulated and aggregated Malaysia dengue cases from 2010 to 2015. You can view the processed data complemented with Year filter.</p>
                  <br/>
                  <h4><i class=' fa fa-area-chart fa-fw'></i><b>Trend Visualization</b></h4>
                  <p>We built a trend visualisation that contains total dengue cases reported by each state between 2010-2015. It uses the Pivot Table and Pivot Chart that enable custom visualisation and filtration desired by users.</p>
                  <br/>
                  <h4><i class=' fa fa-line-chart fa-fw'></i><b>Scatterplot</b></h3>
                  <p>We have plotted the dengue cases and number of healthcare across Malaysia states for you to visualize the supply and demand of this problem. You will able to see the which state needs more hospitals and clinics.</p>
                  <br/>
                  <h4><i class=' fa fa-file-code-o fa-fw'></i><b>Source Code</b></h4>
                  <p>Feel free to check on our application source code through this tab.</p>
                  <br/>
                </div>
               ")
                
                
              
                
                
              )
      )
      
    )
    
  )
)
)
)
###/Vivian end###


