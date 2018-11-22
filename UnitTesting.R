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
gtoken <- config(token = github_token)

#Use API to get repositories
req <- GET("https://api.github.com/repositories", gtoken)
stop_for_status(req)
json1 = content(req)
gitReposDF = jsonlite::fromJSON(jsonlite::toJSON(json1))
gitMicrosisRepo = gitReposDF[gitReposDF$node_id == "MDEwOlJlcG9zaXRvcnk0OA==",]
gitRubiniusRepo = gitReposDF[ gitReposDF$node_id == "MDEwOlJlcG9zaXRvcnkyNw==",]
gitJsawesomeRepo = gitReposDF[ gitReposDF$node_id == "MDEwOlJlcG9zaXRvcnkyOQ==",]
gitTwoRepos = rbind(gitMicrosisRepo, gitRubiniusRepo)
gitJSRepos = rbind(gitMicrosisRepo,gitJsawesomeRepo)

  
# Use API to find Microsis Languages
req <- GET("https://api.github.com/repos/Caged/microsis/languages", gtoken)
stop_for_status(req)
json1 = content(req)
gitMicrosisDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Use API to find rubinius Languages
req <- GET("https://api.github.com/repos/rubinius/rubinius/languages", gtoken)
stop_for_status(req)
json1 = content(req)
gitRubiniusDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

#Test PopularLanguages, the values have been cross checked manually using GitHub API on a web browser.

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

#Test ContributionsMade, the values have been cross checked manually using GitHub API on a web browser.

#1. Given an empty data frame, returns NULL and error message
ContributionsMade(NULL)

#2. Given a data frame with no contributors_url value, returns null
DFTest = data.frame(Name = c("Sandra", "John"))
ContributionsMade(DFTest)

#3. Given a data frame of one repository, returns the number of commits and number of contributors to this repository
#Should be 16 commits from 1 contributor
ContributionsMade(gitMicrosisRepo)

#4. Given a data frame with more than one repository, returns the number of commits and number of contributors to
#each repository
#Should be 16 commits and one contributor and  14599 commits by 30 contributors
ContributionsMade(gitTwoRepos)

#Test CreateDGraphData, the values have been cross checked manually using GitHub API on a web browser.

#1. Given an empty data frame, returns NULL and error message
CreateGraphData(NULL)

#2. Given a data frame with no Bytes value, returns null and error message
DFTest = data.frame(Language = c("Sandra", "John"))
CreateGraphData(DFTest)

#3. Given a data frame with no Language value, returns null and error message
DFTest = data.frame(NBytes = c("Sandra", "John"))
CreateGraphData(DFTest)

#4. Given data for one repository, returns relevant information for visualising said data.
#Should be 124846 totalBytes and 1 appearance for javascript
temp = cbind(ContributionsMade(gitMicrosisRepo),PopularLanguages(gitMicrosisRepo)[,-1])
CreateGraphData(temp)

#5. Given data for two repositories with different popular languages, returns relevant information for visualising said
#data.
#Should be 124846 totalBytes and 1 appearance for javascript and
#23614738 bytes and 1 apearance for C
temp2 = cbind(ContributionsMade(gitTwoRepos),PopularLanguages(gitTwoRepos)[,-1])
CreateGraphData(temp2)

#6. Given two repositories with same most pipular languages, combines number of bytes of language written.
#Should be 2 appearences and 251434 bytes of data
temp3 = cbind(ContributionsMade(gitJSRepos),PopularLanguages(gitJSRepos)[,-1])
temp3
CreateGraphData(temp3)
