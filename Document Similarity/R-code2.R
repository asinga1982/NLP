install.packages(c("RTextTools","topicmodels"))
library(RTextTools)
library(topicmodels)
library(tm)
library(RNewsflow)
library(stringr)
library(dplyr)

setwd("E:/R Directory/Innoplex")

info_train <- read.delim("information_train.csv", header = TRUE, sep = "\t", dec = ".")
train <- read.csv("train.csv", header = T)

table(info_train$set)

set = 14

matrix <- create_matrix(cbind(as.vector(info_train$pmid[info_train$set==set]),
                              as.vector(info_train$article_title[info_train$set==set]),
                              as.vector(info_train$abstract[info_train$set==set]), 
                              as.vector(info_train$author_str[info_train$set==set]), 
                              as.vector(info_train$full_Text[info_train$set==set])), 
                        language="english", removeStopwords=TRUE,toLower=TRUE,stripWhitespace = T,
                        removePunctuation= TRUE,removeNumbers=TRUE, stemWords=TRUE,minDocFreq=1, 
                        weighting=weightTfIdf)

comp <- documents.compare(matrix, min.similarity=0.4)

comp$x.pmid <- as.numeric(word(comp$x,1))

comp$y.pmid <- as.numeric(word(comp$y,1))

xx <- inner_join(comp,info_train,by=c("y.pmid" = "pmid"))
comp$y_pub_date <- as.Date(xx$pub_date, format="%Y-%m-%d")

xx <- inner_join(comp,info_train,by=c("x.pmid" = "pmid"))
comp$x_pub_date <- as.Date(xx$pub_date, format="%Y-%m-%d")


#comp_filtered <- comp[comp$x_pub_date > comp$y_pub_date,3:7]
comp_filtered <- comp[,3:7]


r1 <- comp_filtered %>% 
  group_by(x.pmid) %>%
  summarise(y.pmid = toString(unique(y.pmid)))
  
r1$x.pmid <- as.integer(r1$x.pmid)


######################### Did not work out well
train$ref_lst_new <- ""

for (i in 1:nrow(train)) {

a <- gsub('\\[','',as.character(train$ref_list[i]))
a <- gsub('\\]','',a)

aa <- unlist(strsplit(as.character(a), ","))

train$ref_lst_new[i] <- toString(as.numeric(gsub("[[:punct:]]", "", aa)))
}


df <- data.frame(PMID=(character()),
                 F1=double(),
                 stringsAsFactors = FALSE)

for ( i in 1:nrow(r1))
{

pmid <- r1$x.pmid[i]  

a <- unlist(strsplit(train$ref_lst_new[train$pmid==pmid],","))
b <- unlist(strsplit(r1$y.pmid[r1$x.pmid==pmid],","))

overlap <- sum(a %in% b)

Prec <- overlap /length(b)

Recal <- overlap /length(a)

F1 <- 2*((Prec*Recal)/(Prec+Recal))

if (overlap == 0) {
  F1 <- 0
}

df[i,] <- c(pmid,F1)

}

mean(df$F1)
