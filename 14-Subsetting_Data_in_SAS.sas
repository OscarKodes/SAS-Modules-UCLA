* ##########################################################
	SUBSETTING DATA IN SAS #################################
	
	This module demonstrates how to select variables using the 
		keep and drop statements, using keep and drop data step 
		options records, and using the subsetting if and delete 
		statement(s). Selecting variables: The SAS file structure 
		is similar to a spreadsheet. Data values are stored as 
		variables, which are like fields or columns on a 
		spreadsheet. Sometimes data files contain information 
		that is superfluous to a particular analysis, in which 
		case we might want to change the data file to contain 
		only variables of interest. Programs will run more 
		quickly and occupy less storage space if files contain 
		only necessary variables. The following program builds 
		a SAS file called auto.;
DATA auto;
	LENGTH make $ 20;
	INPUT make $1-17 price mpg rep78 hdroom trunk weight length 
		turn displ gratio foreign;
CARDS;
AMC Concord        4099 22 3 2.5 11 2930 186 40 121 3.58 0
AMC Pacer          4749 17 3 3.0 11 3350 173 40 258 2.53 0
AMC Spirit         3799 22 . 3.0 12 2640 168 35 121 3.08 0
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

PROC CONTENTS DATA=auto;
RUN;
* The proc contents provides information about the file.;


* SUBSETTING VARIABLES #######################################

	For example, if we wanted to examine the relationship 
	between mpg and price for various makes, but had no 
	interest in the automobile’s dimensions, we could create 
	a smaller file, by keeping only these three variables.
;
DATA auto2;
	SET auto;
	KEEP make mpg price;
RUN;

* To verify the contents of the new file, run the proc 
	contents command again.;
PROC CONTENTS DATA=auto2;
RUN;

* Note that the number of observations, or records, remains 
	unchanged. This program makes a smaller version of auto 
	called auto2 that just has the three variables make mpg 
	and price. The new file, named auto2, is identical to 
	auto except that it contains only the variables listed 
	in the keep statement. To compare the contents of the 
	two files, run proc contents on each.;
PROC CONTENTS DATA = auto;
RUN; 
PROC CONTENTS DATA = auto2; 
RUN;

* Conversely, we can obtain the same results by using the 
	drop statement.;
DATA auto3;
	SET auto;
	DROP rep78 hdroom trunk weight length turn 
	displ gratio foreign;
RUN;
* The keep statement names variables to include, 
	while the drop statement names variables to exclude.

	Proc contents confirms the results.;
PROC CONTENTS DATA = auto3;
RUN;
* Notice that the number of observations in all the examples 
	above remain constant. The keep and drop statements 
	control the selection of variables only.;



* SUBSETTING OBSERVATIONS ===================================

	The above illustrates the use of "keep" and "drop" 
	statements and data step options to select variables.

	The subsetting "if" is typically used to control the 
	selection of records in the file. Records, or observations 
	in SAS, correspond to rows in a spreadsheet application.

	The auto file contains a variable rep78 with data values 
	from 1 to 5, and missing, which we ascertain from running 
	the following program.
;
PROC FREQ DATA = auto;
	TABLES rep78 / MISSING; 
RUN;

* Note that this program includes the / missing option on 
	the tables statement. Without it, SAS will print only 
	frequencies for non-missing values.

	If we are only interested in cars with data for rep78 
	is not missing, we may eliminate records with missing 
	data from the file by using a subsetting IF;
	
DATA auto2;
	SET auto;
	IF rep78 ^= .; * "^=" or "ne" means not equal;
RUN;
* This program creates a new file auto2 which will be 
	identical to auto, except that it will include only 
	observations where rep78 has a value other than missing. 
	proc freq verifies the change.;
PROC FREQ DATA=auto2;
  TABLES rep78 / MISSING ;
RUN;

* The subsetting IF specifies which observations to keep, 
	i.e., only cars with data for rep78. Alternately, we 
	may use the DELETE statement to specify which observations 
	to eliminate from the file.

	The following program keeps in the output file only 
	cars with repair ratings of 3 or less.;
DATA auto2;
	SET auto;
	IF rep78 > 3 THEN DELETE;
RUN;

* Let’s check the results using proc freq.;
PROC FREQ DATA = auto2;
  TABLES rep78 / MISSING ;
RUN;

* Using the subsetting IF statement as follows yields the 
	same result.;
DATA auto2;
	SET auto;
	IF (rep78 <= 3);
RUN;

PROC FREQ DATA = auto2;
	TABLES rep78 / MISSING;
RUN;

* Note that missing values are included, since missing 
	values are smaller than any other value. To delete 
	missing values, change the program as follows.;
DATA auto2;
	SET auto;
	IF (rep78 <= 3) AND (rep78 ^= .);
RUN;

PROC FREQ DATA = auto2;
	TABLES rep78 / MISSING;
RUN;

* this also works;
DATA auto3;
	SET auto;
	IF (. < rep78 <= 3);
RUN;

PROC FREQ DATA = auto2;
	TABLES rep78 / MISSING;
RUN;
PROC FREQ DATA = auto3;
	TABLES rep78 / MISSING;
RUN;




* PROBLEMS TO LOOK OUT FOR -------------------------------
	
	When you create a subset of your original data, sometimes 
	you may drop variables or cases that you did not intend 
	to drop. If you find variables or cases are gone that 
	should not be gone, double check your subsetting 
	commands.
;









