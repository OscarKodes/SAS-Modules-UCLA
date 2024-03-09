* #############################################################
 INTRODUCTION TO THE FEATURES OF SAS ##########################

	This module illustrates some of the features of The SAS 
	System. SAS is a comprehensive package with very powerful 
	data management tools, a wide variety of statistical 
	analysis and graphical procedures.  
	
	This is a very brief introduction and only covers just a 
	fraction of all of the features of SAS. 
	We use the following data file to illustrate the features 
	of SAS.   
	
	This data file contains information about 26 automobiles, 
	namely their make, price, miles per gallon, repair rating 
	(in 1978), weight in pounds, length in inches, and 
	whether the car was foreign or domestic.  
;





* ==========================================================
	The program below reads the data and creates a 
	temporary data file called "auto"
	
	The descriptive statistics shown in this module are 
	all performed on this data file called auto.
;

DATA auto;
	INPUT make $ price mpg rep78 weight length foreign;
DATALINES;
AMC     4099 22  3     2930   186    0
AMC     4749 17  3     3350   173    0
AMC     3799 22  3     2640   168    0
Audi    9690 17  5     2830   189    1
Audi    6295 23  3     2070   174    1
BMW     9735 25  4     2650   177    1
Buick   4816 20  3     3250   196    0
Buick   7827 15  4     4080   222    0
Buick   5788 18  3     3670   218    0
Buick   4453 26  3     2230   170    0
Buick   5189 20  3     3280   200    0
Buick  10372 16  3     3880   207    0
Buick   4082 19  3     3400   200    0
Cad.   11385 14  3     4330   221    0
Cad.   14500 14  2     3900   204    0
Cad.   15906 21  3     4290   204    0
Chev.   3299 29  3     2110   163    0
Chev.   5705 16  4     3690   212    0
Chev.   4504 22  3     3180   193    0
Chev.   5104 22  2     3220   200    0
Chev.   3667 24  2     2750   179    0
Chev.   3955 19  3     3430   197    0
Datsun  6229 23  4     2370   170    1
Datsun  4589 35  5     2020   165    1
Datsun  5079 24  4     2280   170    1
Datsun  8129 21  4     2750   184    1
;
RUN;

* prints out the 10 first rows of the dataset "auto";
PROC PRINT DATA=auto(obs=10);
RUN;






* =========================================================
	DESCRIPTIVE STATISTICS IN SAS
;
	
	
* SUMMARY DESCRIPTIVE STATS -----------------------------
	We can get descriptive statistics for all of the variables 
	using proc means as shown below.;

PROC MEANS DATA=auto;
RUN;


* SEPERATE CATEGORY STATISTICS ---------------------------
	We can use class to get descriptive statistics separately 
	for the different categories in a cateogorical variable.;

PROC MEANS DATA=auto;
  CLASS foreign;
RUN; 


* ONE VARIABLE STATISTICS -------------------------------
	We can get detailed descriptive statistics for price 
	using proc univariate as shown below.;

PROC UNIVARIATE DATA=auto;
  VAR PRICE;
RUN; 


* FREQUENCY DISTRIBUTION -------------------------------
	Use proc freq to get the frequency distribution of a 
	variable. (rep78 is the repair rating of the car);

PROC FREQ DATA=auto;
  TABLES rep78 ;
RUN; 


* We can also make a two way table showing the frequencies 
	for two categorical variables;

PROC FREQ DATA=auto;
	TABLES rep78 * foreign;
RUN;






* =========================================================
	MAKING GRAPHS IN SAS
;


* BAR CHARTS ---------------------------------------;

TITLE "Bar Chart /w Discrete Option";

PROC GCHART DATA=auto;
	VBAR rep78 / DISCRETE;
RUN;






* =========================================================
	CORRELATION, REGRESSION, AND ANALYSIS OF VARIANCE
;


* CORRELATIONS ---------------------------------------
	Use proc corr to get the correlations of specified 
	variables;
	
PROC CORR DATA=auto;
	VAR price mpg weight length;
RUN;


* REGRESSION ---------------------------------------
	We can use proc reg to predict mpg from weight, 
	length, and foreign, as shown below.;
	
PROC REG DATA=auto;
	MODEL mpg = weight length foreign;
RUN;


* ANOVA ---------------------------------------------
	We can use proc glm to do an ANOVA to test if 
	the mean mpg is the same for foreign and domestic cars, 
	as shown below.;

PROC GLM DATA=auto;
	CLASS foreign;
	MODEL mpg = foreign;
RUN;






