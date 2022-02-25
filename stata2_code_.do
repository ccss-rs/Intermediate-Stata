*Open sample dataset.
sysuse auto, clear
*generate and replace
codebook price 
*** when one is generating a variable, the variable has to be defined
gen price_t = price * 1.08
codebook price_t
*drop variable
drop price_t

*include if options. 
generate group = 1 if price < 5000
replace group = 2 if price>=5000 & price<10000
replace group = 3 if price >= 10000
codebook group

*say we want to relabel the codes
recode group (1=0) (2/3=1)
codebook group

*label variables
*** two steps: 	create labels for each category of the variable
***				put the labels on the variable
label def group_label 0 "cheap" 1"expensive"
label val group group_label
codebook group

*can also generate string variables
gen r2 = "e" if rep78 == 2 | rep78 == 4
replace r2 = "o" if rep78 == 3 | rep78 == 5


* subset data, preserve
preserve
drop if price > 10000
*include if options and operators. 
keep if rep78 == 3 | rep78 == 2
keep make price mpg
* save this reduced data as a separate dataset
save reduced_data, replace
restore


*collapse command, 
sysuse auto, clear
collapse (mean) price_avg = price mpg_avg = mpg (sd) price_sd = price mpg_sd = mpg, by(foreign)
*open dataset.
browse
*export data
export delimited using price_mpg, replace


*Sample datasets below gotten from Stata website section on data management. 
*https://www.stata-press.com/data/r17/d.html
*Sample dataset for reshape. 
webuse reshape6, clear
reshape wide inc ue, i(id) j(year)
reshape long inc ue, i(id) j(year)


*sample datasets for merging. 
*merge 1 to many
webuse overlap1, clear
save overlap1, replace
webuse overlap2 
merge 1:m id using overlap1
browse


*merge 1:1
webuse autosize, clear
save car_size, replace
webuse autoexpense, clear
merge 1:1 make using car_size
browse

