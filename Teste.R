require(rtweet)
require(tidyverse)
require(here)
require(lubridate)
require(igraph)
require(syuzhet)
require(tidytext)
install.packages("tm")
install.packages("wordcloud")
library(tm)
require(wordcloud)
require(ggplot2)
require(dplyr)


api_key <- "NseHaV4ZQfSjdgD8zPDvB1F8E" 
api_secret <- "kWnkHPg3HyLkmBSCMTPaIPquBOrqUfTB6oCjizwvAjczBbTSJJ" 
access_token <- "241525113-fy1L7U4u2ZKNsCv8dVhn0g8W0h4vwijNpf26scOb" 
access_secret <- "gWoNGNU817Q7E6eZrAIjivfoj61yzkvVQriVIwMNHHnFL"  
origop <- options("httr_oauth_cache") 
options(httr_oauth_cache = TRUE)

auth_setup_default()

debate <- search_tweets("bolsonaro", n=10)
debate
head(debate, n=3)

textdata <- head(debate$full_text)
textdata

textdata <- debate$full_text
textdata <- debate$text

tw_doc <- Corpus(VectorSource(textdata))

#Limpeza
tw_doc <- tm_map(tw_doc, content_transformer(tolower))
tw_doc <- tm_map(tw_doc, removeNumbers)
tw_doc <- tm_map(tw_doc, removeWords, stopwords('english'))
tw_doc <- tm_map(tw_doc, removePunctuation)
tw_doc <- tm_map(tw_doc, stripWhitespace)


deb <- TermDocumentMatrix(tw_doc)
mt <- as.matrix(deb)
v <- sort(rowSums(mt), decreasing = T)
df <- data.frame(frequency(v))
df <- data.frame(word(names(v), frequency(v)))
head(df,10)

#BarPlot

barplot(df$frequency, las=2, names.arg=df$word,
        col="Blue", main="Palavras que mais aparecem",
        ylab="Palavras frequentes")

#Wordcloud

set.seed(1)
nuvem <- wordcloud(words = df$word, freq=df$frequency, min.freq=5, max.words=10,
                   random.order = TRUE, rot.per = 0.1, colors = brewer.pal(8, "Dark2"))