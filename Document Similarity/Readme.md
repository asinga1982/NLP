# This folder contains code and data for finding out document similairty and predicting which articles will refer which ones.     
# This is my work for a competition held on AV.       

## Data Dictionary   
  

## information_train.csv, information_test.csv - tab separated files    

 

Variable   Meaning

abstract: Text containing the abstract of the article

article_title: Title of the article

author_str: Name of the Authors of the article

pmid: Id for the article

pub_date: Publication date of the article/manuscript

set: The set to which the article belongs

full_Text: The complete text of the research article



## Train.csv - comma separated file

Variable      Meaning

pmid: Id for the article

ref_list: pmid of the articles that this article has cited


## Test.csv - comma separated file


Variable        Meaning

pmid: Id for the article

Evaluation Metric: The Evaluation Metric for this competition is f1 weighted by samples.
