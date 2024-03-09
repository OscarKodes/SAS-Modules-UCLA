* ########################################################
	MISSING DATA IN SAS ##################################
	
	This module will explore missing data in SAS, focusing 
	on numeric missing data. It will describe how to indicate 
	missing data in your raw data files, how missing data are 
	handled in SAS procedures, and how to handle missing data 
	in a SAS data step. 
	
	Suppose we did a reaction time study with six subjects, 
	and the subjects reaction time was measured three times. 
	The data file is shown below.
;

DATA times;
	INPUT id trial1 trial2 trial3;
CARDS;
1 1.5 1.4 1.6 
2 1.5  .  1.9 
3  .  2.0 1.6 
4  .   .  2.2 
5 2.1 2.3 2.2
6 1.8 2.0 1.9
;
RUN;

PROC PRINT DATA=times;
RUN;

* You might notice that some of the reaction times are coded 
	using a single dot. For example, for subject 2, the second 
	trial is coded just as a dot. Well, the person measuring 
	response time for that trial did not measure the response 
	time properly so the data for that trial was missing.
	
	In your raw data, missing data are generally coded using a 
	single . to indicate a missing value. SAS recognizes a 
	single . as a missing value and knows to interpret it as 
	missing and handles it in special ways. Let’s examine how 
	SAS handles missing data in procedures.;
	
	
* HOW SAS HANDLES MISSING DATA IN PROCEDURES ================

	As a general rule, SAS procedures that perform computations 
	handle missing data by omitting the missing values. 
	
	(We say procedures that perform computations to indicate 
	that we are not addressing procedures like proc contents). 
	
	The way that missing values are eliminated is not always 
	the same among SAS procedures, so let’s us look at some 
	examples. First, let’s do a proc means on our data file 
	and see how SAS proc means handles the missing values.
;

PROC MEANS DATA=times;
	VAR trial1 trial2 trial3;
RUN;
* As you see in the output, proc means computed the means 
	using 4 observations for trial1 and trial2 and 
	6 observations for trial3. In short, proc means used all 
	of the valid data and performed the computations on all 
	of the available data;


PROC FREQ DATA=times;
	TABLES trial1 trial2 trial3;
RUN;
* As you see in the output, proc freq likewise performed its 
	computations using just the available data. Note that the 
	percentages are computed based on just the total number 
	of non-missing cases.;
	

* It is possible that you might want the percentages to be 
	computed out of the total number of values, and even 
	report the percentage missing right in the table itself. 
	You can request this using the missing option on the tables 
	statement of proc freq as shown below (just for trial1).;
	
PROC FREQ DATA=times;
	TABLES trial1 trial2 trial3 / MISSING;
RUN;
* As you see, now the percentages are computed out of the 
	total number of observations, and the percentage missing 
	are shown right in the table as well.;
	


* Let’s look at how proc corr handles missing data. We would 
	expect that it would do the computations based on the 
	available data, and omit the missing values. Here is an 
	example program.;
	
PROC CORR DATA=times;
	VAR trial1 trial2 trial3;
RUN;
* Note how the missing values were excluded. For each pair 
	of variables, proc corr used the number of pairs that 
	had valid data. For the pair formed by trial1 and 
	trial2,  there were 3 pairs with valid data.  For the 
	pairing of trial1 and trial3 there were 4 valid pairs, 
	and likewise there were 4 valid pairs for trial2 and 
	trial3.  Since this used all of the valid pairs of data, 
	this is often called pairwise deletion of missing data.;
	


* It is possible to ask SAS to only perform the correlations 
	on the observations that had complete data for all of 
	the variables on the var statement. 
	
	For example, you might want the correlations of the 
	reaction times just for the observations that had 
	non-missing data on all of the trials. 
	
	This is called listwise deletion of missing 
	data, meaning that when any of the variables are missing, 
	the entire observation is omitted from the analysis. 
	
	You can request listwise deletion within proc corr with 
	the nomiss option as illustrated below.;
	
PROC CORR DATA=times NOMISS;
	VAR trial1 trial2 trial3;
RUN;
* As you see in the results, the N for all the simple 
	statistics is the same, 3, which corresponds to the 
	number of cases with complete non-missing data for 
	trial1 trial2 and trial3. Since the N is the same for 
	all of the correlations (i.e., 3), the N is not displayed 
	along with the correlations.;



* SUMMARY OF HOW MISSING VALUES ARE HANDLED IN PROCEDURES ====

	It is important to understand how SAS procedures handle 
	missing data if you have missing data. To know how a 
	procedure handles missing data, you should consult the 
	SAS manual. Here is a brief overview of how some common 
	SAS procedures handle missing data. 
	
	PROC MEANS
		For each variable, the number of non-missing values 
		are used
		
	PROC FREQ
		By default, missing values are excluded and percentages 
		are based on the number of non-missing values. If you 
		use the MISSING option on the tables statement, 
		the percentages are based on the total number of 
		observations (non-missing and missing) and the 
		percentage of missing values are reported in the table.

	PROC CORR
		By default, correlations are computed based on the 
		number of pairs with non-missing data (pairwise 
		deletion of missing data). The NOMISS option can be 
		used on the PROC CORR statement to request that 
		correlations be computed only for observations that 
		have non-missing data for all variables on the var 
		statement (listwise deletion of missing data).
		
	PROC REG
		If any of the variables on the model or var statement 
		are missing, they are excluded from the analysis 
		(i.e., listwise deletion of missing data)
		
	PROC FACTOR
		Missing values are deleted listwise, 
		i.e., observations with missing values on any of the 
		variables in the analysis are omitted from the analysis.

	PROC GLM
		The handling of missing values in proc glm can be 
		complex to explain. If you have an analysis with 
		just one variable on the left side of the model 
		statement (just one outcome or dependent variable), 
		observations are eliminated if any of the variables 
		on the model statement are missing. Likewise, if you 
		are performing a repeated measures ANOVA or a MANOVA, 
		then observations are eliminated if any of the 
		variables in the model statement are missing. For 
		other situations, see the SAS/STAT manual about 
		proc glm.

	For other procedures, see the SAS manual for information 
	on how missing data are handled.
;




* MISSING VALUE SIN ASSIGNMENT STATEMENTS ==================
	It is important to understand how missing values are 
	handled in assignment statements. Consider the example 
	shown below.
;

DATA times2;
	SET times;
	avg = (trial1 + trial2 + trial3) / 3;
RUN;
* The proc print above illustrates how missing values are 
	handled in assignment statements. The variable avg is 
	based on the variables trial1 trial2 and trial3. If any 
	of those variables were missing, the value for avg was 
	set to missing. This meant that avg was missing for 
	observations 2, 3 and 4.
	
	In fact, SAS included a NOTE: in the Log to let you know 
	about the missing values that were created. The Log 
	entry from this example is shown below.
	
	This note tells us that three missing values were created 
	in the program at line 224. This makes sense, we know that 
	3 missing values were created for avg and that avg is 
	created on line 224.

	As a general rule, computations involving missing 
	values yield missing values.
	
	Whenever you add, subtract, multiply, divide, etc., 
	values that involve missing data, the result is missing.;




* In our reaction time experiment, the average reaction time 
	avg is missing for three out of six cases. We could try 
	just averaging the data for the non-missing trials by 
	using the mean function as shown in the example below.;

DATA times3;
	SET times;
	avg = MEAN(trial1, trial2, trial3);
RUN;

PROC PRINT DATA=times3;
RUN;
* The results show that avg now contains the average of the 
	non-missing trials.
	
	Had there been a large number of trials, say 50 trials, 
	then it would be annoying to have to type
		avg = mean(trial1, trial2, trial3 …. trial50)
		
	Here is a shortcut you could use in this kind of situation
		avg = mean(of trial1-trial50);
	
DATA times3;
	SET times;
	avg = MEAN(of trial1-trial3);
RUN;

PROC PRINT DATA=times3;
RUN;

* Also, if we wanted to get the sum of the times instead of 
	the average, then we could just use the sum function 
	instead of the mean function. The syntax of the sum 
	function is just like the mean function, but it returns 
	the sum of the non-missing values.;

DATA times_sum;
	SET times;
	total = SUM(of trial1-trial3);
RUN;

PROC PRINT DATA=times_sum;
RUN;



* Finally, you can use the N function to determine the number 
	of non-missing values in a list of variables, as 
	illustrated below.;
DATA times4;
	SET times;
	n = N(of trial1-trial3);
RUN;

PROC PRINT DATA=times4;
RUN;
* As you see, observations 1, 5 and 6 had three valid values, 
	observations 2 and 3 had two valid values, and observation 
	4 had only one valid value.;

* You might feel uncomfortable with the variable avg for 
	observation 4 since it is not really an average at all. 
	We can use the variable n to create avg only when there 
	are two or more valid values, but if the number of 
	non-missing values is 1 or less, then make avg to be 
	missing. This is illustrated below.;
DATA times5;
	SET times;
	n = N(trial1, trial2, trial3);
	IF n >= 2 THEN avg = MEAN(trial1, trial2, trial3);
	IF n <= 1 THEN avg = . ;
RUN;

PROC PRINT DATA=times5;
RUN;
* In the output, you see that avg now contains the average 
	reaction time for the non-missing values, except for 
	observation 4 where the value is assigned to missing 
	because it had only 1 valid observation.;
	


* MISSING VALUES IN LOGICAL STATEMENTS =====================

	It is important to understand how missing values are 
	handled in logical statements.  For example, say that 
	you want to create a 0/1 value for trial1 that is 0 if 
	it is 1.5 or less, and 1 if it is over 1.5.  We show 
	this below (incorrectly, as you will see).
;

DATA times2;
	SET times;
	IF (trial1 <= 1.5) THEN trial1a = 0;
	ELSE trial1a = 1;
RUN;

PROC PRINT DATA=times2;
	VAR id trial1 trial1a;
RUN;
* And as you can see in the output, the values for trial1a 
	are wrong when id is 3 or 4, when trial1 is missing.  
	This is because SAS treats a missing value as the 
	smallest possible value (e.g., negative infinity) and 
	that value is less than 1.5, so then the value for 
	trial1a becomes 0.;
	
* Instead, we will explicitly exclude missing values to make 
	sure they are treated properly, as shown below.;
DATA times2 ;
  SET times ;
  trial1a = .;
  IF (trial1 <= 1.5) AND (trial1 > .) THEN trial1a = 0;
  IF (trial1 > 1.5) THEN trial1a = 1 ;
RUN ;

PROC PRINT DATA=times2;
	VAR id trial1 trial1a;
RUN;
* And now we get the results that we wish.  The value for 
	trial1a is only 0 when it is less than or equal to 1.5 
	and it is not missing.  The value for trial1a is only 1 
	when it is over 1.5, as shown below.;

* just another way to do the same thing;
DATA times2;
	SET times;
	IF . < trial1 <= 1.5 THEN trial1a = 0;
	IF trial1 > 1.5 THEN trial1a = 1;
RUN;

PROC PRINT DATA=times2;
	VAR id trial1 trial1a;
RUN;



* PROBLEMS TO LOOK OUT FOR ----------------------------

	When creating or recoding variables that involve missing 
	values, always pay attention to the SAS log to detect 
	when you are creating missing values. 
;







