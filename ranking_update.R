library(rvest)
library(stringr)
library(XML)
library(RSelenium)
library(git2r)
library(DatawRappr)
library(readxl)
library(dplyr)

#setwd("C:/Users/simon/Onedrive/Fussballdaten/uefa_ranking")
setwd("C:/Users/Administrator/Desktop/uefa_ranking")

#Load functions
source("ranking_funktionen.R",encoding = "UTF-8")

#Check Update Time

driver <- RSelenium::rsDriver(port= 4568L, browser = "firefox")
remote_driver <- driver[["client"]]

repeat {
Sys.sleep(10)
current_date <- Sys.Date()
current_day <- as.numeric(format(Sys.Date(),"%d"))
remote_driver$navigate("https://kassiesa.net/uefa/data/method5/crank2022.html")

output <- remote_driver$findElement(using="class",value="flex-container")
text_all <- output$getElementText()

day <- gsub(".*Last update:","",text_all)
day <- parse_number(day)

if (day == current_day) {
break
print("Aktuelle Daten gefunden")
}
if (as.numeric(format(Sys.time(),"%H")) == 1) {
break
print("Keine neuen Daten gefunden an dem aktuellen Tag")

}  
print("Noch leine aktuellen Daten gefunden")
}

#Close browser
remote_driver$close()

#Close server
driver[["server"]]$stop()

#Stop Java-Process
system("taskkill /F /IM java.exe")

#Update Ranking Data
source("ranking_scraping.R",encoding = "UTF-8")

#Update Team Data
source("ranking_teams_scraping.R",encoding = "UTF-8")

#Update Maps
source("create_maps.R",encoding = "UTF-8")

#Make Commit
#token <- read.csv("C:/Users/simon/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]
token <- read.csv("C:/Users/Administrator/Desktop/Github_Token/token.txt",header=FALSE)[1,1]

git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
invisible(git2r::cred_token(token))
gitadd()
gitcommit()
gitpush()

#Update Datawrapper
source("update_datawrapper.R",encoding = "UTF-8")


format(Sys.time(),"%M")
