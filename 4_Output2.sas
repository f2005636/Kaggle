libname rg '/folders/myfolders/rg';

proc sql;
create table volume_forecast as 
select a.Agency, a.SKU, b.ma12_201801 as Volume
from rg.vol_forecast as a left join rg.output_data2 as b
on a.Agency = b.Agency and a.SKU = b.SKU;
quit;

proc export data=volume_forecast
outfile='/folders/myfolders/rg/out_vol.csv' dbms=csv replace;
run;

/* sku for agency 06 */
proc sort data=volume_forecast;
by Agency descending Volume ;
run;

data temp;
set volume_forecast;
by Agency;
retain cnt;
if first.Agency then cnt = 1; else cnt = cnt+1;
run;

data temp;
set temp;
where Agency in ('Agency_07', 'Agency_27', 'Agency_46', 'Agency_48', 'Agency_49', 'Agency_51');
run;

proc sql;
create table sku_recommendation as
select SKU, sum(cnt) as SKU_RANK
from temp
group by SKU
order by SKU_RANK;
quit;

proc export data=sku_recommendation
outfile='/folders/myfolders/rg/out_sku06.csv' dbms=csv replace;
run;

/* sku for agency 14 */
proc sort data=volume_forecast;
by Agency descending Volume ;
run;

data temp;
set volume_forecast;
by Agency;
retain cnt;
if first.Agency then cnt = 1; else cnt = cnt+1;
run;

data temp;
set temp;
where Agency in ('Agency_03', 'Agency_12', 'Agency_38', 'Agency_46', 'Agency_48', 'Agency_49', 'Agency_51', 'Agency_55', 'Agency_56', 'Agency_57', 'Agency_60');
run;

proc sql;
create table sku_recommendation as
select SKU, sum(cnt) as SKU_RANK
from temp
group by SKU
order by SKU_RANK;
quit;

proc export data=sku_recommendation
outfile='/folders/myfolders/rg/out_sku14.csv' dbms=csv replace;
run;