** DATA MANAGEMENT CLASS 
** PS3 DOFILE
** Daniel Assamah, Spring 2022
** Stata 16

*..............................................................................
*..............................................................................
** RESEARCH FOCUS........................................................................

*These dataset tends to access the impact of greenfield investment on the Ghanaian economy. Most often, FDI investment in Ghana is analyzed as monolithic, without adquate differentiation of their impact whether they are greenfield or brownfield investment. However, most studies asserts developing economies like Ghana will greatly benefit from a greenfield investment than brownfield. This study, intends to examine the impact of greenfield investment on the Ghanaian economy. Analysis of the dataset tend to examine the following questions critically?
  // does greenfield investment affect economic growth in Ghana?
  // does greenfield investment great significant jobs in Ghana?
  // does it matter what kind of investment Ghana attracts?
  

clear         
set matsize 800 
version 14
set more off


** DATA FROM FDI MARKET PLACE**********

	// Data on FDI capital investment and jobs created were extracted in 2021 from FDI Market Place database.FDI Market Place is a closed databased owned by the Financial Times in London and you need a subscription to access. I gained access through the Cornel Library in 2020
	// the database provides a comprehensive crossborder statistics on greenfield investment for 170 countries across various sectors. FDI to Ghana is extracted from Jun 2003 - Sep 2020.
		// the URL for FDI market place is https://www.fdimarkets.com/
// --------------------------------------------

pwd // to know which directory we currently on
cd C:\Users\danas\OneDrive\Desktop


**************
// cleaning//
**************

import excel "https://docs.google.com/uc?id=15ZBiYkdVF_U65_tWdWVACcSfpqe0OWQt&export=download",clear first
bys Sourcecountry: egen ghjb=mean(Jobscreated) // This shows the avearge jobs created by each country's FDI into Ghana
la var ghjb "country mean job"
l ghjb, sepby(Sourcecountry)
l Sourcecountry ghjb, sepby(ghjb)
l Sourcecountry ghjb, sepby(ghjb) clean
l Projectdate
rename Projectdate Years
gen Year=year(Years) // this will change the date formate to only years
l, sepby(Year) // this will enable me to see if I did a good repalcement in the Years column
drop Years Activity Estimated M // we will be left with only one variable for Year

order Year Jobscreated Capitalinvestment Sourcecountry Sourcestate Destinationstate Destinationcity Sector Cluster
gsort Year // arranging the observations in ascending order
save FDial, replace   // this is mainly the clean up data without collapse the years. The unit of analysis here is the individual companies that invested between Jun of 2003 to Sep of 2020. This will allow us to merge other dataset such as weather paterns, city population by cities or regions. As well as merging with other cluster information.

******Breaking the data further*********
keep Year Jobscreated Capitalinvestment
collapse (sum) Jobscreated Capitalinvestment, by(Year) // this collapse helped us to aggregate the data into years 
save FDisht, replace // the unit of analysis here is years. We forgo all the details and only focus on trends here in terms of Jobs created in Ghana and the associated capital investment.





** WORLD BANK DATA**********

// Data on GDP is extracted from the World Bank - World Development Indicators. Data was extracted on Febuary 11, 2022. GDP for Ghana was extracted from 2003 to 2022 (Both as a percentage of annual growth and the actual amount in dollars)
*the URL for this data source: https://databank.worldbank.org/source/world-development-indicators


insheet using "https://docs.google.com/uc?id=1ezTXeQLBCiFtjPNkjTnkoVAhqfoA_uZF&export=download", clear

********************************
//data cleaning and reshaping//
********************************

drop if CountryName != "Ghana"
reshape long yr, i(CountryName countrycode seriesname seriescode) j(Year)
replace seriescode=strtoname(seriescode)

reshape wide yr seriesname, i(Year) j(seriescode) string  // good
rename (yrNE_GDI_TOTL_ZS yrNY_GDP_MKTP_CD yrNY_GDP_MKTP_KD_ZG yrNY_GDP_PCAP_CD yrNY_GDP_PCAP_KD_ZG)(GCF GDP GDPgth GDPpc GDPgthpc)

drop seriesnameNE_GDI_TOTL_ZS seriesnameNY_GDP_MKTP_CD seriesnameNY_GDP_MKTP_KD_ZG seriesnameNY_GDP_PCAP_CD seriesnameNY_GDP_PCAP_KD_ZG CountryName countrycode

la var GCF "Gross capital formation (% of GDP)" // renaming the labels
la var GDP "GDP (current US$)"
la var GDPgth "GDP growth  (annual %)"
la var GDPpc "GDP per capita (current US$)"
la var GDPgthpc "GDP per capita growth (annual %)"

save WBGDP, replace // saved WORLD BANK GDP (WBGDP). This is without any data manupulation

*****************************
// statistical calculations//
*****************************

egen avg_GDP_act= mean(GDP)
format %20.2g GDP  //I only want two decimals
generate lGDP=. // created a new variable but empty
replace lGDP=avg_GDP_act/1000000 // filled the empty variable with reduced digits by diviging the average GDP by 1000000

gen sGDP=GDP/1000000
keep Year GCF GDP GDPgth GDPpc
aorder
save WBGDP_sat, replace  // data with some statistics

** 1st Merging: FDi Market Place  & World Bank*****
// I will do two merging here. I will do one to one merging and one to many mergin both over years.
merge 1:1 Year using FDisht.dta // Everything merged, because I extracted the exact years for both dataset (2003-2020)

/// Result                           # of obs.
*    -----------------------------------------
*    not matched                             0
*    matched                                18  (_merge==3)
*    -----------------------------------------

list // the merging did not fit in well. Need to try again

sum // From the summarize syntax, we realize that there are 18 number of observations and there is no missing data. Our unit of analysis here is years. On average, 5,484 jobs have been created between 2003 and 2020 (18 years) with $2,747 capital investment. Also the average GDP growth rate over the 18 years is 6.0% which is very good for Ghana. The maximum FDI Ghana received within from a corporation the 18 years is $9124 million and the min was $108.5 million, with a variation measured by the standard deviation been $ 2567.9. 
drop _merge
save fgdps, replace // saves the first merge of FDI data from FDI Market Place and GDP data from World Bank. fgdp dataset will be used for later merges.

***1:m merging***
clear
sysuse WBGDP
merge 1:m Year using FDial.dta // This merge is with the detailed dataset, where the unit of analysis is companies.
gsort Year
drop _merge
save fgdpALL, replace  // saving all wholistic dataset


/* a way to ren with yr and cl or pr
import excel "https://docs.google.com/uc?id=1WQnOwyTj_vpgQncyvUwbaqPbeNyU6QuP&export=download", sheet ("Country") clear //firstr



//replace A = "Year" in 2
//replace A = "Freedom" in 3
drop B-CM // drops all the years we dont need. From 1972 to 2003
//keep if inlist(A, "Year", "Ghana")

drop in 1

edit

foreach v of varlist *{
if `v'[1] !=""{
loc i=`v'[1] 
di "`i'"

}
replace `v' in 1="`i'" 
}

//loc yr="empty"
//foreach v of varlist *{
//replace `v'="`yr'" in 1
//loc yr=`v'[1]
// }

foreach v of varlist *{
loc nam = strtoname(`v'[2]+`v'[1])
di "`nam'"
ren `v' `nam'
}
*/


** FREEDOM HOUSE DATA**********

	// Data was extracted from the Freedom House dataset. 
*Freedom House dataset analyzes the electoral process, political pluralism and participation, the functioning of the government, freedom of expression and of belief, associational and organizational rights, the rule of law, and personal autonomy and individual rights in 210 countries from 1972 to 2020. Mainly under Political Rights (PR) and Civil Liberty (CL)
* Data Interpretaton: Until 2003, countries and territories whose combined average ratings for PR and CL fell between 1.0 and 2.5 were designated Free; between 3.0 and 5.5 Partly Free, and between 5.5 and 7.0 Not Free. Beginning with the ratings for 2003, countries whose combined average ratings fall between 3.0 and 5.0 are Partly Free, and those between 5.5 and 7.0 are Not Free. 
*the URL for this data source: https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Ffreedomhouse.org%2Fsites%2Fdefault%2Ffiles%2F2021-02%2FCountry_and_Territory_Ratings_and_Statuses_FIW1973-2021.xlsx&wdOrigin=BROWSELINK

import excel "https://docs.google.com/uc?id=1WQnOwyTj_vpgQncyvUwbaqPbeNyU6QuP&export=download", sheet ("Country") clear firstr
edit
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
aorder
save Gfrdm, replace

** 2nd Merge, with data on Freedom
merge 1:m Year using fgdpALL.dta
drop _merge
save Ffgdp, replace
 

** UNESCO DATA**********
 
// Dataset was extracted from the UNESCO Institute for Statistics. Data was obtained from the category Sustainable Development Goals: 4.1.2 "Completion rate, upper secondary education by sex and location". This shows the percent of the Ghanaian population that have completed upper secondary school. This information may be relevant to know if the level of education has any impact on investment
 
insheet using "https://docs.google.com/uc?id=1w9mJxynmdKFnSaIi_aEHrPcuXOQl9-g9&export=download", clear

edit  
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

merge 1:m Year using Ffgdp, update // merged the Completion rate, upper secondary education both sexes with the whole data
drop _merge

save EdcaFfgdp, replace /// saved the merged data with the completion rate of upper secondary education

*** adding another variable of education to the whole dataset****
clear
sysuse EduIn.dta
edit
keep if indicator == "CR_F"
reshape long value, i(indicator) j(year)
drop country indicator
rename year Year
rename value CR_M
save CR_M, replace

merge 1:m Year using EdcaFfgdp.dta // added the completion rate by males to the dataset
drop _merge
save GhaIn, replace // saved as Ghana Investment (GhaIn)


**STATISTA**********

// Statista.com consolidates statistical data on over 80,000 topics from more than 22,500 sources and makes it available on four platforms: German, English, French and Spanish. They create customized infographics, videos, presentations and publications in the corporate design of our customers.
// Inflation helps investors to access the help of the economy
*the URL for this data source: https://www.statista.com/statistics/447576/inflation-rate-in-ghana/

import excel "https://docs.google.com/uc?id=12PGtUrpZj4AhwY7lpXFTIJZRsKIlY-Xk&export=download", sheet ("Data") clear
edit
replace B = "2020" if B == "2020*" 
keep if  B >"2002" & B<"2021*" // keeps only the years we are interested in, 2003-2020
rename (B C) (Year infl)
encode infl, gen(Infl)
drop D infl

destring Year, replace
save Ginfl, replace

merge 1:m Year using GhaIn // adding my current inflation data to the main
drop _merge
save GhaInS, replace 



**OUR WORLD IN DATA**********
//Our World in Data is dedicated to a large range of global problems in health, education, violence, political power, human rights, war, poverty, inequality, energy, hunger, and humanity's impact on the environment. Our World in Data has a population data ranging from 1800 to 2021. Ghana's population information is extracted from here. I could not get the most updated population data on Ghana from Ghana's government website
*the URL for this data source: https://ourworldindata.org/search?q=Ghana+population

insheet using "https://docs.google.com/uc?id=16n57XojAMmf0wVYOFrhkhxFOi9b3q3Um&export=download", clear
edit
drop if code ~= "GHA" // only interested in Ghana's population data
sum
keep if  year >2002 & year <2021
rename (year populationhistoricalestimates) (Year Popln)
drop entity code 
save Gpopln, replace

merge 1:m Year using GhaInS  // merging with the main dataset
save GHAPS3, replace



