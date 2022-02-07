library(stringr)
library(rvest)
library(readr)
scrapy <- function(name){
  url <- sprintf("https://www.tennisexplorer.com/list-players/?search-text-pl=%s&country=", name)  
  download.file(url, destfile = "scrapedpage.html", quiet=TRUE)
  content <- read_html("scrapedpage.html")
  
  saved <- content %>%
    html_nodes(".t-name")%>%
    html_nodes("a")%>%
    html_attr("href")
  
  player_page <- sprintf("https://www.tennisexplorer.com%s", saved[1])
  download.file(player_page, destfile = "scrapedpage.html", quiet=TRUE)
  content <- read_html("scrapedpage.html")
  
  player_data <- content %>%
    html_nodes(".date")%>%
    html_text()
  
  scraped_data <- list("", "", "", "", "", "", "", "")
  
  for(p_info in player_data){
    splitted <- str_split(p_info, ": ")
    if(splitted[[1]][1] == "Country"){
      scraped_data[1] = splitted[[1]][2]
    }
    if((splitted[[1]][1] == "Height / Weight") || (splitted[[1]][1] == "Height")){
      scraped_data[2] = parse_number(splitted[[1]][2])
    }
    if(splitted[[1]][1] == "Age"){
      tmp <- str_split(splitted[[1]][2], " ")
      index <- 0
      for(i in tmp[[1]]){
        scraped_data[3+index] <- parse_number(i)
        index <- index+1
      }
    }
    if(splitted[[1]][1] == "Sex"){
      scraped_data[7] <- splitted[[1]][2]
    }
    if(splitted[[1]][1] == "Plays"){
      scraped_data[8] <- splitted[[1]][2]
    }
  }
  return(scraped_data)
}
add <- function(val){
  return(val)
}