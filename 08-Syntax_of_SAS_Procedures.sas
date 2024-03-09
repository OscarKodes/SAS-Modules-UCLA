* #####################################################
	AN OVERVIEW OF THE SYNTAX OF SAS PROCEDURES #######
	
	This module will illustrate the general syntax of SAS 
	procedures. We will use the auto data file, shown below, 
	to illustrate the syntax of SAS procedures.
;

DATA auto;
	INPUT MAKE $ PRICE MPG REP78 FOREIGN;
DATALINES;
AMC    4099 22 3 0
AMC    4749 17 3 0
AMC    3799 22 3 0
Audi   9690 17 5 1
Audi   6295 23 3 1
BMW    9735 25 4 1
Buick  4816 20 3 0
Buick  7827 15 4 0
Buick  5788 18 3 0
Buick  4453 26 3 0
Buick  5189 20 3 0
Buick 10372 16 3 0
Buick  4082 19 3 0
Cad.  11385 14 3 0
Cad.  14500 14 2 0
Cad.  15906 21 3 0
Chev.  3299 29 3 0
Chev.  5705 16 4 0
Chev.  4504 22 3 0
Chev.  5104 22 2 0
Chev.  3667 24 2 0
Chev.  3955 19 3 0
Datsun 6229 23 4 1
Datsun 4589 35 5 1
Datsun 5079 24 4 1
Datsun 8129 21 4 1
;
RUN;




* PROC with NO OPTIONS =====================================
	Now, lets have a look at the use of SAS procedures using 
	proc means as an example.  Here we show that it is possible 
	to use proc means with no options at all.  
	
	By default,SAS uses the last data file created (i.e., auto) 
	and it provides means for all of the numeric variables in 
	the data file.
;

PROC MEANS;
RUN;




* PROC STATEMENT WITH OPTIONS =====================================
	We can use the data= option to tell proc means to tell SAS 
	what data file will be used to perform the means procedure. 
	
	The data= option comes right after proc means.  
	
	Even though the data= option is optional, we strongly 
	recommend using it every time because it avoids errors 
	of omission when you revise your programs.
;

PROC MEANS DATA=auto;
RUN;

* We can use the n, mean and std options to tell proc means that 
	we just want the N, mean and standard deviation for the 
	data.;
PROC MEANS DATA=auto N MEAN STD;
RUN;





* USING ADDITIONAL STATEMENTS =================================
	Proc means also supports additional statements.  Here we 
	use the var statement to say which variable(s) we want 
	SAS to produce means for.
;
PROC MEANS DATA=auto;
	VAR price;
RUN;





* Here we also use the class statement to request means broken 
	down by  the variable foreign (i.e., foreign and domestic 
	cars).;
PROC MEANS DATA=auto;
	CLASS foreign;
	VAR price;
RUN;
* As we requested, the means of price are shown for the two 
	levels of foreign.
	
	These examples have shown that you can have additional 
	statements with a proc (for example, the var and class 
	statements). Each proc has its own set of additional 
	statements that are valid for that proc.;
	




* OPTIONS ON ADDITIONAL STATEMENTS ==========================
	It is also possible to have options on the additional 
	statements lines (the statements after the proc statement).  
	We will illustrate this using proc reg.

	Here we use proc reg to predict price from mpg.  We use 
	the model statement to tell proc reg that we want to predict 
	price from mpg.
;
PROC REG DATA=auto;
	MODEL price=mpg;
RUN;
QUIT;
* Notice that we don’t get standardized estimates (betas).  
	We have to ask proc reg to give those to us.  
	In particular, we use the stb option on the model 
	statement, as shown below.  Note that the stb option 
	comes after a forward slash ( / ).  
	
	Options on a proc statement come right after the name of 
	the proc, but options for subsequent statements must 
	follow a forward slash.
;

PROC REG DATA=auto;
	MODEL price=mpg / STB;
RUN;
* The output here the same as the output above, except that it
	also includes the standardized estimates (betas).;
	
	
	
	
	
	
	
* MORE EXAMPLES ===========================================
	We have illustrated the general syntax of SAS procedures 
	using proc means and proc reg.  
	
	Let’s look at a few more examples, this time using proc 
	freq.  
	
	As you may imagine, proc freq is used for generating 
	frequency tables.  From what we have learned, we would 
	expect that proc freq would have:
	
		– Options on the proc freq statement that would 
			influence the way that the tables look.
			
		– Additional statements that would specify what tables 
			to produce.
			
		– Options on the additional statements lines that 
			would influence how those particular tables look.
			
	First, consider the program below.  As you might expect, 
	the program below would generate frequency tables for 
	every variable in the auto data file.
;
PROC FREQ DATA=auto;
RUN;


* If we use the page option, proc freq will start every 
	table on a new page.  Note that this influences all of 
	the tables produced in that proc freq procedure.;
PROC FREQ DATA=auto PAGE;
RUN;


* We have also seen that a SAS procedure can have one or more 
	optional statements.  Below we show that we can have one 
	or more tables statements to specify the frequency tables 
	we want, in this case, tables for rep78 and price.  
	
	Because we used the page option, each table will start on a 
	new page.  
	
	This influences both the tables made for rep78 and price.  
	
	(Note that we could have specified tables rep78 price, 
	and gotten the same result, but we wanted to illustrate 
	having more than one tables statement.);
PROC FREQ DATA=auto PAGE;
	TABLES rep78;
	TABLES price;
RUN;

PROC FREQ DATA=auto PAGE;
	TABLES rep78 price;
RUN;




* As we might expect, we could supply options on each of the 
	tables statements to determine how those particular tables 
	are to be shown.  
	
	The example below requests frequency tables for rep78 
	and price, but the table for rep78 will omit percentages 
	because it used the nopercent option.  
	
	Both tables will appear on a new page (because the page 
	option influences all of the tables) but only rep78 will 
	suppress the printing of percentages because the nopercent 
	option only applies to that one tables statement.;
PROC FREQ DATA=auto PAGE;
	TABLES rep78 / NOPERCENT;
	TABLES price;
RUN;




* PROBLEMS TO LOOK OUT FOR ---------------------------------

	When you use options, it is easy to confuse an option that 
	goes on the proc statement with options that follow on 
	subsequent statements.
;





