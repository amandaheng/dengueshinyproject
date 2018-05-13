library(stringr)
library(dplyr)

################################################################################
#                             Global Variables                                 #
################################################################################


###Amanda- load dengue dataset
dengue2010_2015 <- read.csv("dengue2010_2015.csv", header = TRUE, stringsAsFactors=FALSE)
dengue2010_2015$area <- str_trim(dengue2010_2015$area)
str(dengue2010_2015)

###Amanda- load longitude and latitude dataset
longitudelatitude <- read.csv("location.csv", header = TRUE)
longitudelatitude$area <- str_trim(longitudelatitude$area)

###Amanda- load clinic 1m dataset
clinic1m <- read.csv("clinic1m.csv", header = TRUE, stringsAsFactors=FALSE)
clinic1m$state <- str_trim(clinic1m$state)

###Amanda- load clinic government dataset
clinicgov <- read.csv("clinicgov.csv", header = TRUE, stringsAsFactors=FALSE)
clinicgov$state <- str_trim(clinicgov$state)

###Amanda- load clinic desa dataset
clinicdesa <- read.csv("clinicdesa.csv", header = TRUE, stringsAsFactors=FALSE)
clinicdesa$state <- str_trim(clinicdesa$state)

###Amanda- load hospital dataset
hospital <- read.csv("hospital.csv", header = TRUE, stringsAsFactors=FALSE)
hospital$state <- str_trim(hospital$state)


###Vivian start###
a <- clinicdesa %>% count(state)
b <- clinic1m %>% count(state)
c <- clinicgov %>% count(state)
d <- hospital %>% count(state)
### vivian's code - count total number of observations/rows for each state
### e <- dengue2010_2015 %>% count(state)

### Added by Amanda on 3 May - count total number of dengue outbreak cases for each state
e <- dengue2010_2015 %>% group_by(state) %>% summarise(
  n = sum(total_cases)
)


a$state <- tolower(a$state)
b$state <- tolower(b$state)
c$state <- tolower(c$state)
d$state <- tolower(d$state)
e$state <- tolower(e$state)

a <- a[which(a$state!='n. sembilan' & a$state!='kedah'),]
b <- b[which(b$state!='n. sembilan' & b$state!='kedah'),]
c <- c[which(c$state!='n. sembilan' & c$state!='kedah'),]
d <- d[which(d$state!='n. sembilan' & d$state!='kedah'),]
e <- e[which(e$state!='n. sembilan' & e$state!='kedah'),]

f <- cbind(e,a$n,b$n,c$n,d$n,a$n+b$n+c$n+d$n)
names(f) <- c("State","DengueCases","ClinicDesa","Clinic1M","ClinicGov","Hospital","TotalHealthcare")
###/Vivian end###


#Addition by Aishah 29 Apr 2018
###load dengue cases and dengue death cases dataset
dengue_figures <- readxl::read_excel("kes denggi 2010-2015 transformed.xlsx",sheet="TRANSFORM_CASES3")


###Amanda- get the list of states from clinic government dataset
stateslist <- unique(clinicgov$state)
options <- list(states = stateslist)

###Amanda- leaflet legend  
maplabelstext <- c('lightblue',  'blue','darkblue', 'orange', 'red')
mapcolors <- rgb(t(col2rgb(maplabelstext)) / 255)
maplabel <- c('0 - 50', '51 - 200', '201 - 1000',  '1001 - 1500', '> 1500')

