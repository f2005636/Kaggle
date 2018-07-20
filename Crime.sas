libname rg "/ccr/ccar_secured/rg83892";
options compress=yes;

/*raw data preparation*/
/*data rg.crime (drop=DISTRICT); set crime (rename=('STATE/UT'n = Sate)); where compress(DISTRICT) = "TOTAL"; run;*/
/*proc sql; create table rg.census as select 'State name'n as Sate, sum(Population) as Population from census group by Sate; quit;*/
/*data rg.census; set rg.census;*/
/*if Sate = 'ANDAMAN AND NICOBAR ISLANDS' then Sate = 'A & N ISLANDS';if Sate = 'DADRA AND NAGAR HAVELI' then Sate = 'D & N HAVELI';*/
/*if Sate = 'JAMMU AND KASHMIR' then Sate = 'JAMMU & KASHMIR';if Sate = 'DAMAN AND DIU' then Sate = 'DAMAN & DIU';*/
/*if Sate = 'PONDICHERRY' then Sate = 'PUDUCHERRY';if Sate = 'ORISSA' then Sate = 'ODISHA';run;*/
/*proc sql; create table rg.crime as select a.*, b.Population from rg.crime as a left join rg.census as b on a.Sate = b.Sate; quit;*/

/*Preparation of Data*/
proc contents data=rg.crime; run;
data temp1; set rg.crime; run;
data temp1 (drop='CUSTODIAL RAPE'n 'OTHER RAPE'n
'KIDNAPPING & ABDUCTION'n 'KIDNAPPING AND ABDUCTION OF WOME'n 'KIDNAPPING AND ABDUCTION OF OTHE'n
'PREPARATION AND ASSEMBLY FOR DAC'n
'ROBBERY'n 'BURGLARY'n 'AUTO THEFT'n 'OTHER THEFT'n
'CRIMINAL BREACH OF TRUST'n 'COUNTERFIETING'n 'ARSON'n
'HURT/GREVIOUS HURT'n 'ATTEMPT TO MURDER'n 'CULPABLE HOMICIDE NOT AMOUNTING'n
'DOWRY DEATHS'n 'CRUELTY BY HUSBAND OR HIS RELATI'n
'ASSAULT ON WOMEN WITH INTENT TO'n 'INSULT TO MODESTY OF WOMEN'n 'IMPORTATION OF GIRLS FROM FOREIG'n
'CAUSING DEATH BY NEGLIGENCE'n 'OTHER IPC CRIMES'n 'TOTAL IPC CRIMES'n); set temp1;
murder = 'MURDER'n;
rape = sum('RAPE'n, 'CUSTODIAL RAPE'n, 'OTHER RAPE'n);
kidnapping = sum('KIDNAPPING & ABDUCTION'n, 'KIDNAPPING AND ABDUCTION OF WOME'n, 'KIDNAPPING AND ABDUCTION OF OTHE'n);
riots = 'RIOTS'n;
theft = sum('ROBBERY'n, 'BURGLARY'n, 'THEFT'n, 'AUTO THEFT'n, 'OTHER THEFT'n);
cheating = sum('CRIMINAL BREACH OF TRUST'n, 'CHEATING'n, 'COUNTERFIETING'n, 'ARSON'n);
hurt = sum('HURT/GREVIOUS HURT'n,'ATTEMPT TO MURDER'n,'CULPABLE HOMICIDE NOT AMOUNTING'n,'CAUSING DEATH BY NEGLIGENCE'n);
dowry = sum('DOWRY DEATHS'n, 'CRUELTY BY HUSBAND OR HIS RELATI'n);
women = sum('ASSAULT ON WOMEN WITH INTENT TO'n, 'INSULT TO MODESTY OF WOMEN'n, 'IMPORTATION OF GIRLS FROM FOREIG'n);
others = 'OTHER IPC CRIMES'n;
total = sum(murder,rape,kidnapping,riots,theft,cheating,hurt,dowry,women,others);run;
proc sql; create table temp1 as select Sate, avg(murder) as murder, avg(hurt) as hurt, avg(kidnapping) as kidnapping, avg(rape) as rape, avg(dowry) as dowry, avg(women) as women,
avg(cheating) as cheating, avg(theft) as theft, avg(riots) as riots, avg(others) as others, avg(total) as total, avg(population) as population from temp1 group by Sate; quit;

data temp2; set temp1; where Sate not in ('A & N ISLANDS','CHANDIGARH','D & N HAVELI','DAMAN & DIU','LAKSHADWEEP','PUDUCHERRY'); run;

data temp2 (drop=total population); set temp2;
murder=murder/total; hurt=hurt/total; kidnapping=kidnapping/total; rape=rape/total; dowry=dowry/total; women=women/total; cheating=cheating/total; theft=theft/total; riots=riots/total; others=others/total; total=total/total; 
run;