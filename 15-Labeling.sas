* ########################################################
	LABELING #############################################
	
	This module illustrates how to create and use labels in SAS.
	
	There are two main items that can be labeled, variables and 
	values. 
	
	Once created these labels will appear in the output 
	of statistical procedures and reports that you may produce 
	from SAS. They are also displayed by some of the SAS/GRAPH 
	procedures.

	The program below reads the data and creates a temporary 
	data file called auto.  The labeling shown in this 
	module are all applied to this data file called auto.
;

DATA auto;
	INPUT make $ mpg rep78 weight foreign;
CARDS;
AMC     22 3 2930 0
AMC     17 3 3350 0
AMC     22 . 2640 0
Audi    17 5 2830 1
Audi    23 3 2070 1
BMW     25 4 2650 1
Buick   20 3 3250 0
Buick   15 4 4080 0
Buick   18 3 3670 0
Buick   26 . 2230 0
Buick   20 3 3280 0
Buick   16 3 3880 0
Buick   19 3 3400 0
Cad.    14 3 4330 0
Cad.    14 2 3900 0
Cad.    21 3 4290 0
Chev.   29 3 2110 0
Chev.   16 4 3690 0
Chev.   22 3 3180 0
Chev.   22 2 3220 0
Chev.   24 2 2750 0
Chev.   19 3 3430 0
Datsun  23 4 2370 1
Datsun  35 5 2020 1
Datsun  24 4 2280 1
Datsun  21 4 2750 1
;
RUN;

PROC CONTENTS DATA=auto;
RUN;


* Creating variable labels ===========================

	We use the label statement in the data step to assign 
	labels to the variables.  You could also assign labels 
	to variables in proc steps, but then the labels only 
	exist for that step.  When labels are assigned in the 
	data step they are available for all procedures that 
	use that data set.

	The following program assigns variable labels to 
	rep78, mpg and foreign.
;

DATA auto2;
	SET auto;
	LABEL rep78 = "1978 Repair Record"
		mpg = "Miles Per Gallon"
		foreign = "Where Car Was Made";
RUN;

PROC CONTENTS DATA=auto2;
RUN;


* These labels will also appear on the output of other 
	procedures giving a fuller description of the variables 
	involved.  This is demonstrated in the proc means below.;
PROC MEANS DATA=auto2;
RUN;





* Creating and using value labels =============================

	Labeling values is a two step process.  
	
	First, you must 
	create the label formats with proc format using a value 
	statement.  
	
	Next, you attach the label format to the 
	variable with a format statement.  
	
	This format statement 
	can be used in either proc or data steps.  
	
	An example of 
	the proc format step for creating the value formats, 
	forgnf and $makef follows.
;
PROC FORMAT;
	VALUE forgnf 0="domestic"
				1="foreign";
	VALUE $makef "AMC" = "American Motors"
				"Buick" = "Buick (GM)"
				"Cad." = "Cadillac (GM)"
				"Chev." = "Chevrolet (GM)"
				"Datsun" = "Datsun (Nissan)";
RUN;
* You may include any number of value statements to create 
	label formats as needed.  Since make is a variable that 
	contains character values, when you define the formats 
	for it you have to precede the format name with a $ so 
	the format name becomes $makef.  
	
	Additionally, for character variables the values of the 
	variables must be enclosed in quotes. 

	Now that the formats forgnf and $makef have been created, 
	they must be linked to the variables, foreign and make.  
	This is accomplished by including a format statement in 
	either a proc or a data step.  In the program below the 
	format statement is used in a proc freq.;
PROC FREQ DATA=auto2;
	FORMAT foreign forgnf.
		make $makef.;
	TABLES foreign make;
RUN;
* Notice that the formats forgnf. and $makef. are each 
	followed by a period in the format statement.  This is 
	the way that SAS tells the difference between the name 
	of a format and the name of a variable in a format 
	statement. 

	The output of the frequencies procedure for foreign 
	displays the newly defined labels instead of the values 
	of the variable.
	
	The output of the frequencies procedure for make displays 
	the newly defined labels instead of the values of the 
	variable.  Values for which formats haven’t been defined 
	(Audi and BMW) appear in the table without modification.
	
	
	If you link formats to variables in a data step where a 
	permanent file is created, then every time you use that 
	file SAS expects to find the formats.  Thus you will 
	have to supply the proc format code in each program that 
	uses the file.  Since this can make each of your 
	programs much longer than you might like, I would like 
	to provide a tip for accomplishing this task without 
	repeating the code for the proc format in every program.  
	Assuming that a small program containing only the proc 
	format is stored in a file called fmats.sas in a 
	directory on your C: drive called myfiles, the following 
	statement will bring that code into your current program:
	
	%INCLUDE ‘C:myfilesfmats.sas’
	
	This should save time and make maintenance of your 
	programs easier.  The remainder of your program would 
	follow this statement.
;


* PROBLEMS TO LOOK OUT FOR --------------------------------

	Common errors in dealing with value labels are
	
		1) leaving off the period at the end of the format 
			in a format statement
			
		2) leaving off the dollar sign before a character 
			format.
			
	If you leave out the proc format code in a program using 
	a permanent file where formats are defined SAS will 
	require the formats be available for use.  In this 
	case you can either follow the instructions for 
	including code (%include) above, or copy the proc format 
	code into your current program.  You can also include 
	the nofmterr option to allow the program to run with out 
	errors.

	Another common error is to reference the format with a 
	format statement before defining the format with proc 
	format code.  Simply move your proc format code to the 
	beginning of the program to fix this problem.
;
	
	













