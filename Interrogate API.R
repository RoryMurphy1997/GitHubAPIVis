#Installs relevant packages only if they arent already installed
if (!require("pacman")) install.packages("pacman")
pacman::p_load("jsonlite", "httpuv", "httr")


#Opens necessary libraries
library(jsonlite)
library(httpuv)
library(httr)


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
gitReposDF$name

# Find Microsis repository
gitMicrosis = gitReposDF[gitReposDF$name == "microsis",] 

#Get languages used in Microsis repository
gitMicrosis$languages_url
req2 = GET(paste(gitMicrosis$languages_url), gtoken)
stop_for_status(req2)
json2 = content(req2)
gitMicrosisLanguagesDF = jsonlite::fromJSON(jsonlite::toJSON(json2))
gitMicrosisLanguagesDF
