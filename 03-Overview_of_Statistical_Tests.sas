* ######################################################
	OVERVIEW OF STATISTICAL TESTS ######################
	
	We will illustrate doing some basic statistical tests in SAS, 
	including  t-tests, chi square, correlation, regression, 
	and analysis of variance.  
	
	We demonstrate this using the auto data file.  
	
	The program below reads the data and creates a temporary 
	data file called auto.  
	
	(Please note that we have made the values of mpg to be 
	missing for the AMC cars.  This differs from the other 
	example data files where the AMC cars have valid data 
	for mpg.)
;

DATA auto;
	LENGTH make $ 20; * limit make to 20 characters;
	INPUT make $ 1-17 price mpg rep78 hdroom trunk weight 
        length turn displ gratio foreign ; * specify the location of make to be b/w index 1 and 17.;
CARDS;
AMC Concord        4099  . 3 2.5 11 2930 186 40 121 3.58 0
AMC Pacer          4749  . 3 3.0 11 3350 173 40 258 2.53 0
AMC Spirit         3799  . . 3.0 12 2640 168 35 121 3.08 0
Audi 5000          9690 17 5 3.0 15 2830 189 37 131 3.20 1
Audi Fox           6295 23 3 2.5 11 2070 174 36  97 3.70 1
BMW 320i           9735 25 4 2.5 12 2650 177 34 121 3.64 1
Buick Century      4816 20 3 4.5 16 3250 196 40 196 2.93 0
Buick Electra      7827 15 4 4.0 20 4080 222 43 350 2.41 0
Buick LeSabre      5788 18 3 4.0 21 3670 218 43 231 2.73 0
Buick Opel         4453 26 . 3.0 10 2230 170 34 304 2.87 0
Buick Regal        5189 20 3 2.0 16 3280 200 42 196 2.93 0
Buick Riviera     10372 16 3 3.5 17 3880 207 43 231 2.93 0
Buick Skylark      4082 19 3 3.5 13 3400 200 42 231 3.08 0
Cad. Deville      11385 14 3 4.0 20 4330 221 44 425 2.28 0
Cad. Eldorado     14500 14 2 3.5 16 3900 204 43 350 2.19 0
Cad. Seville      15906 21 3 3.0 13 4290 204 45 350 2.24 0
Chev. Chevette     3299 29 3 2.5  9 2110 163 34 231 2.93 0
Chev. Impala       5705 16 4 4.0 20 3690 212 43 250 2.56 0
Chev. Malibu       4504 22 3 3.5 17 3180 193 31 200 2.73 0
Chev. Monte Carlo  5104 22 2 2.0 16 3220 200 41 200 2.73 0
Chev. Monza        3667 24 2 2.0  7 2750 179 40 151 2.73 0
Chev. Nova         3955 19 3 3.5 13 3430 197 43 250 2.56 0
Datsun 200         6229 23 4 1.5  6 2370 170 35 119 3.89 1
Datsun 210         4589 35 5 2.0  8 2020 165 32  85 3.70 1
Datsun 510         5079 24 4 2.5  8 2280 170 34 119 3.54 1
Datsun 810         8129 21 4 2.5  8 2750 184 38 146 3.55 1
Dodge Colt         3984 30 5 2.0  8 2120 163 35  98 3.54 0
Dodge Diplomat     4010 18 2 4.0 17 3600 206 46 318 2.47 0
Dodge Magnum       5886 16 2 4.0 17 3600 206 46 318 2.47 0
Dodge St. Regis    6342 17 2 4.5 21 3740 220 46 225 2.94 0
Fiat Strada        4296 21 3 2.5 16 2130 161 36 105 3.37 1
Ford Fiesta        4389 28 4 1.5  9 1800 147 33  98 3.15 0
Ford Mustang       4187 21 3 2.0 10 2650 179 43 140 3.08 0
Honda Accord       5799 25 5 3.0 10 2240 172 36 107 3.05 1
Honda Civic        4499 28 4 2.5  5 1760 149 34  91 3.30 1
Linc. Continental 11497 12 3 3.5 22 4840 233 51 400 2.47 0
Linc. Mark V      13594 12 3 2.5 18 4720 230 48 400 2.47 0
Linc. Versailles  13466 14 3 3.5 15 3830 201 41 302 2.47 0
Mazda GLC          3995 30 4 3.5 11 1980 154 33  86 3.73 1
Merc. Bobcat       3829 22 4 3.0  9 2580 169 39 140 2.73 0
Merc. Cougar       5379 14 4 3.5 16 4060 221 48 302 2.75 0
Merc. Marquis      6165 15 3 3.5 23 3720 212 44 302 2.26 0
Merc. Monarch      4516 18 3 3.0 15 3370 198 41 250 2.43 0
Merc. XR-7         6303 14 4 3.0 16 4130 217 45 302 2.75 0
Merc. Zephyr       3291 20 3 3.5 17 2830 195 43 140 3.08 0
Olds 98            8814 21 4 4.0 20 4060 220 43 350 2.41 0
Olds Cutl Supr     5172 19 3 2.0 16 3310 198 42 231 2.93 0
Olds Cutlass       4733 19 3 4.5 16 3300 198 42 231 2.93 0
Olds Delta 88      4890 18 4 4.0 20 3690 218 42 231 2.73 0
Olds Omega         4181 19 3 4.5 14 3370 200 43 231 3.08 0
Olds Starfire      4195 24 1 2.0 10 2730 180 40 151 2.73 0
Olds Toronado     10371 16 3 3.5 17 4030 206 43 350 2.41 0
Peugeot 604       12990 14 . 3.5 14 3420 192 38 163 3.58 1
Plym. Arrow        4647 28 3 2.0 11 3260 170 37 156 3.05 0
Plym. Champ        4425 34 5 2.5 11 1800 157 37  86 2.97 0
Plym. Horizon      4482 25 3 4.0 17 2200 165 36 105 3.37 0
Plym. Sapporo      6486 26 . 1.5  8 2520 182 38 119 3.54 0
Plym. Volare       4060 18 2 5.0 16 3330 201 44 225 3.23 0
Pont. Catalina     5798 18 4 4.0 20 3700 214 42 231 2.73 0
Pont. Firebird     4934 18 1 1.5  7 3470 198 42 231 3.08 0
Pont. Grand Prix   5222 19 3 2.0 16 3210 201 45 231 2.93 0
Pont. Le Mans      4723 19 3 3.5 17 3200 199 40 231 2.93 0
Pont. Phoenix      4424 19 . 3.5 13 3420 203 43 231 3.08 0
Pont. Sunbird      4172 24 2 2.0  7 2690 179 41 151 2.73 0
Renault Le Car     3895 26 3 3.0 10 1830 142 34  79 3.72 1
Subaru             3798 35 5 2.5 11 2050 164 36  97 3.81 1
Toyota Celica      5899 18 5 2.5 14 2410 174 36 134 3.06 1
Toyota Corolla     3748 31 5 3.0  9 2200 165 35  97 3.21 1
Toyota Corona      5719 18 5 2.0 11 2670 175 36 134 3.05 1
Volvo 260         11995 17 5 2.5 14 3170 193 37 163 2.98 1
VW Dasher          7140 23 4 2.5 12 2160 172 36  97 3.74 1
VW Diesel          5397 41 5 3.0 15 2040 155 35  90 3.78 1
VW Rabbit          4697 25 4 3.0 15 1930 155 35  89 3.78 1
VW Scirocco        6850 25 4 2.0 16 1990 156 36  97 3.78 1
;
RUN;




* T-TESTS ============================================
	We can use proc ttest to perform a t-test to determine 
	whether the average mpg for domestic cars differ from the 
	foreign cars.
	
	comparing the mean mpg (continuous) of
		two groups (categorical)
		
	(continuous vs continuous)
	
	(ANOVA is just like the T-test, but with many more group
	means being compared. Think of T-test as a simpler version
	of ANOVA best for when just comparing two group means.)
;

* below we compare the average mpg for foreign & domestic cars
	we use the t-test to test for statistic significance
	
	The results show that foreign cars have significantly 
	higher gas mileage ( mpg ) than domestic cars. 
	Note that the overall N is 71 (not 74). 
	
	This is because mpg was missing for 3 of the 
	observations, so those observations were omitted 
	from the analysis.
;
PROC TTEST DATA=auto;
	CLASS foreign;
	VAR mpg; 
RUN;

* NOTE:
	Note that the output provides two t values, one 
	assuming that the variances are Unequal and 
	another assuming that the variances are Equal, 
	and below that is shown a test of whether the 
	variances are equal.  
	
	Null-Hypothesis for Equal Variances:
		No difference b/w variances.
		The p-value was not below .05, so
		we could not reject the null-hypothesis.
		(The variances of the two groups do not
		significantly differ)
		
	The test for equal variances has an F value of 1.86, 
	with a p value of 0.0776 indicating that the variances 
	of the two groups do not significantly differ, 
	therefore the Equal variance t-test would be the 
	appropriate test to use.  
	
	In this case, we would report a t value of -3.5597 
	with a p value of 0.0007, concluding that the mean 
	mpg for foreign cars is significantly greater than 
	the mpg for domestic cars.  
	
	Had the F test of equal variances been significant 
	(p-value below .05), then the Unequal variance 
	t value (-3.1685) & p-value (0.0034) would have 
	been the appropriate values to use. 
	
	(but either way the difference was significant
	because the p-values were below .05)
	
	This is especially important when the sample sizes 
	for the 2 groups differ, because when the variances 
	of the two groups differ and the sample sizes of the 
	two groups differ, then the results assuming Equal 
	variances can be quite inaccurate and could differ 
	from the Unequal variance result.
;






* CHI-SQUARE TESTS ============================================
	
	We can use proc freq to examine the repair records of 
	the cars (rep78, where 1 is the worst repair record, 
	5 is the best repair record) by foreign 
	(foreign coded 1, domestic coded 0).  
	
	Using the chisq option we can request a chi-square test 
	that tests if these two variables are independent, 
	as shown below.
	
	rep78 (categorical) vs foreign (categorical)
;

* categorical vs categorical 
	examine the differences with a cross tabulation table
	then test significance with CHISQ;
PROC FREQ DATA=auto;
	TABLES rep78 * foreign / CHISQ;
RUN;

* NOTE:
	Notice the warning that SAS gave at the end of the results. 
	The chi-square is not really valid when you have empty 
	cells (or cells with expected values less than 5). 
	
	In such cases, you can request Fisher’s EXACT test 
	(which is valid under such circumstances) with the 
	exact option as shown below.;
PROC FREQ DATA=auto;
	TABLES rep78 * foreign / CHISQ EXACT;
RUN;

* The results of the 
The Fisher’s Exact Test is significant, showing that 
there is an association between rep78 and foreign.   

In other words, the repair records for the domestic cars 
differ from the repair record of the foreign cars;






* CORRELATION ============================================
	
	Let’s use proc corr to examine the correlations among 
	price mpg and weight.
;

PROC CORR DATA=auto;
	VAR price mpg weight;
RUN;

* NOTE:
	The top portion of the output shows simple descriptive 
	statistics for the variables (note that the N for mpg 
	is 71 because it has 3 missing observations).  
	
	The second part of the output shows the correlation 
	matrix for the price, mpg, and weight   
	
	Each entry shows the correlation, and below that 
	the 2 tailed p value for the hypothesis test that 
	the correlation is 0, and below that is the sample 
	size (N) on which the correlation is based.

	By looking at the sample sizes, we can see how proc 
	corr handled the missing values.  
	
	Since mpg had 3 missing values, all the correlations 
	that involved it have an N of 71, whereas the rest 
	of the correlations were based on an N of 74.  
	
	This is called pairwise deletion of missing data 
	since SAS used the maximum number of non-missing 
	values for each pair of variables.  
	
	It is possible to ask SAS to only perform the correlations 
	on the records which had complete data for all of the 
	variables on the var statement.  
	
	This is called listwise deletion of missing data, 
	meaning that when any of the variables are missing, 
	the entire record will be omitted from analysis.  
	
	You can request listwise deletion with the nomiss 
	option as illustrated below.;

PROC CORR DATA=auto NOMISS ;
  VAR price mpg weight ;
RUN;






* REGRESSION ============================================
	
	Let’s perform a regression analysis where we predict 
	price from mpg and weight.   
	
	The proc reg example below does just this.
;

PROC REG DATA=auto;
	MODEL price = mpg weight; * predict price with mpg & weight;
RUN;

* NOTES:
	The results are shown below.  
	
	Two interesting things to note are:
	
    – Only 71 observations are used (not all 74) 
    because mpg had three missing values.  
    
    Proc reg deletes missing cases using listwise deletion.   
    
    If you have lots of missing data, this is important to 
    notice
    
    – Looking at the predictors, the results show that 
    weight is the only variable that significantly predicts
    price (with a t-value of 2.603 and a p-value of 0.0113).
;






* ANALYSIS OF VARIANCE (ANOVA /w PROC GLM) ===================
	
	Let’s compare the average miles per gallon (mpg) among 
	the cars in the different repair groups using 
	Analysis of Variance. 
	
	You might think to use proc anova for such an analysis, 
	BUT proc anova assumes that the sample sizes for all 
	groups are equal, an assumption that is frequently untrue.
	
	Instead, we will use proc glm to perform an ANOVA comparing 
	the prices among the repair groups.  
	
	Since there are so few cars with a repair record (rep78) 
	of 1 or 2, we will use a where statement to omit them, 
	allowing us to concentrate on the cars with repair records 
	of 3, 4 and 5.  
	
	The proc glm below performs an Analysis of Variance testing 
	whether the average mpg for the 3 repair groups (rep78) 
	are the same.  
	
	It also produces the means for the 3 repair groups.
	
	comparing the mean mpg (continuous) of each group
	in rep78 (categorical).
	
	(ANOVA is just like the T-test, but with many more groups
	being compared. Think of T-test as a simpler version
	best for when just comparing two tests.)

* Filter the dataset to get only car reparibility
	ratings of 3, 4, or 5;
PROC GLM DATA=auto;
	WHERE (rep78 = 3) OR (rep78 = 4) OR (rep78 = 5);
	CLASS rep78; *seperate the cases among the rating groups;
	MODEL mpg = rep78; * predict mpg with rep78;
	MEANS rep78; * get the means of rep 78;
RUN;

*NOTES:
	The results of the proc glm are shown below.  
	SAS informs us that it used only 57 observations 
	(due to the missing values of mpg).  
	
	The results suggest that there are significant differences 
	in mpg among the three repair groups (based on the F value 
	of 8.08 with a p value of 0.009).  
	
	The means for groups 3, 4 and 5 were 19.43, 21.67, and 27.36.
;


* You can use the tukey option on the means statement 
to request Tukey tests for pairwise comparisons among 
the three means.;

PROC GLM DATA=auto;
	WHERE (rep78 = 3) OR (rep78 = 4) OR (rep78 = 5);
	CLASS rep78;
	MODEL mpg = rep78 ;
	MEANS rep78 / TUKEY ;
RUN;

* The Tukey comparisons that are significant are indicated 
	by "***".  The group with rep78 of 5 is significantly 
	different from 3 and significantly different from 4. 
	
	However, the group with rep78 of 3 is not significantly 
	different from rep78 of 4.
	
	(So you might say that cars with a rating of 5
	have signifiganctly greater mpg than the other two
	groups.);
	
* PROBLEMS TO LOOK OUT FOR ---------------------------
	If you have lots of missing data, be sure to check 
	the N when you do correlations, regression, or ANOVA.
;













