# dengueshinyproject

Introduction
====================
Dengue fever is an infectious tropical disease caused by the dengue virus and transmitted by Aedes mosquitoes. The dengue fever brought by Aedes mosquitoes is listed as the most prevalent disease in the country with a ratio of 328.3 cases per 100,000 population.

Finding and Getting Data
========================
All the datasets are downloaded from http://www.data.gov.my. 
These datasets are tabulation of Dengue Outbreak in Malaysia recorded between 2010 to 2015 ,4 healthcare centres datasets and dengue dealth cases,.  

The data is provided by the Ministry of Health Malaysia. 


Data Cleaning and Processing
============================
-Rename columns into a meaningful names

-Select distinct areas from a combined dataset (dengue2010_2015)

#select distinct areas from  dataset
location <- dengue2010_2015%>% select("area") %>% distinct
location$area <- str_trim(location$area)

-Fetching location coordinates from Google API (Geocoding.R)

-Fixing inaccurate data (mismatch between some states and areas) by perform system testing 

-Clean NAs as well as white spaces 

Problem Definition Framework
==============================
What is  the problem?
==============================
Where are the hotspots of dengue outbreak in Malaysia & the healthcare centres (Hospital, Clinic 1M, Clinic Desa, Clinic Government) near  them?

Why does the problem need to be solved?
=======================================
Dengue fever, which is transmitted by the bite of Aedes mosquitoes,  is listed as the most prevalent disease in Malaysia with a ratio of 328.3 cases per 100,000 population. A modern & effective strategy to address this pressing issue is crucial.

How would I solve the problem?
======================================
Interactive Map

- Create an interactive map to locate the hotspots of dengue outbreaks & healthcare centres near them. The best way to survive dengue fever is to seek medical help promptly.


Dengue Outbreak Analysis

-It shows:

-Total dengue cases by year

-Total dengue cases by state

-Comparisons of total dengue cases for all chosen states from year 2010 to 2015

The government can focus more on high risk states & areas and put more effort into educating the residents.  The best way to prevent infection is to protect against the bites of mosquitoes that transmit the virus and to minimize sites where mosquitoes breed.

References
===================
leaflet tutorial
===================
https://rstudio.github.io/leaflet/shiny.html

shiny dashboard tutorial
=======================
https://rstudio.github.io/shinydashboard/get_started.html
https://datascienceplus.com/building-a-simple-sales-revenue-dashboard-with-r-shiny-shinydashboard/

Shiny html tags glossary
=======================
https://shiny.rstudio.com/articles/tag-glossary.html
https://shiny.rstudio.com/articles/html-tags.html


Icons for shiny app
===================
https://fontawesome.com/v4.7.0/icons/


Color scheme
==================
https://www.w3schools.com/cssref/css_colors.asp

css cheatsheet for styling
=================
http://htmlcheatsheet.com/css/
