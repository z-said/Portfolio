/* create pdf file using ODS statement */
%let outpath = /home/u63486551/ECRB94/TSA Case Study;
ods pdf file = "&outpath/ClaimsReport.pdf" style = meadow pdftoc = 1;
ods noproctitle;

/* Q1: How many rows with date issues are in the data? */
ods proclabel "Overall Date Issues in the Data";
title "Overall Date Issues in the Data";
proc freq data = tsa.claims_clean order = freq;
	tables Date_Issues / nocum nopercent;
run;
title;

/* exclude all rows with date issues for remaining analyses */
data tsa.claims_cleandate;
	set tsa.claims_clean;
	where Date_Issues = " ";
run;


/* Q2: How many claims per year of Incident_Date are in the data? Include a plot. */
ods graphics on;
ods proclabel "Overall Claims By Year";
title "Overall Claims By Year";
proc freq data = tsa.claims_cleandate;
	tables Incident_Date / nocum nopercent plots = freqplot();
	format Incident_Date year4.;
run;
title;


/* Q3 */
/* define macro variable for State Name */
%let state = California;

/* Q3(a): What are the frequency values for Claim_Type for the selected state?
   Q3(b): What are the frequency values for Claim_Site for the selected state?
   Q3(c): What are the frequency values for Disposition for the selected state? */
ods proclabel "&state Frequency Values for Claim Type, Claim Site, and Disposition";
title "&state Frequency Values for Claim Type, Claim Site, and Disposition";
proc freq data = tsa.claims_cleandate order = freq;
	where StateName = "&state";
	tables Claim_Type Claim_Site Disposition / nocum nopercent;
run;
title;

/* Q3(d)What is the mean, minimum, maximum, and sum of Close_Amount for the selected state? 
   Round to the nearest integer. */
ods proclabel "Mean, Minimum, Maximum, and Sum of Close Amount for &state";
title "Mean, Minimum, Maximum, and Sum of Close Amount for &state";
proc means data = tsa.claims_cleandate mean min max sum maxdec = 0;
	where StateName = "&state";
	var Close_Amount;
run;
title;


/* close pdf file using ODS statement */
ods pdf close;