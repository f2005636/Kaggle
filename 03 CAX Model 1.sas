options compress=yes;
libname rg '/ccr/ccar_secured/rg83892/in2016ye';

/*data rg.CAX_Startup_Data; set WORK.CAX_Startup_Data; X = 'X'; run;*/
/*proc contents data=rg.CAX_Startup_Data;run;*/

data temp (drop='Dependent-Company Status'n 'year of founding'n 'Age of company in years'n
'Internet Activity Score'n 'Short Description of company pro'n 'Industry of company'n 'Focus functions of company'n
Investors 'Employee Count'n 'Employees count MoM change'n 'Has the team size grown'n
'Est. Founding Date'n 'Last Funding Date'n 'Last Funding Amount'n 'Country of company'n
'Continent of company'n 'Number of Investors in Seed'n 'Number of Investors in Angel and'n 'Number of Co-founders'n
'Number of of advisors'n 'Team size Senior leadership'n 'Team size all employees'n 'Presence of a top angel or ventu'n);

format Status best32.; format Age_company best32.;
format Internet_Activity  best32.; format Industry_company $100.; format Focus_company $100.;
format Employee_Count best32.; format Employees_MoMchange best32.; format team_size_grown best32.;
format Est_Founding_Date best32.; format Last_Funding_Date best32.; format Last_Funding_Amount best32.; format Country $100.;
format Continent $100.; format Investors_Seed best32.; format Investors_Angel best32.; format Co_founders best32.;
format advisors best32.; format Senior_leadership best32.; format Team_size best32.; format Presence_top best32.;
set rg.CAX_Startup_Data;

if 'Dependent-Company Status'n = 'Success' then Status = 1; else Status = 0;
Age_company = input ('Age of company in years'n,best32.);

Internet_Activity = 'Internet Activity Score'n;
Industry_company = 'Industry of company'n;
Focus_company = 'Focus functions of company'n;
 
Employee_Count = 'Employee Count'n;
Employees_MoMchange = 'Employees count MoM change'n;
if compress(upcase('Has the team size grown'n)) = 'YES' then team_size_grown = 1; else team_size_grown = 0;

Est_Founding_Date = year('Est. Founding Date'n)*100 + month('Est. Founding Date'n);
Last_Funding_Date = year('Last Funding Date'n)*100 + month('Last Funding Date'n);
Last_Funding_Amount = 'Last Funding Amount'n;
Country = 'Country of company'n;

Continent = 'Continent of company'n;
Investors_Seed = input('Number of Investors in Seed'n,best32.);
Investors_Angel = input('Number of Investors in Angel and'n,best32.);
Co_founders = 'Number of Co-founders'n;

advisors = 'Number of of advisors'n;
Senior_leadership = 'Team size Senior leadership'n;
Team_size = input('Team size all employees'n,best32.);
if compress(upcase('Presence of a top angel or ventu'n)) = 'YES' then Presence_top = 1; else Presence_top = 0;
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
proc print data=m1; run;
data temp; set m2 (drop=&var.); run;
%mend;
%rg_bin(Age_company);
%rg_bin(Internet_Activity);
%rg_bin(Industry_company);
%rg_bin(Focus_company);
%rg_bin(Employee_Count);
%rg_bin(Employees_MoMchange);
%rg_bin(team_size_grown);
%rg_bin(Est_Founding_Date);
%rg_bin(Last_Funding_Date);
%rg_bin(Last_Funding_Amount);
%rg_bin(Country);
%rg_bin(Continent);
%rg_bin(Investors_Seed);
%rg_bin(Investors_Angel);
%rg_bin(Co_founders);
%rg_bin(advisors);
%rg_bin(Senior_leadership);
%rg_bin(Team_size);
%rg_bin(Presence_top);

data rg.CAX_Startup_Data; set temp; run;
