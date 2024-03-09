* ########################################################
	Merging Data Files via DATA STEP #####################

	When you have two data files, you can combine them by 
	merging them side by side, matching up observations based 
	on an identifier. 
	
	For example, below we have a data file containing 
	information on guild leaders and we have a file containing 
	information on guild income called guild_income.
	
	We would like to match merge the files together so we 
	have the leader observation on the same line with the 
	guild_income observation based on the key variable guild_id.
;



* One-to-one merge ============================================

	There are three steps to match merge the leaders file 
	with the guild_income file (this is called a one-to-one 
	merge because there is a one to one correspondence 
	between the leaders and guild_income records). 
	These three steps are illustrated in the SAS program 
	merge1.sas below.

	1) Use proc sort to sort leaders on guild_id and save that 
		file (we will call it leaders2)
	
	2) Use proc sort to sort guild_income on guild_id and save 
		that file (we will call it guild_income2)
	
	3) merge the leaders2 and guild_income2 files based 
		on leader_id

	These three steps are illustrated in the program below.
;


* We first created the leaders and guild_income data files 
	below ; 

DATA leaders; 
  INPUT guild_id name $ income ; 
CARDS; 
2 Crstna 22000 
1 Emma 30000 
3 Kara 25000 
; 
RUN; 

DATA guild_income; 
  INPUT guild_id guild_inc96 guild_inc97 guild_inc98 ; 
CARDS; 
3 75000 76000 77000 
1 40000 40500 41000 
2 45000 45400 45800 
;
RUN;

* 1. Sort the leaders file by "guild_id" & save 
	sorted file as leaders2 ; 
PROC SORT DATA=leaders OUT=leaders2; 
  BY guild_id; 
RUN; 

* 2. Sort guild_income by "guild_id" & save sorted file as 
	guild_income2 ; 
PROC SORT DATA=guild_income OUT=guild_income2; 
  BY guild_id; 
RUN; 

* 3. Merge leaders2 and guild_income2 by guild_id in a 
	data step ; 
DATA leaders_guild; 
  MERGE leaders2 guild_income2; 
  BY guild_id; 
RUN; 

* Let's do a proc print and look at the results. ; 
PROC PRINT DATA=leaders2; 
RUN; 

PROC PRINT DATA=guild_income2; 
RUN; 

PROC PRINT DATA=leaders_guild; 
RUN; 






* One-to-many merge =========================================

	Imagine that we had a file with leaders like we saw in 
	the previous example, and we had a file with members where 
	a leader could have more than one member. Matching up the "leaders" 
	with the "members" is called a "one-to-many" merge since you 
	are matching one leader observation to possibly many members 
	records. The leaders and members records are shown below.
	
	After matching the leaders with the members you get a file that 
	looks like the one below. Emma is matched up with his 
	members Ember, Enid and Eagle. Crstna is matched up with Cove Cani, 
	and Cibni. and Kara is matched up with Kery, Kat and Kil.
	
	Just like the "one-to-one" merge, we follow the same 
	three steps for a "one-to-many" merge. These three steps 
	are illustrated in the SAS program merge2.sas below.

		1) Use proc sort to sort leaders on guild_id and save 
			that file (we will call it leaders2)
			
		2) Use proc sort to sort members on guild_id and save 
			that file (we will call it members2)
			
		3) merge the leaders2 and members2 files based on 
			guild_id
;

* first we make the "leaders" data file ;
DATA leaders; 
  INPUT guild_id leader_name $ inc ; 
CARDS; 
2 Crstna 22000 
1 Emma 30000 
3 Kara 25000 
; 
RUN; 

* Next we make the "members" data file ;
DATA members; 
  INPUT guild_id membername $ birth age wt sex $ ; 
CARDS; 
1 Ember 1 9 60 f 
1 Enid  2 6 40 m 
1 Eagle 3 3 20 f 
2 Cani 1 8 80 m 
2 Cove   2 6 50 m 
2 Cibni  3 2 20 f 
3 Kery 1 6 60 m 
3 Kat  2 4 40 f 
3 Kil 3 2 20 m 
; 
RUN; 

* 1. sort "leaders" on guild_id and save the sorted file as 
	"leaders2" ; 
PROC SORT DATA=leaders OUT=leaders2; 
  BY guild_id; 
RUN; 

* 2. sort "members" on guild_id and save the sorted file as 
	"members2" ; 
PROC SORT DATA=members OUT=members2; 
  BY guild_id; 
RUN; 

* 3. merge "leaders2" and "members2" based on guild_id, 
	creating "leader_member" ; 
DATA leader_member; 
  MERGE leaders2 members2; 
  BY guild_id; 
RUN; 

* Let's do a PROC PRINT of "leader_member" to see if the merge 
	worked ; 
PROC PRINT DATA=leaders2; 
RUN; 

PROC PRINT DATA=members2; 
RUN; 

PROC PRINT DATA=leader_member; 
RUN; 


* The output shows just what we hoped to see, the leaders 
	merged along side of their members. You might have wondered 
	what would have happened if the merge statement had 
	reversed the order of the files, had we changed step 3 
	to look like below.;

* 3. merge "leaders2" and "members2" based on guild_id, 
	creating "leader_member" ; 
DATA leader_member; 
  MERGE members2 leaders2; 
  BY guild_id; 
RUN; 

* Let's do a PROC PRINT of "leader_member" see what happens ; 
PROC PRINT DATA=leader_member; 
RUN; 

* This output shows what happened when we switched the 
	order of members2 and leaders2 in the merge statement. The 
	merge results are basically the same, except that the 
	order of the variables is modified — the members variables 
	are on the left and the leaders variables are at the right. 
	Other than that, the results are the same.
;



* PROBLEMS TO LOOK OUT FOR -------------------------------------
	
	These examples cover situations where there are no 
	complications. We show some examples of complications 
	that can arise and how you can solve them below.
;



* Mismatching records in one-to-one merge ===================

	The two data files have may have records that do not match. 
	Below we illustrate this by including an extra leader 
	(Karl in guild_id 4) that does not have a corresponding 
	guildily, and there are two extra guildilies (5 and 6) in 
	the guildily file that do not have a corresponding leader.
;


* create leaders dataset;
DATA leaders; 
  INPUT guild_id leader_name $ inc ; 
CARDS; 
2 Crstna 22000 
1 Emma 30000 
3 Kara 25000 
4 Wern 95000
; 
RUN; 

* created guild_income dataset;
DATA guild_income;
 INPUT guild_id guild_income96 guild_income97 guild_income98;
DATALINES;
3 75000 76000 77000
1 40000 40500 41000
2 45000 45400 45800
5 55000 65000 70000
6 22000 24000 28000
;
RUN;

* sort the leaders dataset by id;
PROC SORT DATA=leaders;
 BY guild_id;
RUN;

* sort the guild_income dataset by id;
PROC SORT DATA=guild_income;
 BY guild_id;
RUN;

* merge the two datasets together by guild id;
DATA merge121;
  MERGE leaders(IN=fromleaderx) guild_income(IN=fromguildx);
  BY guild_id;
  fromleader = fromleaderx;
  fromguild = fromguildx;
RUN;

* As you see above, we use the "in" option to create a 0/1 
	variable fromleaderx that indicates whether the resulting 
	file contains a record with data from the leaders file. 
	
	Likewise, we use IN option to create a 0/1 variable
	fromguildx that indicates if the observation came from the 
	guild_income file. 
	
	The fromleaderx and fromguildx variables are 
	temporary, so we make copies of them in fromleader and 
	fromguild so we have copies of these variables that stay 
	with the file. 
	
	We can then use proc print and proc freq 
	to identify the mismatching records.;

PROC PRINT DATA=merge121;
RUN;

PROC FREQ DATA=merge121;
	TABLES fromleader * fromguild;
RUN;


* The output illustrates that there were mismatching 
	records. 
	
	For guild_id 4, the value of fromleader is 1 and 
	fromguild is 0, as we would expect since there was data 
	from leaders for guild_id 4, but no data from guild_income. 
	
	Also, 
	as we expect, this record has valid data for the variables 
	from the leaders file (name and inc) and missing data for 
	the variables from guild_income 
	(guild_income96 guild_income97 and guild_income98). 
	
	We see the reverse pattern for guild_id‘s 5 and 6.

	A closer look at the fromleader and fromguild variables 
	reveals that there are three records that have matching 
	data: 
	
		one that has data from the leaders only, and 
		
		two records that have data from the guild_income 
		file only.
		
		The crosstab table from above confirms this.	
		
		
		
	You may want to use this crosstab strategy to check the 
	matching of the two files. 
	
	If there are unexpected mismatched records, then you 
	should investigate to understand the cause of the
	mismatched records.

	Use the "where" statement in a "proc print" to eliminate 
	some of the non-matching records.
;
	



* Variables with the same name, but different information =====

	Below we have the files with the information about the 
	leaders and guilds, but look more closely at the names of 
	the variables. In the leaders file, there is a variable 
	called inc98, and in the guild file there are variables 
	inc96, inc97 and inc98. Let’s attempt to merge these 
	files and see what happens.;

DATA leaders;
 INPUT guild_id name $ inc98;
DATALINES;
2 Crstna 22000 
1 Emma 30000 
3 Kara 25000 
;
RUN;

DATA guild_income;
 INPUT guild_id inc96 inc97 inc98;
DATALINES;
3 75000 76000 77000
1 40000 40500 41000
2 45000 45400 45800
;
RUN;

PROC SORT DATA=leaders;
 BY guild_id;
RUN;

PROC SORT DATA=guild_income;
 BY guild_id;
RUN;

DATA merge121;
 MERGE guild_income leaders;
 BY guild_id;
RUN;

PROC PRINT DATA=merge121;
RUN;

* As you see, the variable 
	inc98 has the data from the leaders file, the file that 
	appears last on the merge statement. When you merge 
	files that have the same variable, SAS will use the 
	values from the file that appears last on the merge 
	statement.
	

	There are a couple of ways you can solve this problem.

	Solution #1. The most obvious solution is to choose 
		variable names in the original files that will 
		not conflict with each other. 
		
		However, you may have 
		files where the names have already been chosen.

	Solution #2. You can rename the variables in a data 
		step using the rename option (which renames the 
		variables before doing the merging). This allows 
		you to select variable names that do not conflict 
		with each other, as illustrated below.
;

DATA merge121;
	MERGE 
		guild_income(RENAME=(
			inc96=guild_income96 
			inc97=guild_income97 
			inc98=guild_income98))
		leaders(RENAME=(
			inc98=leaderinc98));
	BY guild_id;
RUN;

PROC PRINT DATA=merge121;
RUN;

* As you can see below, the variables were renamed as 
	specified.;

