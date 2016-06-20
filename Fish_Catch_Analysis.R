library(dplyr)
library(reshape2)
library(googleVis)

#read data
dat<-read.csv("../data/fish_catches.csv",header = T,stringsAsFactors = F)
country_codes<-read.csv("../data/country_codes.csv",header = T,stringsAsFactors = F)

#remove NA columns
dat<-select(dat,Species:X2006)

#remove x from years 
names(dat)[5:13]<-sub('.', '', names(dat)[5:13])

#melt the data frame
datm<-melt(dat,id=names(dat)[1:4],
           variable.name = "Year",
           value.name = "Quantity")

#Na.omit
datm<-na.omit(datm)

#change year from factor to numeric
datm$Year<-as.numeric(as.character(datm$Year))

#extract country and code from the country_codes dataframe
cc<-country_codes[,1:2]

#merge the main data and country codes 
datm<-left_join(datm,cc,by=c("Country"="Code"))

#rename columns 
names(datm)[names(datm)=="Country"]="Code"
names(datm)[names(datm)=="Description"]="Country"

################################

datm.country<-datm %>%
        group_by(Year,Country) %>%
        summarise(TLW=sum(Quantity)) %>%
        arrange(Country)


#set state with default line chart, unique colors 

myState<-'
{"yLambda":1,"showTrails":false,"xAxisOption":"_TIME",
"xZoomedDataMin":1136073600000,"orderedByY":false,"playDuration":15000,
"nonSelectedAlpha":0.4,"xZoomedIn":false,"xLambda":1,"colorOption":"2",
"iconKeySettings":[],"xZoomedDataMax":1388534400000,
"dimensions":{"iconDimensions":["dim0"]},
"sizeOption":"_UNISIZE","yZoomedIn":false,
"uniColorForNonSelected":false,"time":"2014","yZoomedDataMax":10000000,
"iconType":"LINE","duration":{"timeUnit":"Y","multiplier":1},
"yAxisOption":"2","yZoomedDataMin":0,"orderedByX":false}
'

#create motion chart
#remove upper tabs
N = gvisMotionChart(datm.country, "Country", "Year",
                    options = list(showChartButtons=F, state=myState))
#plot chart
plot(N)


#######################
datm.species<-datm %>%
        group_by(Year,Species) %>%
        summarise(TLW=sum(Quantity)) %>%
        arrange(Species)

#create motion chart
#remove upper tabs
M = gvisMotionChart(datm.species, "Species", "Year",
                    options = list(showChartButtons=F, state=myState))
#plot chart
plot(M)