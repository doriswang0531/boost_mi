

	use "$clean\boost_panel_wss.dta", replace
	keep if year>=2009 & year<=2018
	bysort countryname: egen avg_gdp=mean(gdp_usd_cons_2019)
	replace ex_ce_watersan=ex_ce_watersan*10 if countryname=="Benin" & year==2017
	replace ex_ce_watersan=ex_ce_watersan*10 if countryname=="Cabo Verde" & year==2017
	replace ex_te_watersan=. if countryname=="Georgia" & year==2009
	replace ex_ce_watersan=. if countryname=="Georgia" & year==2009
	replace ex_ce_watersan=. if countryname=="Georgia" & year==2010
	replace ex_ce_watersan=. if countryname=="Malawi" & year==2016
	replace ex_ce_watersan=. if countryname=="Tanzania" & year==2015
	replace ex_ce_watersan=. if countryname=="Timor-Leste" & (year==2011 | year==2017)
	drop if countryname=="Sao Tome and Principe"
	
	gen wss_capex=(ex_ce_watersan!=.)
	gen wss_opex=(ex_re_watersan!=.)
	gen capex_wss_to_gdp=ex_ce_watersan/gdp_usd_cons_2019*100
	label var capex_wss_to_gdp	"WSS CapEx (% GDP)"
	gen opex_wss_to_gdp=ex_re_watersan/gdp_usd_cons_2019*100
	label var opex_wss_to_gdp	"WSS OpEx (% GDP)"
	replace wss_capex=. if capex_wss_to_gdp>100
	replace wss_opex=. if opex_wss_to_gdp>100
	replace capex_wss_to_gdp=. if capex_wss_to_gdp>100
	replace opex_wss_to_gdp=. if opex_wss_to_gdp>100
	
	keep countryname year wss_capex wss_opex ex_ce_watersan ex_te_watersan gdp_usd_cons_2019 capex_wss_to_gdp opex_wss_to_gdp
	set scheme swift_red
	
	sort countryname
	encode countryname, gen(country)
	summ year
	local x1 = `r(min)'
	local x2 = `r(max)'
	heatplot wss_capex i.country year, ///
	yscale(noline) ///
	ylabel(, nogrid labsize(*0.3)) ///
	xlabel(`x1'(1)`x2', labsize(*0.5) angle(vertical)  nogrid) ///
	color(white royalblue) ///  
	p(lcolor(black%10) lwidth(*0.15)) ///
	xtitle("", size(vsmall)) legend(subtitle(CapEx(% GDP), size(vsmall)) order(1 "missing" 2 "non-missing"))	///
	title("Pattern of Missing Values", size(medsmall)) note("Data souce: BOOST database World Bank", size(vsmall))
	graph export "$output\wss_capex_missing_pattern.png", replace
	
	
	summ year
	local x1 = `r(min)'
	local x2 = `r(max)'
	heatplot capex_wss_to_gdp i.country year, ///
	yscale(noline) ///
	ylabel(, nogrid labsize(*0.3)) ///
	xlabel(`x1'(1)`x2', labsize(*0.5) angle(vertical)  nogrid) ///
	color(viridis, reverse) /// 
	p(lcolor(black%10) lwidth(*0.15)) ///
	xtitle("", size(vsmall)) legend(subtitle(CapEx(% GDP), size(vsmall)))	///
	title("Original data", size(medsmall)) note("Data souce: BOOST database World Bank", size(vsmall))
	graph export "$output\wss_capex_values.png", replace

	
	
	use "$clean\boost_panel_mi.dta", clear
	gen capex_wss_to_gdp=ce_wss_mi/gdp_usd_cons_2019*100
	replace ce_wss_mi=. if capex_wss_to_gdp>2
	replace capex_wss_to_gdp=. if capex_wss_to_gdp>2
	sort countryname
	encode countryname, gen(country)	
	summ year
	local x1 = `r(min)'
	local x2 = `r(max)'
	heatplot capex_wss_to_gdp i.country year, ///
	yscale(noline) ///
	ylabel(, nogrid labsize(*0.3)) ///
	xlabel(`x1'(1)`x2', labsize(*0.5) angle(vertical)  nogrid) ///
	color(viridis, reverse) ///
	p(lcolor(black%10) lwidth(*0.15)) ///
	xtitle("", size(vsmall)) legend(subtitle(CapEx(% GDP), size(vsmall)))	///
	title("data filled by MICE", size(medsmall)) note("Data souce: BOOST database World Bank", size(vsmall))
	graph export "$output\wss_capex_values_mi.png", replace

	
	gen opex_wss_to_gdp=re_wss_mi/gdp_usd_cons_2019*100
	replace re_wss_mi=. if capex_wss_to_gdp>2
	replace opex_wss_to_gdp=. if opex_wss_to_gdp>2
	
	summ year
	local x1 = `r(min)'
	local x2 = `r(max)'
	heatplot opex_wss_to_gdp i.country year, ///
	yscale(noline) ///
	ylabel(, nogrid labsize(*0.3)) ///
	xlabel(`x1'(1)`x2', labsize(*0.5) angle(vertical)  nogrid) ///
	color(viridis, reverse) ///   
	p(lcolor(black%10) lwidth(*0.15)) ///
	title("") ///
	xtitle("", size(vsmall)) legend(subtitle(opex(% GDP), size(vsmall)))	///
	title("data filled by MICE", size(medsmall)) note("Data souce: BOOST database World Bank", size(vsmall))
	graph export "$output\wss_opex_values_mi.png", replace
	
		
