** DATA MANAGEMENT CLASS 
** PS3 DOFILE
** Daniel Assamah, Spring 2022
** Stata 16
** PS5



//---------------------------------begin dofile---------------------------
//---------------------------------begin dofile---------------------------
//---------------------------------begin dofile---------------------------

**NOTES: MACROS STARTS FROM LINE 415

clear         
set matsize 800 
set more off

/******************/
/* Research Focus**/
/******************/

/*These dataset tends to access the impact of greenfield investment on the Ghanaian economy. Most often, FDI investment in Ghana is analyzed as monolithic, without adquate differentiation of their impact whether they are greenfield or brownfield investment. However, most studies asserts developing economies like Ghana will greatly benefit from a greenfield investment than brownfield. This study, intends to examine the impact of greenfield investment on the Ghanaian economy. Analysis of the dataset tend to examine the following questions critically?
   does greenfield investment affect economic growth in Ghana?
   does greenfield investment great significant jobs in Ghana?
   does it matter what kind of investment Ghana attracts?    */

   
/*********************************/
/* Data Description & Sources ****/
/*********************************/

/* DATA FROM FDI MARKET PLACE******
Data on FDI capital investment and jobs created were extracted in 2021 from FDI Market Place database.FDI Market Place is a closed databased owned by the Financial Times in London and you need a subscription to access. I gained access through the Cornel Library in 2020
the database provides a comprehensive crossborder statistics on greenfield investment for 170 countries across various sectors. FDI to Ghana is extracted from Jun 2003 - Sep 2020. The capital investment figures are in USD (millions), while jobs are actual.
  The URL for FDI market place is https://www.fdimarkets.com/

** WORLD BANK DATA******************
Data on GDP is extracted from the World Bank - World Development Indicators. Data was extracted on Febuary 11, 2022. GDP for Ghana was extracted from 2003 to 2022 (Both as a percentage of annual growth and the actual amount in dollars)
   The URL for this data source: https://databank.worldbank.org/source/world-development-indicators

*** FREEDOM HOUSE DATA************* 
Freedom House dataset analyzes the electoral process, political pluralism and participation, the functioning of the government, freedom of expression and of belief, associational and organizational rights, the rule of law, and personal autonomy and individual rights in 210 countries from 1972 to 2020. Mainly under Political Rights (PR) and Civil Liberty (CL)
  Data Interpretaton: Until 2003, countries and territories whose combined average ratings for PR and CL fell between 1.0 and 2.5 were designated Free; between 3.0 and 5.5 Partly Free, and between 5.5 and 7.0 Not Free. Beginning with the ratings for 2003, countries whose combined average ratings fall between 3.0 and 5.0 are Partly Free, and those between 5.5 and 7.0 are Not Free. 
  The URL for this data source: https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Ffreedomhouse.org%2Fsites%2Fdefault%2Ffiles%2F2021-02%2FCountry_and_Territory_Ratings_and_Statuses_FIW1973-2021.xlsx&wdOrigin=BROWSELINK
   
**** UNESCO DATA******************   
Dataset was extracted from the UNESCO Institute for Statistics. Data was obtained from the category Sustainable Development Goals: 4.1.2 "Completion rate, upper secondary education by sex and location". This shows the percent of the Ghanaian population that have completed upper secondary school. This information may be relevant to know if the level of education has any impact on investment   
   The URL for this data source: http://data.uis.unesco.org/
   
*****STATISTA********************
Statista.com consolidates statistical data on over 80,000 topics from more than 22,500 sources and makes it available on four platforms: German, English, French and Spanish. They create customized infographics, videos, presentations and publications in the corporate design of our customers.
Inflation helps investors to access the help of the economy
  The URL for this data source: https://www.statista.com/statistics/447576/inflation-rate-in-ghana/ 
   
******OUR WORLD IN DATA**********
Our World in Data is dedicated to a large range of global problems in health, education, violence, political power, human rights, war, poverty, inequality, energy, hunger, and humanity's impact on the environment. Our World in Data has a population data ranging from 1800 to 2021. Ghana's population information is extracted from here. I could not get the most updated population data on Ghana from Ghana's government website
  The URL for this data source: https://ourworldindata.org/search?q=Ghana+population   

*******Heritage Foundation**********  
Heritage foundation measures economic freedom for 184 countries across four broad categories: Rule of Law, Government Size, Regulatory Efficiency and Open Markets. Each broad category, represents 3 freedom index scaled between 0 and 100. And the yearly economic freedom index is the average of the 12 economic freedooms (with each having an equal weight). This provides an excellent tool for analyzing the 184 economies across the globe.

Rule of Law (property rights, government integrity, judicial effectiveness)
Government Size (government spending, tax burden, fiscal health)
Regulatory Efficiency (business freedom, labor freedom, monetary freedom)
Open Markets (trade freedom, investment freedom, financial freedom)
  The URL for this data source: https: www.heritage.org/index/explore?view=by-region-country-year&u=637510876280358752    */

/*********************************/
/* Data Cleaning ****/
/*********************************/

pwd // to know which directory we currently on
cd "C:\Users\danas\Box\PhD_Public Policy\Classes\Spring 2022\Data Management\Project" // current dir
import excel "https://docs.google.com/uc?id=15ZBiYkdVF_U65_tWdWVACcSfpqe0OWQt&export=download",clear first
gen Year=year(Projectdate) // this will change the date formate to only years
drop Estimated M Projectdate
bys Sourcecountry: egen ghcap=mean(Capitalinvestment) // This shows the avearge capital investment from each country into Ghana
bys Sourcecountry: egen ghjb=mean(Jobscreated)
la var ghcap "country mean Capitalinvestment"
la var ghjb "country mean job"
order Year Jobscreated Capitalinvestment ghcap ghjb Sourcecountry Sourcestate Destinationstate Destinationcity Sector Cluster 
gsort Year // arranging the observations in ascending order
save FDiall, replace // this is mainly the clean up data without collapse the years. The unit of analysis here is the individual companies that invested between Jun of 2003 to Sep of 2020. This will allow us to merge other dataset such as weather paterns, city population by cities or regions. As well as merging with other cluster information.

keep Year Jobscreated Capitalinvestment 
collapse (sum) Jobscreated Capitalinvestment, by(Year) // by reducing the variables we are able to collapse and graph to have a sense of the data.
save FDisum, replace
twoway(line Capitalinvestment Year) (line Jobscreated Year, yaxis(2)) 
     /* This first figure reveals interesting trends in both jobs created and the
     corresponding capital investment by the 500 companies from June 2013 to September 
	 2020. Couple of things to note from the graph: 1) Capital investment and jobs 
	 created follow similar trends. 2) The lowest record for both Capitalinvestment and 
	 Jobscreated are recorded in 2007. 3) And the highest number of jobs was created in
	 2019 while the investment picked at 2017 there seem to be a lag in the 
	 relationship.*/
graph save CapJob, replace
graph hbar Jobscreated, over(Year) // Using a different format, this graph shows us that the most jobs were created in 2019 just before the pandemic and least in 2007, why?
graph save bJobs, replace

use FDiall, clear
collapse (sum) Jobscreated Capitalinvestment, by (Sourcecountry)
gsort -Capitalinvestment // allows us to arrange the variables in a descending manner
keep if Capitalinvestment > 501
    /* Interested in knowing the top 15 countries with the most capital investment in
	Ghana. South Africa has the highest greenfield investment in Ghana between the years
	examined.*/
#delimit ;
  graph hbar (asis) Capitalinvestment, over(Sourcecountry, sort(Capitalinvestment)
  descending axis(off)) blabel(group, size(vsmall) position ("Base") justification(left  )) title(15 Countries with the Highest Capital Investment in Ghana (Jun 2003-Sep 2020
  ), size(medsmall)) legend(off) ;
#delimit cr
graph save mosInv, replace

use FDiall, clear
collapse (sum) Jobscreated Capitalinvestment, by (Sourcecountry)
gsort -Jobscreated // we are interested in knowing where the jobs comes from - countries
keep if Jobscreated > 2500
#delimit ;
  graph hbar (asis) Jobscreated, over(Sourcecountry, sort(Jobscreated) descending axis(
  off)) blabel(group, size(vsmall) position(Base) justification(left)) title(Top 15 
  Countries Whose Companies Create the Most Jobs in Ghana (Jun 2003-Sep 2020), size(
  small)) legend(off) ;
#delimit cr
  /* We see from figure 2 & 3, that South Africa followed by Italy was leading in the
  amount of capital invested in Ghana within the time frame of our investigation,
  however, interms of the jobs created, companies from the United States and United
  Kingdom created the most jobs. Why and how? The next graphs will examine the type of
  industries companies from South Africa, Italy, United States, United Kingdom, China
  India and Nigeria invests in the most. A pie chart will be used for this. */
graph save mosJob, replace
graph combine mosInv.gph mosJob.gph, iscale (0.5)
graph save CounInveJob, replace 

***************
//PIE CHARTS//
***************  
/*use FDiall, clear
encode Sector, gen (Sec) //  encoding the sectors so we can graph using pie chart 
keep if Sourcecountry == "South Africa"
keep Sourcecountry Sec
list
tabulate Sec
graph pie, over (Sec) pie(1, explode) plabel (1 percent) plabel (2 percent) plabel (3 percent) plabel (4 percent) title(South Africa Comp. Sector Invest.) sort descending
         /* This pie chart reflects which sectors South African (SA) companies invest 
		 in the most in Ghana. From the graph we see that most of the companies from SA
		 invest the Financial Sector (28.26%) followed by communications and metal 
		 sectors (17.39%) respectively.*/
graph save pieSA, replace
		 
use FDiall, clear 
encode Sector, gen (Sec)
keep Sourcecountry Sec            
keep if Sourcecountry == "Italy"
tab Sec  
       /* The Italian companies invests mainly in Coal, oil & Gas, as well as in
	   Business Services, Renewable energy and Food & Beverages.*/
graph pie, over (Sec) pie(1, explode) plabel (1 percent) title(Italian Comp. Sector Invest.)  sort descending
graph save pieIta, replace

use FDiall, clear 
encode Sector, gen (Sec)
keep Sourcecountry Sec            
keep if Sourcecountry == "United States"
tab Sec  
		/* Companies from the United States invests mostly in the Food & Beverages sector
		(17.19%). Followed by the Metals and Software & IT services (14.06%) respectively
		*/
graph pie, over(Sec) pie(1, explode) plabel(1 percent) plabel(2 percent) plabel(3 percent) plabel(4 percent, size(*0.8)) title(United States Comp. Sector Invest.) sort descending
graph save pieUS, replace

use FDiall, clear 
encode Sector, gen (Sec)
keep Sourcecountry Sec            
keep if Sourcecountry == "United Kingdom"
tab Sec
		/* The companies from the United Kingdom invests mostly in Business services 
		(24.53%) followed by the Financial services sector (20.75%) then Coal, oil & 
		Gas (15.09%), Communications (13.21%).*/		
graph pie, over(Sec) pie(1, explode) plabel(1 percent) plabel(2 percent) plabel(3 percent) title(United Kingdom Comp. Sector Invest.) sort descending
graph save pieUK, replace			

use FDiall, clear 
encode Sector, gen (Sec)
keep Sourcecountry Sec            
keep if Sourcecountry == "India"
tab Sec
		/* The companies from the India invests mainly in Automotive OEM (19.05%)
		followed by Business services (14.29%)*/		
graph pie, over(Sec) pie(1, explode) plabel(1 percent) plabel(2 percent) plabel(3 percent) title(India Comp. Sector Invest.) sort descending
graph save pieIndia, replace				
// gr combine pieIndia.gph pieIta.gph pieSA.gph pieUK.gph pieUS.gph	// work on this later */

 
/*********************************/
/* Merging ****/
/*********************************/			

***WORLD BANK DATA****// Data description is summarized above the dofile//

insheet using "https://docs.google.com/uc?id=1ezTXeQLBCiFtjPNkjTnkoVAhqfoA_uZF&export=download", clear
drop if CountryName != "Ghana"
reshape long yr, i(CountryName countrycode seriesname seriescode) j(Year)
replace seriescode=strtoname(seriescode)
reshape wide yr seriesname, i(Year) j(seriescode) string  

rename (yrNE_GDI_TOTL_ZS yrNY_GDP_MKTP_CD yrNY_GDP_MKTP_KD_ZG yrNY_GDP_PCAP_CD yrNY_GDP_PCAP_KD_ZG)(GCF GDP GDPgth GDPpc GDPgthpc)

drop seriesnameNE_GDI_TOTL_ZS seriesnameNY_GDP_MKTP_CD seriesnameNY_GDP_MKTP_KD_ZG seriesnameNY_GDP_PCAP_CD seriesnameNY_GDP_PCAP_KD_ZG CountryName countrycode

la var GCF "Gross capital formation (% of GDP)" // renaming the labels
la var GDP "GDP (current US$)"
la var GDPgth "GDP growth  (annual %)"
la var GDPpc "GDP per capita (current US$)"
la var GDPgthpc "GDP per capita growth (annual %)"

save WBGDP, replace // saved WORLD BANK GDP (WBGDP). This is without any data manupulation

twoway (connected GDP Year, lcolor(blue)) (line GDPgth Year, yaxis(2) lcolor(red)), title(Ghana's GDP & Growth Rate from 2013 to 2020)
	/*This graph shows the trend in Ghana's GDP and the growth rate from 2013 to 2020*/
    //gr export Myfigs.png, replace(Later)
merge 1:m Year using FDiall.dta // **1st merged: FDI data with the World Bank Data on GDP 


******
sort Year
drop _merge
save FDgdp, replace //**// FDI + GDP data//**//

***FREEDOM HOUSE DATA****// Data description is summarized above the dofile//
import excel "https://docs.google.com/uc?id=1WQnOwyTj_vpgQncyvUwbaqPbeNyU6QuP&export=download", sheet ("Country") clear 
replace A = "Year" in 2
replace A = "Freedom" in 3
drop B-CM // drops all the years we dont need. From 1972 to 2003
keep if inlist(A, "Year", "Ghana")
rename ( CP CS CV CY DB DE DH DK DN DQ  DT DW DZ EC EF EI EL EO) (Yr2003 Yr2004 Yr2005 Yr2006 Yr2007 Yr2008 Yr2009 Yr2010 Yr2011 Yr2012 Yr2013 Yr2014 Yr2015 Yr2016 Yr2017 Yr2018 Yr2019 Yr2020)
drop if A == "Year"
keep A Yr2003 Yr2004 Yr2005 Yr2006 Yr2007 Yr2008 Yr2009 Yr2010 Yr2011 Yr2012 Yr2013 Yr2014 Yr2015 Yr2016 Yr2017 Yr2018 Yr2019 Yr2020
rename A Country
reshape long Yr, i(Country)j(Year)
rename Yr Status
codebook Status // to check if the status are coded
encode Status, generate(frdm) /*string into numeric represent both Political Rights and Civil Liberty freedom.*/ 
drop Country Status
save Gfrdm, replace   // saves the Freedom house data in years

merge 1:m Year using FDgdp.dta // **2nd Merge, with data on Freedom***********
drop _merge
save FDgdpf, replace //**// FDI + GDP + Freedom data //**//

***UNESCO DATA****// Data description is summarized above the dofile//
insheet using "https://docs.google.com/uc?id=1w9mJxynmdKFnSaIi_aEHrPcuXOQl9-g9&export=download", clear 
drop sdg_ind location v6 flagcode flags
reshape wide value, i(indicator) j(time) // to reshape the data into wide. but we are still not there yet, I need to reshape it again. But before that, I need to rename the first column so they can take on a variable name

replace indicator = "CR_BSEX" if indicator == "Completion rate, upper secondary education, both sexes (%)" // renaming the variables to shorten it
replace indicator = "CR_F" if indicator == "Completion rate, upper secondary education, female (%)"
replace indicator = "CR_M" if indicator == "Completion rate, upper secondary education, male (%)"
replace indicator = "CR_RBSEX" if indicator == "Completion rate, upper secondary education, rural, both sexes (%)"
replace indicator = "CR_RF" if indicator == "Completion rate, upper secondary education, rural, female (%)"
replace indicator = "CR_RM" if indicator == "Completion rate, upper secondary education, rural, male (%)"
replace indicator = "CR_UBSEX" if indicator == "Completion rate, upper secondary education, urban, both sexes (%)"
replace indicator = "CR_UF" if indicator == "Completion rate, upper secondary education, urban, female (%)"
replace indicator = "CR_UM" if indicator == "Completion rate, upper secondary education, urban, male (%)"

save EduIn, replace // saving the education indicators so I can use them again
keep if indicator == "CR_BSEX"
reshape long value, i(indicator) j(year)
la var indicator "Completion rate, upper secondary education, both sexes (%)"
drop country
rename year Year
rename value CR_BSEX
drop indicator
save Educ_Bsex, replace

merge 1:m Year using FDgdpf, update // merged the Completion rate, upper secondary education both sexes with the whole data
drop _merge
save FDgdpE1, replace //**// FDI + GDP + Freedom data + Education_Upper Sec both Sexes//**//

***adding another educational variable: Rural upper secondary education for both sexes- CR_RBSEX****
clear
use EduIn
keep if indicator == "CR_RBSEX"
reshape long value, i(indicator) j(year)
drop country indicator
rename year Year
rename value CR_RBSEX
save CR_RBSEX, replace

merge 1:m Year using FDgdpE1
drop _merge
save FDgdpE2, replace //**// FDI + GDP + Freedom data + Education (both Sexes & Rural )//**//

***what about if we add education for both Sexes in Urban areas- CR_UBSEX****************
clear
use EduIn
keep if indicator == "CR_UBSEX"
reshape long value, i(indicator) j(year)
drop country indicator
rename value CR_UBSEX
rename year Year
save CR_UBSEX, replace

merge 1:m Year using FDgdpE2
drop _merge
save FDgdpE, replace //**// FDI + GDP + Freedom data + Education//**//

***STATISTA****// Data description is summarized above the dofile//
import excel "https://docs.google.com/uc?id=12PGtUrpZj4AhwY7lpXFTIJZRsKIlY-Xk&export=download", sheet ("Data") clear
replace B = "2020" if B == "2020*" 
keep if  B >"2002" & B<"2021*" // keeps only the years we are interested in, 2003-2020
rename (B C) (Year infl)
drop D
destring Year infl, replace
save Ginfl, replace

merge 1:m Year using FDgdpE 
drop _merge
save FDgdpEin, replace //**// FDI + GDP + Freedom data + Education + Inflation//**//

***OUR WORLD IN DATA****// Data description is summarized above the dofile//
insheet using "https://docs.google.com/uc?id=16n57XojAMmf0wVYOFrhkhxFOi9b3q3Um&export=download", clear
drop if code ~= "GHA" // only interested in Ghana's population data
sum
keep if  year >2002 & year <2021
rename (year populationhistoricalestimates) (Year Popln)
drop entity code 
save Gpopln, replace

merge 1:m Year using FDgdpEin  // merging with the main dataset
drop _merge
save Ghainv, replace //**// FDI + GDP + Freedom + Education + Inflation + Population data//**//


***HERITAGE FOUNDATION****// Data description is summarized above the dofile//
insheet using "https://docs.google.com/uc?id=1QrceTl7XhMSz6nujDCix3GTEEfsFWBAC&export=download", clear
rename (indexyear overallscore propertyrights governmentintegrity judicialeffectiveness taxburden governmentspending fiscalhealth businessfreedom laborfreedom monetaryfreedom tradefreedom investmentfreedom financialfreedom) (Year Hersco Proprit Govinteg Judieff Taxburd Govspen Fishth Buzfr Laborfr Moneyfr Tradefr Invfr Finfr)

replace Judieff = "." if Judieff == "N/A"
replace Fishth = "." if Fishth == "N/A"
replace Laborfr = "." if Laborfr == "N/A"
keep if Year > 2002
destring Judieff Fishth Laborfr, replace
drop name
save heritage, replace

merge m:m Year using Ghainv
drop _merge
save Ghainvest, replace //**// FDI + GDP + Freedom + Education + Inflation + Population + Heritage data//**//


/*********************************/
/* Graphics Continued ****/
/*********************************/

**TWOWAY LINE GRAPHS (GDP & POPULATION)
collapse Popln GDP infl CR_BSEX CR_RBSEX CR_UBSEX Hersco Proprit Govinteg Judieff Taxburd Govspen Fishth Buzfr Laborfr Moneyfr Tradefr Invfr Finfr, by(Year) // by reducing the variables we are able to 
save 4graph, replace // saving for graph purposes
format %10.2g GDP
twoway(line GDP Year) (line Popln Year, yaxis(2)), title(Ghana's GDP &  Population) 
	/* This graph shows the relationship between Ghana's annual population and the nation's
		gross domestic product. From the graph, GDP has mostly been around the population, with a
		significant shift above population in 2013.*/ 
graph save GDPop, replace
graph combine CapJob.gph GDPop.gph, iscale(0.5) 
	/* This combine twoway graphs helps us to compare the trends in four variables: Capital investment,
	   jobs created, GDP, and the population. From the two graphs, we can connect the GDP spike in 2013
	   to that of capital investment as well.*/

**SCATTER GRAPH, WTIH CONNECTED LINE
scatter CR_BSEX CR_RBSEX CR_UBSEX Year, connect(1 2 3)
	/* This shows the differences in the rates of education at the upper secondary level. The data 
	shows rate of rural education being lower than the Urban areas all throughout the years.*/
graph save scEdu, replace

**LINE GRAPHS
line infl Year, title("Ghana Inflation Rate") // showing the trends in Ghana's inflation rate
graph save Infla, replace
line Hersco Year, title("Ghana Heritage Freedom Score")
graph save HeSco, replace
graph combine Infla.gph HeSco.gph

**AVERAGE 
symplot infl // The graph shows most of the inflation points above the average line

**BAR GRAPHS
drop if Year >2020
#delimit ;
	graph hbar Govspen Taxburd Fishth, 
	over(Year)stack 
	ytitle("") 
	title(Heritage Score by Government Size) ;
#delimit cr
graph save hbar1, replace 

#delimit ;
	graph hbar Buzfr Laborfr Moneyfr, 
	over(Year)stack 
	ytitle("") 
	title(Heritage Score by Regulatory Efficiency) ;
#delimit cr
graph save hbar2, replace 	   

#delimit ;
	graph hbar Tradefr Invfr Finfr, 
	over(Year)stack 
	ytitle("") 
	title(Heritage Score by Open Markets) ;
#delimit cr
graph save hbar3, replace 
graph combine hbar1.gph hbar2.gph hbar3.gph, c(2) iscale (0.5)
graph save Ghanahbar, replace 


/**************/
/* Macro ****/
/**************/

use Ghainvest.dta, clear
gsort Year
drop if Year >2020 // to remove the exess years 2021 and 2022
save GhaData4Macro, replace
encode Sector, gen (Sec)
encode Sourcecountry, gen (Country)
encode Sourcestate, gen (State)
encode Cluster, gen (Clus)



local F infl  /* This macro `F' contains the inflation data. To know the level of inflatin
				 from the begining of our data to the end, ie. 2003 & 2020, we use the
				 display functions below. Out put shows that in 2003, inflation was 26.63
				 percent and dropped to 9.89 in 2020*/
di `F'
di `F'[500]
di "`F'"     //Finally on this, when I use the quote on the macro, it interprets it as a string


**Regression Models with Macros*****
loc al Hersco Popln infl GCF Year /* I grouped this independent variables so I can manuplate
										the dependent variable in the analysis, although our 
										main dependent variable is Jobscreated*/

reg Jobscreated Capitalinvestment      		         `al'
reg Jobscreated Capitalinvestment  GDP				 `al' 
reg Jobscreated Capitalinvestment  GDP	Sec	 	  	 `al' 
reg Jobscreated Capitalinvestment  GDP	Sec	Country	 `al' 

**generating some log function for more regression analysis****
gladder Capitalinvestment, fraction  // the gladder syntax gave me a clue to introduce the log function for capital investment
gen lncap = ln(Capitalinvestment)      
reg Jobscreated Capitalinvestment lncap    // and when I did, it improved my regression output

loc am c.CR_BSEX c.CR_RBSEX c.CR_UBSEX c.Hersco
loc am2 Country Sec GDP Year

reg Jobscreated lncap `am'
reg Jobscreated lncap `am' `am2'

**using macros after estimation commands****
summarize Jobscreated
return list
gen JobGha=(Jobscreated-`r(mean)')/`r(sd)'
summarize Jobscreated JobGha


/**********/
/* loops */
/********/

foreach i of num 1/10 {
	display `i'
}


** creating loops for multiple regressions

foreach i of num 1/100 {
	reg GDPgth infl
	eststo reg_`i'
}  

local ye lncap Popln GCF Hersco Year
local cy Jobscreated Capitalinvestment GDP Country
foreach var of varlist `cy' {
   regress `var' `ye'
   }

   
** 
levelsof Sec, loc(Sec)
levelsof Clus, loc(Clus)
foreach lev in `Clus' {
reg Jobscreated lncap if Clus==`lev'
}

** with demacation

levelsof Sec, loc(Sec)
levelsof Clus, loc(Clus)
foreach lev in `Clus' {
di"***********************************************"
di "***this is `:label Cluster `lev''***"
reg Jobscreated lncap GDP infl Year if Clus==`lev'
}
  
  
   
**using global
reg Jobscreated lncap      // equation 1
global Yes "lncap"   
reg Jobscreated $Yes      // we get the same equation
sum $Yes

**loops with global
gen lnjob = ln(Jobscreated)
global outcomes "Jobscreated lnjob"

foreach var of global outcomes {
	sum `var'
	reg `var' $Yes
	reg `var' $Yes, robust
}
save macroGha, replace
   
***nested loops
drop if CR_BSEX ==. // reducing the number of observations
drop if Laborfr ==. 

/* the function below allows me to see the summary statistics of each country and the specific cluster they invested in. 
	note: observations reduced to 189, so I can easily work with the variables*/

levelsof Clus, loc(Clus)
levelsof Sourcecountry, loc(Sourcecountry)
foreach m in `Sourcecountry' {
       foreach r in `Clus' {
              sum Capitalinvestment lncap Jobscreated if Sourcecountry == "`m'" & Clus == `r'
       }
}


**with demacation
levelsof Cluster, loc(Cluster)
levelsof Sourcecountry, loc(Sourcecountry)
foreach m in `Sourcecountry' {
       foreach r in `Cluster' {
	   di "************************************"
       di "this is Sourcecountry `m'  and Clus `r'" 
              sum Capitalinvestment lncap Jobscreated if Sourcecountry == "`m'" & Cluster == "`r'"
       }
}




*******************************END OF DO FILE FOR PS5************************************************************************
*******************************END OF DO FILE FOR PS5************************************************************************
*******************************END OF DO FILE FOR PS5************************************************************************


***Work on in the Future****
/**********/
/* Branching */
/********/

        foreach var of varlist {
           capture confirm numeric variable `var'
           if _rc==0 {
             sum `var', meanonly
             replace `var'=`var'-r(mean)
           } 
           else display as error "`var' is not a numeric variable and cannot be demeaned."
         }
sum




local ye lncap Popln GCF Hersco Year
local cy Jobscreated Capitalinvestment GDP Country
foreach var of varlist `cy' {
   regress `var' `ye'
   predict `var' _resid, resid 
   kdensity `var' _resid, normal name (`var'_resid)
   margin, at(lncap=(100(10000)100000))
   
   }   
   
gladder Jobscreated, fraction
gladder Capitalinvestment, fraction
gladder GDP, fraction


misstable summarize
misstable pattern


