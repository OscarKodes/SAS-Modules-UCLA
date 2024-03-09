* COLLAPSING ACROSS OBSERVATIONS, ADVANCED #######################

	This module illustrates how to collapse across 
	variables using retained variables. 
	
	First, let’s read in a sample dataset named kids which 
	includes the variables famid (family id) and wt 
	(kids weight in pounds).
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

PROC PRINT DATA=kids;
RUN;



* Computing a running total with implicitly retained variables
	==========================================================
	
	There are times when a running total for a particular 
	variable is desired. 
	
	For example, suppose that a variable representing the 
	running total of the weights for each person in the 
	dataset needs to be computed. 
	
	This can be done by using implicitly retained variables 
	in a data step. 
	
	In the example below, the implicitly retained variable is 
	sumwt, where the weight of the current observation (wt) 
	is added to the last value of sumwt. 
	
	This results in a new total for each observation. 
	
	This is why it is called a running total, because 
	the value of sumwt at each observation is the sum of all 
	the previous observations plus the current observation, 
	NOT the sum of ALL observations in the dataset. 
	
	The value of sumwt at the last observation, however, 
	IS the sum for ALL observations in the dataset, 
	because it is adding the sum of all the previous 
	observations, plus its own value, and hence is the 
	sum across ALL observations in the dataset.
;

DATA sum;
	SET kids;
	
	running_total + wt;
RUN;

PROC PRINT DATA=sum;
	VAR famid wt running_total;
RUN;


* Computing a running count and average with implicitly 
	retained variables ===================================
	
	Implicitly retained variables can also be used to keep a 
	running count. 
	
	Hence, if one has the running total, and the running count, 
	the running mean then is simply the quotient of the two. 
	
	Below is an example that computes the running total 
	as sumwt, the running count as the variable cnt, and 
	the variable meanwt, which is equal to the sumwt divided 
	by cnt. 
	
	Note that meanwt is not retained because it has 
	an equals sign in its formula AND it is not declared as 
	a retained variable on a RETAIN statement. 
	
	The variables sumwt and cnt are retained (implicitly) 
	because there is no equals sign, and the terms ‘sumwt + wt’ 
	and ‘cnt + 1’ implicitly declare the variables sumwt 
	and cnt as retained variables, which will be used as 
	counters at each observation.
;

DATA sum2;
	SET kids;
	
		running_total + wt;
		cnt + 1;
		running_mean = running_total / cnt;
RUN;

PROC PRINT DATA=sum2;
	VAR famid wt running_total cnt running_mean;
RUN;



* Computing a running total using first. variables ============

	This section achieves the same goal as the above section, 
	but uses a different approach. 
	
	Here the implicitly retained variables sumwt and cnt are 
	initialized to zero for the first observation within each 
	family. 
	
	This is what the first.famid variable is used for. 
	
	If the current observation is the first observation 
	within a family, then sumwt and cnt are set to zero, 
	and the observations that follow within each family 
	have sumwt and cnt defined by the terms ‘sumwt + wt’ 
	and ‘cnt + 1’, each being a function of the previous 
	observations value for sumwt and cnt. 
	
	Note that the variable first.famid exists only because 
	famid was declared with the BY statement.
;

DATA sum3;
	SET kids;
	BY famid;
	
	* this resets the running total to 0 at the
		start of family;
	IF first.famid THEN
		DO;
			running_total = 0;
			cnt = 0;
		END;
	
	running_total + wt;
	cnt + 1;
	running_mean = running_total / cnt;
RUN;

PROC PRINT DATA=sum3;
	VAR famid wt running_total cnt running_mean;
RUN;


* Outputting observations using last. variables ============

	This next section is almost identical to the above section, 
	except that here ONLY the last observation within each 
	family is outputted to the dataset sum4. 
	
	This is what the variable last.famid is used for. 
	
	Note (again) that the variables first.famid and last.famid 
	only exist because famid was declared with the by 
	statement. 
	
	Lastly, only the variables famid, sumwt, cnt and 
	meanwt are kept in the dataset sum4. 
	
	This is achieved using the keep statement followed by 
	the list of variables one wants to keep.
;

DATA sum4;
	SET kids;
	
	BY famid;
	
	IF first.famid THEN
		DO;
			wt_total = 0;
			cnt = 0;
		END;
		
	wt_total + wt;	
	cnt + 1;
	wt_mean = wt_total / cnt;
	
	IF last.famid THEN
		DO;
			OUTPUT;
		END;
		
	KEEP famid wt_total cnt wt_mean;
RUN;

PROC PRINT DATA=sum4;
RUN;
		
		
		
* Computing a running total with explicitly retained variables
	==========================================================

	In the above sections, all retained variables were 
	implicitly declared with the terms ‘sumwt + wt’ and 
	‘cnt + 1’. 
	
	retained variables can also be explicitly declared 
	using the retain statement. 
	
	In the example below notice that the variables sumwt 
	and cnt are listed in the retain statement. 
	
	Moreover, notice that the terms ‘sumwt + wt’ and 
	‘cnt + 1’ have been replaced with the equations 
	‘sumwt = sumwt + wt’ and ‘cnt = cnt + 1’. 
	
	When variables are declared as retained variables, 
	explicitly, the counter equations must by given. 
	
	However, when variables are declared as retained 
	variables implicitly, ONLY the terms on the right side 
	of the counter equations are required.
;

DATA sum5;
	SET kids;
	
	BY famid;
	
	RETAIN wt_total cnt;
	
	IF first.famid THEN
		DO;
			wt_total = 0;
			cnt = 0;
		END;
		
	wt_total = wt_total + wt;
	cnt = cnt + 1;
	wt_mean = wt_total / cnt;
	
	IF last.famid THEN OUTPUT;
	
	KEEP famid wt_total cnt wt_mean;
	
RUN;

PROC PRINT DATA=sum5;
RUN;
	
			
			
* Sorting data before collapsing across observations =========
 
 All of the previous sections have worked on the assumption 
 that the data are sorted by famid, which is true of the 
 sample dataset kids defined in section 1. 
 
 However, if this is not the case, and the data are not 
 sorted by famid, then the results of a counter may be 
 incorrect. 
 
 Additionally, in some instances, you may need to 
 temporarily sort a dataset, but you may not want to sort 
 the main data file. 
 
 The example below sorts the dataset kids with proc sort 
 and names the sorted output dataset sortkids. 
 
 The dataset sum6 then uses the dataset sortkids instead of 
 the kids dataset.
;

PROC SORT DATA=kids OUT=sortkids;
	BY famid;
RUN;

DATA sum6;
	SET sortkids;
		RETAIN sumwt cnt;
		
		BY famid;
		
		IF first.famid THEN
			DO;
				sumwt = 0;
				cnt = 0;
		END;
				
		sumwt = sumwt + wt;
		cnt = cnt + 1;
		meanwt = sumwt / cnt;
		
		IF last.famid THEN OUTPUT;
		
		KEEP famid sumwt cnt meanwt;
RUN;

PROC PRINT DATA=sum6;
RUN;


		
		
		
		
		
		
		











