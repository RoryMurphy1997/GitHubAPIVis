#Loads functions from R file to test
source("Interrogate API.R")

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

#Use API to get repositories
req <- GET("https://api.github.com/repositories", gtoken)
stop_for_status(req)
json1 = content(req)
gitReposDF = jsonlite::fromJSON(jsonlite::toJSON(json1))
gitMicrosisRepo = gitReposDF[gitReposDF$node_id == "MDEwOlJlcG9zaXRvcnk0OA==",]
gitRubiniusRepo = gitReposDF[ gitReposDF$node_id == "MDEwOlJlcG9zaXRvcnkyNw==",]
gitTwoRepos = rbind(gitMicrosisRepo, gitRubiniusRepo)

  
# Use API to find Microsis Languages
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/repos/Caged/microsis/languages", gtoken)
stop_for_status(req)
json1 = content(req)
gitMicrosisDF = jsonlite::fromJSON(jsonlite::toJSON(json1))
gitMicrosisDF
#Number = Number of bytes of code written in the language
is.element("Ruby", names(gitMicrosisDF)[])
match("JavaScript", names(gitMicrosisDF))
gitMicrosisDF

# Use API to find rubinius Languages
req <- GET("https://api.github.com/repos/rubinius/rubinius/languages", gtoken)
stop_for_status(req)
json1 = content(req)
gitRubiniusDF = jsonlite::fromJSON(jsonlite::toJSON(json1))
print(gitRubiniusDF[1])
print(as.numeric(gitRubiniusDF[1]))

#Test PopularLanguages 

#1. Given an empty data frame, returns NULL and error message
PopularLanguages(NULL)

#2. Given a data frame with no languages_url value, returns null
DFTest = data.frame(Name = c("Sandra", "John"))
PopularLanguages(DFTest)

#3. Given a data frame of one repository, returns the most popular language use
#Should be Javascript (bytes = 124846)
PopularLanguages(gitMicrosisRepo)

#4. Given a data frame with more than one repository, returns the most popular language of each repository
#Should be JavaScript (bytes = 124846) and C (bytes = 23614738)
PopularLanguages(gitTwoRepos)
