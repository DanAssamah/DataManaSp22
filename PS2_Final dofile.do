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
//paid subscription; data not available publicly

//like an abstract or a pragraph what the research is bout; say also a hypothesis
*..............................................................................


clear         
set matsize 800 
version 14
set more off

// --------------------------------------------
pwd // to know which directory we currently on
cd C:\Users\danas\OneDrive\Desktop
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
recode Projectdate () /// not sure, how to recode it inoder to be able to collapse it
collapse Projectdate, by (Jobscreated) /// I tried this but did not give me what I wanted
//interpret! and focus on meaningful quantities


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

//generate lGDP=. // created a new variable but empty
//replace lGDP=avg_GDP_act/1000000 // filled the empty variable with reduced digits by diviging the average GDP by 1000000
//can be done in one step
gen lGDP= avg_GDP_act/1000000


gen sGDP=GDP_act/1000000
keep SeriesName GCF lGDP sGDP
aorder
order SeriesName

//preobably really want to save it on hd, otherwhise losing work

** Merging*****
//cannot have data that you have edited and dont have code!!!
import excel "https://docs.google.com/uc?id=15ZBiYkdVF_U65_tWdWVACcSfpqe0OWQt&export=download",clear first
rename Projectdate Years
keep Years Jobscreated Capitalinvestment
gen Year=year(Years) // this will change the date formate to only years
l, sepby(Year) // this will enable me to see if I did a good repalcement in the Years column
drop Years // we will be left with only one variable for Year

order Year Jobscreated Capitalinvestment 

collapse (sum) Jobscreated Capitalinvestment, by(Year) // this collapse helped us to aggregate the data into years 

//so without collapsing could do m:1 merge

merge 1:1 Year using "https://docs.google.com/uc?id=1dX6KtZYrdaWwSVKLGhILZDf1cZ9GEjRS&export=download" // this link is the GDP dataset
 
list // the merging did not fit in well. Need to try again

sum // From the summarize syntax, we realize that there are 18 number of observations and there is no missing data. Our unit of analysis here is years. On average, 5,484 jobs have been created between 2003 and 2020 (18 years) with $2,747 capital investment. Also the average GDP growth rate over the 18 years is 6.0% which is very good for Ghana. The maximum FDI Ghana received within from a corporation the 18 years is $9124 million and the min was $108.5 million, with a variation measured by the standard deviation been $ 2567.9. 






