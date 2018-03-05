libname rg '/folders/myfolders/rg';

/* data rg.vol_forecast; set IMPORT2; run; */
/* data rg.dem; set IMPORT3; run; */
/* data rg.hist; set IMPORT; run; */
/* data rg.sku_reco; set IMPORT1; run; */

proc sql;
create table temp as 
select a.*, b.* 
from rg.vol_forecast as a left join rg.dem as b
on a.Agency = b.Agency;

create table rg.master_data as 
select a.*, b.* 
from temp as a left join rg.hist as b
on a.Agency = b.Agency and a.SKU = b.SKU;
quit;

proc corr data=rg.master_data (drop=Agency SKU Volume);
var _all_;
run;