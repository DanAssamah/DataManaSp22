** Data Management Class
** PS1 DOFILE
** Daniel Assamah, Spring 2022
** Stata 16
//good
//--------------------------------------------

* notes: Fdi data extracted from fdi market place
//be more specific, like give url
//..................................................
//..................................................

Clear // first clean up

// uploaded excel file using the gui: file import-excel or 
//what?

** Question 1

import excel "https://docs.google.com/uc?id=15ZBiYkdVF_U65_tWdWVACcSfpqe0OWQt&export=download",clear first
//good

** Question 2
// Upload of second dataset 
//no; should change dir beofre importing any data; these are first steps
pwd // to know which directory we currently on 
cd C:\Users\danas\OneDrive\Desktop


import delimited FDi_average, clear //this doesnt make sense: i dont have this file! and you just loaded the file ealier from internet!
edit // to open up in edit mode to check up the dataset
des // There 10 variables, with most of them having 18 observations, while some have only 17 observations
sum // there are 18 variables but some variables 

** or we can load the data from online, just like the first dataset //yes please!
import delimited "https://docs.google.com/uc?id=1bWfiqmyNVtJlP77kaaBPGfzDJnVMwzg6&export=download", clear
// I used delimited because it is a csv file

** want to introduce another variable gpd2 //good
gen gdp2 = 2*gdp 
save FDi_average // file saved as .dta ie. FDi_average.dta, on the desktop 
generate fdi2 = 3*fdi // creating another variable 
save FDi_avearge, replace // without the replace, it indicated that the file already exists



** Question 3 //all the data you're using--should give source url and perhaps brief description
import excel "https://docs.google.com/uc?id=15ZBiYkdVF_U65_tWdWVACcSfpqe0OWQt&export=download",clear first
sum
// 500 observations
// Mean job created is 197.44, with the min as 0 and max been 5000
// Capital investments mean is $ 98.89 million, wtih the min 0.1 and max 7900 mil 

count
* give total number of observations similar to the summarize functions ie. 500

sample 25
* 375 of my observations got deleted (mouth open) how do I undo this? lol

browse
* browse functions like edit. so what is the difference?? They open up the data so you can edit

// how do I upload a data from online? and how do i groupd the data 


** Question 4 //rmember that ps is asking you to save it in 3 different formats! you didnt do that!

