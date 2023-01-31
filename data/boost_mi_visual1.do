
/*==============================================================================
							 
			IMPUTE MISSING VALUES USING CHAINED EQUATIONS WITH BOOST PANEL DATA
							 
==============================================================================*/

**# PART I: DATA VISUALIZATION
	
	use "$clean\boost_panel_wss.dta", replace
	keep if year>=2009 & year<=2018
	bysort countryname: egen avg_gdp=mean(gdp_usd_cons_2019)
	
	*	drop outliers
	replace ex_ce_watersan=ex_ce_watersan*10 if countryname=="Benin" & year==2017
	replace ex_ce_watersan=ex_ce_watersan*10 if countryname=="Cabo Verde" & year==2017
	replace ex_te_watersan=. if countryname=="Georgia" & year==2009
	replace ex_ce_watersan=. if countryname=="Georgia" & year==2009
	replace ex_ce_watersan=. if countryname=="Georgia" & year==2010
	replace ex_ce_watersan=. if countryname=="Malawi" & year==2016
	replace ex_ce_watersan=. if countryname=="Tanzania" & year==2015
	replace ex_ce_watersan=. if countryname=="Timor-Leste" & (year==2011 | year==2017)
	
	*	drop country with low data quality
	drop if countryname=="Sao Tome and Principe"
	drop if countryname=="Tuvalu"
	
	*	target variables
	gen log_ce_watersan=log(ex_ce_watersan)
	gen log_re_watersan=log(ex_re_watersan)
	
	*	data visualization
	set scheme swift_red
	**	pooled-year average by country
	***	capex
	cap drop y_mean rank
	bysort countryname: egen y_mean=mean(log_ce_watersan)
	bysort year: egen rank=rank(y_mean)
	sort rank
	twoway scatter log_ce_watersan rank, msymbol(circle_hollow) msize(small) || connected y_mean rank, msymbol(diamond) msize(small)  mlabel(countryname) mlabsize(tiny) jitter(10) ///
	ytitle("Yearly Log(WSS capital expenditure) ") xtitle("Rank based on decadal average capital expenditure on WSS") ///
	legend(order(1 "yearly log(WSS CapEx)" 2 "country decadal average")) 
	graph export "$output\wss_capex_avgbycountry.png", replace
	
	***	open
	cap drop y_mean rank
	bysort countryname: egen y_mean=mean(log_re_watersan)
	bysort year: egen rank=rank(y_mean)
	sort rank
	twoway scatter log_re_watersan rank, msymbol(circle_hollow) msize(small) || connected y_mean rank, msymbol(diamond) msize(small)  mlabel(countryname) mlabsize(tiny) jitter(10) ///
	ytitle("Yearly Log(WSS operating expenditure) ") xtitle("Country rank based on decadal average operating expenditure on WSS") ///
	legend(order(1 "yearly log(WSS OpEX" 2 "country decadal average")) 
	graph export "$output\wss_opex_avgbycountry.png", replace
	

	**	pooled-country average by year
	***	capex
	cap drop y_mean1
	bysort year: egen y_mean1=mean(log_ce_watersan)
	sort year
	twoway scatter log_ce_watersan year, msymbol(circle_hollow) || connected y_mean1 year, msymbol(diamond) || , xlabel(2009(1)2019) ///
	ytitle("Country Log(WSS CapEx)") xtitle("") legend(order(1 "country log(CapEx)" 2 "yearly average")) 
	graph export "$output\wss_capex_avgbyyear.png", replace
	
	***	opex
	cap drop y_mean1
	bysort year: egen y_mean1=mean(log_re_watersan)
	sort year
	twoway scatter log_re_watersan year, msymbol(circle_hollow) || connected y_mean1 year, msymbol(diamond) || , xlabel(2009(1)2019) ///
	ytitle("Country Log(WSS OpEx)") xtitle("") legend(order(1 "country log(OpEx)" 2 "yearly average")) 
	graph export "$output\wss_opex_avgbyyear.png", replace
	
	
	*	keep related variables
	replace ex_re_watersan = ex_te_watersan-ex_ce_watersan
	keep countryname year ex_ce_watersan ex_re_watersan avg_gdp gdp_usd_cons_2019


	tempfile wss
	save `wss'
	
**# PART II: MULTIPLE IMPUTATION

	mi set mlong
	mi reshape wide ex_ce_watersan ex_re_watersan gdp_usd_cons_2019, i(countryname) j(year)

	mi register imputed ex_re_watersan* ex_ce_watersan*

	mi impute chained (regress) ex_re_watersan* ex_ce_watersan*  = avg_gdp, add(50) rseed(08312022)
	*mi impute chained (regress) ex_ce_watersan* = avg_gdp, add(50) rseed(08312022)
	mi reshape long ex_ce_watersan ex_re_watersan gdp_usd_cons_2019, i(countryname) j(year)
	rename ex_re_watersan ex_re_watersan_mi
	rename ex_ce_watersan ex_ce_watersan_mi

	merge m:1 countryname year using `wss'
	cap drop _merge
	
	*	drop irrational values
	drop if ex_re_watersan_mi<0 | ex_ce_watersan_mi<0
	bysort countryname year: egen re_wss_mi=mean(ex_re_watersan_mi) if _mi_m>0
	bysort countryname year: egen ce_wss_mi=mean(ex_ce_watersan_mi) if _mi_m>0
	replace re_wss_mi=ex_re_watersan if re_wss_mi==.
	replace ce_wss_mi=ex_ce_watersan if ce_wss_mi==.
	collapse re_wss_mi ce_wss_mi ex_ce_watersan ex_re_watersan gdp_usd_cons_2019, by(countryname year)

	save "$clean\boost_panel_mi.dta", replace
