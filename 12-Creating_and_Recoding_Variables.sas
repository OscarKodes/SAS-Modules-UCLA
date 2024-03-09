* ##############################################################
	CREATING AND RECODING VARIABLES ############################
	
	We will illustrate creating and replacing variables in SAS 
	using a data file about 26 automobiles with their make, 
	price, mpg, repair record in 1978 (rep78), and whether the 
	car was foreign or domestic (foreign).  
	
	The program below reads the data and creates a temporary 
	data file called “auto“.  Please note that there are two 
	missing values for mpg in the data file (coded as a single 
	period).

	We will create two new variables to go along with the 
	existing ones. First, we will create cost so that it gives 
	us the price in thousands of dollars. Then we will create 
	mpgpd which will stand for miles per gallon per thousand 
	dollars.  In each case, we just type the variable name, 
	followed by an equal sign, followed by an expression for 
	the value.
;
DATA auto;
  INPUT make $ price mpg rep78 foreign;
  cost = ROUND( price / 1000 );
  mpgptd = mpg / cost;
DATALINES;
AMC    4099 22 3 0
AMC    4749 17 3 0
AMC    3799 22 3 0
Audi   9690  . 5 1
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
Chev.  4504  . 3 0
Chev.  5104 22 2 0
Chev.  3667 24 2 0
Chev.  3955 19 3 0
Datsun 6229 23 4 1
Datsun 4589 35 5 1
Datsun 5079 24 4 1
Datsun 8129 21 4 1
;
RUN;
PROC PRINT DATA=auto;
RUN;
* Note that cost is just a one or two-digit value. The 
	vehicle that achieves the best mpgptd is the Chev. for 
	observation 17 which gets 9+ miles per gallon for every 
	thousand dollars in price. The Cad. in observation 14 has 
	the worst mpgptd.

	Also note that there are two missing values for mpgptd 
	because of the missing values in mpg.;
	
	

* RECODING VARIABLES IN SAS ================================

	The variable rep78 is coded 1 through 5 standing for poor, 
	fair, average, good and excellent. We would like to change 
	rep78 so that it has only three values, 1 through 3, 
	standing for below average, average, and above average. 
	We will do this by creating a new variable called 
	repair_rating and recoding the values of rep78 into it.

	We will also create a new variable called himpg that is a 
	dummy coding of mpg. All vehicles with better than 20 mpg 
	will be coded 1 and those with 20 or less will be coded 0.

	SAS does not have a recode command, so we will use a 
	series of if-then/else commands in a data step to do 
	the job. This data step creates a temporary data file 
	called auto2.
;
DATA auto2;
	SET auto;
	
	repair_rating = .;
	IF (rep78=1) OR (rep78=2) THEN repair_rating = 1;
	IF (rep78=3) THEN repair_rating = 2;
	IF (rep78=4) OR (rep78=5) THEN repair_rating = 3;
	
	high_mpg = .;
	IF (mpg <= 20) THEN high_mpg = 0;
	IF (mpg > 20) THEN high_mpg = 1;
RUN;
* Note that we begin by setting repair and himpg to missing, 
	just in case we make a mistake in the recoding. Proc 
	freq will show us how the recoding worked.;

PROC FREQ DATA=auto2;
	TABLES repair_rating*rep78 repair_rating*high_mpg / MISSING;
RUN;
	
* Uh oh, there’s a problem with himpg. There are no missing 
	values for himpg even though there were two missing 
	values of mpg.  SAS treats missing values 
	(values coded with a . ) as the smallest number possible 
	(i.e., negative infinity).  When we recoded mpg we wrote:
	
	IF (mpg <= 20) THEN high_mpg = 0
	
	which converted all values of mpg that were 20 or less 
	into a value of 0 for himpg.  Since a missing value is 
	also less than 20, the missing values got recoded to 0 
	as well.  (It is unforeseen mistakes like this that make 
	it so important to check every variable that you recode.) 
	Let’s try recoding himpg again, being careful to properly 
	treat missing values like this:
	
	IF (. < mpg <= 20) THEN high_mpg = 0

	The complete program, with the fixed if statement, 
	is shown below.;
DATA auto2;
  SET auto;
     	 
  repair = .;
  IF (rep78=1) OR (rep78=2) THEN repair_rating = 1;
  IF (rep78=3) THEN repair = 2;
  IF (rep78=4) OR (rep78=5) THEN repair_rating = 3;
   
  himpg = .;
  IF (.  < mpg <= 20) THEN high_mpg = 0; 
  IF (mpg >  20) THEN high_mpg = 1;
RUN;

PROC FREQ DATA=auto2;
  TABLES repair*himpg / MISSING; *includes missing values in results;
RUN;
	
	
	
	
	
	
* PROBLEMS TO LOOK OUT FOR ---------------------------------

	Watch out for math errors, such as, division by zero 
	and square root of a negative number.
;


* HELPFUL HINTS AND SUGGESTIONS ----------------------------

	- Set values to missing and then recode them.
	
	- Use new variable names when you create or recode 
		variables. Avoid constructions like this, that 
		reuse the variable name total. 
	
		total = total + sub1 + sub2 
		
	- Use the MISSING option with proc freq to make sure 
		all missing values are accounted for.
;


