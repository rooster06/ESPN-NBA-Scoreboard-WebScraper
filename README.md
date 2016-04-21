# ESPN-NBA-Scoreboard-WebScraper in R

The R code in this repo is a webscraper that for a given date, outputs an exel file with the information on ESPNs publicaly available NBA Scoreboard, provided atleast one game was played on that date. 

The exel file contains the following columns:
team names, team locations, home/away, team scores, winner or loser indicator, top performing player, the top performing playes rebound points, and his assist points.

The date variable on line 26 is where the user provides the date for which he/she wishes to extract the above information. 
The format of entering the date is yyyymmdd, ex- if you wish the information of all the games played on 04/19/2016 then the date variable
must be set to 20160419.

Provided atleast one game was played on the date set in the date variable, the code creates an exel file ESPNnba.xlsx, and adds the information to a sheet, named after the contents of the date variable. 

IF no games were played on a given date then the code outputs "no games played on this date" in the R console, and does not create any exel file/sheet.

The ESPN website from which the data is scraped is as follows, (the url is http://espn.go.com/nba/scoreboard)
![alt tag](https://github.com/rooster06/ESPN-NBA-Scoreboard-WebScraper/blob/master/1.png)

The exel file generated from the webscraper in this repo is as follows:
![alt tag](https://github.com/rooster06/ESPN-NBA-Scoreboard-WebScraper/blob/master/2.png)

-P.R.
