# GitHubAPIVis
Pull data from GitHub API and create a webpage with a visualisation of said data

By running the following lines in R, the interactive visualisation can be displayed fully, with an option to view it in a web browser. This code is also contained in "Test.R" so simply downloading that file and running it will produce the visualisation.

install.packages("shiny")
library(shiny)
runGitHub( "GitHubAPIVis", "RoryMurphy1997") 

The first line installs "Shiny" if you have not already installed it. Shiny is the package used to build the visualisation, the second line will notify R to use Shiny for the third line, which runs the application directly from the R code here on GitHub.

The R file "app.R" is called, which in turn runs "Interrogate API.R". "Interrogate API.R" pulls and processes the relevant data used by the visualisation from GitHub, installing any R packages needed to do so. After this, "app.R" runs the visualisation, updating the graphs in real time when different options (such as orientation) are selected. Thus, if the R code is stopped, the visualisation page will no longer work. Screenshots of the visualisation have been provided in this repository.

Finally, "UnitTesting.R" contains a number of unit tests to ensure the functions used in "Interrogate API.R" work correctly. Screenshots of these have also been provided.

The visualisation itself produces two graphs, one which shows the number of repositories where a given language was the most popular language used in that repository and the second compares the number of bytes written in the most popular language used in the given repositories (in this case a sample of 100 repositories is used). These graphs can be broken down by all 100 repositories, repositories with over 200 commits made, which were considered "large" (of which there were 20 in the sample), repositories with between 200 and 50 commits made, which were considered "medium" sized (of which there were 19 in the sample), and repositories with less 50 than commits made, which were considered "small" (of which there were 61 in the sample). Thus, one can see which languages were popular for different sized repos and the amount of code written in said languages in different sized repos, giving a better understanding of the popularity of different languages for larger and smaller projects as well as which languages have more code written for them than others.

Furthermore, both graphs can individually be shown in vertical and horizontal orientation, and the two graphs can also be sorted "By Language" whereby both graphs show their languages in the same order, or in "ascending" or "descending" order of size.
