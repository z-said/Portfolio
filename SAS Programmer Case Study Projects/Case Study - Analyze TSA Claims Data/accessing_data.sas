/* define library */
%let path = ~/ECRB94/data;
libname TSA "&path";

/* enforce SAS naming conventions */
options validvarname = v7;

/* import data */
proc import datafile = "&path/TSAClaims2002_2017.csv"
			dbms = csv
			out = TSA.ClaimsImport
			replace;
	guessingrows = max;
run;