* PROC MEANS - COLLAPSING ACROSS OBSERVATIONS IN SAS ############

	(Collapsing across records is the same as
		using GROUP BY and an aggregate function in SQL.
		
		It's just another name for putting 
		observations into specified groups
		and deriving specific summary statistics 
		from each group.)

	Here we illustrate how to collapse data across 
	observations using proc means.  Our example uses a 
	hypothetical data set containing information about kids 
	in three families.  These examples show how you can 
	collapse across kids to form family records from the 
	kids records.
;

* Reading the data file =====================================

	Here is the SAS program that makes a data file called kids.  
	It contains three families (famid) each with three kids.  
	It contains the family ID, the name of the kid, the order 
	of birth (1 2 3 for 1st, 2nd, 3rd), and the age, weight 
	and sex of each kid.
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

* Using proc means to collapse data across records ===========

	We can use proc means to collapse across across families.  
	
	The example below computes the average age of each child 
	within each family (because of the class famid statement) 
	and then outputs the results into a SAS data file called 
	fam2.
;

PROC MEANS DATA=kids;
	CLASS famid;
	VAR age;
	OUTPUT OUT=fam2 MEAN=;
RUN;

PROC PRINT DATA=fam2;
RUN;

* And this output shows that the data file fam2 contains 
	the average of age for the kids for each family.
	
	However, there is one extra record.  
	
	This is the overall mean (notice that the _FREQ_ for 
	it is 9, and there are a total of nine kids).  We really 
	don’t want this record.
	
	We can suppress the creation of the record with the overall 
	mean with the nway option on the proc means statement.  
	
	In general, when you use proc means with the class 
	statement and make an output data file, you usually will 
	want to use the NWAY option as shown below.
	
	"You can use the NWAY statement in PROC SUMMARY in SAS 
	to only calculate summary statistics at a group level 
	rather than calculating them for an entire dataset."
;

PROC MEANS DATA=kids NWAY;
	CLASS famid;
	VAR age;
	OUTPUT OUT=fam3 MEAN=;
RUN;

PROC PRINT DATA=fam3;
RUN;

* Now, the fam3 data file had just has three records with 
	the average age for each family.;
* Explicitly naming the collapsed variables ===================

	The following proc means example does the exact same thing 
	as the prior example, except that the average of age is 
	explicitly named, calling it "average_age"
;

PROC MEANS DATA=kids NWAY;
	CLASS famid;
	VAR age;
	OUTPUT OUT=fam4 MEAN=average_age;
RUN;

PROC PRINT DATA=fam4;
RUN;

* The rest of the examples will explicitly name the collapsed 
	variables (e.g., use mean=average_age instead of just mean= ).  
	
	In general, it is better to explicitly name the variables 
	to avoid confusion between the original variable and the 
	collapsed variable.;
* Getting means of more than one variable ====================

	We can request averages for more than one variable. 
	Here we get the average for age and for wt all in the 
	same command.
;

PROC MEANS DATA=kids NWAY;
	CLASS famid;
	VAR age wt;
	OUTPUT OUT=fam5 MEAN=average_age average_wt;
RUN;

PROC PRINT DATA=fam5;
RUN;

* Requesting multiple statistics at once ====================

	We can request multiple statistics at once.  
	
	The command below  gets the mean, standard deviation and 
	age (mean std and N) for age and wt within each family.
;

PROC MEANS DATA=kids NWAY;
	CLASS famid;
	VAR age wt;
	OUTPUT OUT=fam6 MEAN=average_age average_wt STD=std_age std_wt N=N_age N_wt;
RUN;

PROC PRINT DATA=fam6;
RUN;

* Suppressing  proc means output ==========================

	In our example, we have just three families. For your data, 
	you might have dozens, hundreds, or thousands of families 
	(or whatever grouping you are using). 
	
	The output of the proc means can get very long, so you 
	may want to suppress the output. You can do that with 
	the noprint option as shown below.
;

PROC MEANS DATA=kids NWAY NOPRINT;
	CLASS famid;
	VAR age wt;
	OUTPUT OUT=fam7 MEAN=average_age average_wt STD=std_age std_wt N=n_age n_wt;
RUN;

* The output from the proc means is not printed 
	due to the noprint option.;
* Counting the number of boys and girls in the family ========

	Suppose you wanted a count of the number of boys and 
	girls in the family. We can do that with one extra step. 
	
	We will make a dummy variable that is 1 if a boy 
	(0 if not), and a dummy variable that is 1 if a girl 
	(and 0 if not). 
	
	The sum of the boy dummy variable within a family is the 
	number of boys in the family and the sum of the girl 
	dummy variable within a family is the number of girls in 
	the family. 
	
	First, we use a data step to make the boy and girl 
	dummy variable.
;

DATA kids2;
	SET kids;

	IF sex='m' THEN
		boy=1;
	ELSE
		boy=0;

	IF sex='f' THEN
		girl=1;
	ELSE
		girl=0;
RUN;

PROC PRINT DATA=kids2;
	VAR sex boy girl;
RUN;

* We use proc means to sum up the boy and girl dummy variables 
	for each family and to create a data file called fam8 that 
	contains the sum of boy in boys and the sum of girl in 
	girls.  
	
	We use the noprint option to suppress the output of the 
	proc means.
;

PROC MEANS DATA=kids2 NWAY NOPRINT;
	CLASS famid;
	VAR boy girl;
	OUTPUT OUT=fam8 SUM=boys girls;
RUN;

PROC PRINT DATA=fam8;
RUN;

* Merging the collapsed data back with the original data========

	Sometimes you want to merge the collapsed data back with 
	the original data. 
	
	Let’s use an example creating avgage and avgwt for each 
	family, then merge those results back with the original 
	kids data.

	First, let’s collapse the data across families to make 
	avgage and avgwt just as we have done before.
;

PROC MEANS DATA=kids NWAY NOPRINT;
	CLASS famid;
	VAR age wt;
	OUTPUT OUT=fam9 MEAN=average_age average_wt;
RUN;

* Second, we sort kids and sort fam9 both on famid, 
	preparing for merging them together.;

PROC SORT DATA=kids OUT=sorted_kids;
	BY famid;
RUN;

PROC SORT DATA=fam9 OUT=sorted_fam9;
	BY famid;
RUN;

* Third, we merge the sorted files together (skids and sfam9) 
	by famid.  We can drop _type_ and _freq_ since they 
	are not needed, but we don’t have to drop them.
;

DATA kids_merge;
	MERGE sorted_kids sorted_fam9;
	BY famid;
	DROP _type_ _freq_;
RUN;

* We can print out the results, showing that the variables 
	avgage and avgwt are now merged back with the original 
	kids so each kid has the associated average age and 
	weight for their family.
;

PROC PRINT DATA=kids_merge;
RUN;

* Problems to look out for =================================

	You may end up with records that you were not expecting 
	if you forget to use the nway option.
	
	If you collapse across records, and then remerge back 
	with the original data, be sure that you explicitly 
	name the variables when you collapse them.  
	
	If you don’t, the variables from the collapsed data 
	will have the same names as the original data, and they 
	will clash when you remerge the data.
;