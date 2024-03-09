* COLLAPSING ACROSS OBSERVATIONS USING PROC SQL ###################

	Creating a new variable of grand mean
	
	Let’s say that we have a data set containing three families 
	with kids and we want to create a new variable in the data 
	set that is the grand mean of age across the entire data set. 
	
	This can be accomplished by using SAS proc sql as shown 
	below. We also print out the new data set with a new 
	variable of grand mean using proc print.
;

DATA kids;
	LENGTH kidname $ 4 sex $ 1;
	INPUT famid kidname birth age wt sex;
CARDS;
1 Beth 1  9  60  f
1 Bob  2  6  40  m
1 Barb 3  3  20  f
2 Andy 1  8  80  m
2 Al   2  6  50  m
2 Ann  3  2  20  f
3 Pete 1  6  60  m
3 Pam  2  4  40  f
3 Phil 3  2  20  m
;
RUN;

PROC SQL;
	CREATE TABLE kids1 AS
	
	SELECT *,
			MEAN(age) AS mean_age
	FROM kids;
QUIT;

* NOOBS Suppresses the observation number in the output.;
PROC PRINT DATA=kids1 NOOBS;
RUN;


* Alternative SQL syntax, same result;
PROC SQL;

	SELECT *,
			AVG(age) AS mean_age
	FROM kids;
QUIT;




* Creating a new variable of group mean ==================

	We will continue to use the data set in previous example. 
	
	Now we want to use the variable famid as a group variable
	and create a new variable that is the group mean of the 
	variable age.
;

PROC SQL;
	CREATE TABLE kids2 AS
	
	SELECT *,
		MEAN(age) LABEL="group average" AS mean_age
	FROM kids
	GROUP BY famid;
QUIT;

TITLE 'New Variable of Group Mean';
PROC PRINT DATA=kids2;
RUN;

TITLE 'Label at Work';
PROC FREQ DATA=kids2;
	TABLE mean_age;
RUN;



* Creating multiple variables of summary statistics at once ====

	Sometimes we only need summary statistics based on a 
	group variable similar to the output of  proc means. 
	
	This can also be done in proc sql as shown in our next 
	example.
;

PROC SQL;
	CREATE TABLE kids3 AS 
	
	SELECT famid,
		MEAN(age) AS mean_age,
		STD(age) AS std_age,
		MEAN(wt) AS mean_wt,
		STD(wt) AS std_wt
	FROM kids
	GROUP BY famid;
QUIT;

PROC PRINT DATA=kids3 NOOBS;
RUN;




* Creating multiple summary statistics variables in the 
	original data set ========================================
;

PROC SQL;
	CREATE TABLE fam5 AS 
	
	SELECT *,
		MEAN(age) AS mean_age,
		STD(age) AS std_age,
		MEAN(wt) AS mean_wt,
		STD(wt) AS std_wt
	FROM kids
	GROUP BY famid
	ORDER BY famid, kidname DESC;
QUIT;

PROC PRINT DATA=fam5;
RUN;

* alternative syntax;
PROC SQL;
	CREATE TABLE fam5_2 AS 
	
	SELECT *,
		AVG(age) AS mean_age,
		STD(age) AS std_age,
		AVG(wt) AS mean_wt,
		STD(wt) AS std_wt
	FROM kids
	GROUP BY famid
	ORDER BY famid, kidname DESC;
QUIT;

PROC PRINT DATA=fam5_2;
RUN;



* Creating variables and their summary statistics on-the-fly ===

	Let’s say that we want to know the number of boys and 
	girls in each family. 
	
	We can use variable sex to figure it out in one step 
	using proc sql as shown below.
;

PROC SQL;
	CREATE TABLE my_count AS 
	
	SELECT famid,
		SUM(boy) AS num_boy,
		SUM(girl) AS num_girl
	FROM (
		SELECT famid,
			(sex='m') AS boy,
			(sex='f') AS girl
		FROM kids
	)
	GROUP BY famid;
QUIT;

PROC PRINT DATA=my_count NOOBS;
RUN;



* alternative method;
PROC SQL;
	CREATE TABLE my_count_2 AS 
	
	SELECT famid,
			SUM(sex='m') AS num_boy,
			SUM(sex='f') AS num_girl
	FROM kids
	GROUP BY famid;
QUIT;

PROC PRINT DATA=my_count_2 NOOBS;
RUN;


* Creating grand mean and save it into a SAS macro variable ====

	Sometimes, we want to get a summary statistic for a 
	variable and use it later for other purposes. 
	
	We can save the summary statistic in a macro variable 
	and then it can be accessed throughout the entire SAS 
	session. 
	
	proc sql is very handy as shown in the following example 
	where we save the grand mean of variable age into macro 
	variable meanage.
;

PROC SQL NOPRINT;
	SELECT MEAN(age) INTO :mean_age FROM kids;
QUIT;

%PUT &mean_age;



* Creating group means and save them into a sequence 
	of SAS macro variables ================================
;

PROC SQL NOPRINT;
	SELECT MEAN(age) INTO :mean_age1 - :mean_age3 FROM kids
	GROUP BY famid;
QUIT;
%PUT _USER_;






















