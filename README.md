# Development

Installation
devtools::install_github("healixloo/Development")

Description
This function loads a correlation object and a formed database file as input, return a list of calculated roc.

Usage
roc_calculate(tmp_res2, tmp_J, J_name = "None", mark_multiple = TRUE)

Arguments
tmp_res2	
a correlation object
tmp_J	
a formed database file
J_name	
label
mark_multiple	
boolean value representing database file of one category or multiple categories

Value
A list of the calculated roc in indicated database file (roc_qda,plotx,roc.info).
