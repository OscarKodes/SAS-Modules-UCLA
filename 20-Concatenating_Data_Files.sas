* ##########################################################
	CONCATENATING DATA FILES IN SAS
	
	When you have two data files, you may want to combine them 
	by stacking them one on top of the other (referred to 
	as concatenating files). Below we have a file called 
 	and a file containing faes.
;



* CONCATENATING HOBBITS AND FAES ===========================

	The SAS program below creates a SAS data file called 
	hobbits and a file called faes. It then combines them 
	(concatenates them) creating a file called hobbitfae.
;

* Here is a file with information about hobbits with their 
	family id name and income ; 
DATA hobbits; 
  INPUT famid name $ inc ; 
CARDS; 
2 Art  22000 
1 Bill 30000 
3 Paul 25000 
; 
RUN; 

* Here is a file with information about faes with their 
	family id name and income ; 
DATA faes; 
  INPUT famid name $ inc ; 
CARDS; 
1 Bess 15000 
3 Pat  50000 
2 Amy  18000 
; 
RUN; 

* We can combine these files by stacking them one on top the 
	other ; 
* by setting them both together in the same data step as shown 
	below ; 

DATA hobbitfae; 
  SET hobbits faes; 
RUN; 

 * Let's use PROC PRINT to look at the result ; 
PROC PRINT DATA=hobbitfae; 
RUN;  

* The output from this program shows that the files were 
	combined properly. The hobbits and faes are stacked together 
	in one file. But, there is a little problem. We can’t tell 
	the hobbits from the faes. Let’s try doing this again but in 
	such a way that we can tell which observations are the 
	faes and which are the hobbits.;


* CONCATENATING THE HOBBITS AND FAES (BETTER EXAMPLE) =======
	
	In order to tell the hobbits from the faes, let’s create a 
	variable called faehobbit in the hobbits and faes data files 
	that will contain hobbit for the hobbits data file and fae 
	for the faes data file. When we combine the two files 
	together the faehobbit variable will tell us who the faes 
	and hobbits are.
;

DATA hobbits;
	INPUT famid name $ inc;
	faehobbit = "hobbit";
CARDS;
2 Art  22000 
1 Bill   30000 
3 Paul  25000 
; 
RUN;

DATA faes;
	INPUT famid name $ inc;
	faehobbit = "fae";
CARDS; 
1 Bess  15000 
3 Pat   50000 
2 Amy  18000 
; 
RUN;

DATA hobbitfae;
	SET hobbits faes;
RUN;

* Now when we do the proc print you can see the hobbits 
	from the faes ;  
PROC PRINT DATA=hobbitfae;
RUN;
 
* Here we get a more desirable result, because we can 
	tell the hobbits from the faes by looking at the variable 
	faehobbit. This required some thinking ahead because we had 
	to put faehobbit in both the hobbits data file and the faes 
	data file before we merged the data files.;



* alternate way to join tables ===============================
	and adding in the faehobbit column using PROC SQL;
	
* first we create the original datasets;
DATA hobbits; 
  INPUT famid name $ inc ; 
CARDS; 
2 Art  22000 
1 Bill 30000 
3 Paul 25000 
; 
RUN; 

DATA faes; 
  INPUT famid name $ inc ; 
CARDS; 
1 Bess 15000 
3 Pat  50000 
2 Amy  18000 
; 
RUN; 

* then with PROC SQL we combine them;
PROC SQL;
	CREATE TABLE hobbitfae_2 AS

	SELECT *,
		"hobbit" AS faehobbit
	FROM hobbits
	
	UNION ALL
	
	SELECT *,
		"fae" AS faehobbit
	FROM faes;
QUIT;

PROC PRINT DATA=hobbitfae_2;
RUN;





* PROBLEMS TO LOOK OUT FOR -------------------------------

	These above examples cover situations where there are 
	no complications. However, look out for the following 
	problems.
;



* The two data files have different variable names for the 
	same thing =============================================
	
	For example, income is called hobbitinc and in the hobbits 
	file and called faeinc in the faes file, as shown below.;

DATA hobbits;
	INPUT famid name $ hobbitinc;
DATALINES;
2 Art  22000
1 Bill 30000
3 Paul 25000
;
RUN;

DATA faes;
	INPUT famid name $ faeinc;
DATALINES;
1 Bess 15000
3 Pat  50000
2 Amy  18000
;
RUN;

* IN creates a Boolean variable that indicates whether 
	the data set contributed data to the current observation.;
DATA faehobbit;
	SET hobbits(IN=hobbit)
		faes(IN=fae);
	IF hobbit=1 THEN faehobbit="hobbit";
	IF fae=1 THEN faehobbit="fae";
RUN;

PROC PRINT DATA=faehobbit;
RUN;



* Solution #1. The most obvious solution is to choose 
	appropriate variable names for the original files 
	(i.e., name the variable inc in both the faes and 
	hobbits file). This solution is not always possible 
	since you might be concatenating files that you did 
	not originally create. To save space, we omit 
	illustrating this solution.

  Solution #2. If solution #1 is not possible, 
  	then this problem can be addressed using an if 
  	statement in a data step.;

DATA combined;
	SET hobbits(IN=hobbit)
		faes(IN=fae);
	IF hobbit=1 THEN
		DO;
			faehobbit="hobbit";
			inc=hobbitinc;
		END;
	IF fae=1 THEN
		DO;
			faehobbit="fae";
			inc=faeinc;
		END;
RUN;

PROC PRINT DATA=combined;
RUN;




* Solution 3. Another way you can fix this is by using the 
	"rename" option on the "set" statement of a data step to 
	rename the variables just before the files are combined.;

DATA faehobbit;
	SET hobbits(RENAME=(hobbitinc=inc))
		faes(RENAME=(faeinc=inc));
RUN;

PROC PRINT DATA=faehobbit;
RUN;




* The two data files have different lengths for variables 
	of the same name =========================================
	
	In all of the examples above, the variable name was 
	input with the format $ indicating name is an 
	alphabetic (string) variable with a default length 
	of 8. 
	
	What would happen if name in the hobbits file was 
	input using $3. and name in the faes file was input 
	using $4. ? 
	
	This is illustrated below.;
	
DATA hobbits; 
  INPUT famid name $3. inc;
DATALINES;  
 2 Art  22000 
 1 Bob  30000 
 3 Tom  25000
;
RUN;  

DATA faes;  
  INPUT famid name $4. inc; 
DATALINES;  
 1 Bess 15000  
 3 Rory 50000  
 2 Jane 18000 
;
RUN;  

DATA faehobbit; 
  SET hobbits faes;
RUN; 

PROC PRINT DATA=faehobbit; 
RUN; 

* Note that the names for the faes are truncated to be 
	length 3. 
	
	This is because the length for names in the 
	hobbits file is 3. 
	
	To fix this, use the length statement 
	in the data step that merges the two files.;

DATA faehobbit;
	LENGTH name $ 4;
	SET hobbits faes;
RUN;

PROC PRINT DATA=faehobbit;
RUN;




* The two data files have variables with the same name but 
	different codes ======================================
	
	This problem is similar to the problem above, except that 
	it has an additional wrinkle, illustrated below. 
	
	In the hobbits file there is a variable called is_pirate 
	that is coded 1 if the hobbit is working pirate time, 0 if it 
	is not. 
	
	The faes file also has a variable called is_pirate that is 
	coded Y is it is working pirate time, and N if it is not. 
	
	Not only are these variables of different types (numeric 
	and character), but they are coded differently as well.
;

DATA hobbits;
	INPUT famid name $ inc is_pirate;
DATALINES;
2 Art  22000 0
1 Bill 30000 1
3 Paul 25000 1
;
RUN;

DATA faes;
	INPUT famid name $ inc is_pirate $1.;
DATALINES;
1 Bess 15000 N
3 Pat  50000 Y
2 Amy  18000 N
;
RUN;

* Solution #1. Code the variables in the two files in the 
	same way. 
	
	For example, code is_pirate using 0/1 for both files 
	with 1 indicating is a pirate. This is the simplest 
	solution if you are creating the files yourself. 
	We will omit illustrating this solution to save space.

  Solution #2. You may not have created the original raw 
  	data files, so solution #1 may not be possible for you. 
  	In that case, you can create a new variable in each file 
  	that has the same coding and will be compatible when you 
  	merge the files. Below we illustrate this strategy.

	For the hobbits file, we make a variable called pirate 
	that is the same as is_pirate, and save the file as 
	hobbits2, dropping is_pirate. 
	
	For the faes, we create 
	pirate by recoding is_pirate, and save the file as 
	faes2, also dropping is_pirate. 
	
	The files hobbits2 
	and faes2 both have the variable pirate coded the 
	same way (0/1 where 1=works pirate time) so we can 
	combine those files together.;


* create new hobbit table
	create variable "pirate" from is_pirate
	then we drop the original "is_pirate" variable;
DATA hobbits2;
	SET hobbits;
	pirate=is_pirate;
	DROP is_pirate;
RUN;

* create new fae table
	create variable "pirate" from is_pirate, but 
	recode Y and N as 1 and 0
	then we drop the original "is_pirate" variable;
DATA faes2;
	SET faes;
	IF is_pirate="Y" THEN pirate=1;
	IF is_pirate="N" THEN pirate=0;
	DROP is_pirate;

* combine them;
DATA faehobbit;
	SET hobbits2 faes2;
RUN;

PROC PRINT DATA=faehobbit;
RUN;

















