* COLLAPSING ACROSS OBSERVATIONS DATA STEP I #####################

	This module will illustrate how to collapse across variables. 
	
	First, let’s read in a sample dataset named kids which 
	includes the variables famid (family id) and 
	wt (kids weight in pounds).
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
4 Sam  1 11 100  m
4 Stu  2  8  90  m
;
RUN;

PROC PRINT DATA=kids;
RUN;


* Collapsing and computing average weights using proc means =====
	
	Next, by using proc means, one can create a variable that 
	represents the sum of ALL the weights of each person within 
	a family, a variable that represents the average weight of 
	each person within a family, and a variable that counts the 
	number of people within a family. 
	
	This can be seen in the example below, where three new 
	variables, sumwt, meanwt and cnt, are created by famid, 
	and then written to the new dataset fam1.
;

PROC MEANS DATA=kids NWAY;
	CLASS famid;
	VAR wt;
	OUTPUT OUT=fam1 SUM=sum_wt MEAN=mean_wt N=count;
RUN;

PROC PRINT DATA=fam1;
	VAR famid sum_wt mean_wt count;
RUN;



* Collapsing and computing average weights manually 
	(collapsing across observations) ========================
	
	Of course, collapsing can always be done manually within 
	a data step. 
	
	This, however, requires a bit more complex SAS programming. 
	
	To create sum, mean, and N (sample size) variables that 
	summarize values within a group (e.g., families), 
	one can count over observations within a group by using a 
	retained variable and a counter. 
	
	In the example below, retained counter variables are 
	created that count across observations within families 
	until the last record within a family is encountered. 
	
	(This is possible because a retained variable allows the 
	value for the last observation to be available for use 
	when accessing the current observation.) 
	
	Then, the retained variable from the last observation 
	within each family is written to the new SAS dataset fam2. 
	
	At the final step, only the variables famid, sumwt, meanwt, 
	and cnt are kept in the dataset fam2. 
	
	Note that the variable meanwt does NOT need to be retained. 
	
	This is because at each step, it is simply a function of 
	the retained variables sumwt and cnt.
;

* start by sorting the data by famid;
PROC SORT DATA=kids OUT=sortkids;
	BY famid;
RUN;

* creating fam2 using the sorted dataset;
DATA fam2;

	SET sortkids;
		BY famid;

	* RETAIN Causes a variable that is created by an INPUT 
		or assignment statement to retain its value from 
		one iteration of the DATA step to the next; 
		
	RETAIN sum_wt count;
	
	* if it's the first record of that famid group,
		we reset sum_wt and count to 0;
		
	IF first.famid THEN
		DO;
			sum_wt = 0;
			count = 0;
		END;
	
	* each row we add to sum_wt and count;
	sum_wt = sum_wt + wt;
	count = count + 1;
	
	* create variable for mean weight using sum_wt and count;
	mean_wt = sum_wt / count;
	
	* at the very last observation within a famid group,
		we want to output our results;
	IF last.famid THEN OUTPUT;
	
	* KEEP Includes variables in output SAS data sets;
	KEEP famid sum_wt mean_wt count;
RUN;

PROC PRINT DATA=fam2;
RUN;
	
	
	
* Computing sums, counts and other summary information =======
	
	The above example illustrated how one can compute sums, 
	means, and counts within groups using the retain statement 
	within a data step. 
	
	Other variables, such as dummy or flag variables, can 
	also be computed using the retain statement. 
	
	For example, say a study is interested in 
		(1) the number of boys in each family, 
		(2) whether or not there is a girl in the family and 
		(3) if any of the children in each family are over 
			85 pounds in weight. 
			
	All of this information can be collected and stored 
	using the retain statement. 
	
	The example below works similarly to the example above 
	
	however, this example additionally creates a variable 
	numboys, which counts the number of boys in each family, 
	and the flag variables hasgirl and over85, which 
	take on the values of ‘1’ or ‘0’, depending on whether 
	or not there is a girl in the family, or if a family has 
	a child over 85 pounds, respectively.
;

* sort kids by famid and save it as "sortkids";
PROC SORT DATA=kids OUT=sortkids;
	BY famid;
RUN;

DATA fam3;

	* using the sortkids dataset;
	SET sortkids;
	BY famid; * BY Controls the operation of a SET, MERGE, 
			MODIFY, or UPDATE statement in the DATA step 
				and sets up special grouping variables.;
	
	* create variables to retain throughout the DO loops;
	RETAIN sumwt cnt numboys hasgirl over85;
	
	* if we're at the first row of a famid group set
		variables to 0;
	IF first.famid THEN
		DO;
			sumwt = 0; *sum of wt for family;
			cnt = 0; * count of kids in family;
			numboys = 0; * number of boys in family;
			hasgirl = 0; * 1 if family has a girl, 0 if not;
			over85 = 0; * 1 if family has a child over 85lbs
							0 if not;
	END;
	
	* create sumwt to accumulate the weights of kids;
	sumwt = sumwt + wt;
	
	* create cnt to divide sumwt later for meanwt;
	cnt = cnt + 1;
	
	* conditional statements to count the number of boys
		and check if there's a girl and if there's
		a child over 85lbs;
	IF (sex = 'm') THEN numboys = numboys + 1;
	IF (sex = 'f') THEN hasgirl = 1;
	IF (wt > 85) THEN over85 = 1;
	
	* this outputs a record ONLY when at the 
		last obs in a family;
	IF last.famid THEN
		DO;
			meanwt = sumwt / cnt; * do any final computations
						before outputting record;
			OUTPUT;
		END; 
		
	KEEP famid sumwt cnt numboys hasgirl over85 meanwt;
RUN;

PROC PRINT DATA=fam3;
RUN;





























	
	
	
	
	
	
	
	


















