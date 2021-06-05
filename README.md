# CONTENTS

There are three folders in the replication archive. 

The Data folder contains a .csv file ("plane_data.csv") containing the cleaned data from the experiment. 

The Analysis folder contains a single Analysis script ("Analysis.R"), which reads in the .csv file ("plane_data.csv") from the Data folder. The analysis script then carries out all relevant analysis of the experimental data.

The Design folder contains a single R script ("Design.R"), which declares a design of the experiment and carries out analysis of fake data.

# INSTRUCTIONS FOR REPLICATION

The analyses presented here depend on R Version 4.0.3. Relevant R packages are tidyverse (1.3.0), estimatr (0.30.2), randomizr (0.20.0), DeclareDesign (0.26.0), and xtable (1.8-4). 

In order to replicate the analysis of experimental data, one must download the Data and Analysis folders, and  run the Analysis R script. When running this script, the working directory should be set to the Data folder. The Analysis file reads in and analyzes the data from the experiment ("plane_data.csv"). For each of the regression outputs, the analysis script creates and saves an html table, for a total of four tables. These tables can then be imported, and, if desired, edited, in Microsoft Word. These tables initially report p-values to just two decimal places, which means some very small p-values are written as 0.00. To remedy this  issue, the replicator may edit table entries where applicable using the regression outputs, as has  been done here. 

The analysis script also creates two data visualizations, one per outcome variable. These visualizations depict the treatment ("Paperclip") and control ("No Paperclip") means, with error bars corresponding to the upper and lower bounds of a 95% confidence interval for each group mean.

In order to replicate the design declaration, one must simply download the Design folder and run the Design.R script. 
 
