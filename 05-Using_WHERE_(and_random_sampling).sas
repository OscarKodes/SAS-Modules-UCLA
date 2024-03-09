* #####################################################
 USING WHERE WITH SAS PROCEDURES ######################
 
	This program builds a SAS file called auto, which we will 
	use to demonstrate the use of the where statement. 
;

DATA auto;
	INPUT make $ 1-17 price mpg rep78 hdroom trunk weight length turn
        displ gratio foreign ;
DATALINES;
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





* BASIC USE OF THE WHERE STATEMENT =======================

	The where statement allows us to run procedures on a 
	subset of records. For example, instead of printing 
	all records in the file, the following program prints 
	only cars where the value for rep78 is 3 or greater.
;

PROC PRINT DATA=auto;
	WHERE rep78 >= 3;
	VAR make rep78;
RUN;


* Cross tabulation b/w rep78 and foreign;
PROC FREQ DATA=auto;
	TABLES rep78*foreign;
RUN;

* Using the where statement, we restrict the analysis 
	to only cars with a repair rating of 3 or more 
	(rep78  >=  3):;
PROC FREQ DATA=auto;
	WHERE rep78 >= 3;
	TABLES rep78*foreign;
RUN;




* The where statement works with most SAS procedures. 
	The following program prints only records for which the 
	car has a repair rating of 2 or less:;
PROC PRINT DATA=auto;
	WHERE rep78 <= 2;
	VAR make price rep78;
RUN;




* MISSING VALUES AND THE WHERE STATEMENT =======================

	In the example above, note that some of the records print 
	a '.' instead of a value for rep78. These are records 
	where rep78 is missing. SAS stores missing values for 
	numeric variables as '.' and treats them as negative 
	infinity, or the lowest number possible. To exclude 
	missing values, modify the where statement as follows 
	(the rep78 ^= . indicates rep78 is not equal to missing).
;

PROC PRINT DATA=auto;
	WHERE rep78 <= 2 AND rep78 ^= . ;
	VAR make price rep78;
RUN;

* Similarly, this where statement yields the same result:;
PROC PRINT DATA=auto;
	WHERE . < rep78 <= 2;
	VAR make price rep78;
RUN;








* MORE COMPLEX WHERE STATEMENTS =============================

	This program generates summary statistics for price, 
	but only for cars with repair histories of 1 or 2:
;

PROC MEANS DATA=auto;
	WHERE rep78 = 1 OR rep78 = 2;
	VAR price;
RUN;
* By default, proc means will generate the following statistics: 
	mean, minimum and maximum values, standard deviation, 
	and the number of non-missing values for the analysis 
	variable (in this case price).;


* To see summary statistics for price for cars with repair 
	histories of 3, 4 or 5, modify the where statement 
	accordingly:;

PROC MEANS DATA=auto;
	WHERE rep78 = 3 OR rep78 = 4 OR rep78 = 5;
	VAR price;
RUN;

* or this way;
PROC MEANS DATA=auto;
	WHERE 3 <= rep78 <= 5;
	VAR price;
RUN;

* or this way;
PROC MEANS DATA=auto;
	WHERE rep78 IN (3, 4, 5);
	VAR price;
RUN;






* ============================================================
 SIMPLE RANDOM SAMPLING WITH OR WITHOUT REPLACEMENT ==========
 
 Sometimes you may be analyzing a very large data file and 
 want to work with just a simple random sample of the data 
 file. Other times you may want to draw a simple random sample 
 with replacement from a small data file. 
 
 Either way, SAS proc surveyselect is one way to do it, and 
 it is fairly straightforward. Let’s use the following data 
 set for the purpose of demonstration.
;

DATA hsb25;
  INPUT id gender $ race ses schtype $ prog
        read write math science socst;
DATALINES;
 147 f 1 3 pub 1 47  62  53  53  61
 108 m 1 2 pub 2 34  33  41  36  36
  18 m 3 2 pub 3 50  33  49  44  36
 153 m 1 2 pub 3 39  31  40  39  51
  50 m 2 2 pub 2 50  59  42  53  61
  51 f 2 1 pub 2 42  36  42  31  39
 102 m 1 1 pub 1 52  41  51  53  56
  57 f 1 2 pub 1 71  65  72  66  56
 160 f 1 2 pub 1 55  65  55  50  61
 136 m 1 2 pub 1 65  59  70  63  51
  88 f 1 1 pub 1 68  60  64  69  66
 177 m 1 2 pri 1 55  59  62  58  51
  95 m 1 1 pub 1 73  60  71  61  71
 144 m 1 1 pub 2 60  65  58  61  66
 139 f 1 2 pub 1 68  59  61  55  71
 135 f 1 3 pub 1 63  60  65  54  66
 191 f 1 1 pri 1 47  52  43  48  61
 171 m 1 2 pub 1 60  54  60  55  66
  22 m 3 2 pub 3 42  39  39  56  46
  47 f 2 3 pub 1 47  46  49  33  41
  56 m 1 2 pub 3 55  45  46  58  51
 128 m 1 1 pub 1 39  33  38  47  41
  36 f 2 3 pub 2 44  49  44  35  51
  53 m 2 2 pub 3 34  37  46  39  31
  26 f 4 1 pub 1 60  59  62  61  51
;
RUN;


* RANDOM SAMPLING WITHOUT REPLACEMENT ------------------

	In a simple random sample without replacement each 
	observation in the data set has an equal chance of 
	being selected, once selected it can not be chosen again. 
	
	The following code creates a simple random sample of 
	size 10 from the data set hsb25. 
	
	"METHOD" Here the method option on the proc surveyselect 
	statement specifies the method to be SRS 
	(simple random sampling). 
	
	"REP" (=replicate) option specifies the number of 
	simple random samples you want create. 
	
	"SAMPSIZE" is a required option here specifying the 
	size of the random sample. 
	
		This number has to be smaller than the size of the 
		original data set, since the sampling is done without 
		replacement.  
	
	"SEED" You can also specify the seed so a precise replicate 
	can be reproduced later using the same seed. 
	
	"ID" is used to specify the variables to be 
	included in the sample. 
	
		Here we use _all_ to include all the variables to be in 
		the sample.
;

PROC SURVEYSELECT DATA=hsb25 
	METHOD=SRS 
	REP=1
	SAMPSIZE=10
	SEED=12345
	OUT=my_sample;
	ID _all_;
RUN;

* NOOBS suppresses the observation number in the output;
PROC PRINT DATA=my_sample NOOBS;
	RUN;








* RANDOM SAMPLING WITH REPLACEMENT ------------------

	In a random sample with replacement, each observation 
	in the data set has an equal chance to be selected and 
	can be selected over and over again. 
	
	The following code creates a random sample with 
	replacement of size 10. We can see from the output that 
	observations with id = 139 and id = 128 have been selected 
	twice because we now allow replacement in the sampling. 
	
	"METHOD=URS" (unrestricted random sampling) is used here 
	to allow the replacement. We will only include variables 
	id, read, write, math, science and socst in the sample 
	data set.
;

PROC SURVEYSELECT DATA=hsb25
	METHOD=URS
	SAMPSIZE=10
	REP=1
	SEED=12345
	OUT=my_sample
	OUTHITS;
	ID id read write math science socst;
RUN;

PROC PRINT DATA=my_sample NOOBS;
RUN;




