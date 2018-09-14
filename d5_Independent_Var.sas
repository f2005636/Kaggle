options compress=yes;
libname outlib "/ccr/ccar_secured/rg83892/us_2017/data";

proc sort data= outlib.i2_base nodup; by Mnemonics; run;
proc sort data= outlib.i3_adverse nodup; by Mnemonics; run;

data outlib.macro_b (keep=obsdate US_LBR_M US_RHPI_M);
set outlib.macro_us outlib.i2_base (rename=(Mnemonics = obsdate));
where obsdate ^= .;
run;

data outlib.macro_a (keep=obsdate US_LBR_M US_RHPI_M);
set outlib.macro_us outlib.i3_adverse (rename=(Mnemonics = obsdate));
where obsdate ^= .;
run;

proc sort data= outlib.macro_b nodup; by obsdate; run;
proc sort data= outlib.macro_a nodup; by obsdate; run;

/*This code is to conduct macro variable transformation*/
%macro MacroVar(dfMacro, MacroVar);
data &dfMacro(drop=lag3&MacroVar lag12&MacroVar s k temp1 temp2);
retain s k;
set outlib.macro_b;

lag3&MacroVar=lag3(&MacroVar); /*create macro variable transformation and lags*/
lag12&MacroVar=lag12(&MacroVar);
format Dqoq_&MacroVar best12.;
if missing(lag3&MacroVar) or missing(&MacroVar) then Dqoq_&MacroVar='.';
else Dqoq_&MacroVar=&MacroVar-lag3&MacroVar;
format Pctqoq_&MacroVar best12.;
Pctqoq_&MacroVar=Dqoq_&MacroVar/lag3&MacroVar;
format Pctyoy_&MacroVar best12.;
if missing(lag12&MacroVar) or missing(&MacroVar) then Pctyoy_&MacroVar='.';
else Pctyoy_&MacroVar=(&MacroVar-lag12&MacroVar)/lag12&MacroVar;

s = sum (s, &MacroVar, -lag120(&MacroVar)) ; /*create moving average*/
k = sum (k, &MacroVar, -lag3(&MacroVar)) ;
temp1 = s / 120;
temp2 = k / 3;
D10YrAvg_&MacroVar = &MacroVar - lag(temp1);
D3MonMavg_&MacroVar = temp2 - lag(temp2);
run;

proc sort data=&dfMacro;by obsdate; run;

data &dfMacro;
set &dfMacro;
/*lagN1_&MacroVar=lag(&MacroVar);*/
/*lagN2_&MacroVar=lag2(&MacroVar);*/
lagN3_&MacroVar=lag3(&MacroVar);
/*lagN4_&MacroVar=lag4(&MacroVar);*/
/*lagN5_&MacroVar=lag5(&MacroVar);*/
lagN6_&MacroVar=lag6(&MacroVar);
/*lagN7_&MacroVar=lag7(&MacroVar);*/
/*lagN8_&MacroVar=lag8(&MacroVar);*/
lagN9_&MacroVar=lag9(&MacroVar);
/*lagN10_&MacroVar=lag10(&MacroVar);*/
/*lagN11_&MacroVar=lag11(&MacroVar);*/
lagN12_&MacroVar=lag12(&MacroVar);

/*lagN1_Pctqoq_&MacroVar=lag1(Pctqoq_&MacroVar);*/
/*lagN2_Pctqoq_&MacroVar=lag2(Pctqoq_&MacroVar);*/
lagN3_Pctqoq_&MacroVar=lag3(Pctqoq_&MacroVar);
/*lagN4_Pctqoq_&MacroVar=lag4(Pctqoq_&MacroVar);*/
/*lagN5_Pctqoq_&MacroVar=lag5(Pctqoq_&MacroVar);*/
lagN6_Pctqoq_&MacroVar=lag6(Pctqoq_&MacroVar);
/*lagN7_Pctqoq_&MacroVar=lag7(Pctqoq_&MacroVar);*/
/*lagN8_Pctqoq_&MacroVar=lag8(Pctqoq_&MacroVar);*/
lagN9_Pctqoq_&MacroVar=lag9(Pctqoq_&MacroVar);
/*lagN10_Pctqoq_&MacroVar=lag10(Pctqoq_&MacroVar);*/
/*lagN11_Pctqoq_&MacroVar=lag11(Pctqoq_&MacroVar);*/
lagN12_Pctqoq_&MacroVar=lag12(Pctqoq_&MacroVar);

/*lagN1_Pctyoy_&MacroVar=lag1(Pctyoy_&MacroVar);*/
/*lagN2_Pctyoy_&MacroVar=lag2(Pctyoy_&MacroVar);*/
lagN3_Pctyoy_&MacroVar=lag3(Pctyoy_&MacroVar);
/*lagN4_Pctyoy_&MacroVar=lag4(Pctyoy_&MacroVar);*/
/*lagN5_Pctyoy_&MacroVar=lag5(Pctyoy_&MacroVar);*/
lagN6_Pctyoy_&MacroVar=lag6(Pctyoy_&MacroVar);
/*lagN7_Pctyoy_&MacroVar=lag7(Pctyoy_&MacroVar);*/
/*lagN8_Pctyoy_&MacroVar=lag8(Pctyoy_&MacroVar);*/
lagN9_Pctyoy_&MacroVar=lag9(Pctyoy_&MacroVar);
/*lagN10_Pctyoy_&MacroVar=lag10(Pctyoy_&MacroVar);*/
/*lagN11_Pctyoy_&MacroVar=lag11(Pctyoy_&MacroVar);*/
lagN12_Pctyoy_&MacroVar=lag12(Pctyoy_&MacroVar);
run;
%mend;

%MacroVar(US_LBR_M,US_LBR_M);
%MacroVar(US_RHPI_M,US_RHPI_M);

proc sql;
create table outlib.macro_b as 
select a.*, k.*, o.*
from outlib.macro_b as a
left join US_LBR_M as k on a.obsdate = k.obsdate
left join US_RHPI_M as o on a.obsdate = o.obsdate;
quit;


/*This code is to conduct macro variable transformation*/
%macro MacroVar(dfMacro, MacroVar);
data &dfMacro(drop=lag3&MacroVar lag12&MacroVar s k temp1 temp2);
retain s k;
set outlib.macro_a;

lag3&MacroVar=lag3(&MacroVar); /*create macro variable transformation and lags*/
lag12&MacroVar=lag12(&MacroVar);
format Dqoq_&MacroVar best12.;
if missing(lag3&MacroVar) or missing(&MacroVar) then Dqoq_&MacroVar='.';
else Dqoq_&MacroVar=&MacroVar-lag3&MacroVar;
format Pctqoq_&MacroVar best12.;
Pctqoq_&MacroVar=Dqoq_&MacroVar/lag3&MacroVar;
format Pctyoy_&MacroVar best12.;
if missing(lag12&MacroVar) or missing(&MacroVar) then Pctyoy_&MacroVar='.';
else Pctyoy_&MacroVar=(&MacroVar-lag12&MacroVar)/lag12&MacroVar;

s = sum (s, &MacroVar, -lag120(&MacroVar)) ; /*create moving average*/
k = sum (k, &MacroVar, -lag3(&MacroVar)) ;
temp1 = s / 120;
temp2 = k / 3;
D10YrAvg_&MacroVar = &MacroVar - lag(temp1);
D3MonMavg_&MacroVar = temp2 - lag(temp2);
run;

proc sort data=&dfMacro;by obsdate; run;

data &dfMacro;
set &dfMacro;
/*lagN1_&MacroVar=lag(&MacroVar);*/
/*lagN2_&MacroVar=lag2(&MacroVar);*/
lagN3_&MacroVar=lag3(&MacroVar);
/*lagN4_&MacroVar=lag4(&MacroVar);*/
/*lagN5_&MacroVar=lag5(&MacroVar);*/
lagN6_&MacroVar=lag6(&MacroVar);
/*lagN7_&MacroVar=lag7(&MacroVar);*/
/*lagN8_&MacroVar=lag8(&MacroVar);*/
lagN9_&MacroVar=lag9(&MacroVar);
/*lagN10_&MacroVar=lag10(&MacroVar);*/
/*lagN11_&MacroVar=lag11(&MacroVar);*/
lagN12_&MacroVar=lag12(&MacroVar);

/*lagN1_Pctqoq_&MacroVar=lag1(Pctqoq_&MacroVar);*/
/*lagN2_Pctqoq_&MacroVar=lag2(Pctqoq_&MacroVar);*/
lagN3_Pctqoq_&MacroVar=lag3(Pctqoq_&MacroVar);
/*lagN4_Pctqoq_&MacroVar=lag4(Pctqoq_&MacroVar);*/
/*lagN5_Pctqoq_&MacroVar=lag5(Pctqoq_&MacroVar);*/
lagN6_Pctqoq_&MacroVar=lag6(Pctqoq_&MacroVar);
/*lagN7_Pctqoq_&MacroVar=lag7(Pctqoq_&MacroVar);*/
/*lagN8_Pctqoq_&MacroVar=lag8(Pctqoq_&MacroVar);*/
lagN9_Pctqoq_&MacroVar=lag9(Pctqoq_&MacroVar);
/*lagN10_Pctqoq_&MacroVar=lag10(Pctqoq_&MacroVar);*/
/*lagN11_Pctqoq_&MacroVar=lag11(Pctqoq_&MacroVar);*/
lagN12_Pctqoq_&MacroVar=lag12(Pctqoq_&MacroVar);

/*lagN1_Pctyoy_&MacroVar=lag1(Pctyoy_&MacroVar);*/
/*lagN2_Pctyoy_&MacroVar=lag2(Pctyoy_&MacroVar);*/
lagN3_Pctyoy_&MacroVar=lag3(Pctyoy_&MacroVar);
/*lagN4_Pctyoy_&MacroVar=lag4(Pctyoy_&MacroVar);*/
/*lagN5_Pctyoy_&MacroVar=lag5(Pctyoy_&MacroVar);*/
lagN6_Pctyoy_&MacroVar=lag6(Pctyoy_&MacroVar);
/*lagN7_Pctyoy_&MacroVar=lag7(Pctyoy_&MacroVar);*/
/*lagN8_Pctyoy_&MacroVar=lag8(Pctyoy_&MacroVar);*/
lagN9_Pctyoy_&MacroVar=lag9(Pctyoy_&MacroVar);
/*lagN10_Pctyoy_&MacroVar=lag10(Pctyoy_&MacroVar);*/
/*lagN11_Pctyoy_&MacroVar=lag11(Pctyoy_&MacroVar);*/
lagN12_Pctyoy_&MacroVar=lag12(Pctyoy_&MacroVar);
run;
%mend;

%MacroVar(US_LBR_M,US_LBR_M);
%MacroVar(US_RHPI_M,US_RHPI_M);

proc sql;
create table outlib.macro_a as 
select a.*, k.*, o.*
from outlib.macro_a as a
left join US_LBR_M as k on a.obsdate = k.obsdate
left join US_RHPI_M as o on a.obsdate = o.obsdate;
quit;
