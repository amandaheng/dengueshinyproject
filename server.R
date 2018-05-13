library(ggplot2)

################################################################################
#                             Shiny Server                                     #
################################################################################

shinyServer(function(input, output, session) { 
  output$mymap <-  renderLeaflet({
  fyear = as.integer(input$fyear)
  tyear = as.integer(input$tyear)
  fweek = as.integer(input$fweek)
  tweek = as.integer(input$tweek)
  
  fdata <- list()
  if(length(input$state) > 0){
    
###Amanda - filter all data within the chosen states
    fdata = subset(dengue2010_2015, state %in% input$state)


###Amanda - filter all data within the range of from year from week -> to year to week
    fdata <- fdata %>% 
      filter(
        (fyear != tyear & ((year == fyear & week >= fweek) | (year == tyear & week <= tweek) | (year > fyear & year < tyear)))
      | (fyear == tyear & year == fyear & week >= fweek & week <= tweek) 
        )
    fdata
    
###Amanda - group by area to find total dengue cases in each area
    fdata <- fdata %>% group_by(area) %>% summarise(
      totalcases = sum(total_cases)
    )
    
###Amanda - join with longtiude and latitude dataset with area as primary key
    fdata <- merge(x = fdata, y = longitudelatitude, by = "area", all.x = TRUE)
    
###Amanda - template to display information of dengue cases in each area
    template_pop_up <-  tags$dl(class = "dl-horizontal",
                                tags$dt("Dengue Outbreak Area :"), tags$dd("%s"),
                                tags$dt("Total Cases :"), tags$dd("%s")) %>% paste()
    
    popup_info <- sprintf(template_pop_up,
                          fdata[["area"]], fdata[["totalcases"]])
    
###Amanda - template to display information of hospital and clinic
    clinichospital_pop_up <-  tags$dl(class = "dl-horizontal",
                                  tags$dt("Name :"), tags$dd("%s"),
                                  tags$dt("Address :"), tags$dd("%s"),
                                  tags$dt("Postcode :"), tags$dd("%s"),
                                  tags$dt("City :"), tags$dd("%s"),
                                  tags$dt("District :"), tags$dd("%s"),
                                  tags$dt("State :"), tags$dd("%s"),
                                  tags$dt("Tel :"), tags$dd("%s"),
                                  tags$dt("Fax :"), tags$dd("%s"),
                                  tags$dt("Website :"), tags$dd("%s")) %>% paste()
    
###Amanda - filter all data within the chosen states
    clinicdata = subset(clinicgov, state %in% input$state)
    
    clinic_popup_info <- sprintf(clinichospital_pop_up,
                                 clinicdata[["name"]],
                                 clinicdata[["address"]], clinicdata[["postcode"]],
                                 clinicdata[["city"]], clinicdata[["district"]],
                                 clinicdata[["state"]], clinicdata[["tel"]],
                                 clinicdata[["fax"]], clinicdata[["website"]])
    
###Amanda - filter all data within the chosen states
    clinicdesadata = subset(clinicdesa, state %in% input$state)
    
    clinicdesa_popup_info <- sprintf(clinichospital_pop_up,
                                     clinicdesadata[["name"]],
                                     clinicdesadata[["address"]], clinicdesadata[["postcode"]],
                                     clinicdesadata[["city"]], clinicdesadata[["district"]],
                                     clinicdesadata[["state"]], clinicdesadata[["tel"]],
                                     clinicdesadata[["fax"]], clinicdesadata[["website"]])
    
###Amanda - filter all data within the chosen states
    clinic1mdata = subset(clinic1m, tolower(state) %in% tolower(input$state))
    
    clinic1m_popup_info <- sprintf(clinichospital_pop_up,
                                   clinic1mdata[["name"]],
                                   clinic1mdata[["address"]], clinic1mdata[["postcode"]],
                                   clinic1mdata[["city"]], clinic1mdata[["district"]],
                                   clinic1mdata[["state"]], clinic1mdata[["tel"]],
                                   clinic1mdata[["fax"]], clinic1mdata[["website"]])
    
###Amanda - filter all data within the chosen states
    hospitaldata = subset(hospital, state %in% input$state)
    
    hospital_popup_info <- sprintf(clinichospital_pop_up,
                                   hospitaldata[["name"]],
                                   hospitaldata[["address"]], hospitaldata[["postcode"]],
                                   hospitaldata[["city"]], hospitaldata[["district"]],
                                   hospitaldata[["state"]], hospitaldata[["tel"]],
                                   hospitaldata[["fax"]], hospitaldata[["website"]])
  }
  
###Amanda - check if to display cluster or not
  clusteroption = reactive({
    if(input$cluster){
      cluster = markerClusterOptions()
    }else{
      cluster = NULL
    }
    cluster
  })
  
###Amanda - get the color based on total dengue cases
  getColor <- function(df) {
    sapply(df$totalcases, function(x) {
      if(x <= 50) {
        "lightblue"
      } else if(x <= 200) {
        "blue"
      } else if(x <= 1000){
        "darkblue"
      } else if(x <= 1500){
        "orange"
      }else{
        "red"
      } })
  }
  
###Amanda - get size of radius based on total dengue cases
  getRadius <- function(df) {
    sapply(df$totalcases, function(x) {
      if(x <= 50) {
        3000
      } else if(x <= 200) {
        4000
      } else if(x <= 1000){
        5000
      } else if(x <= 1500){
        6000
      }else{
        7000
      } })
  }
  
###Amanda - icon for markers
    icons <- awesomeIcons(
    icon = 'fa-blank',
    library = 'fa',
    iconColor = 'white',
    markerColor = getColor(fdata)
  )
  
    
###Amanda - display the location of dengue cases and location of hospital $ clinics
   if(length(input$state) > 0){
         fmap <- leaflet(clinicdata) %>% addTiles() 
     
    if(input$scgov) {
      fmap <- fmap %>% addCircleMarkers(lng = ~clinicdata$longitude, lat = ~clinicdata$latitude, radius = 5, popup = ~clinic_popup_info, color="#FFD700", clusterOptions = clusteroption())
    }
    if(input$scdesa) {
      fmap <- fmap %>% addCircleMarkers(lng = ~clinicdesadata$longitude, lat = ~clinicdesadata$latitude, radius = 5, popup = ~clinicdesa_popup_info, color="green", clusterOptions = clusteroption())
    }
    if(input$sc1m) {
      fmap <- fmap %>% addCircleMarkers(lng = ~clinic1mdata$longitude, lat = ~clinic1mdata$latitude, radius = 5, popup = ~clinic1m_popup_info, color="black", clusterOptions = clusteroption())
    }
    if(input$shos) {
      fmap <- fmap %>% addCircleMarkers(lng = ~hospitaldata$longitude, lat = ~hospitaldata$latitude, radius = 5, popup = ~hospital_popup_info, color="purple", clusterOptions = clusteroption())
    }
    
    
#####Amanda - addAwesomeMarkers is a preferable way 
     fmap <- fmap %>% addAwesomeMarkers(fdata$longitude,fdata$latitude,icon = icons,popup = popup_info,
     popupOptions = popupOptions(closeButton = FALSE, closeOnClick = TRUE,className = "popup"),clusterOptions = clusteroption())
     
###Amanda - leaflet legend
     fmap <- fmap %>% addLegend(position = 'bottomleft',
                                colors = mapcolors,
                                labels = maplabel, opacity = 1,
                                title = 'Dengue Outbreak Cases')
     
#####Amanda -  addCircles is not a good option  
     # fmap <- fmap %>%  addCircles(~fdata$longitude, ~fdata$latitude, radius=~getRadius(fdata), popup=~popup_info, stroke=FALSE, fillOpacity=0.4, fillColor='red')
     #fmap <- fmap %>% setView(103.8, 4.33, zoom = 8)
  }
  else
  {

###Amanda - set view in Malaysia when deselect all
    leaflet() %>% addTiles() %>% setView(103.8, 4.33, zoom = 7)
    
  }
})



###Amanda - display the data in table form
  output$newtbl <- renderDataTable({
  newdata <- dengue2010_2015 %>% filter (year == input$newdatayear)
  
  opts <- list(pageLength = 20, lengthChange = FALSE, searching = FALSE,
               info = FALSE,  pagingType = "full")
  
  datatable(newdata, escape = FALSE, rownames = FALSE, options = opts)
  })


###Amanda -plot the barplot
  output$data_plot <- renderPlot({
  dgraf <- as.character(input$grafA)
  
  if (dgraf == "By Year"){ 
    tdata <- dengue2010_2015 %>% group_by(year) %>% summarise(
      totalcases = sum(total_cases)
    )
    grafA <- barplot(tdata$totalcases,names.arg=tdata$year, main="Total Dengue Cases By Year", xlab="Year", ylab="Total Cases", ylim=c(0,250000),col="cadetblue")
    text(x = grafA, y = tdata$totalcases, label = tdata$totalcases, pos = 3, cex = 0.8, col = "blue")
  }
  else if (dgraf == "By State"){
    tdata <- dengue2010_2015 %>% group_by(state) %>% summarise(
      totalcases = sum(total_cases)
    ) %>% arrange(desc(totalcases))
    
    grafB <- barplot(tdata$totalcases,names.arg=tdata$state, main="Total Dengue Cases By State", xlab="State", ylab="Total Cases", ylim=c(0,250000),col="cadetblue")
    text(x = grafB, y = tdata$totalcases, label = tdata$totalcases, pos = 3, cex = 0.8, col = "blue")
  }
  else if (dgraf == "By Year & State") {
    cstate = input$fstate
    
    tdata = subset(dengue2010_2015, state %in% input$fstate)
    
    tdata <- tdata %>% group_by(state, year) %>% summarise(
      totalcases = sum(total_cases)
    )
    
    for(sstate in input$fstate) {
      for(syear in 2010:2015){
        if(nrow(tdata %>% filter(state == sstate & year == syear)) == 0){
          tdata <- tdata %>% bind_rows(tibble(state=sstate, year=syear,totalcases=1))
        }
      }
    }
    ggplot(data=tdata, aes(x=factor(year), y=log10(totalcases), fill=state))+geom_bar(stat="identity",position="dodge")+labs(title="Comparison of Dengue Cases", x="Year",y="Total Cases (log10)", fill="State")+theme_bw()    
  }
})
  
  ### addition by Aishah 29 Apr 2018
  ### display the dengue cases and dengue deaths data in pivot table
  output$trendpivot <- renderRpivotTable({rpivotTable(data=dengue_figures,rows=c('Year'),cols=c('Weekno'),vals=c('no_of_cases','no_of_death_cases')
                                                      ,aggregatorName="Integer Sum",rendererName="Area Chart")})  
  
  ##Vivian##
  ###Dengue vs Healthcare plot
  output$dengue_plot <- renderPlot({
    
    ff <- tolower(input$LineState)
    ff
    g <- f %>% filter (State %in% ff)
    ###Modified by Amanda on 6th May 2018 - Changed to log10
    ggplot() + 
      labs(y = "Frequency (log10)", x = "State") +
      theme(panel.background = element_rect(fill = NA), panel.grid.major = element_line(colour = "grey80"), panel.ontop = FALSE) +
      geom_label(data=g, aes(x=State, y=log10(DengueCases), label = DengueCases, color = "Dengue_Cases"),vjust = 0.5, hjust = 1.0) +
      geom_point(data=g, aes(x=State, y=log10(DengueCases),group=1, color="Dengue_Cases"), size = 3) +
      geom_label(data=g, aes(x=State, y=log10(TotalHealthcare), label = TotalHealthcare, color = "Healthcare_Institutions"),vjust = 0.5, hjust = 0.0) +
      geom_point(data=g, aes(x=State, y=log10(TotalHealthcare),group=1, color="Healthcare_Institutions"), size = 3) +
      scale_colour_manual(name="Line Color",values=c(Dengue_Cases="red", Healthcare_Institutions="blue")) 
  })  
  ##/Vivian##
})

