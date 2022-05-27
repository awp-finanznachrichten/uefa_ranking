library(rvest)
library(stringr)
library(XML)
library(RSelenium)
library(git2r)
library(DatawRappr)

setwd("C:/Users/simon/Onedrive/Fussballdaten/uefa_ranking")

#Make Commit
token <- read.csv("C:/Users/simon/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]

git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
invisible(git2r::cred_token(token))
gitadd()
gitcommit()
gitpush()

