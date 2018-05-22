options compress=yes;
libname rg '/ccr/ccar_secured/rg83892/in2016ye';

/*data rg.CAX_Startup_Data; set WORK.CAX_Startup_Data; X = 'X'; run;*/
/*proc contents data=rg.CAX_Startup_Data;run;*/

data temp (drop='Number of of repeat investors'n 'Number of  Sales Support materia'n 'Worked in top companies'n 'Average size of companies worked'n
'Have been part of startups in th'n 'Have been part of successful sta'n 'Was he or she partner in Big 5 c'n 'Consulting experience?'n
'Product or service company?'n 'Catering to product/service acro'n 'Focus on private or public data?'n 'Focus on consumer data?'n
'Focus on structured or unstructu'n 'Subscription based business'n 'Cloud or platform based serive/p'n 'Local or global player'n
'Linear or Non-linear business mo'n 'Capital intensive business e.g.'n 'Number of  of Partners of compan'n 'Crowdsourcing based business'n
'Crowdfunding based business'n 'Machine Learning based business'n 'Predictive Analytics business'n 'Speech analytics business'n);

format repeat_investors best32.; format Sales_Support $100.; format part_top $100.; format companies_worked $100.;
format part_startup $100.; format part_successful $100.; format part_big5 $100.; format part_consulting $100.; 
format product_service $100.; format Catering $100.; format private_public $100.; format consumer_data $100.; 
format struct_unstruct $100.; format Subscription_based $100.; format Cloud_platform $100.; format Local_global $100.; 
format linear_nonl $100.; format Capital_intensive $100.; format Partners_company $100.; format Crowdsourcing $100.; 
format Crowdfunding $100.; format Machine_Learning $100.; format Predictive_Analytics $100.; format Speech_analytics $100.; 
set rg.CAX_Startup_Data;

repeat_investors = input('Number of of repeat investors'n,best32.);
Sales_Support = 'Number of  Sales Support materia'n;
part_top = 'Worked in top companies'n;
companies_worked = 'Average size of companies worked'n;

part_startup = 'Have been part of startups in th'n;
part_successful = 'Have been part of successful sta'n;
part_big5 = 'Was he or she partner in Big 5 c'n;
part_consulting = 'Consulting experience?'n;

product_service = 'Product or service company?'n;
Catering = 'Catering to product/service acro'n;
private_public = 'Focus on private or public data?'n;
consumer_data = 'Focus on consumer data?'n;

struct_unstruct = 'Focus on structured or unstructu'n;
Subscription_based = 'Subscription based business'n;
Cloud_platform = 'Cloud or platform based serive/p'n;
Local_global = 'Local or global player'n;

linear_nonl = 'Linear or Non-linear business mo'n;
Capital_intensive = 'Capital intensive business e.g.'n;
Partners_company = 'Number of  of Partners of compan'n;
Crowdsourcing = 'Crowdsourcing based business'n;

Crowdfunding = 'Crowdfunding based business'n;
Machine_Learning = 'Machine Learning based business'n;
Predictive_Analytics = 'Predictive Analytics business'n;
Speech_analytics = 'Speech analytics business'n;
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
%rg_bin(repeat_investors);
%rg_bin(Sales_Support);
%rg_bin(part_top);
%rg_bin(companies_worked);
%rg_bin(part_startup);
%rg_bin(part_successful);
%rg_bin(part_big5);
%rg_bin(part_consulting);
%rg_bin(product_service);
%rg_bin(Catering);
%rg_bin(private_public);
%rg_bin(consumer_data);
%rg_bin(struct_unstruct);
%rg_bin(Subscription_based);
%rg_bin(Cloud_platform);
%rg_bin(Local_global);
%rg_bin(linear_nonl);
%rg_bin(Capital_intensive);
%rg_bin(Partners_company);
%rg_bin(Crowdsourcing);
%rg_bin(Crowdfunding);
%rg_bin(Machine_Learning);
%rg_bin(Predictive_Analytics);
%rg_bin(Speech_analytics);

data rg.CAX_Startup_Data; set temp; run;
