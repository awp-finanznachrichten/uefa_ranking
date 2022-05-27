uefa_country_ranking_teams <- data.frame("country","team",0)
colnames(uefa_country_ranking_teams) <- c("country","overall_points","points_season","text_datawrapper_overall","text_datawrapper_season")

for (c in 1:nrow(uefa_country_ranking_full)) {

country_name <- gsub(".*:","",uefa_country_ranking_full$country[1])
teams <- uefa_country_ranking_teams %>%
  filter(country == country_name)

View(points_team)
uefa_country_ranking_teams
text_datawrapper_overall <- 

}    


