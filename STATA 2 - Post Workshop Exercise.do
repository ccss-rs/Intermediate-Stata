/* 
Import Data
*/

* Adult dataset - the unit level of data is household by person
use "https://ssc.wisc.edu/sscc/stata/dws/2000_acs_adults.dta", clear
gen adult = 1
save 2000_acs_adult, replace

* Children dataset - the unit level of data is household by person
use "https://ssc.wisc.edu/sscc/stata/dws/2000_acs_children.dta", clear
gen adult = 0
save 2000_acs_children, replace

* Household dataset - the unit level of data is household
use "https://ssc.wisc.edu/sscc/stata/dws/2000_acs_households.dta", clear
save 2000_acs_household, replace

* Education dataset - tthe unit level of data is household by person
use "https://ssc.wisc.edu/sscc/stata/dws/2000_acs_education.dta", clear
save 2000_acs_education, replace

/*
Merge and Append
*/

** Append datasets **
use 2000_acs_adult, clear
append using 2000_acs_children
sort household person
save 2000_acs_all, replace

* Append more than two datasets 
* Person 1
use 2000_acs_all, clear
keep if person == 1
save 2000_acs_p1, replace
* Person 2
use 2000_acs_all, clear
keep if person == 2
save 2000_acs_p2, replace
* Person 3
use 2000_acs_all, clear
keep if person == 3
save 2000_acs_p3, replace
* Others
use 2000_acs_all, clear
keep if person > 3
save 2000_acs_p4, replace
* Append all datasets and generate an identifier that tells us which dataset the observation is from.
append using 2000_acs_p1 2000_acs_p2 2000_acs_p3, generate(filenum)
tab filenum

** Merge datasets **

* Identifier not unique in master but unique in local file
use 2000_acs_all, clear
merge m:1 household using 2000_acs_household
* Use `list in [a]/[b]' to get a preview of row a to row b in the datasets
list in 1/5

* Identifier unique in both local file and master file
use 2000_acs_all, clear
drop edu
* The pair `household' and `person' is uniquely identified in the dataset as that's the unit level.
* We use `merge 1:1' to tell the machine that household-person pair is uniquely identified in both master and local file
merge 1:1 household person using 2000_acs_education
list in 1/5

* Identifier unique in master file but not in local file
use 2000_acs_household, clear
* Use `keepusing' to include the variables we need from the local file - as an example, we pick `person`, `age` and `income' variable.
merge 1:m household using 2000_acs_all, keepusing(person age income)
sort household person
list in 1/5
* We drop the automatically generated variable `_merge' that indicates whether the observation is matched or not.
drop _merge
* We save this merged dataset for next exercise.
save 2000_acs_merge, replace


/*
Reshape
*/

* Long to Wide
use 2000_acs_merge, clear
list in 1/5
reshape wide age income, i(household) j(person)
* Print out the summary statistics for each variables.
summarize

* Wide to Long
reshape long age income, i(household) j(id)
tab id
tab id if age != .
drop if age ==.
summarize

* Re-import `2000_acs_merge' for comparison.
use 2000_acs_merge, clear
summarize