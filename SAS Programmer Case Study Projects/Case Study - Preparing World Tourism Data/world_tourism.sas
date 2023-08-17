/* clean tourism table */
data tourism_cleaned;
	length Country_Name $300 Tourism_Type $20;
	retain Country_Name "" Tourism_Type "";
	set cr.Tourism(drop = _1995-_2013);
	if A ne . then Country_Name = Country;
	if lowcase(Country) = "inbound tourism" then Tourism_Type = "Inbound Tourism";
	else if lowcase(Country) = "outbound tourism" then Tourism_Type = "Outbound Tourism";
	if Country_Name ne Country and Tourism_Type ne Country;
	Series = upcase(Series);
	if Series = ".." then Series = "";
	ConversionType = scan(Country, -1, " ");
	if _2014 = ".." then _2014 = "";
	if ConversionType = "Mn" then do;
		if _2014 ne "." then Y2014 = input(_2014, 16.) * 1000000;
		else Y2014 = .;
		Category = cat(scan(Country, 1, '-', 'r'), ' - US$');
	end;
	if ConversionType = "Thousands" then do;
		if _2014 ne "." then Y2014 = input(_2014, 16.) * 1000;
		else Y2014 = .;
		Category = scan(Country, 1, '-', 'r');
	end;
	format Y2014 comma25.;
	drop A ConversionType Country _2014;
run;

/* create format for continents */
proc format;
	value contIDs 1 = "North America"
				  2 = "South America"
				  3 = "Europe"
				  4 = "Africa"
				  5 = "Asia"
				  6 = "Oceania"
				  7 = "Antarctica";
run;

/* sort country_info table */
proc sort data = cr.country_info(rename = (Country = Country_Name))
		  out = country_sorted;
	by Country_Name;
run;

/* merge tourism_cleaned and country_sorted tables */
data tourism_final NoCountryFound(keep = Country_Name);
	merge tourism_cleaned(in = t) country_sorted(in = c);
	by Country_Name;
	if t = 1 and c = 1 then output tourism_final;
	if (t = 1 and c = 0) and first.Country_Name = 1 then output NoCountryFound;
	format Continent contIDs.;
run;

/* Question 1 */
proc means data = tourism_final mean min max maxdec = 0;	
	var Y2014;
	class Continent;
	where Category = "Arrivals";
run;

/* Question 2 */
proc means data = tourism_final mean maxdec = 0;	
	var Y2014;
	where lowcase(Category) contains "tourism expenditure in other countries";
run;
	