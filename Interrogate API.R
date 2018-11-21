#Installs relevant packages only if they arent already installed
if (!require("pacman")) install.packages("pacman")
pacman::p_load("jsonlite", "httpuv", "httr", "devtools", "shiny")

#Opens necessary libraries
library(jsonlite)
library(httpuv)
library(httr)
library(devtools)
#library(sunburstR)
library(shiny)

oauth_endpoints("github")

#Stores relevant OAth information
myapp <- oauth_app(appname = "Software_Engineering_GitHub_Assignment",
                   key = "9cdd2af0684fe05044a7",
                   secret = "a58134728046024f716360e2b7bf4c97210e38fe")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API to find repositories
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/repositories", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitReposDF = jsonlite::fromJSON(jsonlite::toJSON(json1))
#Find most popular language used for each repo in the given data.frame and the number of bytes of that language written
PopularLanguages = function(gitRepos)
{
  #Re-initialise Data Frame for unit testing
  Languages = NULL
  if(is.null(nrow(gitRepos)) | is.null(gitRepos$languages_url))
  {
    print("Incorrect data frame given for repos")
    return(Languages)
  }else
  {
    for(i in 1:nrow(gitRepos))
    {
      reqTemp = GET(paste(gitRepos$languages_url[i]), gtoken)
      stop_for_status(reqTemp)
      jsonTemp = content(reqTemp)
      dataFrameTemp = jsonlite::fromJSON(jsonlite::toJSON(jsonTemp))
      dataFrameTemp
      name = paste(gitRepos$name[i])
      #If no languages are listed, adds to data frame with a blank value
      if(length(dataFrameTemp) == 0)
      {
        newRow = data.frame(Repo=name, Language="None Entered", Bytes=0)
        Languages = rbind(Languages, newRow)
      }else
      {
        language = NULL
        bytes = -1
        #Find most popular language for the repository
        for(j in 1:length(dataFrameTemp))
        {
          if(as.numeric(dataFrameTemp[j]) > bytes)
          {
            language = names(dataFrameTemp)[j]
            bytes = as.numeric(dataFrameTemp[j])
          }
        }
        #Adds it to DF
        newRow = data.frame(Repo=name, Language=language, Bytes=bytes)
        Languages = rbind(Languages, newRow)
      }
    }
    return(Languages)
  }
}
Languages = PopularLanguages(gitReposDF)

#Gets number of contributions (commits) made to each of the repositories in the data.frame
ContributionsMade = function(gitRepos)
{
  #Re-initialise Data Frame for unit testing
  Contributions = NULL
  if(is.null(nrow(gitRepos)) | is.null(gitRepos$contributors_url))
  {
    print("Incorrect data frame given for repos")
    return(Contributions)
  }else
  {
    for(i in 1:nrow(gitRepos))
    {
      reqTemp = GET(paste(gitRepos$contributors_url[i]), gtoken)
      stop_for_status(reqTemp)
      jsonTemp = content(reqTemp)
      dataFrameTemp = jsonlite::fromJSON(jsonlite::toJSON(jsonTemp))
      dataFrameTemp
      name = paste(gitRepos$name[i])
      #If no contributors are listed, adds to data frame with a blank value
      if(length(dataFrameTemp) == 0)
      {
        newRow = data.frame(Repo=name, NumberOfCommits=0, NumberOfContributors=0)
        Contributions = rbind(Contributions, newRow)
      }else
      {
        totalCommits=0
        #Sums total number of commits made to each repository
        for(j in 1:length(dataFrameTemp$contributions))
        {
          totalCommits = totalCommits + as.numeric(dataFrameTemp$contributions[j])
        }
        #Adds it to DF
        newRow = data.frame(Repo=name, NumberOfCommits=totalCommits, NumberOfContributors=length(dataFrameTemp$contributions))
        Contributions = rbind(Contributions, newRow)
      }
    }
    return(Contributions)
  }
}
Contributions = ContributionsMade(gitReposDF)

#Combine Contributions and Languages
fullDataCollected = cbind(Contributions, Languages[,-1])
fullDataCollected

#Subsets Data into large, medium and small
largeData = fullData[which(fullData$NumberOfCommits > 200),]
mediumData = fullData[which(fullData$NumberOfCommits <= 200 & fullData$NumberOfCommits >= 50),]
smallData = fullData[which(fullData$NumberOfCommits < 50),]

#Creates data for visualisations of all sizes
CreateGraphData <- function(fullData)
{
  if(is.null(nrow(fullData)) | is.null(fullData$Language) | is.null(fullData$Bytes))
  {
    print("Invalid Data Entry")
    return(NULL)
  }else{
    languagesGraphData = data.frame(Language = NULL, totalBytes = NULL, numberOfAppearances = NULL)
    for(i in 1:nrow(fullData))
    {
      #Increments count of language already recorded
      if(fullData$Language[i] %in% languagesGraphData$Language)
      {
        index = match(fullData$Language[i],languagesGraphData$Language)
        languagesGraphData[index,]$totalBytes = as.numeric(languagesGraphData[index,]$totalBytes) + fullData[i,]$Bytes
        languagesGraphData[index,]$numberOfAppearances = as.numeric(languagesGraphData[index,]$numberOfAppearances) + 1
      }else{
        #Adds newly observed language and the number of bytes written in it 
        newRow = data.frame(Language = fullData$Language[i], totalBytes = fullData$Bytes[i], numberOfAppearances = 1)
        languagesGraphData = rbind(languagesGraphData, newRow)
      }
    }
    return(languagesGraphData)
  }
}

visFullData = CreateGraphData(fullDataCollected)
visLargeData = CreateGraphData(largeData)
visMediumData = CreateGraphData(mediumData)
visSmallData = CreateGraphData(smallData)
visLargeData
?barplot
?abline
visFullData
par(mar=c(11,11,5,1))
barplot(visFullData$totalBytes,names.arg = visFullData$Language,col = 2, las=2,main = "Number of Bytes of Code written in Repos where Language is Most Popular", horiz=TRUE)
abline(v = mean(visFullData$totalBytes))
barplot(visFullData$numberOfAppearances,names.arg = visFullData$Language,col = 4, las=2, main = "Number of Repos where Language is Most Popular",ylab="Number of Repos")
