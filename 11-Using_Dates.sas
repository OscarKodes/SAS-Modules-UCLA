* ###############################################################
	USING DATES #################################################

	This module will show how to read date variables, use date 
		functions, and use date display formats in SAS. You 
		are assumed to be familiar with data steps for reading 
		data into SAS, and assignment statements for 
		computing new variables.
		
		The data file used in the first example is presented 
		next.
;



* READING DATES IN DATA =========================================

	The program below reads the data and creates a temporary 
	data file called dates.  Note that the dates are read in 
	the data step, and the format date11. is used to read the 
	date.
;

DATA dates;
	INPUT name $ 1-4 @6 bday date11.;
CARDS;
John  1 Jan 1960
Mary 11 Jul 1955
Kate 12 Nov 1962
Mark  8 Jun 1959
;
RUN;

PROC PRINT DATA=dates;
RUN;
* The output of the proc print is presented below.  Compare the 
	dates in the data to the values of bday. Note that for 
	John the date is 1 Jan 1960 and the value for bday is 0.  
	
	This is because dates are stored internally in SAS as the 
	number of days from Jan 1,1960. Since Mary was born before 
	1960 the value of bday for her is negative (-1635).
	
	
	In order to see the dates in a way that we understand you 
	would have to format the output. We use the date9. format 
	to see dates in the form ddmmmyyyy. This is specified on 
	a format statement.
;
PROC PRINT DATA=dates;
	FORMAT bday date9.;
RUN;





* Let’s look at the following data. At first glance it looks 
	like the dates are so different that they couldn’t be read. 
	
	They do have two things in common:

	1) they all have numeric months,
	2) they all are ordered month, day, and then year.
	
	
	These dates can be read with the same format, mmddyy11. 
	An example of the use of that format in a data step 
	follows.;
DATA dates;
   INPUT name $ 1-4 @6 bday mmddyy11.;
CARDS;
John 1 1 1960
Mary 07/11/1955
Joan 07-11-1955
Kate 11.12.1962
Mark 06081959
;
RUN;
PROC PRINT DATA=dates;
   FORMAT bday date9. ;
RUN;

* There is a wide variety of formats available for use in 
	reading dates into SAS. The following is a sample of some 
	of those formats.
	
	
	Informat   Description        Range   Width    Sample
	--------   -----------        -----   -------  ------
	JULIANw.   Julian date        5-32    5        65001
	           YYDDD
	DDMMYYw.   date values        6-32    6        14/8/1963
	MONYYw.    month and year     5-32    5        JUN64
	YYMMDDw.   date values        6-32    8        65/4/29
	YYQw.      year and quarter   4-32    4        65Q1
	
	
	Consider the following data in which the order is month, 
	year and day.
;
DATA dates;
   INPUT month 1-2 year 4-7 day 9-10;
   bday=MDY(month,day,year);
CARDS;
 7 1948 11
 1 1960  1
10 1970 15
12 1971 10
;
RUN;

PROC PRINT DATA=dates;
   FORMAT bday date9. ;
RUN;
* Notice the function mdy(month,day,year) in the data step. 
	This function is used to create a date value from the 
	individual components. The result of the proc print 
	follows.;





* TWO DIGIT DATES =========================================

	Consider the following data, which are the same as above 
	except that only two digits are used to signify the year, 
	and year appears last.
;
DATA dates;
	INPUT month day year;
	bday=MDY(month,day,year);
CARDS;
 7 11 18
 7 11 48
 1  1 60
10 15 70
12 10 71
;
RUN;

PROC PRINT DATA=dates;
	FORMAT bday date9.;
RUN;
* Two digit years work here because SAS assumes a cutoff 
	(yearcutoff) before which value two digit years are 
	interpreted as the year 2000 and above and after which 
	they are interpreted as 1999 and below. The default 
	yearcutoff differs for different versions of SAS:
	
	SAS 6.12 and before (YEARCUTOFF=1900)
	SAS 7 and 8         (YEARCUTOFF=1920)
	
	The options statement in the program that follows changes 
	the yearcutoff value to 1920. This causes in two digit 
	years lower than 20 to be read as after the year 2000. 
	Running the same program then will yield different results 
	when this option is set.;
OPTIONS YEARCUTOFF=1920;

DATA dates;
   INPUT  month day year ;
   bday=MDY(month,day,year);
CARDS;
 7 11 18
 7 11 48
 1  1 60
10 15 70
12 10 71
;
RUN;

PROC PRINT DATA=dates;
   FORMAT bday date9. ;
RUN;

* different year cut off;
OPTIONS YEARCUTOFF=1900;

DATA dates;
   INPUT  month day year ;
   bday=MDY(month,day,year);
CARDS;
 7 11 18
 7 11 48
 1  1 60
10 15 70
12 10 71
;
RUN;

PROC PRINT DATA=dates;
   FORMAT bday date9. ;
RUN;





* ELAPSED DATES =========================================

	SAS date variables make computations involving dates 
	very convenient. For example, to calculate everyone’s 
	age on January 1, 2000 use the following conversion 
	in the data step.
;
OPTIONS YEARCUTOFF=1900; /* sets the cutoff to 1900 */

DATA dates;
   INPUT  name $ 1-4 @6 bday mmddyy11.;
   age2000 = (MDY(1,1,2000)-bday)/365.25 ;
CARDS;
John 1 1 1960
Mary 07/11/1955
Joan 07-11-1955
Kate 11.12.1962
Mark 06081959
;
RUN;

PROC PRINT DATA=dates;
   FORMAT bday date9. ;
RUN;
* The results of the proc print are shown below.  
	The variable AGE2000 now contains the age in years as 
	of January 1, 2000.;





* OTHER DATE FUNCTIONS ==================================

	There are a number of useful functions for use with date 
	variables. The following is a list of some of those 
	functions.

	Function   Description             Sample
	--------   ---------------------   -----------------
	month()    Extracts Month          m=MONTH(bday)
	day()      Extracts Day            d=DAY(bday) 
	year()     Extracts Year           y=YEAR(bday)
	weekday()  Extracts Day of Week    wk_d=WEEKDAY(bday)
	qtr()      Extracts Quarter        q=QTR(bday)
	
	
	The following program demonstrates the use of these 
	functions.
;
DATA dates;
   INPUT  name $ 1-4 @6 bday mmddyy11.;
    m=MONTH(bday);
    d=DAY(bday) ;
    y=YEAR(bday);
    wk_d=WEEKDAY(bday);
    q=QTR(bday);
CARDS;
John 1 1 1960
Mary 07/11/1955
Joan 07-11-1955
Kate 11.12.1962
Mark 06081959
;
RUN;

PROC PRINT DATA=dates;
   VAR bday m d y;
   FORMAT bday date9. ;
RUN;

PROC PRINT DATA=dates;
   VAR bday wk_d q;
   FORMAT bday date9. ;
RUN;


* SUMMARY ==================================================

	Dates are read with date formats, most commonly 
		date9. and mmddyy11.
		
	Date functions can be used to create date values from 
		their components (mdy(m,d,y)), and to extract the 
		components from a date value (month(),day(), etc.).
		
	The yearcutoff option may be used if you have to read 
		two digit years.
;



* PROBLEMS TO LOOK OUT FOR --------------------------------

	- Dates are mixed within a field such that no single date 
		format can read them.  
		
		Solution: Read the field as a character field, test 
			the string, and use the input function and 
			appropriate format to read the value into the 
			date variable.
			
	- There is no format capable of reading the date. 
	
		Solution: read the date as components and use a 
			function to produce a date value.
			
	- Sometimes the default for yearcutoff is not the default 
		for the version of the package mentioned above.  
		
		Solution: to determine the current setting for 
			yearcutoff simply run a program containing
			
			PROC OPTIONS OPTION=YEARCUTOFF
			RUN
			
		This will result in output containing the current 
			value of yearcutoff.
;
PROC OPTIONS OPTION=YEARCUTOFF;
RUN;



OPTIONS YEARCUTOFF=12019; /* sets the cutoff to 12019 */
PROC OPTIONS OPTION=YEARCUTOFF;
RUN;



