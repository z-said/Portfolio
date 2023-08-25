/* print report of relevant columns */
proc print data = tsa.claimsimport (obs = 30);
	var Claim_Site Disposition Claim_Type Date_Received Incident_Date;
run;

/* contents report of relevant columns */
proc contents data = tsa.claimsimport varnum;
run;

/* frequency report of relevant columns */
proc freq data = tsa.claimsimport;
	tables Claim_Site Disposition Claim_Type Date_Received Incident_Date / nocum nopercent;
	format Date_Received Incident_Date year4.;
run;