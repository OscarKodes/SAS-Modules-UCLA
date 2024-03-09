* #############################################################
  DESCRIPTIVE STATISTICS ##########################

	This module illustrates how to obtain basic descriptive 
	statistics using SAS. We illustrate this using a data file 
	about 26 automobiles with their make, price, mpg, repair 
	record, and whether the car was foreign or domestic. 
	The data file is illustrated below.
;



* ==========================================================
	The program below reads the data and creates a temporary 
	data file called auto.  The descriptive statistics shown 
	in this module are all performed on this data file 
	called auto.
;

DATA auto;
  input MAKE $ PRICE MPG REP78 FOREIGN;
DATALINES;
AMC    4099 22 3 0
AMC    4749 17 3 0
AMC    3799 22 3 0
Audi   9690 17 5 1
Audi   6295 23 3 1
BMW    9735 25 4 1
Buick  4816 20 3 0
Buick  7827 15 4 0
Buick  5788 18 3 0
Buick  4453 26 3 0
Buick  5189 20 3 0
Buick 10372 16 3 0
Buick  4082 19 3 0
Cad.  11385 14 3 0
Cad.  14500 14 2 0
Cad.  15906 21 3 0
Chev.  3299 29 3 0
Chev.  5705 16 4 0
Chev.  4504 22 3 0
Chev.  5104 22 2 0
Chev.  3667 24 2 0
Chev.  3955 19 3 0
Datsun 6229 23 4 1
Datsun 4589 35 5 1
Datsun 5079 24 4 1
Datsun 8129 21 4 1
;
RUN;

PROC PRINT DATA=auto(OBS=10);
RUN;


* ==============================================
	FREQUENCY TABLES 
;

* This creates a frequency table for the "make" variable
	from the "auto" dataset;
PROC FREQ DATA=auto;
	TABLES make;
RUN;

* This creates a frequency table for the "rep78" variable
	from the "auto" dataset;
PROC FREQ DATA=auto;
	TABLES rep78;
RUN;

* This creates a frequency table for the "foreign" variable
	from the "auto" dataset;
PROC FREQ DATA=auto;
	TABLES foreign;
RUN;


* Instead of having three separate proc freqs, 
	we could have done this all in one proc freq step 
	as illustrated below.  The output will be the same 
	as shown above.;
PROC FREQ DATA=auto;
	TABLES make rep78 foreign;
RUN;


* CROSS TABULATION --------------------------
	Just add a "*" sign in between the variables
;

PROC FREQ DATA=auto;
	TABLES rep78 * foreign;
RUN;


* We can show just the cell percentages to make the 
	table easier to read by using the norow, nocol and 
	nofreq options on the tables statement to suppress 
	the printing of the row percentages, column percentages 
	and frequencies (leaving just the cell percentages).  
	Note that the options come after the forward slash ( / ) 
	on the tables statement.;
PROC FREQ DATA=auto;
	TABLES rep78 * foreign / NOROW NOCOL NOFREQ;
RUN;

* using nopercent and leaving only frequency & column;
PROC FREQ DATA=auto;
	TABLES rep78 * foreign / NOROW NOPERCENT;
RUN;

* The order of the options does not matter.  
	We would have gotten the same output had we 
	written the command like this.;
PROC FREQ DATA=auto;
  TABLES rep78 * foreign / NOFREQ NOROW NOCOL;
RUN; 




* ==============================================
	SUMMARY STATISTICS 
	
	Proc means can be used to produce summary statistics.  
	Below, proc means is used to get descriptive 
	statistics for the variable mpg.
;

PROC MEANS DATA=auto;
	VAR mpg;
RUN;

* SEPERATE SUMMARY STATISTICS BY CLASS-------------------
;
PROC MEANS DATA=auto;
	CLASS foreign;
	VAR mpg;
RUN;




* ==============================================
	PROC UNIVARIATE
	
	You can use proc univariate to get more 
	detailed summary statistics, as shown below.
;
PROC UNIVARIATE DATA=auto;
	VAR mpg;
RUN;

* We can use the class statement to obtain separate 
univariate results for foreign and domestic cars.;
PROC UNIVARIATE DATA=auto;
  CLASS foreign;
  VAR mpg;
RUN; 





* ==============================================
	PROBLEMS TO LOOK OUT FOR
;


*
	If you make a crosstab with proc freq and 
	one of the variables has large number of values 
	(say 10 or more) the crosstab table could be very 
	hard to read.  
	
	In such cases, try using the list option on the 
	tables statement.  
;

* compare the two proc steps below;
PROC FREQ DATA=auto;
	TABLES rep78 * foreign;
RUN;

PROC FREQ DATA=auto;
	TABLES rep78 * foreign / LIST;
RUN;




*
	When using the by statement in PROC UNIVARIATE, 
	if you choose a CLASS variable with a large number of 
	values (say 5, 10, or more) it will produce a very 
	large amount of output. In such cases, you may try 
	to use PROC MEANS with a CLASS statement instead of 
	PROC UNIVARIATE.
;

* compare the two proc statements below;
PROC UNIVARIATE DATA=auto;
	CLASS price;
	VAR mpg;
RUN;


PROC MEANS DATA=auto;
	CLASS price;
	VAR mpg;
RUN;


* NOTE: When trying to group data by a continuous variable
	it is best to use grouping bins, but in this case
	we just wanted to show an example of classifying
	the data by a variable with many different possible values;









