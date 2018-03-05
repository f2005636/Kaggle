libname rg '/folders/myfolders/rg';

/* forecasting the sales at SKU level */
proc sql;
create table SKU as 
select SKU, sum(Avg_Population_2017) as sum_Avg_Population_2017, sum(Avg_Yearly_Household_Income_2017) as sum_Household_Income_2017, 
sum(_201301) as sum_201301, sum(_201302) as sum_201302, sum(_201303) as sum_201303, sum(_201304) as sum_201304, sum(_201305) as sum_201305, sum(_201306) as sum_201306, sum(_201307) as sum_201307, sum(_201308) as sum_201308, sum(_201309) as sum_201309, sum(_201310) as sum_201310, sum(_201311) as sum_201311, sum(_201312) as sum_201312, 
sum(_201401) as sum_201401, sum(_201402) as sum_201402, sum(_201403) as sum_201403, sum(_201404) as sum_201404, sum(_201405) as sum_201405, sum(_201406) as sum_201406, sum(_201407) as sum_201407, sum(_201408) as sum_201408, sum(_201409) as sum_201409, sum(_201410) as sum_201410, sum(_201411) as sum_201411, sum(_201412) as sum_201412, 
sum(_201501) as sum_201501, sum(_201502) as sum_201502, sum(_201503) as sum_201503, sum(_201504) as sum_201504, sum(_201505) as sum_201505, sum(_201506) as sum_201506, sum(_201507) as sum_201507, sum(_201508) as sum_201508, sum(_201509) as sum_201509, sum(_201510) as sum_201510, sum(_201511) as sum_201511, sum(_201512) as sum_201512, 
sum(_201601) as sum_201601, sum(_201602) as sum_201602, sum(_201603) as sum_201603, sum(_201604) as sum_201604, sum(_201605) as sum_201605, sum(_201606) as sum_201606, sum(_201607) as sum_201607, sum(_201608) as sum_201608, sum(_201609) as sum_201609, sum(_201610) as sum_201610, sum(_201611) as sum_201611, sum(_201612) as sum_201612, 
sum(_201701) as sum_201701, sum(_201702) as sum_201702, sum(_201703) as sum_201703, sum(_201704) as sum_201704, sum(_201705) as sum_201705, sum(_201706) as sum_201706, sum(_201707) as sum_201707, sum(_201708) as sum_201708, sum(_201709) as sum_201709, sum(_201710) as sum_201710, sum(_201711) as sum_201711, sum(_201712) as sum_201712
from rg.master_data
group by SKU;
quit;

data SKU_Jan18 (keep = SKU sum_Avg_Population_2017 sum_Household_Income_2017
ma01_201801 ma02_201801 ma03_201801  ma04_201801 ma05_201801 ma06_201801 ma07_201801 ma08_201801 ma09_201801 ma10_201801 ma11_201801 ma12_201801);
set SKU;
ma01_201801 = mean(sum_201712);
ma02_201801 = mean(sum_201711,sum_201712);
ma03_201801 = mean(sum_201710,sum_201711,sum_201712);
ma04_201801 = mean(sum_201709,sum_201710,sum_201711,sum_201712);
ma05_201801 = mean(sum_201708,sum_201709,sum_201710,sum_201711,sum_201712);
ma06_201801 = mean(sum_201707,sum_201708,sum_201709,sum_201710,sum_201711,sum_201712);
ma07_201801 = mean(sum_201706,sum_201707,sum_201708,sum_201709,sum_201710,sum_201711,sum_201712);
ma08_201801 = mean(sum_201705,sum_201706,sum_201707,sum_201708,sum_201709,sum_201710,sum_201711,sum_201712);
ma09_201801 = mean(sum_201704,sum_201705,sum_201706,sum_201707,sum_201708,sum_201709,sum_201710,sum_201711,sum_201712);
ma10_201801 = mean(sum_201703,sum_201704,sum_201705,sum_201706,sum_201707,sum_201708,sum_201709,sum_201710,sum_201711,sum_201712);
ma11_201801 = mean(sum_201702,sum_201703,sum_201704,sum_201705,sum_201706,sum_201707,sum_201708,sum_201709,sum_201710,sum_201711,sum_201712);
ma12_201801 = mean(sum_201701,sum_201702,sum_201703,sum_201704,sum_201705,sum_201706,sum_201707,sum_201708,sum_201709,sum_201710,sum_201711,sum_201712);
run;

/* forecasting the sales at Agency and SKU level */
proc sql;
create table Agency as 
select a.*, b.*
from rg.master_data as a left join SKU_Jan18 as b
on a.SKU = b.SKU;
quit;

data Agency_Jan18;
format Volume best12.;
set Agency (drop=Volume);
adj01_201801 = ma01_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
adj02_201801 = ma02_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
adj03_201801 = ma03_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
adj04_201801 = ma04_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
adj05_201801 = ma05_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
adj06_201801 = ma06_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
adj07_201801 = ma07_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
adj08_201801 = ma08_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
adj09_201801 = ma09_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
adj10_201801 = ma10_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
adj11_201801 = ma11_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
adj12_201801 = ma12_201801 * Avg_Population_2017 / sum_Avg_Population_2017;
run;

/* Adjustments for series where data is available */
data Adj;
set Agency_Jan18 (drop = sum_Avg_Population_2017 sum_Household_Income_2017
ma01_201801 ma02_201801 ma03_201801  ma04_201801 ma05_201801 ma06_201801 ma07_201801 ma08_201801 ma09_201801 ma10_201801 ma11_201801 ma12_201801);
ma01_201801 = mean(_201712);
ma02_201801 = mean(_201711,_201712);
ma03_201801 = mean(_201710,_201711,_201712);
ma04_201801 = mean(_201709,_201710,_201711,_201712);
ma05_201801 = mean(_201708,_201709,_201710,_201711,_201712);
ma06_201801 = mean(_201707,_201708,_201709,_201710,_201711,_201712);
ma07_201801 = mean(_201706,_201707,_201708,_201709,_201710,_201711,_201712);
ma08_201801 = mean(_201705,_201706,_201707,_201708,_201709,_201710,_201711,_201712);
ma09_201801 = mean(_201704,_201705,_201706,_201707,_201708,_201709,_201710,_201711,_201712);
ma10_201801 = mean(_201703,_201704,_201705,_201706,_201707,_201708,_201709,_201710,_201711,_201712);
ma11_201801 = mean(_201702,_201703,_201704,_201705,_201706,_201707,_201708,_201709,_201710,_201711,_201712);
ma12_201801 = mean(_201701,_201702,_201703,_201704,_201705,_201706,_201707,_201708,_201709,_201710,_201711,_201712);
run;

data Adj_Jan18;
set Adj;
if ma01_201801 = . then ma01_201801 = adj01_201801;
if ma02_201801 = . then ma02_201801 = adj02_201801;
if ma03_201801 = . then ma03_201801 = adj03_201801;
if ma04_201801 = . then ma04_201801 = adj04_201801;
if ma05_201801 = . then ma05_201801 = adj05_201801;
if ma06_201801 = . then ma06_201801 = adj06_201801;
if ma07_201801 = . then ma07_201801 = adj07_201801;
if ma08_201801 = . then ma08_201801 = adj08_201801;
if ma09_201801 = . then ma09_201801 = adj09_201801;
if ma10_201801 = . then ma10_201801 = adj10_201801;
if ma11_201801 = . then ma11_201801 = adj11_201801;
if ma12_201801 = . then ma12_201801 = adj12_201801;
run;

data rg.output_data (keep= Agency SKU Volume
ma01_201801 ma02_201801 ma03_201801 ma04_201801 ma05_201801 ma06_201801 ma07_201801 ma08_201801 ma09_201801 ma10_201801 ma11_201801 ma12_201801);
set Adj_Jan18;
run;

proc contents data=rg.output_data; run;

