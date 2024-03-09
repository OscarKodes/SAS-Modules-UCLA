* RESHAPING DATA WIDE TO LONG USING A DATA STEP ################

	There are several ways to reshape data. 
	
	You can reshape the data using proc transpose or reshape 
	the data in a data step.  
	
	The following will illustrate how to reshape data from wide 
	to long using the data step.
	
	
	We will begin with a small data set with only one 
	variable to be reshaped.
;

DATA wide;
	INPUT famid faminc96-faminc98;
CARDS;
1 40000 40500 41000 
2 45000 45400 45800 
3 75000 76000 77000 
; 
RUN;

PROC PRINT DATA=wide;
RUN;


* The technique we will use to reshape this data set works 
	well if you have only a few variables to be reshaped.  
	
	We will create a new variable called year, which will be 
	set equal to each year for which we have data.  
	
	After setting the variable year equal to a year in our data 
	set, we will set the value of another new variable, 
	faminc, equal to the value of the faminc variable 
	(faminc96, faminc97 or faminc98) for that year.  
	
	Next, we will use the output statement to have SAS 
	output the results to the data set.  
	
	Note that if you do not include an output statement 
	after creating the variables for that year, that year 
	will not be included in the new data set.  
	
	Finally, we will use the drop statement to drop faminc96, 
	faminc97 and faminc98 from our data set once we have 
	finished reshaping it.
;

DATA long1;
	SET wide;
	
	year = 96;
	faminc = faminc96;
	OUTPUT;
	
	
	year = 97 ;
  	faminc = faminc97 ;
  	OUTPUT ;
 
  	year = 98 ;
  	faminc = faminc98 ;
  	OUTPUT ;

  	DROP faminc96-faminc98 ;
RUN;

PROC PRINT DATA=long1;
RUN;

* Let’s look at the data to ensure that the reshaping worked 
	as we expected.  We will run a proc print on the long1 
	data file to visually inspect it, and then we will run 
	a proc means on both the original data file, wide, and 
	the new data file, long1, to compare the descriptive 
	statistics.;
	
PROC MEANS DATA=long1 FW=8 ;
  CLASS year;
  VAR faminc;
RUN;

* To ensure that the reshaping was successful, 
	we need to compare the output of the proc means for 
	both the old and the new data sets.  
	
	All of the descriptive statistics for faminc96 in the 
	first output should be the same as those for year 96 
	in the second output.  
	
	For example, we see that there are three observations 
	for faminc96, the mean is 53333.3, the standard deviation 
	is 18929.7, the minimum is 40000.0 and the maximum is 
	75000.0.   
	
	These are the exact values that we see in 
	second output for year 96.  
	
	Likewise, we compare the row in the first output for 
	faminc97 with the corresponding row in the second 
	output and see that they are exactly the same.  
	
	This is also the case for the third variable, faminc98.  
	
	While this is not absolute proof that the reshaping was 
	successful, we can be pretty certain that it was.;
	

* Reshaping one variable using an array ==================

	A second method of reshaping variables in a data step is 
	to use an array statement.  
	
	This method is useful if  you have more than a few 
	variables to reshape.  
	
	We will begin with an example using only one variable, 
	and then move on to an example with two variables to be 
	reshaped.

	As in the last example, we want to reshape the variables 
	faminc96, faminc97 and faminc98 into two long variables, 
	year and faminc.  
	
	We will first show you the code used to accomplish this 
	and then explain each piece of the code below.
;

* creating new dataset using the wide dataset;
DATA long1a;
	SET wide;
	
	* Regarding the below array statement, 
		the name of the array is afaminc.
		
		The numbers in parentheses (96:98) indicate the 
		first and last numbers of the series to be reshaped.  
		
		Finally, the actual variable names are listed.  
		
		You can use a dash to indicate the inclusion of 
		consecutive numbers.
		;
	ARRAY afaminc(96:98) faminc96 - faminc98;


	* On the first line of the below do-loop, 
		you put the name of the new variable that will 
		contain the suffix for the old variables.  
	;	
	DO year = 96 to 98;
	
		*   On the second line of the do-loop, we set our new 
			variable (faminc) equal to the value of the array 
			for the given year ( afaminc(year) ), i.e., when year 
			is 96 then afaminc(96) refers to faminc96.;
		faminc = afaminc(year);
		
		*   We then use the output statement to force SAS to 
			output the results before starting the loop over 
			again.  
			
			If this is omitted, only the record for the last 
			observation in each group will be output and you 
			will have only three records in the new data set 
			instead of nine.;
		OUTPUT;
	END;
	
	* Finally, we use the drop statement to drop the variables 
		from the wide data file that have been reshaped and 
		are no longer needed.;
	DROP faminc96 - faminc98;
RUN;

* Below we run proc print on the new data file and proc means 
	on both the old and the new data sets to ensure that the 
	reshaping went as expected.
;
PROC PRINT DATA=long1a ;
RUN ;


PROC MEANS DATA=wide FW=8;
	VAR faminc96-faminc98;
RUN;

PROC MEANS DATA=long1a FW=8;
	CLASS year;
	VAR faminc;
RUN;

* The output from the proc print of the new data set looks 
	as we expect:  
	
	there are three observations per family and the variable 
	year ranges from 96 to 99.  
	
	We also compare the output of the proc means for the old 
	and the new data sets.  
	
	We compare the descriptive statistics for each variable 
	to ensure that they did not change during the course of 
	the reshaping.  
	
	We see that they have not, which is a good indication 
	that the reshaping was successful.
;


* Reshaping two variables using an array ===============

	This example is very similar to the last one except that 
	now we will reshape two variables in the same data step.  
	
	There are three places where this program has been modified 
	from the version shown in the example above.  
	
	They are denoted with a comment to the right of the 
	statement in the program.  
	
	Please note that you can reshape as many variables as 
	you want in a single data step.   
	
	To reshape additional variables, you would add an array 
	statement, another line within the do-loop and drop the 
	reshaped variables for each set of variables to be 
	reshaped.
;

DATA wide2;
	INPUT famid faminc96-faminc98 spend96-spend98;
CARDS;
1 40000 40500 41000 38000 39000 40000 
2 45000 45400 45800 42000 43000 44000 
3 75000 76000 77000 70000 71000 72000 
; 
RUN;

PROC PRINT DATA=wide2;
RUN;

DATA long2;
	SET wide2;
	
	* Create an array with indexes 96,97,98
		fill them with values from faminc96-faminc98
	  Create an array with indexes 96,97,98
		fill them with values from spend96-spend98;
	ARRAY afaminc(96:98) faminc96-faminc98;
	ARRAY aspend(96:98) spend96-spend98;
	
	* Use a DO loop, to loop through 
		indexes 96, 97, and 98 in both arrays
	  Fill in the faminc and spend columns with
	  	values from each of the matching indexes
	  Output the current values (as opposed to only outputting
	  	the end result);
	DO year = 96 to 98;
		faminc = afaminc(year);
		spend = aspend(year);
		OUTPUT;
	END;
	
	* drop the old horizontal data;
	DROP faminc96-faminc98 spend96-spend98;
RUN;
		
PROC PRINT DATA=long2;
RUN;

PROC MEANS DATA=wide2 FW=8 ;
  VAR faminc96-faminc98 spend96-spend98 ;
RUN ;

PROC MEANS DATA=long2 FW=8 ;
  CLASS year ;
  VAR faminc spend ;
RUN ;


* #############################################################
	###########################################################
	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	
	STOPPED SAS LEARNING AT EXAMPLE 4
	
	https://stats.oarc.ucla.edu/sas/modules/
	
	Reshaping data from wide to long via "Data Step"
;















