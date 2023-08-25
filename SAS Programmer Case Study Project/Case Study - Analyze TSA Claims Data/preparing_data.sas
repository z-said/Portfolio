/* remove duplicate rows */
proc sort data = tsa.claimsimport
	      out = tsa.claims_nodups
	      noduprecs;
	by _all_;
run;

/* sort data by ascending Incident Date */
proc sort data = tsa.claims_nodups;
	by Incident_Date;
run;

/* clean data using data step */
data tsa.claims_clean;
	set tsa.claims_nodups;
	
/* 	clean Claims Site */
	if Claim_Site in (" ", "-") then Claim_Site = "Unknown";
	
/* 	clean Disposition */
	if Disposition in (" ", "-") then Disposition = "Unknown";
	else if Disposition = "Closed: Canceled" then Disposition = "Closed:Canceled";
	else if Disposition = "losed: Contractor Claim" then Disposition = "Closed:Contractor Claim";
	
/* 	clean Claim Type */
	if Claim_Type in (" ", "-") then Claim_Type = "Unknown";
	else if Claim_Type in ("Passenger Property Loss/Personal Injur", "Passenger Property Loss/Personal Injury") then Claim_Type = "Passenger Property Loss";
	else if Claim_Type = "Property Damage/Personal Injury" then Claim_Type = "Property Damage";
	
/* 	fix case of State Name and State */
	StateName = propcase(StateName);
	State = upcase(State);
	
/* 	add Date_Issues column */
	if (Incident_Date = .
	   or Date_Received = .
	   or year(Incident_Date) < 2002
	   or year(Date_Received) < 2002
	   or year(Incident_Date) > 2017
	   or year(Date_Received) > 2017
	   or Incident_Date > Date_Received) then Date_Issues = "Needs Review";
	   
/* 	format columns and add labels*/
	format Currency dollar20.2 Date_Received Incident_Date date9.;
	label Airport_Code = "Airport Code"
		  Airport_Name = "Airport Name"
		  Claim_Number = "Claim Number"
		  Claim_Site = "Claim Site"
		  Claim_Type = "Claim Type"
		  Close_Amount = "Close Amount"
		  Date_Issues = "Date Issues"
		  Date_Received = "Date Received"
		  Incident_Date = "Incident Date"
		  Item_Category = "Item Category";
	
/* 	drop Country and City columns */
	drop County City;
run;

/* check cleaned data using freq report */
proc freq data = tsa.claims_clean order = freq;
	tables Claim_Site Disposition Claim_Type Date_Issues / nocum nopercent;
run;