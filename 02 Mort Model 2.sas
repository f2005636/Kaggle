/*4. categorical variables*/
%macro cat_bin(df, var);
proc sql;
select &var., count(*) as cnt, avg(default_time) as pd, log(avg(default_time) / (1-avg(default_time))) as log_pd
from &df.
group by &var.;
quit;
%mend;
%cat_bin(rg.step1, REtype_CO_orig_time);
%cat_bin(rg.step1, REtype_PU_orig_time);
%cat_bin(rg.step1, REtype_SF_orig_time);
%cat_bin(rg.step1, investor_orig_time);

data temp4; set rg.step1;
    if REtype_CO_orig_time = 0 then REtype_CO_orig_bin = -3.6220; 
    else REtype_CO_orig_bin = -3.5763;
    if REtype_PU_orig_time = 0 then REtype_PU_orig_bin = -3.6182; 
    else REtype_PU_orig_bin = -3.6230;
    if REtype_SF_orig_time = 0 then REtype_SF_orig_bin = -3.6393; 
    else REtype_SF_orig_bin = -3.6059;
*1; if investor_orig_time = 0 then investor_orig_bin = -3.6060; 
    else investor_orig_bin = -3.6986;
run;

%cat_bin(temp4, REtype_CO_orig_bin);
%cat_bin(temp4, REtype_PU_orig_bin);
%cat_bin(temp4, REtype_SF_orig_bin);
%cat_bin(temp4, investor_orig_bin);

data temp4 (drop=investor_orig_time REtype_CO_orig_bin REtype_PU_orig_bin REtype_SF_orig_bin);
set temp4; run;

proc contents data=temp4; run;

/*5. numerical variables*/
data temp5; set temp4; run;
%macro num_bin(var);
proc rank data=temp5 out=temp5 groups=12;
var &var; ranks &var._;
run;
data temp5; set temp5;
if &var._ = . then &var._ = -1;
run;
proc sql;
select &var._, count(*) as cnt, min(&var) as min_var, max(&var) as max_var, avg(&var) as mean_avg,
avg(default_time) as pd, log(avg(default_time) / (1-avg(default_time))) as log_pd
from temp5
group by &var._;
quit;
%mend;
%num_bin(hpi_diff);
%num_bin(hpi_mom);
%num_bin(hpi_orig_time);
%num_bin(hpi_qoq);
%num_bin(gdp_mom);
%num_bin(gdp_qoq);
%num_bin(uer_mom);
%num_bin(uer_qoq);
%num_bin(LTV_diff);
%num_bin(LTV_orig_time);
%num_bin(LTV_time);
%num_bin(interest_rate_diff);
%num_bin(Interest_Rate_orig_time);
%num_bin(interest_rate_time);
%num_bin(balance_diff);
%num_bin(balance_orig_time);
%num_bin(balance_time);
%num_bin(orig_time);
%num_bin(FICO_orig_time);

data temp5; set temp5;
*2; hpi_diff_bin= (0.7168*(hpi_diff/100)*(hpi_diff/100)) - (1.0169*(hpi_diff/100)) - 4.1217;
*3; hpi_qoq_bin = (-2.9895*hpi_qoq*hpi_qoq) - (5.3006*hpi_qoq) - 3.7889;
*4; uer_mom_bin = (-23.464*uer_mom*uer_mom) + (8.0047*uer_mom) - 3.7449;
*5; uer_qoq_bin = (-6.0509*uer_qoq*uer_qoq) + (4.612*uer_qoq) - 3.7664;
*6; if LTV_time = . then LTV_time_bin = -3.98434;
    else LTV_time_bin = (-0.2014*(LTV_time / 100)*(LTV_time / 100)) + (2.99*(LTV_time / 100)) - 6.218;
*7; if interest_rate_diff <= -1.50 then int_rate_diff_bin = -4.11596;
    else if interest_rate_diff <= 0.00 then int_rate_diff_bin = -3.75167;
    else int_rate_diff_bin = -3.15217;
*8; if balance_time <= 54764.28 then balance_time_bin = -4.39022;
    else if balance_time <= 99433.43 then balance_time_bin = -3.83974;
    else balance_time_bin = -3.51884;
*9; if orig_time <= 11.00 then orig_time = 20;
    orig_time_bin = (-38.8*(orig_time/100)*(orig_time/100)) + (28.189*(orig_time/100)) - 7.9738;
*10;FICO_orig_bin = (-0.3442*(FICO_orig_time/100)*(FICO_orig_time/100)) + (4.0397*(FICO_orig_time/100)) - 15.1;
*11;balance_orig_bin = (-11.411*( balance_orig_time/1000000)*( balance_orig_time/1000000)) + (6.8512*( balance_orig_time/1000000)) - 4.3458;
*12;balance_time_bin = (-12.948*(balance_time/1000000)*(balance_time/1000000)) + (7.7883*(balance_time/1000000)) - 4.4564;
run;

data rg.step2 (rename=(default_time = default));
set temp5 (drop=LTV_diff LTV_diff_ LTV_orig_time LTV_orig_time_ LTV_time LTV_time_
balance_diff balance_diff_ balance_orig_time balance_orig_time_ balance_time balance_time_
FICO_orig_time FICO_orig_time_ orig_time orig_time_
gdp_mom gdp_mom_ gdp_qoq gdp_qoq_ uer_mom uer_mom_ uer_qoq uer_qoq_ 
hpi_diff hpi_diff_ hpi_mom hpi_mom_ hpi_orig_time hpi_orig_time_ hpi_qoq hpi_qoq_
interest_rate_diff interest_rate_diff_ Interest_Rate_orig_time Interest_Rate_orig_time_ interest_rate_time interest_rate_time_);
run;

proc contents data=rg.step2; run;