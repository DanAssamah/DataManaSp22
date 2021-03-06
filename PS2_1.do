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
rename Projectdate Year
keep Year Jobscreated Capitalinvestment

merge m:1 Year using "https://docs.google.com/uc?id=1dX6KtZYrdaWwSVKLGhILZDf1cZ9GEjRS&export=download" // this link is the GDP dataset
list // the merging did not fit in well. Need to try again

collapse month, by (Year) // did not work since I do not have any variable named month. I must find a way out!!





