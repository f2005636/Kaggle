options compress=yes;
libname rg '/ccr/ccar_secured/rg83892/in2016ye';

/*data rg.CAX_Startup_Data; set WORK.CAX_Startup_Data; X = 'X'; run;*/
/*proc contents data=rg.CAX_Startup_Data;run;*/

data temp (drop='Survival through recession, base'n 'Time to 1st investment (in month'n 'Avg time to investment - average'n 'Gartner hype cycle stage'n
'Time to maturity of technology ('n 'Percent_skill_Entrepreneurship'n 'Percent_skill_Operations'n 'Percent_skill_Engineering'n
'Percent_skill_Marketing'n 'Percent_skill_Leadership'n 'Percent_skill_Data Science'n 'Percent_skill_Business Strategy'n
'Percent_skill_Product Management'n 'Percent_skill_Sales'n 'Percent_skill_Domain'n 'Percent_skill_Law'n
'Percent_skill_Consulting'n 'Percent_skill_Finance'n 'Percent_skill_Investment'n 'Renown score'n);

format Survival_recession $100.; format Time_investment best32.; format Avgtime_investment best32.; format Gartner $100.;
format Time_maturity $100.; format Percent_Entrepreneurship best32.; format Percent_Operations best32.; format Percent_Engineering best32.;
format Percent_Marketing best32.; format Percent_Leadership best32.; format Percent_Data best32.; format Percent_Business best32.;
format Percent_Product best32.; format Percent_Sales best32.; format Percent_Domain best32.; format Percent_Law best32.;
format Percent_Consulting best32.; format Percent_Finance best32.; format Percent_Investment best32.; format Renown_score best32.;

set rg.CAX_Startup_Data;
Survival_recession = 'Survival through recession, base'n;
Time_investment = input('Time to 1st investment (in month'n, best32.);
Avgtime_investment = input('Avg time to investment - average'n, best32.);
Gartner = 'Gartner hype cycle stage'n;

Time_maturity = 'Time to maturity of technology ('n;
Percent_Entrepreneurship = input('Percent_skill_Entrepreneurship'n, best32.);
Percent_Operations = input('Percent_skill_Operations'n, best32.);
Percent_Engineering = input('Percent_skill_Engineering'n, best32.);

Percent_Marketing = input('Percent_skill_Marketing'n, best32.);
Percent_Leadership = input('Percent_skill_Leadership'n, best32.);
Percent_Data = input('Percent_skill_Data Science'n, best32.);
Percent_Business = input('Percent_skill_Business Strategy'n, best32.);

Percent_Product = input('Percent_skill_Product Management'n, best32.);
Percent_Sales = input('Percent_skill_Sales'n, best32.);
Percent_Domain = input('Percent_skill_Domain'n, best32.);
Percent_Law = input('Percent_skill_Law'n, best32.);

Percent_Consulting = input('Percent_skill_Consulting'n, best32.);
Percent_Finance = input('Percent_skill_Finance'n, best32.);
Percent_Investment = input('Percent_skill_Investment'n, best32.);
Renown_score = input('Renown score'n, best32.);
run;

proc contents data=temp; run;

%macro rg_bin (var);
proc sql;
create table m1 as 
select &var., mean(Status) as &var._bin
from temp
group by &var.;
quit;
proc sql;
create table m2 as 
select a.*, b.&var._bin
from temp as a left join m1 as b
on a.&var. = b.&var.;
quit;
data temp; set m2 (drop=&var.); run;
%mend;
%rg_bin(Survival_recession);
%rg_bin(Time_investment);
%rg_bin(Avgtime_investment);
%rg_bin(Gartner);
%rg_bin(Time_maturity);
%rg_bin(Percent_Entrepreneurship);
%rg_bin(Percent_Operations);
%rg_bin(Percent_Engineering);
%rg_bin(Percent_Marketing);
%rg_bin(Percent_Leadership);
%rg_bin(Percent_Data);
%rg_bin(Percent_Business);
%rg_bin(Percent_Product);
%rg_bin(Percent_Sales);
%rg_bin(Percent_Domain);
%rg_bin(Percent_Law);
%rg_bin(Percent_Consulting);
%rg_bin(Percent_Finance);
%rg_bin(Percent_Investment);
%rg_bin(Renown_score);

data rg.CAX_Startup_Data; set temp; run;
