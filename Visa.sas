libname rg "/ccr/ccar_secured/rg83892";
options compress=yes;

/*raw data preparation*/
/*data rg.visa; set visa; run;*/

/*Preparation of Data*/
data temp; set rg.visa; run;

data temp1 (drop='MISSION'n 'VISA ISSUE DATE'n 'TOURIST VISA'n 'STUDENT VISA'n 'MEDICAL VISA'n 'MEDICAL ATTENDENT VISA'n 
'BUSINESS VISA'n 'BUS VISA INDSPOUSE'n 'BUSINESS VISA TRANSFER'n 'CONFERENCE VISA'n 
'EMPLOYMENT VISA'n 'EMPLOYMENT VISA INDSPOUSE'n 'DIPLOMATIC VISA'n 'DIPLOMATIC DEPENDANT VISA'n 
'ENTRY VISA'n 'MISSIONARY VISA'n 'PILGRIMAGE VISA'n 'RESEARCH VISA'n 'PROJECT VISA'n 'TRANSIT VISA'n 'VISIT VISA'n 'ART SURROGACY'n 'LONG TERM VISA TRANSFER'n ); 
set rg.visa; issue_month = input(substr('VISA ISSUE DATE'n,4,2),2.);
business = sum('BUSINESS VISA'n ,'BUS VISA INDSPOUSE'n ,'BUSINESS VISA TRANSFER'n ,'CONFERENCE VISA'n );
diplomatic = sum('DIPLOMATIC VISA'n ,'DIPLOMATIC DEPENDANT VISA'n );
employment = sum('EMPLOYMENT VISA'n ,'EMPLOYMENT VISA INDSPOUSE'n );
student = 'STUDENT VISA'n;
tourist = 'TOURIST VISA'n ;
visit = sum('VISIT VISA'n);
others = sum('ENTRY VISA'n ,'MEDICAL VISA'n ,'MEDICAL ATTENDENT VISA'n ,'MISSIONARY VISA'n ,'PILGRIMAGE VISA'n ,'RESEARCH VISA'n ,'PROJECT VISA'n ,'TRANSIT VISA'n ,'ART SURROGACY'n ,'LONG TERM VISA TRANSFER'n );
work = sum(business,employment);
others = sum(others,diplomatic,visit);
total = sum(tourist,business,visit,others,employment,student,diplomatic);
run;

proc sql; create table temp2 as 
select COUNTRY, issue_month, sum(student) as student, sum(tourist) as tourist, sum(work) as work,  sum(others) as others, sum(total) as total
from temp1 group by COUNTRY, issue_month; quit;

data temp3; set temp2;
where COUNTRY not in ('BELARUS','IVORY COST','JORDAN','TRINIDAD AND TOBAGO','TANZANIA','UGANDA',
'ICELAND','INDIA','KUWAIT','LATVIA','PALESTINIAN','SERBIA','ARMENIA','SLOVAK REPUBLIC','VENEZUELA',
'AZERBAIJAN','BULGARIA','CHILE','SAUDI ARABIA','UZBEKISTAN','MYANMAR','ROMANIA','UKRAINE'); run;

/*By visa type*/
proc sql; create table visa_type as 
select sum(student) as student, sum(tourist) as tourist, sum(work) as work,  sum(others) as others
from temp3; quit;

/*By country*/
proc sql; create table country as 
select COUNTRY, sum(total) as total
from temp3 group by COUNTRY; quit;

/*By month*/
proc sql; create table count_month as 
select issue_month, sum(total) as total
from temp3 group by issue_month; quit;

/*10 countries*/
%macro rg_cnt (var);
proc sql; select sum(others) / sum(total) as others, sum(student) / sum(total) as student, sum(work) / sum(total) as work, sum(tourist) / sum(total) as tourist
from temp3 where COUNTRY = "&var."; quit;
%mend;
%rg_cnt(BANGLADESH);
%rg_cnt(UNITED KINGDOM);
%rg_cnt(UNITED STATES OF AMERICA);
%rg_cnt(RUSSIAN FEDERATION);
%rg_cnt(GERMANY);
%rg_cnt(SRI LANKA);
%rg_cnt(MALAYSIA);
%rg_cnt(FRANCE);
%rg_cnt(CHINA);
%rg_cnt(JAPAN);

