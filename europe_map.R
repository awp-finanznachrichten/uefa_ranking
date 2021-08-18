query <- query[,c(2,4:5)]
names(query) <- c("Club","Stadium","Coordinates")

test <- merge(query,clubs_europe)

library(reshape2)
test2 <- colsplit(test$Coordinates," ",c("Latitude","Longitude"))
uefa_clubs <- cbind(test,test2)
View(uefa_clubs)
uefa_clubs <- uefa_clubs[,-3]
uefa_clubs$Latitude <- gsub("Point[(]","",uefa_clubs$Latitude)
uefa_clubs$Longitude <- gsub("[)]","",uefa_clubs$Longitude)



View(query)

library(xlsx)
write.xlsx(uefa_clubs, file="uefa_clubs.xlsx")
