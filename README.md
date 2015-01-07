# varMode

SPSS Python Extension function to calculate the mode of a set of variables

This function operates parallel to the "mean" function of SPSS, where you can provide a variable list and the function will assign the value of a target variable for a given case to be the mode of that case's values on the variable list. For example, you might have each person in a study rate fifty items. This function could tell you what the most common rating given to those ratings for each person.

This function will only work on numeric variables. If there are multiple values with equivalent counts, the mode will be assigned to whichever value is lowest.

Note that this function cannot be used to calculate the mode of the values within a single variable. However, that can be easily done for numeric variables using the Data --> Aggregate function.

##Usage
**varMode(varList, modeVar)**
* "varList" is a list of strings indicating the variables for which you want the mode
* "modeVar" is a string giving the name of the variable you want assigned to the mode

##Example
**varMode(["rank1", "rank2", "rank3", "rank4", "rank5"], "scoreMode")**
* This will set the value of "scoreMode" for each subject to be equal to be the mode of that subject's five ranks.
