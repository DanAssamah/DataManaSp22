** Data Management Class
** PS1 DOFILE
** Daniel Assamah, Spring 2022
** Stata 16

//--------------------------------------------

* notes: Fdi data extracted from fdi market place
// Extracted from this website https://www.fdimarkets.com/
//..................................................
//..................................................

Clear // first clean up

** Question 1

pwd // to know which directory we currently on
cd C:\Users\danas\OneDrive\Desktop
import excel "https://docs.google.com/uc?id=15ZBiYkdVF_U65_tWdWVACcSfpqe0OWQt&export=download",clear first
edit // to open up in edit mode to check up the dataset
des // There 13 variables, with 500 observations
sum
// 500 observations
// Mean job created is 197.44, with the min as 0 and max been 5000
// Capital investments mean is $ 98.89 million, wtih the min 0.1 and max 7900 mil 
count //give total number of observations similar to the summarize functions ie. 500

sample 25


** Question 2
// Upload of second dataset 
** we can load the data from online, just like the first dataset 
import delimited "https://docs.google.com/uc?id=1bWfiqmyNVtJlP77kaaBPGfzDJnVMwzg6&export=download", clear
// I used delimited because it is a csv file
// data was extracted from the World Bank Dataset https://databank.worldbank.org/source/world-development-indicators

edit // to open up in edit mode to check up the dataset
des // There 10 variables, with most of them having 18 observations, while some have only 17 observations
sum // there are 18 variables but some variables 


** want to introduce another variable gpd2
gen gdp2 = 2*gdp 
save FDi_average // file saved as .dta ie. FDi_average.dta, on the desktop 
generate fdi2 = 3*fdi // creating another variable 
save FDi_average, replace // without the replace, it indicated that the file already exists



** Question 3
** saving data in other formats 
** using the FDi_average.dta data, let us save that in different formates like csv, .xls and .v8xpt
sysuse FDi_average.dta
export excel using "FDi_average Excel", firstrow(variables) file FDi_average Excel.xls saved
		// the above saved the FDi_average.dta file into excel
export delimited using "FDi_average CSV PS1", replace
		// Using the gui the data was transformed into a csv format
export sasxport8 "FDi_average v8 PS1", vallabfile
		// Using the gui the data was transformed into a SAS format

