** DATA MANAGEMENT CLASS 
** PS2 DOFILE
** Daniel Assamah, Spring 2022
** Stata 16

*..............................................................................
*..............................................................................

// Data Sources for the two data set are indicated below
// Data on FDI capital investment and jobs created were extracted in 2021 from FDI Market place database.
	// the URL for FDI market place is https://www.fdimarkets.com/
	// the database provides a comprehensive crossborder statistics on greenfield investment for 170 countries across various sectors. FDI to Ghana is extracted from Jun 2003 - Sep 2020. 
*..............................................................................

* Research Focus: These dataset tends to access the impact of greenfield investment on the Ghanaian economy. Most often, FDI investment in Ghana is analyzed as monolithic, without adquate differentiation of their impact whether they are greenfield or brownfield investment. However, most studies asserts developing economies like Ghana will greatly benefit from a greenfield investment than brownfield. This study, intends to examine the impact of greenfield investment on the Ghanaian economy. Analysis of the dataset tend to examine the following questions critically?
  // does greenfield investment affect economic growth in Ghana?
  // does greenfield investment great significant jobs in Ghana?
  // does it matter what kind of investment Ghana attracts?
  

clear         
set matsize 800 
version 14
set more off

// --------------------------------------------
pwd // to know which directory we currently on

import excel "https://docs.google.com/uc?id=15ZBiYkdVF_U65_tWdWVACcSfpqe0OWQt&export=download",clear first
bys Sourcecountry: egen ghjb=mean(Jobscreated) // This shows the avearge jobs created by each country's FDI into Ghana
la var ghjb "country mean job"
l ghjb, sepby(Sourcecountry)
l Sourcecountry ghjb, sepby(ghjb)
l Sourcecountry ghjb, sepby(ghjb) clean

collapse Capitalinvestment, by(Projectdate)

import excel "https://docs.google.com/uc?id=15ZBiYkdVF_U65_tWdWVACcSfpqe0OWQt&export=download",clear first
keep Projectdate Jobscreated Capitalinvestment
l Projectdate


**** clearing to upload the GDP dataset 
// Data on GDP is extracted from the World Bank - World Development Indicators. Data was extracted on Febuary 11, 2022. GDP for Ghana was extracted from 2003 to 2022 (Both as a percentage of annual growth and the actual amount in dollars)
// url: https://databank.worldbank.org/source/world-development-indicators

clear
use "https://docs.google.com/uc?id=1fHMlhGZqQWNH5eO5abPwQe2nXMw72N-u&export=download" , clear
edit
rename GrosscapitalformationofGD GCF 
rename GDPgrowthannual GDPG
rename GDPcurrentUS GDP_act
drop GDPpercapitacurrentUS
drop GDPpercapitagrowthannual

la var GCF "Gross capital formation (% of GDP)"
la var GDPG "GDP growth  (annual %)"
la var GDP_act "GDP (current US$)"

egen avg_GDP_act= mean(GDP_act)

generate lGDP=. // created a new variable but empty
replace lGDP=avg_GDP_act/1000000 // filled the empty variable with reduced digits by diviging the average GDP by 1000000

gen sGDP=GDP_act/1000000
keep SeriesName GCF lGDP sGDP
aorder
order SeriesName

** Merging*****
import excel "https://docs.google.com/uc?id=15ZBiYkdVF_U65_tWdWVACcSfpqe0OWQt&export=download",clear first
rename Projectdate Years
keep Years Jobscreated Capitalinvestment
gen Year=year(Years) // this will change the date formate to only years
l, sepby(Year) // this will enable me to see if I did a good repalcement in the Years column
drop Years // we will be left with only one variable for Year

order Year Jobscreated Capitalinvestment 

collapse (sum) Jobscreated Capitalinvestment, by(Year) // this collapse helped us to aggregate the data into years 


merge 1:1 Year using "https://docs.google.com/uc?id=1dX6KtZYrdaWwSVKLGhILZDf1cZ9GEjRS&export=download" // this link is the GDP dataset
 
list // the merging did not fit in well. Need to try again

sum // From the summarize syntax, we realize that there are 18 number of observations and there is no missing data. Our unit of analysis here is years. On average, 5,484 jobs have been created between 2003 and 2020 (18 years) with $2,747 capital investment. Also the average GDP growth rate over the 18 years is 6.0% which is very good for Ghana. The maximum FDI Ghana received within from a corporation the 18 years is $9124 million and the min was $108.5 million, with a variation measured by the standard deviation been $ 2567.9. 
drop _merge
save fgdp, replace // saves the first merge of FDI data from FDI Market Place and GDP data from World Bank. fgdp dataset will be used for later merges.


import excel "https://docs.google.com/uc?id=1WQnOwyTj_vpgQncyvUwbaqPbeNyU6QuP&export=download", sheet ("Country") clear
// Data was extracted from the Freedom House dataset. 
*Freedom House dataset analyzes the electoral process, political pluralism and participation, the functioning of the government, freedom of expression and of belief, associational and organizational rights, the rule of law, and personal autonomy and individual rights in 210 countries from 1972 to 2020. Mainly under Political Rights (PR) and Civil Liberty (CL)
* Data Interpretaton: Until 2003, countries and territories whose combined average ratings for PR and CL fell between 1.0 and 2.5 were designated Free; between 3.0 and 5.5 Partly Free, and between 5.5 and 7.0 Not Free. Beginning with the ratings for 2003, countries whose combined average ratings fall between 3.0 and 5.0 are Partly Free, and those between 5.5 and 7.0 are Not Free. 
*the URL for this data source: https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Ffreedomhouse.org%2Fsites%2Fdefault%2Ffiles%2F2021-02%2FCountry_and_Territory_Ratings_and_Statuses_FIW1973-2021.xlsx&wdOrigin=BROWSELINK

edit
drop B-CD // drops all the years we dont need. From 1972 to 2003
keep in 1/75
drop in 4/70
keep in 1/4
drop CE-CM
rename ( CP CS CV CY DB DE DH DK DN DQ  DT DW DZ EC EF EI EL EO) (Yr2003 Yr2004 Yr2005 Yr2006 Yr2007 Yr2008 Yr2009 Yr2010 Yr2011 Yr2012 Yr2013 Yr2014 Yr2015 Yr2016 Yr2017 Yr2018 Yr2019 Yr2020)
keep A Yr2003 Yr2004 Yr2005 Yr2006 Yr2007 Yr2008 Yr2009 Yr2010 Yr2011 Yr2012 Yr2013 Yr2014 Yr2015 Yr2016 Yr2017 Yr2018 Yr2019 Yr2020
drop in 1/2
rename A Country
replace Country = "" in 2
replace Country = "Ghana" in 1
reshape long Yr, i(Country)j(Year)
rename Yr Status
replace Country = "Ghana" in 1/18
keep in 1/18
codebook Status
//encode Status, generate(frdm) /*string into numeric*/ F represent both Political Rights and Civil Liberty freedom.
drop Country
aorder
save Gfrdm, replace

** Merge
merge 1:1 Year using fgdp.dta
drop _merge
save Ffgdp, replace
 
 insheet using "https://docs.google.com/uc?id=1w9mJxynmdKFnSaIi_aEHrPcuXOQl9-g9&export=download", clear
// Dataset was extracted from the UNESCO Institute for Statistics. Data was obtained from the category Sustainable Development Goals: 4.1.2 "Completion rate, upper secondary education by sex and location". This shows the percent of the Ghanaian population that have completed upper secondary school. This information may be relevant to know if the level of education has any impact on investment

edit  
drop sdg_ind location v6 flagcode flags
reshape wide value, i(indicator) j(time) // to reshape the data into wide. but we are still not there yet, I need to reshape it again. But before that, I need to rename the first column so they can take on a variable name
replace indicator = "CR_BSEX" in 1
replace indicator = "CR_F" in 2
replace indicator = "CR_M" in 3
replace indicator = "CR_RBSEX" in 4
replace indicator = "CR_RF" in 5
replace indicator = "CR_RM" in 6
replace indicator = "CR_UBSEX" in 7
replace indicator = "CR_UF" in 8
replace indicator = "CR_UM" in 9

save EduIn, replace // saving the education indicators so I can use them again
keep if indicator == "CR_BSEX"
reshape long value, i(indicator) j(year)
la var indicator "Completion rate, upper secondary education, both sexes (%)"
drop country
rename year Year
rename value CR_BSEX
drop indicator
save Educ_Bsex, replace

merge 1:m Year using Ffgdp, update
drop _merge

save EFfgdp, replace /// saved the merged data with the completion rate of upper secondary education

use EduIn
edit
keep in 2
reshape long value, i(indicator) j(year)
drop country indicator
rename year Year
rename value CR_M
save CR_M, replace

merge 1:m Year using EFfgdp // added the completion rate by males to the dataset

