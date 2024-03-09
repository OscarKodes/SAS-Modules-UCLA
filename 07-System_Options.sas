* ########################################################
 COMMON SAS SYSTEM OPTIONS ###############################
 
	System options are global instructions that affect the entire 
	SAS session and control the way SAS performs operations. 
	
	SAS system options differ from SAS data set options and 
	statement options in that once you invoke a system option, 
	it remains in effect for all subsequent data and proc steps 
	in a SAS job, unless you specify them.
	
	In order to view which options are available and in effect 
	for your SAS session, use proc options.
;

PROC OPTIONS;
RUN;
* Of course, it is not necessary to understand every SAS option 
	in order to run a SAS job. This module will discuss some of 
	the more common SAS system options that the typical user 
	would use to customize their SAS sessions.;



* LOG, OUTPUT, PROCEDURE OPTIONS ============================
	
	Log, output and procedure options specify the ways in 
	which SAS output is written to the SAS log and procedure 
	output file.

	Below are some commonly used log, output, and procedure 
	options:

	CENTER controls whether SAS procedure output is centered. 
		By default, output is always centered. To specify not 
		centered, use NOCENTER, which will print results to the 
		output window as left justified.

	DATE prints the date and time to the log and output window. 
		By default, the date and time is always printed. To 
		suppress the printing of the date, use NODATE.

	LABEL allows SAS procedures to use labels with variables. 
		By default, labels are permitted. To suppress the 
		printing of labels, use NOLABEL.

	NOTES controls whether notes are printed to the SAS log. 
		By default, notes are printed. To suppress the printing 
		of notes, use NONOTES.

	NUMBER controls whether page numbers are printed on the 
		first title line of each page of printed output. 
		By default, page numbers are printed. To suppress 
		the printing of page numbers, use NONUMBER.

	LINESIZE= specifies the line size (printer line width) 
		for the SAS log and the SAS procedure output file used 
		by the data step and procedures.

	PAGESIZE= specifies the number of lines that can be printed 
		per page of SAS output.

	MISSING= specifies the character to be printed for missing 
		numeric variable values.

	FORMCHAR= specifies the list of graphics characters that 
		define table boundaries.

	Below is sample syntax for setting some of these options.
;

OPTIONS NOCENTER NODATE NONOTES LINESIZE=80 MISSING=.
		FORMCHAR = '|----|+|---+=|-/<>*';



* SAS DATA SET CONTROL OPTIONS ===============================

	SAS data set control options specify how SAS data sets are 
	input, processed, and output.

	Below are some commonly used SAS data set control options:

	FIRSTOBS= causes SAS to begin reading at a specified 
		observation in a data set. If SAS is processing a 
		file of raw data, this option forces SAS to begin 
		reading at a specified line of data. The default is 
		FIRSTOBS=1.

	OBS= specifies the last observation from a data set or the 
		last record from a raw data file that SAS is to read. 
		To return to using all observations in a data set use 
		OBS=all.

	REPLACE specifies whether permanently stored SAS data 
		sets are to be replaced. By default, the SAS system 
		will over-write existing SAS data sets if the SAS 
		data set is re-specified in a data step. 
		To suppress this option, use NOREPLACE.

	Below is sample syntax for invoking some of these options.
;

OPTIONS OBS=100 NOREPLACE;


* ERROR HANDLING OPTIONS ====================================

	Error handling options specify how the SAS System reports 
	on and recovers from error conditions.

	Below are two commonly used error handling options:

	ERRORS= controls the maximum number of observations for 
		which complete error messages are printed. The default 
		maximum number of complete error messages is ERRORS=20

	FMTERR (which is in effect by default if not specified) 
		controls whether the SAS System generates an error 
		message when the system cannot find a format to 
		associate with a variable. 
		
		Turning this option off 
		is useful when you have a SAS system data set with 
		custom formats, but you do not have the corresponding 
		SAS format library. In this situation, SAS will 
		generate an ERROR message for every unknown format 
		it encounters and will terminate the SAS job without 
		running any following data and proc steps. Thus, in 
		order to override this default option and read a 
		SAS system data set without requiring a SAS format 
		library, use NOFMTERR

	Below is sample syntax for invoking these options.
;

OPTIONS ERRORS=100 NOFMTERR;




* READ AND WRITING DATA OPTIONS =============================

	Reading and writing data options control the ways in which 
	data are input to, and output from, the SAS system.

	Below are some commonly used reading and writing data options:

	CAPS specifies whether lowercase characters input to the 
		SAS System are translated to uppercase. The default 
		is NOCAPS.

	PROBSIG= controls the number of significant digits of 
		p-values in some statistical procedures.

	YEARCUTOFF= specifies the first year of a 100-year span 
		used as the default by various informats and functions. 
		(For more information, see Using dates in SAS).

	Below is sample syntax for invoking these options.
;

OPTIONS CAPS PROBSIG=3 YEARCUTOFF=1900;


* It should also be noted that these data set options are 
	global options, as opposed to local data set options that 
	are specified within a data or proc step, and remain in 
	effect until the data or proc step ends.;







