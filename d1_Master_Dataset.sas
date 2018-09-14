options compress=yes;
libname inlib "/ccr/ccar_secured/lz65770" access =readonly;
libname outlib "/ccr/ccar_secured/rg83892/us_2017/data";
 
/*Create modeling variables*/
data outlib.PORT_SERV14_NEW; set inlib.PORT_SERV14_NEW (drop = co_borr_ssn); run;
proc contents data =outlib.PORT_SERV14_NEW; run;
data temp1 (rename=(rprt_prd = FILE_DT)
drop= yyyy mm dd 
UNPD_PRIN_BAL_AMT 
loan_type_cd1 coborrower_ind1
);
format ARM_year $50.;
format curr_occ $50.;
format inc_doc $50.;
format loan_purp $50.;
format prop_type $50.;
set outlib.PORT_SERV14_NEW (rename=(
ACCT_NUM_KEY = UNIQ_ID_IN_SRC_SYS
FILE_DT = rprt_prd
OS_BAL = UNPD_PRIN_BAL_AMT
LOAN_ORIG_DT = BookingDate
outcome3 =_final_from_
outcome_3 =_final_to_
ORIG_PRIN_BAL = LN_AMT
LOAN_TYPE_CD=LOAN_TYPE_CD1 
coborrower_ind=coborrower_ind1
));

_final_from_=compress(upcase(_final_from_)); /*Create transitions*/
_final_to_=compress(upcase(_final_to_));
transition_1=compress(upcase(_final_from_)||'_'||upcase(_final_to_));

format obsdate MMDDYY10.; /*Create reporting date variable*/
yyyy=year(rprt_prd);
mm=month(rprt_prd);
dd = 31;
if mm in(4,6,9,11) then dd = 30;
if mm = 2 then dd = 28;
if mm = 2 and yyyy in (2000,2004,2008,2012) then dd = 29;
obsdate = mdy(mm,dd,yyyy);

balance = UNPD_PRIN_BAL_AMT; /*Create loan balance variable*/
if missing(UNPD_PRIN_BAL_AMT) or UNPD_PRIN_BAL_AMT < 0 then balance = 0;

seasoning_days = intck('day',BookingDate,obsdate);
seasoning_mths = intck('month',BookingDate,obsdate);
seasoning_yrs = intck('year',BookingDate,obsdate);

if month(obsdate) = 1 then jan_flag = 1; else jan_flag = 0;
if month(obsdate) = 2 then feb_flag = 1; else feb_flag = 0;
if month(obsdate) = 3 then mar_flag = 1; else mar_flag = 0;
if month(obsdate) = 4 then apr_flag = 1; else apr_flag = 0;
if month(obsdate) = 5 then may_flag = 1; else may_flag = 0;
if month(obsdate) = 6 then jun_flag = 1; else jun_flag = 0;
if month(obsdate) = 7 then jul_flag = 1; else jul_flag = 0;
if month(obsdate) = 8 then aug_flag = 1; else aug_flag = 0;
if month(obsdate) = 9 then sep_flag = 1; else sep_flag = 0;
if month(obsdate) = 10 then oct_flag = 1; else oct_flag = 0;
if month(obsdate) = 11 then nov_flag = 1; else nov_flag = 0;
if month(obsdate) = 12 then dec_flag = 1; else dec_flag = 0;

booking_yr=year(BookingDate); /*year of the booking date*/

LOAN_TYPE_CD=put(compress(LOAN_TYPE_CD1),8.);
coborrower_ind=put(compress(coborrower_ind1),8.);

 if ARM_TYPE_YEAR in('0MO','1MO','3MO','6MO','1YR') then ARM_year='<=1 yr';
 else if ARM_TYPE_YEAR in('2YR','3YR') then ARM_year='2-3 Yr';
 else if ARM_TYPE_YEAR in('5YR') then ARM_year='5 Yr';
 else if ARM_TYPE_YEAR in('7YR','10YR') then ARM_year='7-10Yr';
 else ARM_year='Fixed';

 if CURR_OCC_TYPE_CD in ('OO','1','2') then curr_occ='OwnerOcc';
 else if CURR_OCC_TYPE_CD in ('T','IV','3') then curr_occ='Rent-IV';
 else if CURR_OCC_TYPE_CD in ('V','4','5') then curr_occ='Vacant';
 else if CURR_OCC_TYPE_CD in ('O','','0','U','7') then curr_occ='Unknown';
 else curr_occ='Miss';

 If INCOME_DOC_CD in('CSTD','FULL') then Inc_doc='Full';
 else if INCOME_DOC_CD in('LITE','T1','T2','BKS','BKST') then Inc_doc='Lite';
 else if INCOME_DOC_CD in('NIQ','SISA','SIVA','VISA','NIVA','NINA','MVI') then Inc_doc='Part';
 else if INCOME_DOC_CD in('') then inc_doc='Miss';
 else inc_doc='Miss';

 if LOAN_PURP_CD='CASHO' then loan_purp='Cashout';
 else if LOAN_PURP_CD='PURCH' then loan_purp='Purchas';
 else if LOAN_PURP_CD in('RATET','REFIN') then loan_purp='Refin';
 else loan_purp='Other';

 if prop_type_cd in('2FAM','3FAM','4FAM') then prop_type='Multi ';
 else if prop_type_cd in('COOP') then prop_type='Coop ';
 else if prop_type_cd in('COND') then prop_type='Condo ';
 else if prop_type_cd in('SFR') then prop_type='Single';
 else prop_type='Other ';
run;

/*Normalize the loan size by the average loan size in the year of booking*/
proc sort data=temp1; by booking_yr; run;
proc summary data=temp1;
by booking_yr;
var LN_AMT;
output out=yr_avg_loan_size (drop=_type_ rename=(_freq_=nbooked)) mean=avg_booking_amt;
run;
proc sql;
create table temp2 as
select a.*,b.avg_booking_amt,a.LN_AMT/b.avg_booking_amt as nrml_LN_AMT
from temp1 a left join yr_avg_loan_size b
on a.booking_yr=b.booking_yr;
quit;

/*check for dublicate observations*/
proc sort nodup data=temp2 out=temp3 ;
by _all_;
run;

/* create master data with all buckets */
data outlib.Main_data_loan;
set temp3;
where exclude eq 0; /*to keep only exclude = 0 rows*/
run;
proc sql; select transition_1, _final_from_, _final_to_, count(UNIQ_ID_IN_SRC_SYS) as cnt
from outlib.Main_data_loan
group by transition_1, _final_from_, _final_to_;
quit;

proc freq data=outlib.Main_data_loan;
tables _final_to_;
run;
data outlib.Main_data_time_series;
set outlib.Main_data_loan;
if _final_to_ in ('90','120','150','180','PO') then target = 1;
else target = 0;
run;
proc freq data=outlib.Main_data_time_series;
tables target;
run;