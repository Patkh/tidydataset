
Introduction
------------

One of the most exciting areas in all of data science right now is wearable computing. 

The data used in this project is the data collected from the accelerometers from the Samsung Galaxy S smartphone. The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, they captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data for the project was obtained from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Features
--------
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

Time-Domain Variables
-------------------
The time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. The acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

There are two time domain variables - Acceleration and Angular velocity.

a) Acceleration variables
-------------------------
Body acceleration variables

tbodyacc[xyz]     : Body acceleration signal obtained from raw signal using low-pass
                    butterworth signal. 
tbodyaccjerk[xyz] : Jerk Signal obtained from body linear acceleration signal (tbodyacc[xyz])
tbodyaccmag       : Magnitude of body acceleration computed using Euclidean norm

Gravity variables

tgravityacc[xyz]  : Gravity acceleration signal obtained from raw signal using low pass 
                    butterworth signal.  
tgravityaccmag    : Magnitude of gravity acceleration calculated using Euclidean norm
tbodyaccjerkmag   : Magnitude of body acceleration jerk signal calculated using Euclidean norm

b) Angular velocity variables. 

tbodygyro[xyz]    : Body's Angular velocity signal obtained from raw signal tGyro-XYZ using low
                    pass butterworth signal. 
tbodygyrojerk[xyz]: Jerk Signal obtained from angular velocity signal(tbodygyro[xyz]) 
tbodygyromag      : Magnitude of body gyro signal calculated using Euclidean norm
tbodyyrojerkmag   : Magnitude of gyro jerk signal calculated using Euclidean norm

Frequencey Domain Variables
---------------------------
fbodyacc[xyz]     : Body acceleration signal obtained using FFT along 3 axes   
fbodyaccjerk[xyz] : Jerk Signal obtained from from body acceleration using FFT along 3 axes
fbodyaccmag       : Body acceleration magnitude obtained using Euclidean norm
fbodyaccjerkmag   : Jerk Magnitude obtained using Euclidean norm
fbodygyro[xyz]    : Body gyro signal obtained using FFT along three axes
fbodyGyroMag      : Magnitude of body gyro signal obtained using Euclidean norm
fbodygyrojerkmag  : Magnitude of gyro jerk signal obtained using Eucldean norm

'f' is used to indicate frequency domain signals.

Variables based on time domain and frequency domain signals
------------------------------------------------------------
The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. 
These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

Column naming convention
---------------------------------
The column name is a combination of either Time-Domain or Frequency domain variables and statistical operation performed on it. 
E.g. tbodyaccmeanx - Mean of body acceleration signal on x-axis
     tbodyaccmeany - Mean of body acceleration signal on y-axis
     tbodyaccstdx  - standard deviation of body acceleration signal on x-axis
     
Overall, there are 561 such variables 
     

DATA CLEANING and TRANSFORMATIONS
---------------------------------

In the test and training data-sets, the actual data was stored in three different files

a) X_test.txt/X_train.txt : These files contain the 561 variables values for each of 30 
                            subjects.
b) Y_test.txt/Y_train.txt : These files contain activity information such as walking, laying
c) subject_test.txt/subject_train.txt: Contains corresponding subject i.e person performing the
                            test. This is a number from 1 to 30.

Transformations
-------------------
Step 1: Combine the files from the test and training data sets individually
-------
Combine the subject file (subject_test), activity (Y_test) file and variables data (X_test) for the "test" set. Since there is 1x1 corresponence between the rows of these files, we will do a column bind (cbind) first in the same order - subject, activity and variables and
obtain a data frame with following dimensions

testtbl  <- 2947 observations of 563 variables

Repeat a similar step for training set. We get a data frame traintbl 
with 7352 observations of 563 variables

Step 2:- Combine the test and training data sets
-------
Using rbind to combine the test and training datasets. This gives a new table (finaltbl)
which has 10299 observations of 563 variables

Step 3:- Make the activity column descriptive.
------
The activity column contains integer 1 to 6. These need to be transformed into activity labels
such as walking, walking_downstairs, walking_upstairs, sitting, standing, laying.
This information is present in activity_labels.txt file.

Using this information from activity_labels.txt, the activity column (column 2) is transformed into a factor variable whose levels represent the activity.

Step 4: Make descriptive variable names
------
a) The column labels for the 3rd to 563 column are present in the file "features.txt"
  This file is read into a variable colnames.
b) The character "-" hyphen and comma "," are removed from the names as per the criteria for
   naming variables 
c) A character vector containing the strings "subject" (for 1st colum), "activity" (for 2nd  column) and the variables names transformed in step b are combined into one. These are 
set as the column names in the combined test and training table (finaltbl)

Note that we don't remove parentheses () from the column names as we need to search for pattern mean() later.


Step 5: Creating new data frame comprising of mean and std variables
------
We need to create a data frame comprising of subject, activity and other columns containings "std"" (for standard deviation) and "mean()"" (for mean) in their names. 
Note we exclude certain columns with names such as angle(tBodyGyroMean,gravityMean) as here we are just computing the angle and mean happens to be in the name of variables tBodyGyroMean and gravityMean

a) We first grep for these patterns "mean()|std|subject|activity"and create the table tidytbl
b) The parentheses "()"" is then removed from the column names

Step 6: Calculate the averages of variables
------
a) The dataframe is the grouped-by subject and activity columns
b) Use summarize_all function to calcuate mean

This produces a tidy dataset which has 180 observations of 68 columns (180x68 columns)
This is written  to a file using write.table method.
