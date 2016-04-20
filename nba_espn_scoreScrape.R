#' ---
#' title: "WebScraper for ESPN NBA Scoreboard" 
#' author: "Prabhat Rayapati"
#' date: "spring 2016" 
#' ---

## the following code is a webscraper that for a given date, outputs a exel file of the information
## on ESPNs publicaly available NBA Scoreboard, provided atleast one game was played on that date. 
## The exel file contains the following columns:
## team names, team locations, home/away, team scores, winner or loser indicator,
## top performing player, the top performing playes rebound points, and his assist points.


## install and load library xlsx, to be used for exporting data to a xlsx file
#install.packages("xlsx")
library(xlsx)
rm(list = ls())


## read the html from ESPNs webpage that provides scores
## change the date variable to the date you want the scores for,
## the format is yyyymmdd
## i.e. if you want data of the nba games on 03/21/2016 then change the date variable to 20160321
## this is then appended without space to "http://espn.go.com/nba/scoreboard/_/date/" to create 
## the webpage address for R to read the html from.
date = "20160419"
scores <- readLines(paste0("http://espn.go.com/nba/scoreboard/_/date/", date))

## find and keep the body of html that conatins the nba scores, we will only operate on the 
## section of html related to the nba game data for the day
start <- grep("<!-- optimizely js -->",scores)
end <- (grep("<!-- optimizely - initialize Optimizely object: temp hard-coded -->", scores))
scores <- scores[start:end]
#head(scores)
#head(scores)
#str(scores)

## make it a huge vector and split on commas
scores <- strsplit(scores, ",")
scores <- unlist(scores)
end <- length(scores)

## team names
l <- grep("shortDisplayName", scores) 
teams <- scores[l]
teams <- gsub("\"shortDisplayName\":", "",teams)
teams <- gsub("\"","",teams)
teams

nn <- length(teams)

## the if statement checks to make sure atleast one game was played on the given date
## if atleast one game was plated then it extracts the game(s) data otherwise it prints 
## "no games played on this date" in the R console below.
if(nn != 0){ 
## similar to above approach we extract team scores
m <- grep("\"score\"", scores)
teamScore <- scores[m]
#teamScore
teamScore <- gsub("\"score\":","",teamScore)
teamScore <- gsub("\"","",teamScore)
teamScore <- teamScore[1:nn+1]
teamScore

## location
n <- grep("\"location\"", scores)
teamLoc <- scores[n]
teamLoc <- gsub("\"location\":","",teamLoc)
teamLoc <- gsub("\"","",teamLoc)
teamLoc <- teamLoc[0:nn]
teamLoc

## home or away 
q <- grep("\"homeAway\"", scores)
gameHome <- scores[q]
gameHome <- gsub("\"homeAway\":","",gameHome)
gameHome <- gsub("\"","",gameHome)
gameHome <- gameHome[0:nn]

## winner or not, 1 indicates winner and 0 indicated loser 
p <- grep("\"winner\"",scores)
teamWin <- scores[p]
teamWin <- gsub("\"winner\":","",teamWin)
teamWin <- as.logical(toupper(teamWin))
teamWin <- as.numeric(teamWin)
teamWin <- teamWin[0:nn]

## Top performing player for each team
h <- grep("\"athlete\"",scores)
i <- length(h)

for (z in seq(from =4, to= i,by = 4)){
  if (z == 4){
    v <- c(h[z],h[z+1])  
  }else{
    v <- c(v,h[z],h[z+1])
  }
}

z <- length(v)
for (f in seq(1,z-1,by=2)){
  if( f==1){
    scores2 <- scores[v[f]:v[(f+1)]]
    tt <- grep("\"displayName\"", scores2)
    scores2 <- scores2[tt[1]]
  }else{ 
    if(f < z-1 & f > 1){
      tmp <- scores[v[f]:v[(f+1)]]
      tmpNo <- grep("\"displayName\"", tmp)
      scores2 <- c(scores2,tmp[tmpNo[1]])
    }
    if(f == (z-1)){
       tmp <- scores[v[f]:end]
       tmpNo <- grep("\"displayName\"",tmp)
       scores2 <- c(scores2,tmp[tmpNo[1]])
    }
    }
}

teamPlayer <- scores2
teamPlayer <- gsub("\"displayName\":","",teamPlayer)
teamPlayer <- gsub("[[:punct:]]","", teamPlayer)
teamPlayer

##### Top performing Players total points, number of points in asists and points in rebounds 
h <- grep("\"athlete\"",scores)
i <- length(h)

for (g in seq(from =4, to= i,by = 4)){
  if (g == 4){
    s <- c(h[g-1],h[g])  
  }else{
    s <- c(s,h[g-1],h[g])
  }
}

g <- length(s)
for (f in seq(1,g,by=2)){
  if( f==1){
    scores1 <- scores[s[f]:s[(f+1)]]
  }else{
    scores1 <- c(scores1,scores[s[f]:s[(f+1)]])
  }
}

w <- grep("\"displayValue\"",scores1)
TopPlayrPoints <- scores1[w]
TopPlayrREB <- scores1[w+1]
TopPlayrAST <- scores1[w+2]
TopPlayrAST <- as.numeric(gsub("[^[:digit:]]","",TopPlayrAST))
TopPlayrREB <- as.numeric(gsub("[^[:digit:]]","", TopPlayrREB))
TopPlayrPoints <- as.numeric(gsub("[^[:digit:]]","",TopPlayrPoints))
TopPlayrPoints

## lets create a data frame of the data we collected
## the data frame consists of the following columns: team names, team locations, home/away, team scores,
## winner or loser indicator, top performing player, the top performing playes rebound points, and finnaly his assist points
df <- data.frame("team"= teams, "teamLocations"= teamLoc, "HomeOrAway" = gameHome,"teamScore"= teamScore, "winner"= teamWin, "TopPerformer" = teamPlayer, "TopPerformerPoints"= TopPlayrPoints, "TopPerformerREB"= TopPlayrREB, "TopPerformerAST"=TopPlayrAST)
df

## this is stored in a exel file named ESPNnba exel file in a sheet that happens to be the date
write.xlsx(x = df, file = "ESPNnba.xlsx",
           sheetName = date,append = TRUE, row.names = FALSE)

}else{
  print("no games played on this date")
}
