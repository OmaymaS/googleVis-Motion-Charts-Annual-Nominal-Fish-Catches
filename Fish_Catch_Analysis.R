library(dplyr)

#read data
dat<-read.csv("../data/fish_catches.csv",header = T,stringsAsFactors = F)

#remove NA columns
dat<-select(dat,Species:X2006)

#remove x from years 
names(dat)[5:13]<-sub('.', '', names(dat)[5:13])