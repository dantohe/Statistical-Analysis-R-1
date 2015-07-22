---
title: "Getting and Cleaning Data Project Readme"
author: "DA"
date: "July 22, 2015"
output: html_document
---
#**Introduction**

**This content and also a complete set of processing steps are available in CodeBook.md.**

#Resources
**The resources are available on Github [here](https://github.com/dantohe/datasciencecoursera/tree/master/GettingandCleaningData/Project).**

##Files

1. run_analysis.R - contains the script that will generate the data (intermediary data (point 4 of the assignment AND also the tidy data set required at point#5).

2. independent_tidy_data_set.txt - the tidy data set which is the solution for point 5 of the project requirement

3. CodeBook.md - the code book for the tidy data set  - describes the features from independent_tidy_data_set.txt

4. README.md - this file

##Running the script and generating the tidy data set

To run and generate the tidy data set follow the next step:

1. download the original data set from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

2. Unpack the content of the zip file 

3. Go inside the unpacked folder and look for the data root: "UCI HAR Dataset"

4. Place there (in "UCI HAR Dataset" directory) run_analysis.R script - the script needs to be at the same level with "test" and "train" directories 

5. Run the script - it is recommended to run the script inside the R Studio - by setting the work directory to the directory where the run_analysis.R  was placed. To run just issue the following command inside the "R Studio" console:  
source('run_analysis.R')

6. By running the above a script independent_tidy_data_set.txt will be created.

