#Run these 3 lines once to install necessary packages
install.packages("jsonlite")
install.packages("httpuv")
install.packages("httr")

#Run these 3 lines the first time code is run
library(jsonlite)
library(httpuv)
library(httr)

# Run from here each time
oauth_endpoints("github")

myapp <- oauth_app(appname = "Software_Engineering_GitHub_Assignment",
                   key = "9cdd2af0684fe05044a7",
                   secret = "a58134728046024f716360e2b7bf4c97210e38fe")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API to find users
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/RoryMurphy1997/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitReposDF = jsonlite::fromJSON(jsonlite::toJSON(json1))
#Gives null for dataframe with one item, need to fix
nrow(gitReposDF)
if(is.null(nrow(gitReposDF)))
{
  print("Repository is empty")
}else{
  for(i in 1:nrow(gitReposDF))
  {
    print(gitReposDF$full_name)
  }
}

# Subset data.frame
gitReposDF[gitReposDF$full_name == "jtleek/datasharing", "created_at"] 
