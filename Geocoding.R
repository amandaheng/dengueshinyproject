#Fetch coordinates

#Part 1: install and load required library
install.packages('ggmap')
library('ggmap')

#Part 2: Load dataset
data<-read.csv('clinic1m.csv')

#Part 3: use address column from clinic1m.csv to fetch location coordinates from Google API
#since using free API so queries are limited to 2500 queries per IP
data2<-mutate_geocode(data,address)

#may need to filter data a few times and rerun the line of code above in order to get complete location coordinates
#repeat codes in the block below

#filter data that does not have coordinates and remove the coordinate columns
data3<-data2[!complete.cases(data2$lat),!names(data2) %in% c('lat','lon')]
#fetch somemore coordinates
data3<-mutate_geocode(data2,address)
#filter data that already have coordinates
data2<-data2[complete.cases(data2$lat),]
#append data
data2<-rbind(data2,data3)


#Part 4: save results
write.csv('clinic1m.csv',sep=",")

