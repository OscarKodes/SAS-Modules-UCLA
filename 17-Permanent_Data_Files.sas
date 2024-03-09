* ###########################################################
	MAKING AND USING PERMANENT SAS DATA FILES (VERSION 8) ###
	
	This will illustrate how to make and use SAS data files 
	in version 8.  If you have used SAS version 6.xx, you will 
	notice it is much easier to create and use permanent SAS 
	data files in SAS version 8.

	Consider this simple example.  This shows how you can make a 
	SAS version 8 file the traditional way using a libname 
	statement.  The file salary will be stored in the 
	directory c:workers.
;

LIBNAME workers "/home/u63650566/UCLA_Modules";

DATA workers.salary;
	INPUT salary1996-salary2000;
	CARDS;
10000 10500 11000 12000 12700
14000 16500 18000 22000 29000
;
RUN;

* Below we use proc print and proc contents to look at the 
	file that we have created.;
PROC PRINT DATA=workers.salary;
RUN;

PROC CONTENTS DATA=workers.salary;
RUN;

* We can see the data from the proc print and the 
	proc contents shows us the data file that has been created, 
	called salary.sas7bdat
	
	Below we make a file similar to the one above, but we will 
	illustrate some of the new features in SAS version 8.  
	
	First, we did not need to use a libname statement.  
	
	We were able to specify the name of the data file by 
	directly specifying the path name of the file (
	i.e., c:dissertationsalarylong).  Also note that the 
	names of the variables are over 8 characters long.  
	They can be up to 32 characters long.  
	
	This step creates a data file named 
	c:dissertationsalarylong.sas7bdat .
;

DATA "/home/u63650566/UCLA_Modules/workersalarylong";
	INPUT Salary1996-Salary2000;
CARDS;
10000 10500 11000 12000 12700
14000 16500 18000 22000 29000
;
RUN;

* Below we can do a proc print and proc contents 
	on this data file.;

PROC PRINT DATA="/home/u63650566/UCLA_Modules/workersalarylong";
RUN;
PROC CONTENTS DATA="/home/u63650566/UCLA_Modules/workersalarylong";
RUN;



* Note the names of the variables in the proc print and 
	proc contents below SAS shows the variable name as 
	Salary1996 showing that we used an uppercase S.  
	
	When you first create a variable, SAS will remember 
	the case of each of the letters and show the variable 
	names using the case you originally used.  
	
	However, you do not need to always refer to the 
	variable as Salary1996, you can refer to it as 
	SALARY1996 or as salary1996 or however you like, 
	as long as the variable is spelled properly.  
	
	But this can help make your variable names more 
	readable for outputs.
;



* When you read and write SAS version 8 files, you can choose 
	whether you wish to use the libname statement as we showed 
	in our first example, or if you prefer to write out the 
	name of the file as we showed in our second example.  
	
	Either will work with SAS version 8 data files.  
	
	If you are unsure of whether a SAS data file is a 
	version 8 data file, you can look at the extension of 
	the file.  
	
	If it ends with .sas7bdat then it is a version 8 data file 
	that can be used on the PC or on UNIX.  
	
	However, if the extension is .sd2 it is a 
	Windows SAS 6.12 file, or if the extension is .ssd01 
	it is a Unix SAS 6.12 file.;

















