library(rvest)
library(stringr)
library(XML)

setwd("C:/Users/simon/Onedrive/Fussballdaten/uefa_ranking")

url <- "https://kassiesa.net/uefa/data/method5/crank2022.html"
webpage <- read_html(url)

uefa_table <- html_text(html_nodes(webpage,"td"))


uefa_table <- uefa_table[uefa_table!=""]
uefa_table <- uefa_table[-(496:498)]

uefa_table
uefa_country_ranking <- data.frame(1,2,3,4,5,6,7,8,9)
names(uefa_country_ranking) <- c("rank","country","17/18","18/19","19/20","20/21","21/22","overall","teams")
repeat {

country <- uefa_table[1:9]
names(country) <- c("rank","country","17/18","18/19","19/20","20/21","21/22","overall","teams")
uefa_country_ranking <- rbind(uefa_country_ranking,country)
uefa_table <- uefa_table[-(1:9)]

if (length(uefa_table) < 9) {
  
  break
}

}

uefa_country_ranking <- uefa_country_ranking[-1,]
uefa_country_ranking$teams <- gsub(" ","",uefa_country_ranking$teams)

for (i in 1:nrow(uefa_country_ranking)) {
  
  if (nchar(uefa_country_ranking$teams[i]) == 1) {
    
    uefa_country_ranking$teams[i] <- 0
    
  }
  
}

#colnames(uefa_country_ranking) <- c("")


#uefa_country_ranking$teams <- sub("\\/.*", "", uefa_country_ranking$teams)
uefa_country_ranking <- uefa_country_ranking[12:23,]

#Adjustment Serbai
uefa_country_ranking$overall[1] <- "26.125"

#Calculate gap
uefa_country_ranking$gap <- as.numeric(uefa_country_ranking$overall) -
  as.numeric(uefa_country_ranking$overall[4])


#Points gained
old_data_ranking <- read.csv("https://raw.githubusercontent.com/awp-finanznachrichten/uefa_ranking/master/Output/uefa_country_ranking.csv",encoding = "UTF-8")
uefa_country_ranking$gained <- as.numeric(uefa_country_ranking$overall)-as.numeric(old_data_ranking$current.points)

uefa_country_ranking$gained <- c(0.125,0.4,0.625,0.5,0.25,0.4,0.4,0.5,0.375,0.75,0.2,0.5)

#Wappen
uefa_country_ranking$country <- gsub("Serbia",":rs:Serbia",uefa_country_ranking$country)
uefa_country_ranking$country <- gsub("Belgium",":be:Belgium",uefa_country_ranking$country)
uefa_country_ranking$country <- gsub("Croatia",":hr:Croatia",uefa_country_ranking$country)
uefa_country_ranking$country <- gsub("Switzerland",":ch:Switzerland",uefa_country_ranking$country)
uefa_country_ranking$country <- gsub("Cyprus",":cy:Cyprus",uefa_country_ranking$country)
uefa_country_ranking$country <- gsub("Turkey",":tr:Turkey",uefa_country_ranking$country)
uefa_country_ranking$country <- gsub("Czech Republic",":cz:Czech Republic",uefa_country_ranking$country)
uefa_country_ranking$country <- gsub("Norway",":no:Norway",uefa_country_ranking$country)
uefa_country_ranking$country <- gsub("Greece",":gr:Greece",uefa_country_ranking$country)
uefa_country_ranking$country <- gsub("Sweden",":se:Sweden",uefa_country_ranking$country)
uefa_country_ranking$country <- gsub("Denmark",":dk:Denmark",uefa_country_ranking$country)
uefa_country_ranking$country <- gsub("Israel",":il:Israel",uefa_country_ranking$country)

#Tidy it
uefa_country_ranking <- uefa_country_ranking[,c(1:2,8,11,10,9)]
colnames(uefa_country_ranking) <- c("rank","country","current points","points gained",
                                    "gap to 15th place","teams remaining")


write.csv(uefa_country_ranking,"Output/uefa_country_ranking.csv", na = "", row.names = FALSE, fileEncoding = "UTF-8")

#Commit and update Datawrapper
library(git2r)
library(DatawRappr)

gitcommit <- function(msg = "commit from Rstudio", dir = getwd()){
  cmd = sprintf("git commit -m\"%s\"",msg)
  system(cmd)
}

gitstatus <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git status"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitadd <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git add --all"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitpush <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git push"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitpull <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git pull"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}


#Make Commit
token <- read.csv("C:/Users/simon/OneDrive/Github_Token/token.txt",header=FALSE)[1,1]

git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
invisible(git2r::cred_token(token))
gitadd()
gitcommit()
gitpush()


#Update Datawrapper
datawrapper_auth("fYNHJEgLlCPgMC8hO0Bxm7j3SG2cOGCPnIJRc5RCVc72zYBFaMxGYIOY081zYaeq", overwrite = TRUE)
dw_edit_chart("J6Mna", intro=paste0("last update: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr")))
dw_publish_chart("J6Mna")

