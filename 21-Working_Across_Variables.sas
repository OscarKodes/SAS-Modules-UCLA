* WORKING ACROSS VARIABLES #####################################

	This module illustrates: 
	
	(1) how to compute variables manually in a data step and 
	
	(2) how to work across variables using the array statement 
		in a data step.

	Consider the sample program below, which reads in family 
	income data for twelve months.
;

DATA faminc;
	INPUT famid faminc1-faminc12;
CARDS;
1 3281 3413 3114 2500 2700 3500 3114 3319 3514 1282 2434 2818
2 4042 3084 3108 3150 3800 3100 1531 2914 3819 4124 4274 4471
3 6015 6123 6113 6100 6100 6200 6186 6132 3123 4231 6039 6215
;
RUN;

PROC PRINT DATA=faminc;
RUN;


* Computing variables (manually) =============================

	Computing variables in a data step can be accomplished a 
	number of ways in SAS. For example, if one wanted to 
	compute the amount of tax (10%) paid for each month, 
	the simplest way to do this is to compute 12 variables 
	(taxinc1-taxinc12) by multiplying each of the 
	(faminc1-faminc12) by .10 as illustrated below.  
	
	As you see, this requires entering a command computing 
	the tax for each month of data (for months 1 to 12).
;

DATA faminc1a;
	SET faminc;
		taxinc1 = faminc1 * .10;
		taxinc2 = faminc2 * .10;
		taxinc3 = faminc3 * .10;
		taxinc4 = faminc4 * .10;
		taxinc5 = faminc5 * .10;
		taxinc6 = faminc6 * .10;
		taxinc7 = faminc7 * .10;
		taxinc8 = faminc8 * .10;
		taxinc9 = faminc9 * .10;
		taxinc10 = faminc10 * .10;
		taxinc11= faminc11 * .10;
		taxinc12 = faminc12 * .10;
RUN;

PROC PRINT DATA=faminc1a;
RUN;



* Computing variables (using the array statement) =============

	Another way to compute 12 variables representing the 
	amount of tax paid (10%) for each month is to use the 
	array statement.  
	
	In the example below, two "arrays" are declared:  
		Afaminc and Ataxinc.  
		
	The elements of Afaminc are the variables faminc1-faminc12 
	and the elements of Ataxinc are the variables 
	taxinc1-taxinc12.  
	
	You can refer to the variables faminc1-faminc12 by 
	referring to the elements of the array Afaminc.  
	
	For example, Afaminc(3) refers to faminc3.

	Note that the array Afaminc is defined using the 
	existing variables faminc1-faminc12 from the dataset
	faminc, whereas the values of the array Ataxinc 
	(taxinc1-taxinc12) are created by multiplying Afaminc 
	(faminc1-faminc12) by .10 in the do loop shown below.  
;


DATA faminc1b;

	* "SET" Reads an observation from one or more 
		SAS data sets.;
	SET faminc;
	
	* "ARRAY" Defines elements of an array.;
	ARRAY Afaminc(12) faminc1-faminc12;
	ARRAY Ataxinc(12) taxinc1-taxinc12;
	
	DO month = 1 TO 12;
		Ataxinc(month) = Afaminc(month) * .10;
	END;
RUN;

PROC PRINT DATA=faminc1b;
	VAR faminc1-faminc12 taxinc1-taxinc12;
RUN;


* In summary, the new variables become new columns of the 
	dataset faminc1b and one can compute new variables as 
	transformations of these variables, just like any other 
	variables.  

	Note that the array statement cannot loop over 
	observations for any one variable.  
	
	If your data are in this “long” form and you need to 
	loop over observations, you must reshape the data to 
	“wide” form in order to use the array statement.  
	
	Another option for looping across observations in the 
	“long” form is to read the variable into a vector 
	array using proc iml (Interactive Matrix Language), 
	loop over the elements of the vector, and then append 
	the results back to the SAS dataset using proc append.;
	

* Collapsing across variables (manually) =================

	Often one needs to sum across variables (also known as 
	collapsing across variables).  
	
	For example, let’s say the quarterly income for each 
	family is desired.  In order to get this information, 
	four quarterly variables incqtr1-incqtr4 need to be 
	computed. Again, this can be achieved manually or 
	by using the array statement. Below is an example of 
	how to compute four quarterly income variables 
	incqtr1-incqtr4 by simply adding together the months 
	that comprise a quarter.
;

DATA faminc2a;
	SET faminc;
		incqtr1 = faminc1 + faminc2 + faminc3;
		incqtr2 = faminc4 + faminc5 + faminc6;
		incqtr3 = faminc7 + faminc8 + faminc9;
		incqtr4 = faminc10 + faminc11 + faminc12;
RUN;

PROC PRINT DATA=faminc2a;
	VAR faminc1-faminc12 incqtr1-incqtr4;
RUN;



* Collapsing across variables (using the array statement) =====

	This same result as above can be achieved using the 
	array statement. 
	
	The example below illustrates how to compute the quarterly 
	income variables incqtr1-incqtr4 using the array 
	statement in a more elegant fashion.  
	
	The array Aincqtr has four elements which are computed 
	in the do loop as the sum of sets of three months.  
	
	The trick here is that the quarterly intervals begin 
	with months 1,4,7 and 10 respectively, which can be 
	indexed as (month3 – 2)  where month3 is the set of 
	numbers {3,6,9,12}during the execution of the do loop.  
	
	Hence, the first element of the array Aincqtr is equal 
	to the sum of the first three elements of Afaminc, 
	the second element of the array Aincqtr is equal to the 
	sum of the next three elements of Afaminc, etc., 
	until the do loop is finished, as shown below.
;

DATA faminc2b;
	SET faminc;

	ARRAY Afaminc(12) faminc1-faminc12;
	ARRAY Aincqtr(4) incqtr1-incqtr4;
	
	DO qtr = 1 TO 4;
		month3 = 3*qtr;
		Aincqtr(qtr) = 
			Afaminc(month3-2) + 
			Afaminc(month3-1) +
			Afaminc(month3);
	END;
RUN;

PROC PRINT DATA=faminc2b;
	VAR faminc1-faminc12 incqtr1-incqtr4;
RUN;



* Identifying patterns across variables 
	(using the array statement) ===============================
	
	The array statement can also be used to identify patterns 
	across variables of a dataset.  
	
	Let’s say, for example, that one needs to know which 
	months had income that was less than half of the income 
	of the previous month. 
	
	To obtain this information, dummy indicators can be 
	created to indicate in which months this occurred. 
	
	In the example below, two arrays are defined, Afaminc 
	and Alowinc, and the elements of Afaminc and Alowinc are 
	the variables faminc1-faminc12 and lowinc2-lowinc12, 
	respectively, in the SAS dataset faminc4.  

	Note that only 11 dummy indicators are needed for a 
	12 month period because the interest is in the change 
	from one month to the next.  
	
	In the DO loop, when a month has income that is 
	less than half of the income of the previous month, 
	the dummy indicators lowinc2-lowinc12 get assigned a “1”. 
	When this is not the case, they are assigned a “0”.  

	Lastly, a character variable named ever is created 
	(with help from the array statement) indicating whether 
	or not there were any months where income was less than 
	half of the income of the previous month.  
	
	This is accomplished by summing up all of the elements 
	of Alowinc (which contains 1’s and 0’s).  
	
	If the sum of the elements of Alowinc is greater than 
	zero, than there was at least one month where income 
	was less than half of the previous month, and ever 
	equals “Y”.  
	
	Otherwise, if there were no months where income was 
	less than half of the previous month, the sum of the 
	elements of Alowinc is zero, and ever equals “N”. 
;

DATA faminc4;
	SET faminc;
	
	ARRAY Afaminc(12) faminc1-faminc12;
	ARRAY Alowinc(2:12) lowinc2-lowinc12;
	
	DO month = 2 to 12;
		IF Afaminc(month) < Afaminc(month-1) / 2 THEN alowinc(month) = 1;
			ELSE Alowinc(month) = 0;
	END;
	
	sum_low = 0; /*THIS INITIALIZES sum_low TO ZERO AT THE BEGINNING OF THE LOOP*/;
	DO month = 2 to 12;
		sum_low = sum_low + Alowinc(month);
	END;
	
	IF sum_low GT 0 THEN ever='Y'; *GT (greater than) is the same as < ;
	IF sum_low EQ 0 THEN ever='N'; *EQ (equal) is the same as = ;
RUN;

PROC PRINT DATA=faminc4;
	VAR famid faminc1-faminc12 lowinc2-lowinc12 ever;
RUN;




































