# boost_mi



## Impute Missing Values Using Chained Equation with Panel Data

In this repository is a first trial of using MICE (Multiple Imputation Chained Equations) to fill missing values with Stata mi package for a panel dataset of country-level public expenditure from year 2009 to 2018. 

Addition info:

* The [boost_mi_visual1.do](./data/boost_mi_visual1.do) contains the script for original data visualization and mi computation.
* The [boost_mi_visual2.do](./data/boost_mi_visual2.do) contains the script for pattern of missing values, data visualization before- and after- mi computation.
* The [figures](/figures) folder contains the data visualization images.

Documentation: 
[Stata mi package manual](https://www.stata.com/manuals/mimiimputechained.pdf)

Other Guide:
[UCLA Stata website using mi for panel dataset](https://stats.oarc.ucla.edu/stata/faq/how-can-i-perform-multiple-imputation-on-longitudinal-data-using-ice/)
 
## Preview

### tab1 (12 colors)

<img src="./figures/scatter_tab1.png" height="200"><img src="./figures/line_tab1.png" height="200">
<img src="./figures/bar_tab1.png" height="200"><img src="./figures/barh_tab1.png" height="200">
<img src="./figures/pie_tab1.png" height="200"><img src="./figures/box_tab1.png" height="200">

### tab2 (12 colors)

<img src="./figures/scatter_tab2.png" height="200"><img src="./figures/line_tab2.png" height="200">
<img src="./figures/bar_tab2.png" height="200"><img src="./figures/barh_tab2.png" height="200">
<img src="./figures/pie_tab2.png" height="200"><img src="./figures/box_tab2.png" height="200">

### tab3 (12 colors)

<img src="./figures/scatter_tab3.png" height="200"><img src="./figures/line_tab3.png" height="200">
<img src="./figures/bar_tab3.png" height="200"><img src="./figures/barh_tab3.png" height="200">
<img src="./figures/pie_tab3.png" height="200"><img src="./figures/box_tab3.png" height="200">






### Change log
* 08 Nov 2022: v1.4 release. Fixes and corrections to schemes. GitHub folder renamed to stata-schemepack to align it with other dataviz packages.

