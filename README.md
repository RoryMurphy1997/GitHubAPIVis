# GitHubAPIVis
Pull data from GitHub API and create a webpage with a visualisation of said data

By running the following lines in R, the interactive visualisation can be displayed fully, with an option to view it in a web browser. This code is also contained in "Test.R" so simply downloading that file and running it will produce the visualisation.

install.packages("shiny")
library(shiny)
runGitHub( "GitHubAPIVis", "RoryMurphy1997") 

The first line installs "Shiny" if you have not already installed it. Shiny is the package used to build the visualisation, the second line will notify R to use Shiny for the third line, which runs the application directly from the R code here on GitHub.

The R file "app.R" is called, which in turn runs "Interrogate API.R". "Interrogate API.R" pulls and processes the relevant data used by the visualisation from GitHub, installing any R packages needed to do so. After this, "app.R" runs the visualisation, updating the graphs in real time when different options (such as orientation) are selected. Thus, if the R code is stopped, the visualisation page will no longer work. Screenshots of the visualisation have been provided in this repository.

Finally, "UnitTesting.R" contains a number of unit tests to ensure the functions used in "Interrogate API.R" work correctly. Screenshots of these have also been provided.

