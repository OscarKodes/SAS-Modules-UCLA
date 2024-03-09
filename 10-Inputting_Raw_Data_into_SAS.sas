* ################################################################
	INPUTTING RAW DATA INTO SAS #####################################
 
	This module will show how to input raw data into SAS, 
	showing how to read instream data and external raw data 
	files using some common raw data formats.  
	
	Section 3 shows how to read external raw data files on a PC, 
	UNIX/AIX, and Macintosh, while sections 4-6 give examples 
	showing how to read the external raw data files on a PC, 
	however these examples are easily converted to work on 
	UNIX/AIX or a Macintosh based on the examples shown in 
	section 3.
;


* ===============================================================
	1. Reading free formatted data instream 
	
	One of the most common ways to read data into SAS is by 
	reading the data instream in a data step – that is, by 
	typing the data directly into the syntax of your SAS program. 
	This approach is good for relatively small datasets. 
	Spaces are usually used to "delimit" (or separate) free 
	formatted data. 
;
DATA cars1;
	INPUT make $ model $ mpg weight price;
CARDS;
AMC Concord 22 2930 4099
AMC Pacer   17 3350 4749
AMC Spirit  22 2640 3799
Buick Century 20 3250 4816
Buick Electra 15 4080 7827
;
RUN;

* After reading in the data with a data step, it is usually a 
	good idea to print the first few cases of your dataset to 
	check that things were read correctly.;
TITLE "cars1 Dataset";
PROC PRINT DATA=cars1(obs=5);
RUN;





* ===============================================================
	2. Reading fixed formatted data instream
	
	Fixed formatted data can also be read instream. Usually, 
	because there are no delimiters (such as spaces, commas, 
	or tabs) to separate fixed formatted data, column 
	definitions are required for every variable in the dataset. 
	That is, you need to provide the beginning and ending column 
	numbers for each variable. This also requires the data to be 
	in the same columns for each case. For example, if we 
	rearrange the cars data from above, we can read it as fixed 
	formatted data:
;

DATA cars2;
  INPUT make $ 1-5 model $ 6-12 mpg 13-14 weight 15-18 price 19-22;
CARDS;
AMC  Concord2229304099
AMC  Pacer  1733504749
AMC  Spirit 2226403799
BuickCentury2032504816
BuickElectra1540807827
;
RUN;

TITLE "cars2 data";
PROC PRINT DATA=cars2(obs=5);
RUN; 

* The benefit of fixed formatted data is that you can fit 
	more information on a line when you do not use delimiters 
	such as spaces or commas.;





* ===============================================================
	3. Reading fixed formatted data from an external file 
	
	Suppose you are using a PC and you have a file named 
	cars3.dat, that is stored in the c:carsdata directory of 
	your computer.
;

DATA cars3;
  INFILE "c:carsdatacars3.dat";
  INPUT make $ 1-5 model $ 6-12 mpg 13-14 weight 15-18 price 19-22;
RUN;

TITLE "cars3 data";
PROC PRINT DATA=cars3(obs=5);
RUN; 





* ===============================================================
	4. Reading free formatted (space delimited) data from an 
		external file

	Free formatted data that is space delimited can also be 
	read from an external file. For example, suppose you have 
	a space delimited file, that is stored 
	on your computer.
;
DATA cars4;
  INFILE "/home/u63650566/UCLA_Modules/data_for_lesson_10.dat";
  INPUT make $ model $ mpg weight price;
RUN;

TITLE "cars4 data";
PROC PRINT DATA=cars4(OBS=5);
RUN; 





* ===============================================================
	5. Reading free formatted (comma delimited) data from an 
	external file

	Free formatted data that is space delimited can also be 
	read from an external file. For example, suppose you have 
	a space delimited file, that is stored 
	on your computer.
;
DATA cars5;
	INFILE "/home/u63650566/UCLA_Modules/data_for_lesson_10_2.dat"
	DLM=',';
	INPUT make $ model $ mpg weight price;
RUN;

TITLE "cars5 data";
PROC PRINT DATA=cars5(OBS=5);
RUN;





* ===============================================================
	6. Reading free formatted (tab delimited) data from an 
	external file

	Free formatted data that is TAB delimited can also be read 
	from an external file. For example, suppose you have a tab 
	delimited file named cars6.dat, that is stored in the 
	c:carsdata directory of your computer.
;
DATA cars6;
  INFILE "/home/u63650566/UCLA_Modules/data_for_lesson_10_3.dat" 
  DLM='09'x;
  INPUT make $ model $ mpg weight price;
RUN;

TITLE "cars6 data";
PROC PRINT DATA=cars6(OBS=5);
RUN; 







* PROBLEMS TO LOOK OUT FOR ------------------------------------
	
	If you read a file that is wider than 80 columns, you 
	may need to use the lrecl= parameter on the infile 
	statement.
;









