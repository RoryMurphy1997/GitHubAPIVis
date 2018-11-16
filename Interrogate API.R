#Installs relevant packages only if they arent already installed
if (!require("pacman")) install.packages("pacman")
pacman::p_load("jsonlite", "httpuv", "httr", "devtools")


#Opens necessary libraries
library(jsonlite)
library(httpuv)
library(httr)
library(devtools)

#Installs the r2d3 library
install_github("rstudio/r2d3")


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
Languages

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
        #Find most popular language for the repository
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
Contributions


