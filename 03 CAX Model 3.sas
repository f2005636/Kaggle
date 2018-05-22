options compress=yes;
libname rg '/ccr/ccar_secured/rg83892/in2016ye';

/*data rg.CAX_Startup_Data; set WORK.CAX_Startup_Data; X = 'X'; run;*/
/*proc contents data=rg.CAX_Startup_Data;run;*/

data temp (drop='Prescriptive analytics business'n 'Big Data Business'n 'Cross-Channel Analytics/ marketi'n 'Owns data or not? (monetization'n
'Is the company an aggregator/mar'n 'Online or offline venture - phys'n 'B2C or B2B venture?'n 'Top forums like ''Tech crunch'' or'n
'Average Years of experience for'n 'Exposure across the globe'n 'Breadth of experience across ver'n 'Highest education'n
'Years of education'n 'Specialization of highest educat'n 'Relevance of education to ventur'n 'Relevance of experience to ventu'n
'Degree from a Tier 1 or Tier 2 u'n 'Renowned in professional circle'n 'Experience in selling and buildi'n 'Experience in Fortune 100 organi'n
'Experience in Fortune 500 organi'n 'Experience in Fortune 1000 organ'n 'Top management similarity'n 'Number of Recognitions for Found'n);

format Prescriptive_analytics $100.; format Big_Data $100.; format Cross_Analytics $100.; format Owns_data $100.;
format aggregator $100.; format Online_offline $100.; format B2C_B2B $100.; format Top_forums $100.;
format Years_experience $100.; format Exposure $100.; format Breadth $100.; format Highest_education $100.;
format Years_education best32.; format Specialization $100.; format Relevance_education $100.; format Relevance_experience $100.; 
format Degree_T1T2 $100.; format Renowned best32.; format selling_building $100.; format Fortune_100 best32.; 
format Fortune_500 best32.; format Fortune_1000 best32.; format similarity $100.; format Recognitions best32.; 
set rg.CAX_Startup_Data;

Prescriptive_analytics = 'Prescriptive analytics business'n;
Big_Data = 'Big Data Business'n;
Cross_Analytics = 'Cross-Channel Analytics/ marketi'n;
Owns_data = 'Owns data or not? (monetization'n;

aggregator = 'Is the company an aggregator/mar'n;
Online_offline = 'Online or offline venture - phys'n;
B2C_B2B = 'B2C or B2B venture?'n;
Top_forums = 'Top forums like ''Tech crunch'' or'n;

Years_experience = 'Average Years of experience for'n;
Exposure = 'Exposure across the globe'n;
Breadth = 'Breadth of experience across ver'n;
Highest_education = 'Highest education'n;

Years_education = input('Years of education'n, best32.);
Specialization = 'Specialization of highest educat'n;
Relevance_education = 'Relevance of education to ventur'n;
Relevance_experience = 'Relevance of experience to ventu'n;

Degree_T1T2 = 'Degree from a Tier 1 or Tier 2 u'n;
Renowned = input('Renowned in professional circle'n, best32.);
selling_building = 'Experience in selling and buildi'n;
Fortune_100 = input('Experience in Fortune 100 organi'n, best32.);

Fortune_500 = input('Experience in Fortune 500 organi'n, best32.);
Fortune_1000 = input('Experience in Fortune 1000 organ'n, best32.);
similarity = 'Top management similarity'n;
Recognitions = input('Number of Recognitions for Found'n, best32.);
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
%rg_bin(Prescriptive_analytics);
%rg_bin(Big_Data);
%rg_bin(Cross_Analytics);
%rg_bin(Owns_data);
%rg_bin(aggregator);
%rg_bin(Online_offline);
%rg_bin(B2C_B2B);
%rg_bin(Top_forums);
%rg_bin(Years_experience);
%rg_bin(Exposure);
%rg_bin(Breadth);
%rg_bin(Highest_education);
%rg_bin(Years_education);
%rg_bin(Specialization);
%rg_bin(Relevance_education);
%rg_bin(Relevance_experience);
%rg_bin(Degree_T1T2);
%rg_bin(Renowned);
%rg_bin(selling_building);
%rg_bin(Fortune_100);
%rg_bin(Fortune_500);
%rg_bin(Fortune_1000);
%rg_bin(similarity);
%rg_bin(Recognitions);

data rg.CAX_Startup_Data; set temp; run;
