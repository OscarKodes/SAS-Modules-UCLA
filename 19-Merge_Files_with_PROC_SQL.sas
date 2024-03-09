* ########################################################
	Merging Data Files via PROC SQL #####################

	One-to-one merge

	Below we have a file containing guild id, leader’s name 
	and income. We also have a file containing income 
	information for multiple years. We would like to match 
	merge the files together so we have the leaders observation 
	on the same line with the guildinc observation based on the 
	key variable guildid. In proc sql we use where statement 
	to do the matching as shown below. 
;

DATA leaders;
	INPUT guildid name $ inc;
CARDS;
2 Becky  22000 
1 Anya 30000 
3 Carly 25000 
; 
RUN;

DATA guildinc;
	INPUT guildid guildinc96-guildinc98;
CARDS;
3 75000 76000 77000 
1 40000 40500 41000 
2 45000 45400 45800 
;
RUN;

PROC SQL;
	CREATE TABLE leaderguild1 AS
		SELECT *
		FROM leaders, 
			guildinc
		WHERE leaders.guildid = guildinc.guildid
		ORDER BY leaders.guildid;

PROC PRINT DATA=leaderguild1;
RUN;



* One-to-many merge ========================================

	Imagine that we had a file with leaders like we saw in 
	the previous example, and we had a file with members where 
	a leader could have more than one member.  
	
	Matching up the "leaders" 
	with the "members" is called a "one-to-many" merge since you 
	are matching one leader observation to possibly many members 
	records.  
	
	The leaders and members records are shown below. 
	
	Notice here we have variable guildid in the first data set 
	and guildid in the second. These are the variables that 
	we want to match. When we merge the two using proc sql, 
	we don’t have to rename them, since we can use data set 
	name identifier. 
;

DATA leaders;
	INPUT guildid name $ inc;
CARDS;
2 Becky  22000 
1 Anya 30000 
3 Carly 25000 
; 
RUN;

* Next we make the "members" data file ;
DATA members;
	INPUT guildid membername $ birth age wt sex $;
CARDS;
1 Abby 1 9 60 f 
1 Appi  2 6 40 m 
1 Aggi 3 3 20 f 
2 Bipy 1 8 80 m 
2 Beek   2 6 50 m 
2 Boop  3 2 20 f 
3 Cosy 1 6 60 m 
3 Cily  2 4 40 f 
3 Cama 3 2 20 m 
; 
RUN;

* Create a new table using SQL to join the two tables;
PROC SQL;
	CREATE TABLE leadermember2 AS
	SELECT *
	FROM leaders,
		members
	WHERE leaders.guildid = members.guildid
	ORDER BY leaders.guildid, members.membername;
QUIT;

PROC PRINT DATA=leadermember2;


* Another way to use SQL with different syntax;
PROC SQL;
	CREATE TABLE leadermember2_2 AS
	SELECT *
	FROM leaders l
	JOIN members m
	ON l.guildid = m.guildid
	ORDER BY l.guildid, m.membername;
QUIT;

PROC PRINT DATA=leadermember2_2;




* Renaming variables with the same name in merging ==========

	Below we have the files with the information about the 
	leaders and guild, but look more closely at the names of 
	the variables. In the leaders file, there is a variable 
	called inc98, and in the guild file there are variables 
	inc96, inc97 and inc98.
;

DATA leaders;
	INPUT guildid name $ inc98;
CARDS;
2 Becky  22000 
1 Anya 30000 
3 Carly 25000 
; 
RUN;

DATA guildinc;
	INPUT guildid inc96-inc98;
CARDS;
3 75000 76000 77000 
1 40000 40500 41000 
2 45000 45400 45800 
;
RUN;

* Let’s merge them using the same strategy used in our 
	previous example on merging. We see below that we lost 
	variable inc98 from the second dataset guildinc. Proc sql 
	uses the column from the first data set in case of same 
	variable names from both datasets. This may not be what 
	we want.;

PROC SQL;
	CREATE TABLE leadermember4 AS
	SELECT *
	FROM leaders,
		guildinc
	WHERE leaders.guildid=guildinc.guildid
	ORDER BY leaders.guildid;
QUIT;

PROC PRINT DATA=leadermember4;
RUN;

* same result different SQL syntax;
PROC SQL;
	CREATE TABLE leadermember4_2 AS
	SELECT *
	FROM leaders l
	JOIN guildinc g 
	ON l.guildid = g.guildid 
	ORDER BY l.guildid;
QUIT;

PROC PRINT DATA=leadermember4_2;
RUN;


* In proc sql we can rename the variables using 
	the as statement shown below.;
PROC SQL;
	CREATE TABLE leadermember5 AS
	SELECT *,
			leaders.inc98 AS leaderinc98,
			guildinc.inc98 AS guildinc98
	FROM leaders,
			guildinc
	WHERE leaders.guildid=guildinc.guildid
	ORDER BY leaders.guildid;
QUIT;

PROC PRINT DATA=leadermember5;
RUN;

* same result different syntax;
PROC SQL;
	CREATE TABLE leadermember5_2 AS
	SELECT *,
		l.inc98 AS leaderinc98,
		g.inc98 AS guildinc98
	FROM leaders l
	JOIN guildinc g 
	ON l.guildid = g.guildid
	ORDER BY l.guildid;
QUIT;

PROC PRINT DATA=leadermember5_2;
RUN;
	
	
	
	
	
* Using full join to handle mismatching records 
	in a one-to-one merge ================================
	
	The two datasets may have records that do not match. 
	Below we illustrate this by including an extra leader 
	(Debby in guildid 4) that does not have a corresponding 
	guild, and there are two extra guilds (5 and 6) in 
	the guild file that do not have a corresponding leader.
;
	
DATA leaders;
	INPUT guildid name $ inc;
CARDS;
2 Becky  22000 
1 Anya 30000 
3 Carly 25000 
4 Debby 95000
; 
RUN;

DATA guildinc;
	INPUT guildid guildinc96-guildinc98;
CARDS;
3 75000 76000 77000
1 40000 40500 41000
2 45000 45400 45800
5 55000 65000 70000
6 22000 24000 28000
;
RUN;
	
* Let’s apply the previous example to these two datasets. 
	We see that the unmatched records have been dropped out 
	in the merged data set, since the  where statement 
	eliminated them.;

PROC SQL;
	CREATE TABLE leadermember3 AS
	
	SELECT * 
	FROM leaders, 
		guildinc
	WHERE leaders.guildid=guildinc.guildid
	ORDER BY leaders.guildid;
QUIT;

PROC PRINT DATA=leadermember3;
RUN;

* alternate syntax;
PROC SQL;
	CREATE TABLE leadermember3_2 AS
	
	SELECT *
	FROM leaders l
	INNER JOIN guildinc g 
	ON l.guildid = g.guildid 
	ORDER BY l.guildid;
QUIT;

PROC PRINT DATA=leadermember3_2;
RUN;

* we can include the unmatched data if we use FULL JOIN;
PROC SQL;
	CREATE TABLE leadermember3_2 AS
	
	SELECT *
	FROM leaders l
	FULL JOIN guildinc g 
	ON l.guildid = g.guildid 
	ORDER BY l.guildid;
QUIT;

PROC PRINT DATA=leadermember3_2;
RUN;
	
	
* What if we want to keep all the records from both datasets 
	even they do not match? 
	
	The following proc sql does it 
	in a more complex way. 
	
	Here we create two new variables. 
	
	One is indic, an indicator variable that indicates whether 
	an observation is from both datasets, 1 being from both 
	datasets and 0 otherwise. 
	
	Another variable is gid, 
	a coalesce of guildid from both datasets. 
	
	This gives 
	us more control over our datasets. 
	
	We can decide if 
	we have a mismatch and where the mismatch happens.;
	
PROC SQL;
	CREATE TABLE leadermember4 AS 
	
	SELECT *,
		(leaders.guildid=guildinc.guildid) AS indic,
		(leaders.guildid ~=.) AS leaderind,
		(guildinc.guildid ~=.) AS guildind,
		COALESCE(leaders.guildid, guildinc.guildid) AS gid
	FROM leaders
	FULL JOIN guildinc
	ON leaders.guildid=guildinc.guildid;
QUIT;	

PROC PRINT DATA=leadermember4;
RUN;

	
	
* Producing all the possible distinct pairs of the 
	values in a column =====================================

	Let’s say that we have a data set containing a variable 
	called city. We want to create all possible distinct 
	pairs of cities appeared in the variable. 
	
	This would 
	be really tricky to do if we only use a data step. 
	But it can be accomplished fairly straightforwardly 
	with SAS proc sql as shown below. 
	
	Proc sql is first used 
	to select distinct cities and to save them to a new 
	dataset. It is used again to create all distinct pairs 
	of cities. As shown below, there are seven different 
	places. Therefore there will be 7*6/2 =21 pairs of 
	cities.
;

* creating the data set "places";
DATA places;
	INPUT place_id city $12.;
CARDS;
 1   LosAngeles
 2   Orlando
 3   London
 4   NewYork
 5   Boston
 6   Paris
 7   Washington
 8   LosAngeles
 9   Orlando
 10  London
;
RUN;

* create data table "distinct_city" with sql;
PROC SQL;
	CREATE TABLE distinct_city AS 
	
	SELECT DISTINCT city 
	FROM places;
QUIT;

* print out the "distinct_city" table w/ informat $12.;
PROC PRINT DATA=distinct_city;
	TITLE "Distinct Cities";
	FORMAT city $12.;
RUN;

* create a table of all the unique pairs of cities using SQL;
PROC SQL;
	CREATE TABLE pair_places AS 
	
	SELECT d1.city AS origin,
			d2.city AS destination
	FROM distinct_city AS d1,
		distinct_city AS d2
	WHERE d1.city NE ' ' & d1.city < d2.city
	ORDER BY d1.city, d2.city;
QUIT;

* print out the "pair_places" table w/ informat $12.;
TITLE 'All Possible Paired Places';
PROC PRINT DATA=pair_places;
	FORMAT origin destination $12.;
RUN;

* Alternate syntax;
PROC SQL;
	CREATE TABLE pair_places2 AS 
	
	SELECT d1.city AS origin,
			d2.city AS destination
	FROM distinct_city d1,
		distinct_city d2
	WHERE d1.city IS NOT NULL
		AND d1.city < d2.city
	ORDER BY 1, 2;
QUIT;

TITLE 'All Possible Paired Places';
PROC PRINT DATA=pair_places2;
RUN;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


