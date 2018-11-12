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

#Initialise first item in languages used dataframe
reqTemp = GET(paste(gitReposDF$languages_url[1]), gtoken)
stop_for_status(reqTemp)
jsonTemp = content(reqTemp)
gitLanguagesUsedDF = jsonlite::fromJSON(jsonlite::toJSON(jsonTemp))
length(gitLanguagesUsedDF)

#Finds languages used by each repository and increases count of each one found by 1 and number of bytes used
for(i in 2:length(gitReposDF))
{
  reqTemp = GET(paste(gitReposDF$languages_url[i]), gtoken)
  stop_for_status(reqTemp)
  jsonTemp = content(reqTemp)
  dataFrameTemp = jsonlite::fromJSON(jsonlite::toJSON(jsonTemp))
  #Checks if repository actually has any languages listed
  if(length(dataFrameTemp) == 0)
  {
    
  }else
  {
    #For each column in temporary data frame, checks whether is appears in current data frame, adding number of bytes of
    #code used in the current repository being searched in the language to the total amount of bytes of a language used
    #if the language is already in the data frame or adding the new language and the number of bytes used by the current
    #repository of it to the total data frame
    for(j in 1:length(dataFrameTemp))
    {
      if(is.element(names(dataFrameTemp)[j], names(gitLanguagesUsedDF)))
      {
        #Add total number of bytes to existing column
        index = match(names(dataFrameTemp)[j], names(gitLanguagesUsedDF))
        gitLanguagesUsedDF[index] = as.numeric(gitLanguagesUsedDF[index]) + as.numeric(dataFrameTemp[j])
        
      }else
      {
        #Sets up new column
        gitLanguagesUsedDF$temp = as.numeric(dataFrameTemp[j])
        names(gitLanguagesUsedDF)[which(names(gitLanguagesUsedDF) == "temp")] <- names(dataFrameTemp)[j]
      }
    }
  }
}
gitLanguagesUsedDF


# Find Microsis repository
gitMicrosis = gitReposDF[gitReposDF$name == "microsis",] 

#Get languages used in Microsis repository
gitMicrosis$languages_url
req2 = GET(paste(gitMicrosis$languages_url), gtoken)
stop_for_status(req2)
json2 = content(req2)
gitMicrosisLanguagesDF = jsonlite::fromJSON(jsonlite::toJSON(json2))
#Number = Number of bytes of code written in the language
is.element("Ruby", names(gitMicrosisLanguagesDF)[])
match("JavaScript", names(gitMicrosisLanguagesDF))
gitMicrosisLanguagesDF[1]
