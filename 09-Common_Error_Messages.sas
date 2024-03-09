* ############################################################
	COMMON ERROR MESSAGES IN SAS #############################
	
	When a SAS program is executed, SAS generates a log. 
	The log echoes program statements, provides information 
	about computer resources and provides diagnostic information. 

	Understanding the log enables you to identify and correct 
	errors in your program. The log contains three types of 
	messages: Notes, Warnings and Errors. Although notes and 
	warnings will not cause the program to terminate, they are 
	worthy of your attention, since they may alert you to 
	potential problems. An error message is more serious, 
	since it indicates that the program has failed and stopped 
	execution.

	Most of the errors can be easily corrected and this page 
	discusses how some common errors occur and how to correct 
	them.
;



* ================================================= 
	Strategies in finding and correcting errors
	
	1. Start at the beginning
		Do not become alarmed if your program has several 
		errors in it. Sometimes there is a single error in 
		the beginning of the program that causes the others. 
		Correcting this error may eliminate all those that 
		follow. Start at the beginning of your program and 
		work down.

	2. Debug your programs one step at a time
		SAS executes programs in steps, so even if you 
		have an error in a step written in the beginning 
		of your program, SAS will try to execute all 
		subsequent steps, which wastes not only your time, 
		but computer resources as well. Simplify your work. 
		Correct your programs one step at a time, before 
		proceeding to the next step. As mentioned above, 
		often a single error in the beginning of the program 
		can create a cascading error effect. Correcting 
		an error in a previous step may eliminate other errors.

		Look at the statements immediately above and 
		immediately following the line with the error. 
		SAS will underline the error where it detects it, 
		but sometimes the actual error is in a different place 
		in your program, typically the preceding line.

	3. Look for common errors first
		Most errors are caused by a few very common mistakes.
;




* =======================================================
	Common error 1

	Missing semicolon

		This is by far the most common error. A missing 
		semicolon will cause SAS to misinterpret not only 
		the statement where the semicolon is missing, 
		but possibly several statements that follow. 
		Consider the following program, which is correct, 
		except for the missing semicolon:
;

PROC PRINT DATA=auto
	VAR make mpg;
RUN;
* The missing semicolon causes SAS to read the two statements 
	as a single statement. As a result, the var statement 
	is read as an option to the procedure. Since there is no 
	var option in proc print, the program fails.;
	
	

* The syntax for the following program is absolutely correct, 
	except for the missing semicolon on the comment:;
	
* Build a file named auto2
DATA auto2;
	SET auto;
	ratio=mpg/weight;
RUN;







* =======================================================
	Common error 2

	Misspellings

		Sometimes SAS will correct your spelling mistakes 
		for you by making its best guess at what you meant 
		to do. When this happens, SAS will continue execution 
		and issue a warning explaining the assumption it 
		has made. Consider for example, the following 
		program:
;

* Note that the word "DATA" is misspelled. If we were to 
	run this program, SAS would correct the spelling and 
	run the program but issue a warning.;
DAT auto ;
  INPUT make $  mpg rep78 weight foreign ;
CARDS;
AMC     22 3 2930 0
AMC     17 3 3350 0
AMC     22 . 2640 0
;
RUN;


* Sometimes SAS identifies a spelling error in a note, 
	which does not cause the program to fail. Never assume 
	that a program that has run without errors is correct! 
	Always review the SAS log for notes and warning as well 
	as errors.
	
	The following program runs successfully, but is it correct?
;
DATA auto2;
	SET auto;
	ratio = mpg/wieght;
RUN;
* A careful review of the SAS log reveals that it is not:
	NOTE: Variable wieght is uninitialized.
 	NOTE: Missing values were generated as a result of 
 		performing an operation on missing values.;
 		
 		
 		
* 	Sometimes missing values are legitimate. However, when 
 		a variable is missing for every record in the file, 
 		there may be a problem with the program, as 
 		illustrated above. More often, when your program 
 		contains spelling errors, the step will terminate 
 		and SAS will issue an error statement or a note 
 		underlining the word, or words, it does not recognize.;	
PROC PRINT
	VAR make mpg weight;
RUN;
* In this example, there is nothing wrong with the var 
	statement. Adding a semicolon to the proc print 
	solves the problem.;
	
PROC PRINT;
	VAR make mpg weight;
RUN;



* The following code will successfully create a new dataset 
	auto2.

	However, because we misspelled the dataset name in the 
	set statement, the new dataset contains 0 observations.;
DATA auto2;
	SET uato;
	ratio = mpg/weight;
RUN;
* ERROR: File WORK.UATO.DATA does not exist.

	The error message indicates that no dataset exists with 
	the name uato and the warning message hints that the 
	new dataset may be problematic.  
	
	Correcting the spelling solves the problem.
;







* =======================================================
	Common error 3

	Wrong data type

		Consider the following data step. It runs without 
		an error message. But does it give us the intended 
		result?
;
DATA test;
	INPUT a b;
CARDS;
john  1
megan 2
;
RUN;

PROC PRINT DATA=test;
RUN;
* Obviously, variable "a" has not been created as desired. 
	This is because that "a" should be created as a character 
	variable using the dollar sign specification for 
	character variables. Instead, since the dollar sign 
	is missing, SAS assumes that "a" is of numeric type, 
	such as an integer or a real number and SAS expects 
	to encounter a numeric value whenever it is ready to 
	read in something for "a". Now, let’s take a look at 
	the log and see how SAS reacts to not seeing a number 
	for "a."
	
	Indeed, there are no error messages in red. But each NOTE 
	offers some detailed information. The first NOTE says 
	that the data for variable "a" is invalid in line 2311 
	position 1-4. Since line 2310 is the line corresponding 
	to the statement "cards", line 2311 corresponds to the 
	first line of data which starts with input john. So 
	the NOTE is basically saying that "john" is not a 
	valid numeric value. Once we understand the message, 
	correcting our code is usually simple enough and in 
	this case, we just need to add a dollar sign after 
	variable "a"  in the input statement as shown below.;
DATA test;
	INPUT a $ b;
CARDS;
john  1
megan 2
;
RUN;

PROC PRINT DATA=test;
RUN;
	






* =======================================================
	Common error 4

	Unmatched quotes/comments

		Unclosed quotes and unclosed comments will result 
		in a variety of errors because SAS will fail to read 
		subsequent statements correctly. If you are running 
		interactively, your program may appear to be doing 
		nothing, because SAS is waiting for the end of the 
		quoted string or comment before continuing.  
		
		For example, if we were to run the following 
		program,
		
		SAS would not execute the run statement. Instead it 
			reads it as part of the title statement, because 
			the title statement is missing the closing double 
			quotes. When this block of code is run, the 
			program would appear to be doing nothing. System 
			messages would indicate that it is running, 
			which in fact it is. However, SAS is reading 
			the rest of the program, waiting the double quote 
			that will end the step it is currently stuck on.;
			
PROC PRINT DATA=auto (OBS=5);
	VAR mpg foreign;
	TITLE "printing first five observations';
RUN;




";
	






* =======================================================
	Common error 5

	Mixing proc and data statements

		Since the data and proc steps perform very different 
		functions in SAS, statements that are valid for one 
		will probably cause an error when used in the other. 
		Although a program may include several steps, these 
		steps are processed separately.
		
		A step ends in one of three ways:

		1. SAS encounters a keyword that begins a new step 
			(either proc or data)
			
		2. SAS encounters the run statement, which instructs 
			it to run the previous step(s)
			
		3. SAS encounters the end of the program.
		
		Each data, proc and run statement causes the previous 
		step to execute. Consequently, once a new step has 
		begun, you may not go back and add statements to an 
		earlier step. Consider this program, for example.;

DATA auto2;
	SET auto;

PROC SORT;
	BY make;
	ratio = mpg/weight;
RUN;
* SAS creates the new file auto2 when it reaches the end of 
	the data step. This occurs when it encounters the 
	beginning of a new step (in this example proc sort). 
	
	Consequently, the assignment statement 
	(ratio = mpg/weight) is invalid because the data step 
	has been terminated, and an assignment statement cannot 
	be used in a procedure.;

* Simply moving the assignment statement solves the problem.;
DATA auto2;
	SET auto;
	ratio = mpg/weight;
	
PROC SORT;
	BY make;
RUN;
	






* =======================================================
	Common error 6

	Using options with the wrong proc

		Similarly, although many options work with a variety 
		of procedures, some are only valid when used with a 
		particular procedure. Remember to evaluate all errors 
		in context. A perfectly correct statement or option 
		may cause an error not because it is written 
		incorrectly, but because it is being used in the 
		wrong place.
		
		The var statement is not valid when used with proc freq. 
		Change the statement to tables and the program runs 
		successfully.;
PROC FREQ DATA=auto2;
	VAR make;
RUN;

PROC FREQ DATA=auto2;
	TABLES make;
RUN;

* Conversely, the tables statement may not work with other 
	procedures.;
PROC MEANS DATA=auto2;
	TABLES mpg;
RUN;

* In this example, the var statement is correct:;
PROC MEANS DATA=auto2;
	VAR mpg;
RUN;
	






* =======================================================
	Common error 7

	Logic errors

		Consider the log generated when the following program 
		is run:;
DATA auto2;
	SET auto;
	IF tons > .5;
	tons = weight/2000;
RUN;
* Although the program ran with no errors, the new data set 
	has no observations in it. Since we would expect most 
	cars to weigh more than half a ton, there is probably 
	an error in the program logic. In this case, we are 
	subsetting on a variable that has not yet been defined.
	
	SAS Log 
	
	NOTE: The data set WORK.AUTO2 has 0 observations  
	
	
	Changing the order of the programming statements yields 
	a different result:;
DATA auto2;
	SET auto;
	tons = weight/2000;
	isHeavy = 0;
	IF tons > .5
	THEN isHeavy = 1;
RUN;
	






* =======================================================
	Common error 8

	Missing options when dealing with missing data

		Consider following data stored in a text file called 
		test.txt and the data step for reading the data.;

DATA test;
	INFILE "/home/u63650566/UCLA_Modules/data_for_lesson_08.txt";
	INPUT a $ age y;
RUN;

PROC PRINT DATA=test;
RUN;
* This is obviously not what we have intended. There should 
	be two observations and there is only one. Most likely 
	this is due to missing data and this is the case for 
	this example. The value for the variable "y" is missing 
	from row 1. 
	
	In this case, we need to use the option 
	"missover" of the infile statement  to instruct SAS not 
	to go a new input line if it does not find valid values 
	in the current input line.  Here is corrected version of 
	the code together with the output.;
DATA test;
	INFILE "/home/u63650566/UCLA_Modules/data_for_lesson_08.txt"
	MISSOVER;
	INPUT a $ age y;
RUN;

PROC PRINT DATA=test;
RUN;
	




* This is data to be used in the next example;
DATA auto;
	INPUT make $ price mpg rep78 weight length foreign;
DATALINES;
Buick   4082 19  3     3400   200    0
Cad.   11385 14  3     4330   221    0
Cad.   14500 14  2     3900   204    0
Cad.   15906 21  3     4290   204    0
Chev.   3299 29  3     2110   163    0
Chev.   5705 16  4     3690   212    0
Datsun  5079 24  4     2280   170    1
AMC     4099 22  3     2930   186    0
Chev.   4504 22  3     3180   193    0
Chev.   5104 22  2     3220   200    0
Buick   5788 18  3     3670   218    0
Buick   4453 26  3     2230   170    0
AMC     4749 17  3     3350   173    0
AMC     3799 22  3     2640   168    0
Buick   5189 20  3     3280   200    0
Buick  10372 16  3     3880   207    0
Chev.   3667 24  2     2750   179    0
Chev.   3955 19  3     3430   197    0
Datsun  6229 23  4     2370   170    1
Datsun  4589 35  5     2020   165    1
Audi    9690 17  5     2830   189    1
Audi    6295 23  3     2070   174    1
BMW     9735 25  4     2650   177    1
Buick   4816 20  3     3250   196    0
Buick   7827 15  4     4080   222    0
Datsun  8129 21  4     2750   184    1
;
RUN;





* =======================================================
	Common error 9

	Not sorting data before using statements that require sort

		Although steps are executed independent of each other, 
		some steps require a previous step in order to be 
		carried out properly.  A common example is the use 
		of a by statement in a data step.  
		
		This requires that the data has either been sorted by 
		the variable(s) in the by statement or that the 
		data was read in already sorted. If the code below 
		is run without a previous sort on make, the log indicates 
		the omission of this step and prints the first line 
		in the dataset that suggests non-sorted order of the 
		variable(s). ;
DATA auto2;
	SET auto;
	BY make;
	RETAIN makes 0;
	IF FIRST.make THEN makes = makes + 1;
RUN;

PROC PRINT DATA=auto2;
RUN;

* Adding a proc sort before this data step corrects this 
	problem.;
	
PROC SORT DATA=auto;
	BY make;
RUN;

DATA auto2;
	SET auto;
	BY make;
	RETAIN makes 0;
	IF FIRST.make THEN makes = makes + 1;
RUN;

PROC PRINT DATA=auto2;
RUN;



















