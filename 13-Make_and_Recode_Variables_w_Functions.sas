* #############################################################
	USING SAS FUNCTIONS FOR MAKING AND RECODING VARIABLES #####
	
	A SAS function returns a value from a computation or system 
	manipulation that requires zero or more arguments. Most 
	functions use arguments supplied by the user. However, a 
	few obtain their arguments from the operating system. Here 
	is the syntax of a function:

		function-name(argument1, argument2)

	We will illustrate some functions using the following 
	dataset that includes name, x, test1, test2, and test3.
	
	
	$ 
		specifies to store the variable value as a character 
	value rather than as a numeric value.
	
	@ 
		holds an input record for the execution of the next 
	INPUT statement within the same iteration of the DATA step. 
	This line-hold specifier is called trailing @.
	
	informat.
		specifies an informat to use to read the variable value.
		
		
	$14. --- Means a character variable with 14 characters?
			--- Informat?
;
DATA getData;
	INPUT name $14. x test1 test2 test3;
DATALINES;
John Smith       4.2 86.5 84.55 81
Samuel Adams     9.0 70.3 82.37 .
Ben Johnson     -6.2 82.1 84.81 87
Chris Adraktas   9.5 94.2 92.64 93
John Brown        .  79.7 79.07 72
;
RUN;

PROC PRINT DATA=getData;
RUN;

* The data set funct1 will create new variables using the int, 
	round and mean numeric functions. What happens to have due 
	to the missing value of test3?;
DATA funct1;
	SET getdata;
	t1int = INT(test1); /* integer part of a number */
	t2int = INT(test2);
	t1rnd = ROUND(test1); /* round */
	t2rnd = ROUND(test2,.1); 
	tave = MEAN(test1, test2, test3); /* mean across variables */
RUN;
 
PROC PRINT DATA=funct1;
  VAR test1 test2 test3 t1int t2int t1rnd t2rnd tave;
RUN; 

* Now let’s try some more math functions. 
	What happens when there is a missing or negative value of x?;
DATA funct2;
	SET getData;
	xsqrt = SQRT(x);
	xlog = LOG(x);
	xexp = EXP(x);
RUN;

PROC PRINT DATA=funct2;
	VAR x xsqrt xlog xexp;
RUN;



* This time we’ll try some string functions. In particular, 
	look closely at the substr function that is used in 
	fname and lname.;
DATA funct3;
	SET getData;
	c1 = UPCASE(name); * convert to uppercase;
	c2 = SUBSTR(name,3,8); * substring;
	len = LENGTH(name); * length of string;
	ind = INDEX(name,' '); * position in string;
	fname = SUBSTR(name,1,INDEX(name,' '));
	lname = SUBSTR(name,INDEX(name,' '));
RUN;

PROC PRINT DATA=funct3;
	VAR name c1 c2 len ind fname lname;
RUN;



* RANDOM NUMBERS IN SAS ====================================

	Random numbers are more useful than you might imagine.  
	They are used extensively in Monte Carlo studies, as well 
	as in many other situations.  We will look at two of SAS’s 
	random number functions.

		UNIFORM(SEED) – generates values from a random uniform 
			distribution between 0 and 1
		
		NORMAL(SEED) – generates values from a random normal 
			distribution with mean 0 and standard deviation 1

	The statements if x>.5 then coin = ‘heads’ and else 
	coin = ‘tails’ create a random variable called coins 
	that has values ‘heads’ and ‘tails’.  The data sets 
	random1 and random2 use a seed value of -1.  Negative 
	seed values will result in different random numbers 
	being generated each time.
;
DATA random1;
	x = UNIFORM(-1);
	y = 50 + 3*NORMAL(-1);
	IF x>.5 THEN coin = 'heads';
		ELSE coin = 'tails';
RUN;

DATA random2;
	x = UNIFORM(-1);
	y = 50 + 3*NORMAL(-1);
	IF x>.5 THEN coin = 'heads';
		ELSE coin = 'tails';
RUN;

PROC PRINT DATA=random1;
	VAR x y coin;
RUN;

PROC PRINT DATA=random2;
	VAR x y coin;
RUN;

* Sometimes we will want to generate the same random 
	numbers each time so that we can debug our programs. 
	To do this we just enter the same positive number as the 
	seed value.  The data sets random3 and random4 illustrate 
	how to generate the same results each time.;
DATA random3;
	x = UNIFORM(123456);
	y = 50 + 3*NORMAL(123456);
	IF x>.5 THEN coin = 'heads';
		ELSE coin = 'tails';
RUN;

DATA random4;
	x = UNIFORM(123456);
	y = 50 + 3*NORMAL(123456);
	IF x>.5 THEN coin = 'heads';
		ELSE coin = 'tails';
RUN;

PROC PRINT DATA=random3;
	VAR x y coin;
RUN;
PROC PRINT DATA=random4;
	VAR x y coin;
RUN;


* Now let’s generate 100 random coin tosses and compute 
	a frequency table of the results.;
DATA random5;
	DO i=1 to 100;
		x = UNIFORM(123456);
		IF x>.5 THEN coin = 'heads';
			ELSE coin = 'tails';
		OUTPUT;
	END;
RUN;

PROC FREQ DATA=random5;
	TABLE coin;
RUN;



* PROBLEMS TO LOOK OUT FOR -----------------------------
	
	Watch out for math errors, such as division by zero, 
	square root of a negative number and taking the log of a 
	negative number.
;





