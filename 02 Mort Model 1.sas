/*1. get data*/
proc sort data=rg.mortgage; by id time; run;
data temp1 (drop = first_time mat_time payoff_time status_time); 
set rg.mortgage; run;
proc contents data=temp1; run;

/*2. adding variables - macro*/
data temp2; set temp1;
retain flag; by id;
if first.id then flag = 1; else flag = flag + 1; 
run;

data temp2; set temp2;
hpi_time_1 = lag(hpi_time); hpi_time_3 = lag3(hpi_time); 
gdp_time_1 = lag(gdp_time); gdp_time_3 = lag3(gdp_time); 
uer_time_1 = lag(uer_time); uer_time_3 = lag3(uer_time); 
run;

data temp2 (drop=hpi_time_1 hpi_time_3
gdp_time gdp_time_1 gdp_time_3 
uer_time uer_time_1 uer_time_3); set temp2; 
hpi_mom = (hpi_time - hpi_time_1) / hpi_time_1; 
hpi_qoq = (hpi_time - hpi_time_3) / hpi_time_3; 
gdp_mom = (gdp_time - gdp_time_1) / gdp_time_1; 
gdp_qoq = (gdp_time - gdp_time_3) / gdp_time_3; 
uer_mom = (uer_time - uer_time_1) / uer_time_1; 
uer_qoq = (uer_time - uer_time_3) / uer_time_3; 
run;

data temp2 (drop=flag); set temp2; 
where flag > 3;
run;

proc contents data=temp2; run;

/*3. adding varaiables - difference*/
data temp3 (drop=hpi_time); set temp2;
hpi_diff = hpi_time - hpi_orig_time;
interest_rate_diff = interest_rate_time - Interest_Rate_orig_time;
LTV_diff = LTV_time - LTV_orig_time;
balance_diff = balance_time - balance_orig_time;
run;

proc contents data=temp3; run;

data rg.step1; set temp3; run;