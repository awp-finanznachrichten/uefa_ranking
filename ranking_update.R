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

#Update Ranking Data
source("ranking_scraping.R",encoding = "UTF-8")

#Update Team Data
source("ranking_teams_scraping.R",encoding = "UTF-8")

#Update Maps
source("create_maps.R",encoding = "UTF-8")


#Make Commit
token <- read.csv("C:/Users/simon/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]

git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
invisible(git2r::cred_token(token))
gitadd()
gitcommit()
gitpush()

#Update Datawrapper
source("update_datawrapper.R",encoding = "UTF-8")


