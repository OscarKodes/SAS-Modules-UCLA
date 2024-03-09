* #############################################################
	PROC SORT and BY STATEMENTS	###############################

	This module will examine the use of proc sort and use of the 
	by statement with SAS procedures.  
	
	The program below creates 
	a data file called auto that we will use in our examples. 
	Note that this file has a duplicate record for the BMW.
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

PROC PRINT DATA=auto;
RUN;




* SORTING DATA WITH PROC SORT ================================

	We can use proc sort to sort this data file. The program 
	below sorts the auto data file on the variable foreign 
	(1=foreign car, 0=domestic car) and saves the sorted file 
	as auto2. 
	
	The original file remains unchanged since we used 
	out=auto2 to specify that the sorted data should be placed 
	in  auto2.
;
PROC SORT DATA=auto OUT=auto2;
	BY foreign;
RUN;

PROC PRINT DATA=auto2;
RUN;
* From the proc print, you can see that auto2 is indeed 
	sorted on foreign. The observations where foreign is 0 
	precede all of the observations where foreign is 1.  
	
	Note that the order of the observations within each group 
	remain unchanged, (i.e., the observations where foreign 
	is 0 remain in the same order).
	
	
	Suppose you wanted the data sorted, but with the foreign 
	cars (foreign=1) first and the domestic cars (foreign=0) 
	second. The example below shows the use of the descending 
	keyword to tell SAS that you want to sort by foreign, 
	but you want the sort order reversed (i.e., largest to 
	smallest).
;
PROC SORT DATA=auto OUT=auto3;
	BY DESCENDING foreign;
RUN;

PROC PRINT DATA=auto3;
RUN;



* It is also possible to sort on more than one variable 
	at a time.  Perhaps you would like the data sorted on 
	foreign (this time we will go back to the normal sort 
	order for foreign) and then sorted by rep78 within 
	each level of foreign.  The example below shows how 
	this can be done.
;
PROC SORT DATA=auto OUT=auto4;
	BY foreign rep78;
RUN;

PROC PRINT DATA=auto4;
RUN;
* In the output above, note how the missing values of rep78 
	were treated.  Since a missing value is treated as the 
	lowest value possible (e.g., negative infinity), the 
	missing values come before all other values of rep78.;





* REMOVING DUPLICATES WITH PROC SORT ========================

	At the beginning of this page, we noted that there was a 
	duplicate observation in auto, that there were two 
	identical records for BMW.  
	
	We can use proc sort to remove the duplicate observations 
	from our data file using the noduplicates option, as long as 
	the duplicate observations are next to each other.  
	
	The example below sorts the data by foreign and removes 
	the duplicates at the same time.  
	
	Note that it did not matter what variable we chose for 
	sorting the data. As you see in the output below, the 
	extra observation for BMW was deleted.
	
	
	When you use the noduplicates option, the SAS Log displays 
	a note telling you how many duplicates were removed.  
	
	As you see below, SAS informs us that 1 duplicate 
	observation was deleted.
;
PROC SORT DATA=auto OUT=auto5 NODUPLICATES;
	BY foreign;
RUN;

PROC PRINT DATA=auto5;
RUN;


* It is common for duplicate observations to be next to each 
	other in the same file, but if the duplicate observations 
	are not next to each other, there is another strategy you 
	can use to remove the duplicates.  You can sort the data 
	file by all of the variables (which can be indicated with 
	the special keyword _ALL_), which would force the duplicate 
	observations to be next to each other.  This is illustrated 
	below.
;
PROC SORT DATA=auto OUT=auto6 NODUPLICATES;
	BY _all_;
RUN;

PROC PRINT DATA=auto6;
RUN;


* OBTAINING SEPERATE ANALYSES WITH SORTED DATA =================

	Sometimes you would like to obtain results separately for 
	different groups.  For example, you might want to get 
	the mean mpg and weight separately for foreign and 
	domestic cars.  As you see below, it is possible to use 
	proc means with the class statement to get these results.
;
PROC MEANS DATA=auto;
	CLASS foreign;
	VAR mpg weight;
RUN;

* However, what if you wanted to obtain the correlation of 
	weight and mpg separately for foreign and domestic cars?  
	
	Proc corr does not support a class statement like proc 
	means does, but you can use the by statement as in the 
	example below.;
PROC SORT DATA=auto OUT=auto6;
	BY foreign;
RUN;

PROC CORR DATA=auto6;
	BY foreign;
	VAR weight mpg;
RUN;

* As you see in the output below, using the by statement 
	resulted in getting a proc corr for the domestic cars 
	and a proc corr for the foreign cars.  In general, 
	using the by statement requests that the proc be performed 
	for every level of the by variable (in this case, 
	for every level of foreign).;
	

* Here are other examples of where you might use a by 
	statement with the auto data file.  
	
	(Note that some of 
	these analyses are not very practical because of the small 
	size of the auto data file, so please imagine that we would 
	be analyzing a larger version of the auto data file.)

	- You might use a by statement with proc univariate to 
		request univariate statistics for mpg separately for 
		foreign and domestic cars so you can seen if  mpg is 
		normally distributed for foreign cars and normally 
		distributed for domestic cars.  This also allows you 
		to generate side by side box and whisker plots 
		allowing you to compare the distributions of mpg 
		for the separate groups.
		
	- You might use a by statement with proc reg if you would 
		like to do separate regression analyses for foreign 
		and domestic cars.
		
	- You might use a by statement with proc means even 
		though it has the class statement.  If you wanted the
		means displayed on separate pages, then using the by 
		statement would give you the kind of output you desire.
;



* PROBLEMS TO LOOK OUT FOR --------------------------------

	If you use a BY statement in a procedure, make sure the 
		data has been sorted first.  For example, if you use 
		by foreign then be sure that you have first sorted the 
		file by foreign.

	If you want to delete duplicate observations and the 
		duplicate observations are not next to each other, be 
		sure to sort the data on all of the variables 
		(i.e., using  by _ALL_ ) so the noduplicates option 
		will work properly and indeed remove duplicate 
		observations.
;















