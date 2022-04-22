//overall very nice clear structure

//in general the limitation is structure of the data and lack of the data at country level: you have plenty of data at firm level, like hundreds
//but only a handful of yerars at country level, so cannot really figure out much from that--too few obs at country level, just a handful
//there are several ways to improve: add more countries, say all african countries; or look by region/province within ghana, so that have more variability--
//then the data that you would merge would not come from intl institutions like world bank, but rather from Ghanian government;; its not necessarily that
//you have to do it that way for this class, but in general for the future research


** DATA MANAGEMENT CLASS 
** PS3 DOFILE
** Daniel Assamah, Spring 2022
** Stata 16
** PS



//---------------------------------begin dofile---------------------------
//---------------------------------begin dofile---------------------------
//---------------------------------begin dofile---------------------------

clear         
set matsize 800 
set more off

/******************/
/* Research Topic**/
/******************/


//good to have lots of comments here

//*********************GREENFIELD INVESTMENT AND JOB CREATION IN GHANA********//

***EXTENDED ABSTRACT******

/* Multinational investment in foreign countries has attracted mixed reactions from scholars and policymakers concerning their role and impact on host countries, particularly in developing economies. Proponents of MNCs argue that foreign direct investment (FDI) leads to economic growth, creates technological spillover, increases exports, and creates jobs, among other benefits. The benefits have encouraged developing economies to adopt developmental strategies around MNCs' activities in their economies. Some researchers assert that MNCs alleviate poverty in developing economies through their corporate social responsibilities (CSR). Other scholars, in contrast, argue that MNCs widen the income gap in host countries and engage in human rights violations. However, most empirical analyses on MNC investments treat FDI as monolithic, without adequate differentiation of their impact as greenfield or brownfield investments. Using granular data from the fDi Market Place, this research paper intends to fill this gap by empirically analyzing the impact of greenfield investment on job creation from 386 companies that invested in Ghana from June  2003 to September 2020. Over the specified year range, these companies engaged in 500 projects across Ghana. Adopting the ordinary least square analysis (OLS), the study demonstrates that greenfield investment has a statistically significant and positive impact on job creation in Ghana. The study identifies gross domestic product (GDP), labor force participation rate (LFPR), inflation, and gross capital formation (GCF) as essential indicators that influence job creation in Ghana. 

Research Question 
1.	Does greenfield investment in Ghana lead to significant job creation in the formal sector?

//good clear hypotheses

Hypothesis 
	Ho: Greenfield investments does not have any significant impact positive impact
	    on employment in Ghana.
	H1: Greenfield investments in Ghana have a significant  positive impact on employment 
	    in Ghana.

2.	Which sectors/clusters create the most jobs in Ghana?

Hypothesis 
    H0: It does not matter what kind of investment Ghana should attract for job creation 
	    purposes
    H1: It does matter the kind of investment Ghana should attract for job creation purposes */
	
/*********************************/
/* Data Description & Sources ****/
/*********************************/

//very good description of data

/*DATA FROM FDI MARKET PLACE******
Data on FDI capital investment and jobs created were extracted in 2021 from the FDI Market Place database. FDI Market Place is a closed database owned by the Financial Times in London, and you need a subscription to access it. I gained access through the Cornel Library in 2020
The database provides comprehensive cross-border statistics on greenfield investment for 170 countries across various sectors. FDI to Ghana is extracted from June 2003 to September 2020. The capital investment figures are in USD (millions), while jobs are actual.
  The URL for the FDI marketplace is https://www.fdimarkets.com/

  
** WORLD BANK DATA******************
Data on GDP is extracted from the World Bank - World Development Indicators. Data was extracted on February 11, 2022. GDP for Ghana extracted from 2003 to 2022 (Both as a percentage of annual growth and the actual amount in dollars)
   The URL for this data source: https://databank.worldbank.org/source/world-development-indicators

   
*** FREEDOM HOUSE DATA************* 
Freedom House dataset analyzes the electoral process, political pluralism and participation, the functioning of the government, freedom of expression and belief, associational and organizational rights, the rule of law, and personal autonomy and individual rights in 210 countries from 1972 to 2020. Mainly under Political Rights (PR) and Civil Liberty (CL)
  Data Interpretation: Until 2003, countries and territories whose combined average ratings for PR and CL fell between 1.0 and 2.5 were designated Free; between 3.0 and 5.5 Partly Free, and between 5.5 and 7.0 Not Free. Beginning with the ratings for 2003, countries whose combined average ratings fall between 3.0 and 5.0 are Partly Free, and those between 5.5 and 7.0 are Not Free. 
  The URL for this data source: https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Ffreedomhouse.org%2Fsites%2Fdefault%2Ffiles%2F2021-02%2FCountry_and_Territory_Ratings_and_Statuses_FIW1973-2021.xlsx&wdOrigin=BROWSELINK

  
**** UNESCO DATA******************   
Dataset was extracted from the UNESCO Institute for Statistics. Data obtained from the category Sustainable Development Goals: 4.1.2 "Completion rate, upper secondary education by sex and location." This shows the percentage of the Ghanaian population that has completed upper secondary school. This information may be relevant to knowing if the level of education has any impact on investment   
   The URL for this data source: http://data.uis.unesco.org/

   
*****STATISTA********************
Statista.com consolidates statistical data on over 80,000 topics from more than 22,500 sources and makes it available in German, English, French, and Spanish. They create customized infographics, videos, presentations, and publications in the corporate design of our customers.
Inflation helps investors to access the help of the economy
  The URL for this data source: https://www.statista.com/statistics/447576/inflation-rate-in-ghana/ 
 
 
******OUR WORLD IN DATA**********
Our World in Data is dedicated to many global problems in health, education, violence, political power, human rights, war, poverty, inequality, energy, hunger, and humanity's impact on the environment. Our World in Data has population data ranging from 1800 to 2021. Ghana's population information is extracted from here. I could not get the most updated population data on Ghana from Ghana's government website
  The URL for this data source: https://ourworldindata.org/search?q=Ghana+population   
 
 
*******Heritage Foundation**********  
Heritage foundation measures economic freedom for 184 countries across four broad categories: Rule of Law, Government Size, Regulatory Efficiency, and Open Markets. Each broad category represents three freedom indexes scaled between 0 and 100. Moreover, the yearly economic freedom index is the average of the 12 economic freedoms (each having equal weight). This provides an excellent tool for analyzing the 184 economies across the globe.

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
rename (Jobscreated Capitalinvestment) (Jobs Capin)
gsort Year // arranging the observations in ascending order
save FDiall, replace // this is mainly the clean up data without collapse the years. The unit of analysis here is the individual companies that invested between Jun of 2003 to Sep of 2020. This will allow us to merge other dataset such as weather paterns, city population by cities or regions. As well as merging with other cluster information. 


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

merge 1:m Year using FDiall.dta // **1st merged: FDI data with the World Bank Data on GDP   
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
gsort Year
keep if Year > 2002 & Year < 2021
destring Judieff Fishth Laborfr, replace
drop name
save heritage, replace

merge m:m Year using Ghainv //i've never seen m:m in my life! think if rather you need 1:1 or m:1 or 1:m
drop _merge
save Ghainvest, replace //**// FDI + GDP + Freedom + Education + Inflation + Population + Heritage data//**//


*** World Bank Data with Labor Force Participation Rate
import delimited "https://docs.google.com/uc?id=1QqPTpE3fLa8BCC0aVn3eg3i3cOFUCA_T&export=download", clear varnames(1)
drop if countrycode != "GHA"
drop ïcountryname countrycode 
reshape long yr, i(seriesname seriescode) j(Year)
replace yr = "." if yr == ".."
destring yr, replace
replace seriescode=strtoname(seriescode)
reshape wide yr seriesname, i(Year) j(seriescode) string  

drop seriesnameGC_TAX_YPKG_RV_ZS yrGC_TAX_YPKG_RV_ZS seriesnameNE_GDI_FTOT_KD_ZG yrNE_GDI_FTOT_KD_ZG seriesnameSE_SEC_CUAT_LO_ZS yrSE_SEC_CUAT_LO_ZS seriesnameSE_TER_CUAT_BA_ZS yrSE_TER_CUAT_BA_ZS seriesnameSE_XPD_CSEC_ZS yrSE_XPD_CSEC_ZS seriesnameSL_TLF_ADVN_ZS yrSL_TLF_ADVN_ZS seriesnameSL_TLF_BASC_ZS yrSL_TLF_BASC_ZS seriesnameSL_TLF_CACT_NE_ZS yrSL_TLF_CACT_NE_ZS seriesnameNE_GDI_FTOT_CD seriesnameNE_GDI_FTOT_ZS seriesnameNE_GDI_TOTL_CD yrNE_GDI_TOTL_CD seriesnameNY_GDP_PCAP_CD  seriesnameNY_GDP_PCAP_KD_ZG  seriesnameSL_TLF_CACT_ZS seriesnameNY_GDP_PCAP_CD yrNY_GDP_PCAP_CD yrNY_GDP_PCAP_KD_ZG

rename (yrNE_GDI_FTOT_CD yrNE_GDI_FTOT_ZS yrSL_TLF_CACT_ZS) (GFCF GFCFp LFPR)

la var GFCF  "Gross fixed capital formation (current US$)"
la var GFCFp "Gross fixed capital formation (% of GDP)"
la var LFPR     "Labor force participation rate, total (% of total population ages 15+) (modeled ILO estimate)"
save lafo, replace 

merge m:m Year using Ghainvest.dta
drop _merge
save Ghanall, replace //**// FDI + GDP + Freedom + Education + Inflation + Population + Heritage data + Labor Force Participation Rate//**//


/**************************/
/* Graphing the Data ****/
/*************************/
summarize // for a quick summary statistics. 
encode Investingcompany, gen (Comp)
tabulate Comp, subpop(Capin) sort // Shows there are 386 companies that invested in Ghana from June 2003 to September 2020. About 33 percent of these companies invested at least twice in Ghana within that year range, however 67 percent only invested once. 

*****Graphing the dependent variable (Jobs) and Independent Variable (Capin) to observe the trends****************

keep Year Jobs Capin
collapse (sum) Jobs Capin, by(Year) // by reducing the variables we are able to collapse and graph to have a sense of the data.
save FDisum, replace
twoway(line Capin Year) (line Jobs Year, yaxis(2)) 
     /* This first figure reveals interesting trends in both jobs created and the
     corresponding capital investment by the 500 companies from June 2013 to September 
	 2020. Couple of things to note from the graph: 1) Capital investment and jobs 
	 created follow similar trends. 2) The lowest record for both Capitalinvestment and 
	 Jobscreated are recorded in 2007. 3) And the highest number of jobs was created in
	 2019 while the investment picked at 2017 there seem to be a lag in the 
	 relationship.*/
graph save CapJob, replace
graph hbar Jobs, over(Year) // Using a different format, this graph shows us that the most jobs were created in 2019 just before the pandemic and least in 2007, why?
graph save bJobs, replace

use FDiall, clear
collapse (sum) Jobs Capin, by (Sourcecountry)
gsort -Capin // allows us to arrange the variables in a descending manner
keep if Capin > 501
    /* Interested in knowing the top 15 countries with the most capital investment in
	Ghana. South Africa has the highest greenfield investment in Ghana between the years
	examined.*/
#delimit ;
  graph hbar (asis) Capin, over(Sourcecountry, sort(Capin)
  descending axis(off)) blabel(group, size(vsmall) position ("Base") justification(left  )) title(15 Countries with the Highest Capital Investment in Ghana (Jun 2003-Sep 2020
  ), size(medsmall)) legend(off) ;
#delimit cr
graph save mosInv, replace

use FDiall, clear
collapse (sum) Jobs Capin, by (Sourcecountry)
gsort -Jobs // we are interested in knowing where the jobs comes from - countries
keep if Jobs > 2500
#delimit ;
  graph hbar (asis) Jobs, over(Sourcecountry, sort(Jobs) descending axis(
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

**TWOWAY LINE GRAPHS (GDP & POPULATION)
clear
use Ghainvest
twoway (connected GDP Year, sort lcolor(blue)) (line GDPgth Year, sort yaxis(2) lcolor(red)), title(Ghana's GDP & Growth Rate from 2013 to 2020)
	/*This graph shows the trend in Ghana's GDP and the growth rate from 2013 to 2020*/
    //gr export Myfigs.png, replace(Later) 
  
collapse Popln GDP infl CR_BSEX CR_RBSEX CR_UBSEX Hersco Proprit Govinteg Judieff Taxburd Govspen Fishth Buzfr Laborfr Moneyfr Tradefr Invfr Finfr, by(Year) // by reducing the variables we are able to graph is by the years
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
  
  
***LINE GRAPHS
clear
use Ghainvest
line infl Year, sort title("Ghana Inflation Rate") // showing the trends in Ghana's inflation rate
graph save Infla, replace
line Hersco Year, sort title("Ghana Heritage Freedom Score")
graph save HeSco, replace
graph combine Infla.gph HeSco.gph  
  
  
**AVERAGE 
symplot infl // The graph shows most of the inflation points above the average line


**BAR GRAPHS
**Also, we would like to know where companies from each of the top 5 countries are investing using bar graphs.

use Ghanall, clear
encode Sector, gen (Sec) //  encoding the sectors so we can graph using pie chart 
keep if Sourcecountry == "South Africa"
keep Sourcecountry Sec
list
tabulate Sec
graph bar (count), over(Sec, axis(off) sort(ascending)) blabel(group) title(South Africa Companies by Sector of Investment)
graph save baSA, replace


use Ghanall, clear 
encode Sector, gen (Sec)
keep Sourcecountry Sec            
keep if Sourcecountry == "Italy"
tab Sec  
graph bar (count), over(Sec, axis(off) sort(ascending)) blabel(group) title(Italy Companies by Sector of Investment)
graph save baIt, replace


use Ghanall, clear 
encode Sector, gen (Sec)
keep Sourcecountry Sec            
keep if Sourcecountry == "United States"
tab Sec 
graph hbar (count), over(Sec, axis(off) sort(ascending)) blabel(group) title(United States Companies by Sector of Investment)
graph save baUS, replace

use Ghanall, clear 
encode Sector, gen (Sec)
keep Sourcecountry Sec            
keep if Sourcecountry == "United Kingdom"
tab Sec
graph hbar (count), over(Sec, axis(off) sort(descending)) blabel(group) title(United Kingdom Companies by Sector of Investment)
graph save baUk, replace

** Using bar graphs to visual Rule of Law, Government Size and Regulatory Efficiency

use Ghanall, clear 
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
  
/********************/
/* Regressions ****/
/********************/  

** The researcher shall conduct two levels of regressions. The first regression will be an analysis of the 500 observations, which reflects greenfield investment by 386 multinational corporations into Ghana from June 2003 to September 2020. This granular data allows us to efficiently assess the impact of greenfield investment on job creation in Ghana.

gen Cap = 1000000 * Capin
format %12.2g Cap
gen lncap = ln(Cap)
gen lnjob = ln(Jobs)
eststo clear
*(i)
eststo: reg Jobs Capin // this shows a significant output but the relationship is not linear

*(ii)
eststo:  reg lnjob lncap // Remodeling the function to get a linear function. the log function looks better

*(iii)
eststo: reg lnjob lncap GDP GCF LFPR infl   // Economic controlls
test lncap GDP GCF LFPR infl // We reject the p value at 95% confidence interval and conclude that the F statistic is very significant

estat vif // there is no multicolinearity 
estat hettest // there is heteroskedasticity at p value of 0.000, we need to fix it.

*(iv)
eststo: reg lnjob lncap GDP GCF LFPR infl Taxburd Govinteg Buzfr Proprit // Government Controls
test lncap GDP GCF LFPR infl Taxburd Govinteg Buzfr Proprit // We reject the p value at 95% confidence interval and conclude that the F statistic is very significant

estat vif // there is no multicolinearity 
estat hettest //there is heteroskedasticity at p value of 0.000, we need to fix it.
*(v)
eststo: reg Jobs Capin LFPR  c.infl##c.GCF c.GDP##c.GDP  // Introducing some interactions
estat vif // there is multicolinearity. We leave it like that
estat hettest // //there is heteroskedasticity at p value of 0.000, we need to fix it.

esttab, r2 ar2 p scalar(F) compress
esttab using result1.doc, r2 ar2 p scalar(F) title (IMPACT OF GREENFIELD INVESTMENT ON JOB CREATION IN GHANA by 386) replace


/*COLLAPSED DATA IN YEARS*/
** The second regression will be a summation collapse of the data over the 18 years from 2003 to 2022.

eststo clear // to clear the stored regression outputs

format %15.2g GDP GFCF
gladder Capin, fraction // the gladder syntax gave me a clue to introduce the log function for capital investment
collapse (sum) Jobs lnjob Cap GFCF GDP GCF LFPR infl lncap Popln GDPgth CR_BSEX CR_UBSEX CR_RBSEX Hersco, by(Year) //

*(i)
eststo: reg Jobs Cap 

*(ii)
eststo: reg Jobs lncap

*(iii)
eststo: reg lnjob lncap GDP GCF LFPR

**(iv)
gen sqGFCF = sqrt(GFCF) 
gen sqGDP = sqrt(GDP)
gen sqjob = sqrt(Jobs)
gen sqcap = sqrt(Cap)

eststo: reg sqjob sqcap sqGDP sqGFCF LFPR infl
test sqcap sqGDP sqGFCF LFPR infl

**(v)
eststo: reg Jobs LFPR c.Cap##(c.Cap c.GDP c.GCF c.CR_UBSEX c.CR_RBSEX c.Popln) 

esttab, r2 ar2 p scalar(F) compress

esttab using result2.doc, r2 ar2 p title (Impact of Greenfield Inv. on Job creation in Ghana) replace

*** Checking for heteroskedasticity 
**(a)
reg lnjob lncap GDP GCF LFPR

estat hettest // since our p value is 0.67, we fail to reject the null which states that there is constant variance. Thus, there is no heteroskedasticity

estat vif // the vif indicates multicollinearity with a mean VIF of 899

**(b)
reg sqjob sqcap sqGDP sqGFCF LFPR infl
estat hettest // since our p value is 0.67, we fail to reject the null which states that there is constant variance. Thus, there is no heteroskedasticity

estat vif // the vif indicates multicollinearity with a mean VIF of 35.10



**SECOND RESEARCH QUESTION
/* The regression functions below will allow us to answer the second research question*/
use Ghanall, clear
encode Cluster, gen (Clus)
reg Jobs Capin GDP LFPR i.Clus


reg Jobs Capin GDP infl c.LFPR##i.Clus






























