libname rg "/ccr/ccar_secured/rg83892";
options compress=yes;

/*raw data preparation*/
/*data rg.bollywood; set bollywood; run;*/
proc contents data=rg.bollywood; run;
proc freq data=rg.bollywood; tables hitFlop; run;

/*A: rating*/
/*D: imdbId and releaseYear*/
data temp1 (drop=imdbId releaseYear); set rg.bollywood;
if hitFlop in (1,2) then rating = exp(1); /*FLOP*/
else if hitFlop in (3,4,5,6) then rating = exp(2); /*AVG*/
else if hitFlop in (7,8,9) then rating = exp(3); /*HIT*/
else rating = 0; run;
proc freq data=temp1; tables rating; run;

/*A: releaseYear releaseMonth */
/*D: releaseDate and writers*/
data temp2 (drop= releaseDate writers tempMonth); set temp1 (where=(releaseDate ^= 'N/A')); 
releaseYear = input(substr(releaseDate,8),4.);
tempMonth = substr(releaseDate,4,3);
if tempMonth = 'Jan' then m_Jan=1; else m_Jan=0;
if tempMonth = 'Feb' then m_Feb=1; else m_Feb=0;
if tempMonth = 'Mar' then m_Mar=1; else m_Mar=0;
if tempMonth = 'Apr' then m_Apr=1; else m_Apr=0;
if tempMonth = 'May' then m_May=1; else m_May=0;
if tempMonth = 'Jun' then m_Jun=1; else m_Jun=0;
if tempMonth = 'Jul' then m_Jul=1; else m_Jul=0;
if tempMonth = 'Aug' then m_Aug=1; else m_Aug=0;
if tempMonth = 'Sep' then m_Sep=1; else m_Sep=0;
if tempMonth = 'Oct' then m_Oct=1; else m_Oct=0;
if tempMonth = 'Nov' then m_Nov=1; else m_Nov=0;
if tempMonth = 'Dec' then m_Dec=1; else m_Dec=0;
if tempMonth = 'Jan' then releaseMonth = 1;
else if tempMonth = 'Feb' then releaseMonth = 2;
else if tempMonth = 'Mar' then releaseMonth = 3;
else if tempMonth = 'Apr' then releaseMonth = 4;
else if tempMonth = 'May' then releaseMonth = 5;
else if tempMonth = 'Jun' then releaseMonth = 6;
else if tempMonth = 'Jul' then releaseMonth = 7;
else if tempMonth = 'Aug' then releaseMonth = 8;
else if tempMonth = 'Sep' then releaseMonth = 9;
else if tempMonth = 'Oct' then releaseMonth = 10;
else if tempMonth = 'Nov' then releaseMonth = 11;
else if tempMonth = 'Dec' then releaseMonth = 12;
else releaseMonth = 0; run;

proc sort data=temp2; by releaseYear releaseMonth hitFlop; run;
proc freq data=temp2; tables releaseYear; run; 
proc freq data=temp2; tables releaseMonth; run; 

proc sql; select releaseYear, rating, count(*) as cnt from temp2 group by releaseYear, rating; quit;
proc sql; select releaseMonth, rating, count(*) as cnt from temp2 group by releaseMonth, rating; quit;

proc reg data=temp2; model rating = m_Jan m_Feb m_Mar m_Oct; run;
proc reg data=temp2; model rating = m_Jul m_Dec; run;

/*genre*/
data temp3;
set temp2; g_others=0;
if findw(compress(lowcase(genre)),'action') then g_action=1; else g_action=0;
if findw(compress(lowcase(genre)),'adventure') then g_adventure=1; else g_adventure=0;
if findw(compress(lowcase(genre)),'biography') then g_others=1; 
if findw(compress(lowcase(genre)),'comedy') then g_comedy=1; else g_comedy=0;
if findw(compress(lowcase(genre)),'crime') then g_crime=1; else g_crime=0;
if findw(compress(lowcase(genre)),'drama') then g_drama=1; else g_drama=0;
if findw(compress(lowcase(genre)),'family') then g_family=1; else g_family=0;
if findw(compress(lowcase(genre)),'fantasy') then g_others=1; 
if findw(compress(lowcase(genre)),'history') then g_others=1; 
if findw(compress(lowcase(genre)),'horror') then g_horror=1; else g_horror=0;
if findw(compress(lowcase(genre)),'music') then g_others=1; 
if findw(compress(lowcase(genre)),'musical') then g_musical=1; else g_musical=0;
if findw(compress(lowcase(genre)),'mystery') then g_mystery=1; else g_mystery=0;
if findw(compress(lowcase(genre)),'romance') then g_romance=1; else g_romance=0;
if findw(compress(lowcase(genre)),'sci-fi') then g_others=1; 
if findw(compress(lowcase(genre)),'sport') then g_others=1; 
if findw(compress(lowcase(genre)),'thriller') then g_thriller=1; else g_thriller=0;
if findw(compress(lowcase(genre)),'war') then g_others=1; 
if findw(compress(lowcase(genre)),'western') then g_others=1; 
if findw(compress(lowcase(genre)),'animation') then g_others=1; 
if findw(compress(lowcase(genre)),'documentary') then g_others=1; 
if findw(compress(lowcase(genre)),'n/a') then g_others=1; 
if findw(compress(lowcase(genre)),'short') then g_others=1; run;

proc sql; select sum(g_action) as g_action, sum(g_adventure) as g_adventure, sum(g_comedy) as g_comedy, sum(g_crime) as g_crime, sum(g_drama) as g_drama,
sum(g_family) as g_family, sum(g_horror) as g_horror, sum(g_musical) as g_musical, sum(g_mystery) as g_mystery, sum(g_romance) as g_romance, sum(g_thriller) as g_thriller, 
sum(g_others) as g_others from temp3; quit;

data temp; set _null_; run;
%macro bin(var);
proc sql; create table temp4 as select &var., rating, count(*) as cnt from temp3 where &var. = 1 group by &var., rating ; quit;
data temp4; format var $20.; set temp4; var = "&var."; run;
data temp; set temp temp4; run;
%mend;
%bin(g_drama);
%bin(g_comedy);
%bin(g_romance);
%bin(g_action);
%bin(g_crime);
%bin(g_thriller);
%bin(g_others);
%bin(g_musical);
%bin(g_mystery);
%bin(g_adventure);
%bin(g_horror);
%bin(g_family);

proc reg data=temp3; model rating = g_comedy g_romance g_action g_musical; run;

/*directors*/
data temp4; set temp3; 
if findw(compress(lowcase(directors)),'priyadarshan') then d_priyadarshan=1; else d_priyadarshan=0;
if findw(compress(lowcase(directors)),'ramgopalvarma') then d_ramgopalvarma=1; else d_ramgopalvarma=0;
if findw(compress(lowcase(directors)),'vikrambhatt') then d_vikrambhatt=1; else d_vikrambhatt=0;
if findw(compress(lowcase(directors)),'daviddhawan') then d_daviddhawan=1; else d_daviddhawan=0;
if findw(compress(lowcase(directors)),'abbasalibhaiburmawalla') then d_abbasalibhaiburmawalla=1; else d_abbasalibhaiburmawalla=0;
if findw(compress(lowcase(directors)),'madhurbhandarkar') then d_madhurbhandarkar=1; else d_madhurbhandarkar=0;
if findw(compress(lowcase(directors)),'mastanalibhaiburmawalla') then d_mastanalibhaiburmawalla=1; else d_mastanalibhaiburmawalla=0;
if findw(compress(lowcase(directors)),'rohitshetty') then d_rohitshetty=1; else d_rohitshetty=0;
if findw(compress(lowcase(directors)),'maheshmanjrekar') then d_maheshmanjrekar=1; else d_maheshmanjrekar=0;
if findw(compress(lowcase(directors)),'satishkaushik') then d_satishkaushik=1; else d_satishkaushik=0;
if findw(compress(lowcase(directors)),'anantmahadevan') then d_anantmahadevan=1; else d_anantmahadevan=0;
if findw(compress(lowcase(directors)),'anuragbasu') then d_anuragbasu=1; else d_anuragbasu=0;
if findw(compress(lowcase(directors)),'anuragkashyap') then d_anuragkashyap=1; else d_anuragkashyap=0;
if findw(compress(lowcase(directors)),'mohitsuri') then d_mohitsuri=1; else d_mohitsuri=0;
if findw(compress(lowcase(directors)),'nageshkukunoor') then d_nageshkukunoor=1; else d_nageshkukunoor=0; run;

proc sql; select sum(d_priyadarshan) as d_priyadarshan, sum(d_ramgopalvarma) as d_ramgopalvarma, sum(d_vikrambhatt) as d_vikrambhatt, sum(d_daviddhawan) as d_daviddhawan,
sum(d_abbasalibhaiburmawalla) as d_abbasalibhaiburmawalla, sum(d_madhurbhandarkar) as d_madhurbhandarkar, sum(d_mastanalibhaiburmawalla) as d_mastanalibhaiburmawalla, sum(d_rohitshetty) as d_rohitshetty,
sum(d_maheshmanjrekar) as d_maheshmanjrekar, sum(d_satishkaushik) as d_satishkaushik, sum(d_anantmahadevan) as d_anantmahadevan, sum(d_anuragbasu) as d_anuragbasu,
sum(d_anuragkashyap) as d_anuragkashyap, sum(d_mohitsuri) as d_mohitsuri, sum(d_nageshkukunoor) as d_nageshkukunoor from temp4; quit;

data temp; set _null_; run;
%macro bin(var);
proc sql; create table temp5 as select &var., rating, count(*) as cnt from temp4 where &var. = 1 group by &var., rating ; quit;
data temp5; format var $20.; set temp5; var = "&var."; run;
data temp; set temp temp5; run;
%mend;
%bin(d_priyadarshan);
%bin(d_ramgopalvarma);
%bin(d_vikrambhatt);
%bin(d_daviddhawan);
%bin(d_abbasalibhaiburmawalla);
%bin(d_madhurbhandarkar);
%bin(d_mastanalibhaiburmawalla);
%bin(d_rohitshetty);
%bin(d_maheshmanjrekar);
%bin(d_satishkaushik);
%bin(d_anantmahadevan);
%bin(d_anuragbasu);
%bin(d_anuragkashyap);
%bin(d_mohitsuri);
%bin(d_nageshkukunoor);

proc reg data=temp4; model rating = d_priyadarshan d_daviddhawan d_rohitshetty d_mohitsuri d_anuragbasu; run;

/*actors*/
data temp5; set temp4;
if findw(compress(lowcase(actors)),'akshaykumar') then a_akshaykumar=1; else a_akshaykumar=0;
if findw(compress(lowcase(actors)),'ajaydevgn') then a_ajaydevgn=1; else a_ajaydevgn=0;
if findw(compress(lowcase(actors)),'amitabhbachchan') then a_amitabhbachchan=1; else a_amitabhbachchan=0;
if findw(compress(lowcase(actors)),'sanjaydutt') then a_sanjaydutt=1; else a_sanjaydutt=0;
if findw(compress(lowcase(actors)),'sunilshetty') then a_sunilshetty=1; else a_sunilshetty=0;
if findw(compress(lowcase(actors)),'anupamkher') then a_anupamkher=1; else a_anupamkher=0;
if findw(compress(lowcase(actors)),'kareenakapoor') then a_kareenakapoor=1; else a_kareenakapoor=0;
if findw(compress(lowcase(actors)),'priyankachopra') then a_priyankachopra=1; else a_priyankachopra=0;
if findw(compress(lowcase(actors)),'salmankhan') then a_salmankhan=1; else a_salmankhan=0;
if findw(compress(lowcase(actors)),'bipashabasu') then a_bipashabasu=1; else a_bipashabasu=0;
if findw(compress(lowcase(actors)),'abhishekbachchan') then a_abhishekbachchan=1; else a_abhishekbachchan=0;
if findw(compress(lowcase(actors)),'gulshangrover') then a_gulshangrover=1; else a_gulshangrover=0;
if findw(compress(lowcase(actors)),'ompuri') then a_ompuri=1; else a_ompuri=0;
if findw(compress(lowcase(actors)),'pareshrawal') then a_pareshrawal=1; else a_pareshrawal=0;
if findw(compress(lowcase(actors)),'ranimukerji') then a_ranimukerji=1; else a_ranimukerji=0;
if findw(compress(lowcase(actors)),'saifalikhan') then a_saifalikhan=1; else a_saifalikhan=0;
if findw(compress(lowcase(actors)),'emraanhashmi') then a_emraanhashmi=1; else a_emraanhashmi=0;
if findw(compress(lowcase(actors)),'johnabraham') then a_johnabraham=1; else a_johnabraham=0;
if findw(compress(lowcase(actors)),'jackieshroff') then a_jackieshroff=1; else a_jackieshroff=0;
if findw(compress(lowcase(actors)),'sunnydeol') then a_sunnydeol=1; else a_sunnydeol=0;
if findw(compress(lowcase(actors)),'arjunrampal') then a_arjunrampal=1; else a_arjunrampal=0;
if findw(compress(lowcase(actors)),'bobbydeol') then a_bobbydeol=1; else a_bobbydeol=0;
if findw(compress(lowcase(actors)),'shahidkapoor') then a_shahidkapoor=1; else a_shahidkapoor=0;
if findw(compress(lowcase(actors)),'mithunchakraborty') then a_mithunchakraborty=1; else a_mithunchakraborty=0;
if findw(compress(lowcase(actors)),'shahrukhkhan') then a_shahrukhkhan=1; else a_shahrukhkhan=0;
if findw(compress(lowcase(actors)),'aftabshivdasani') then a_aftabshivdasani=1; else a_aftabshivdasani=0;
if findw(compress(lowcase(actors)),'arshadwarsi') then a_arshadwarsi=1; else a_arshadwarsi=0;
if findw(compress(lowcase(actors)),'kaykaymenon') then a_kaykaymenon=1; else a_kaykaymenon=0;
if findw(compress(lowcase(actors)),'irrfankhan') then a_irrfankhan=1; else a_irrfankhan=0;
if findw(compress(lowcase(actors)),'ratiagnihotri') then a_ratiagnihotri=1; else a_ratiagnihotri=0;
if findw(compress(lowcase(actors)),'riteshdeshmukh') then a_riteshdeshmukh=1; else a_riteshdeshmukh=0;
if findw(compress(lowcase(actors)),'ameeshapatel') then a_ameeshapatel=1; else a_ameeshapatel=0;
if findw(compress(lowcase(actors)),'bomanirani') then a_bomanirani=1; else a_bomanirani=0;
if findw(compress(lowcase(actors)),'jimmyshergill') then a_jimmyshergill=1; else a_jimmyshergill=0;
if findw(compress(lowcase(actors)),'manojbajpayee') then a_manojbajpayee=1; else a_manojbajpayee=0; run;

proc sql; select sum(a_akshaykumar) as a_akshaykumar,sum(a_ajaydevgn) as a_ajaydevgn,sum(a_amitabhbachchan) as a_amitabhbachchan,sum(a_sanjaydutt) as a_sanjaydutt,sum(a_sunilshetty) as a_sunilshetty,
sum(a_anupamkher) as a_anupamkher,sum(a_kareenakapoor) as a_kareenakapoor,sum(a_priyankachopra) as a_priyankachopra,sum(a_salmankhan) as a_salmankhan,sum(a_bipashabasu) as a_bipashabasu,
sum(a_abhishekbachchan) as a_abhishekbachchan,sum(a_gulshangrover) as a_gulshangrover,sum(a_ompuri) as a_ompuri,sum(a_pareshrawal) as a_pareshrawal,sum(a_ranimukerji) as a_ranimukerji,
sum(a_saifalikhan) as a_saifalikhan,sum(a_emraanhashmi) as a_emraanhashmi,sum(a_johnabraham) as a_johnabraham,sum(a_jackieshroff) as a_jackieshroff,sum(a_sunnydeol) as a_sunnydeol,
sum(a_arjunrampal) as a_arjunrampal,sum(a_bobbydeol) as a_bobbydeol,sum(a_shahidkapoor) as a_shahidkapoor,sum(a_mithunchakraborty) as a_mithunchakraborty,sum(a_shahrukhkhan) as a_shahrukhkhan,
sum(a_aftabshivdasani) as a_aftabshivdasani,sum(a_arshadwarsi) as a_arshadwarsi,sum(a_kaykaymenon) as a_kaykaymenon,sum(a_irrfankhan) as a_irrfankhan,sum(a_ratiagnihotri) as a_ratiagnihotri,
sum(a_riteshdeshmukh) as a_riteshdeshmukh,sum(a_ameeshapatel) as a_ameeshapatel,sum(a_bomanirani) as a_bomanirani,sum(a_jimmyshergill) as a_jimmyshergill,sum(a_manojbajpayee) as a_manojbajpayee from temp5; quit;

data temp; set _null_; run;
%macro bin(var);
proc sql; create table temp6 as select &var., rating, count(*) as cnt from temp5 where &var. = 1 group by &var., rating ; quit;
data temp6; format var $20.; set temp6; var = "&var."; run;
data temp; set temp temp6; run;
%mend;
%bin(a_akshaykumar);
%bin(a_ajaydevgn);
%bin(a_amitabhbachchan);
%bin(a_sanjaydutt);
%bin(a_sunilshetty);
%bin(a_anupamkher);
%bin(a_kareenakapoor);
%bin(a_priyankachopra);
%bin(a_salmankhan);
%bin(a_bipashabasu);
%bin(a_abhishekbachchan);
%bin(a_gulshangrover);
%bin(a_ompuri);
%bin(a_pareshrawal);
%bin(a_ranimukerji);
%bin(a_saifalikhan);
%bin(a_emraanhashmi);
%bin(a_johnabraham);
%bin(a_jackieshroff);
%bin(a_sunnydeol);
%bin(a_arjunrampal);
%bin(a_bobbydeol);
%bin(a_shahidkapoor);
%bin(a_mithunchakraborty);
%bin(a_shahrukhkhan);
%bin(a_aftabshivdasani);
%bin(a_arshadwarsi);
%bin(a_kaykaymenon);
%bin(a_irrfankhan);
%bin(a_ratiagnihotri);
%bin(a_riteshdeshmukh);
%bin(a_ameeshapatel);
%bin(a_bomanirani);
%bin(a_jimmyshergill);
%bin(a_manojbajpayee);

proc reg data=temp5; model rating = a_shahrukhkhan a_salmankhan a_emraanhashmi a_riteshdeshmukh 
a_kareenakapoor a_abhishekbachchan a_bomanirani a_akshaykumar a_priyankachopra a_pareshrawal; run;

/*Cross freq*/
data temp6 (drop=rating);
set temp5 (keep=title rating g_action g_comedy g_musical g_romance d_rohitshetty d_mohitsuri d_daviddhawan d_priyadarshan
a_shahrukhkhan a_salmankhan a_emraanhashmi a_riteshdeshmukh a_kareenakapoor a_abhishekbachchan a_bomanirani a_akshaykumar a_priyankachopra a_pareshrawal);
where rating = exp(3);
run;

data temp; set _null_; run;
%macro cf(var1,var2,var3);
proc sql; create table temp7 as select 
title as title from temp6
where &var1. = 1 and &var2. = 1 and &var3. = 1; quit;
data temp7; set temp7; 
format actors $20.; actors = "&var1.";
format directors $20.; directors = "&var2.";
format genre $20.; genre = "&var3."; run;
data temp; set temp temp7; run;
%mend;

%cf(a_akshaykumar,d_priyadarshan,g_action);
%cf(a_akshaykumar,d_priyadarshan,g_comedy);
%cf(a_akshaykumar,d_priyadarshan,g_musical);
%cf(a_akshaykumar,d_priyadarshan,g_romance);
%cf(a_akshaykumar,d_daviddhawan,g_action);
%cf(a_akshaykumar,d_daviddhawan,g_comedy);
%cf(a_akshaykumar,d_daviddhawan,g_musical);
%cf(a_akshaykumar,d_daviddhawan,g_romance);
%cf(a_akshaykumar,d_rohitshetty,g_action);
%cf(a_akshaykumar,d_rohitshetty,g_comedy);
%cf(a_akshaykumar,d_rohitshetty,g_musical);
%cf(a_akshaykumar,d_rohitshetty,g_romance);
%cf(a_akshaykumar,d_mohitsuri,g_action);
%cf(a_akshaykumar,d_mohitsuri,g_comedy);
%cf(a_akshaykumar,d_mohitsuri,g_musical);
%cf(a_akshaykumar,d_mohitsuri,g_romance);
%cf(a_kareenakapoor,d_priyadarshan,g_action);
%cf(a_kareenakapoor,d_priyadarshan,g_comedy);
%cf(a_kareenakapoor,d_priyadarshan,g_musical);
%cf(a_kareenakapoor,d_priyadarshan,g_romance);
%cf(a_kareenakapoor,d_daviddhawan,g_action);
%cf(a_kareenakapoor,d_daviddhawan,g_comedy);
%cf(a_kareenakapoor,d_daviddhawan,g_musical);
%cf(a_kareenakapoor,d_daviddhawan,g_romance);
%cf(a_kareenakapoor,d_rohitshetty,g_action);
%cf(a_kareenakapoor,d_rohitshetty,g_comedy);
%cf(a_kareenakapoor,d_rohitshetty,g_musical);
%cf(a_kareenakapoor,d_rohitshetty,g_romance);
%cf(a_kareenakapoor,d_mohitsuri,g_action);
%cf(a_kareenakapoor,d_mohitsuri,g_comedy);
%cf(a_kareenakapoor,d_mohitsuri,g_musical);
%cf(a_kareenakapoor,d_mohitsuri,g_romance);
%cf(a_priyankachopra,d_priyadarshan,g_action);
%cf(a_priyankachopra,d_priyadarshan,g_comedy);
%cf(a_priyankachopra,d_priyadarshan,g_musical);
%cf(a_priyankachopra,d_priyadarshan,g_romance);
%cf(a_priyankachopra,d_daviddhawan,g_action);
%cf(a_priyankachopra,d_daviddhawan,g_comedy);
%cf(a_priyankachopra,d_daviddhawan,g_musical);
%cf(a_priyankachopra,d_daviddhawan,g_romance);
%cf(a_priyankachopra,d_rohitshetty,g_action);
%cf(a_priyankachopra,d_rohitshetty,g_comedy);
%cf(a_priyankachopra,d_rohitshetty,g_musical);
%cf(a_priyankachopra,d_rohitshetty,g_romance);
%cf(a_priyankachopra,d_mohitsuri,g_action);
%cf(a_priyankachopra,d_mohitsuri,g_comedy);
%cf(a_priyankachopra,d_mohitsuri,g_musical);
%cf(a_priyankachopra,d_mohitsuri,g_romance);
%cf(a_salmankhan,d_priyadarshan,g_action);
%cf(a_salmankhan,d_priyadarshan,g_comedy);
%cf(a_salmankhan,d_priyadarshan,g_musical);
%cf(a_salmankhan,d_priyadarshan,g_romance);
%cf(a_salmankhan,d_daviddhawan,g_action);
%cf(a_salmankhan,d_daviddhawan,g_comedy);
%cf(a_salmankhan,d_daviddhawan,g_musical);
%cf(a_salmankhan,d_daviddhawan,g_romance);
%cf(a_salmankhan,d_rohitshetty,g_action);
%cf(a_salmankhan,d_rohitshetty,g_comedy);
%cf(a_salmankhan,d_rohitshetty,g_musical);
%cf(a_salmankhan,d_rohitshetty,g_romance);
%cf(a_salmankhan,d_mohitsuri,g_action);
%cf(a_salmankhan,d_mohitsuri,g_comedy);
%cf(a_salmankhan,d_mohitsuri,g_musical);
%cf(a_salmankhan,d_mohitsuri,g_romance);
%cf(a_abhishekbachchan,d_priyadarshan,g_action);
%cf(a_abhishekbachchan,d_priyadarshan,g_comedy);
%cf(a_abhishekbachchan,d_priyadarshan,g_musical);
%cf(a_abhishekbachchan,d_priyadarshan,g_romance);
%cf(a_abhishekbachchan,d_daviddhawan,g_action);
%cf(a_abhishekbachchan,d_daviddhawan,g_comedy);
%cf(a_abhishekbachchan,d_daviddhawan,g_musical);
%cf(a_abhishekbachchan,d_daviddhawan,g_romance);
%cf(a_abhishekbachchan,d_rohitshetty,g_action);
%cf(a_abhishekbachchan,d_rohitshetty,g_comedy);
%cf(a_abhishekbachchan,d_rohitshetty,g_musical);
%cf(a_abhishekbachchan,d_rohitshetty,g_romance);
%cf(a_abhishekbachchan,d_mohitsuri,g_action);
%cf(a_abhishekbachchan,d_mohitsuri,g_comedy);
%cf(a_abhishekbachchan,d_mohitsuri,g_musical);
%cf(a_abhishekbachchan,d_mohitsuri,g_romance);
%cf(a_pareshrawal,d_priyadarshan,g_action);
%cf(a_pareshrawal,d_priyadarshan,g_comedy);
%cf(a_pareshrawal,d_priyadarshan,g_musical);
%cf(a_pareshrawal,d_priyadarshan,g_romance);
%cf(a_pareshrawal,d_daviddhawan,g_action);
%cf(a_pareshrawal,d_daviddhawan,g_comedy);
%cf(a_pareshrawal,d_daviddhawan,g_musical);
%cf(a_pareshrawal,d_daviddhawan,g_romance);
%cf(a_pareshrawal,d_rohitshetty,g_action);
%cf(a_pareshrawal,d_rohitshetty,g_comedy);
%cf(a_pareshrawal,d_rohitshetty,g_musical);
%cf(a_pareshrawal,d_rohitshetty,g_romance);
%cf(a_pareshrawal,d_mohitsuri,g_action);
%cf(a_pareshrawal,d_mohitsuri,g_comedy);
%cf(a_pareshrawal,d_mohitsuri,g_musical);
%cf(a_pareshrawal,d_mohitsuri,g_romance);
%cf(a_emraanhashmi,d_priyadarshan,g_action);
%cf(a_emraanhashmi,d_priyadarshan,g_comedy);
%cf(a_emraanhashmi,d_priyadarshan,g_musical);
%cf(a_emraanhashmi,d_priyadarshan,g_romance);
%cf(a_emraanhashmi,d_daviddhawan,g_action);
%cf(a_emraanhashmi,d_daviddhawan,g_comedy);
%cf(a_emraanhashmi,d_daviddhawan,g_musical);
%cf(a_emraanhashmi,d_daviddhawan,g_romance);
%cf(a_emraanhashmi,d_rohitshetty,g_action);
%cf(a_emraanhashmi,d_rohitshetty,g_comedy);
%cf(a_emraanhashmi,d_rohitshetty,g_musical);
%cf(a_emraanhashmi,d_rohitshetty,g_romance);
%cf(a_emraanhashmi,d_mohitsuri,g_action);
%cf(a_emraanhashmi,d_mohitsuri,g_comedy);
%cf(a_emraanhashmi,d_mohitsuri,g_musical);
%cf(a_emraanhashmi,d_mohitsuri,g_romance);
%cf(a_shahrukhkhan,d_priyadarshan,g_action);
%cf(a_shahrukhkhan,d_priyadarshan,g_comedy);
%cf(a_shahrukhkhan,d_priyadarshan,g_musical);
%cf(a_shahrukhkhan,d_priyadarshan,g_romance);
%cf(a_shahrukhkhan,d_daviddhawan,g_action);
%cf(a_shahrukhkhan,d_daviddhawan,g_comedy);
%cf(a_shahrukhkhan,d_daviddhawan,g_musical);
%cf(a_shahrukhkhan,d_daviddhawan,g_romance);
%cf(a_shahrukhkhan,d_rohitshetty,g_action);
%cf(a_shahrukhkhan,d_rohitshetty,g_comedy);
%cf(a_shahrukhkhan,d_rohitshetty,g_musical);
%cf(a_shahrukhkhan,d_rohitshetty,g_romance);
%cf(a_shahrukhkhan,d_mohitsuri,g_action);
%cf(a_shahrukhkhan,d_mohitsuri,g_comedy);
%cf(a_shahrukhkhan,d_mohitsuri,g_musical);
%cf(a_shahrukhkhan,d_mohitsuri,g_romance);
%cf(a_riteshdeshmukh,d_priyadarshan,g_action);
%cf(a_riteshdeshmukh,d_priyadarshan,g_comedy);
%cf(a_riteshdeshmukh,d_priyadarshan,g_musical);
%cf(a_riteshdeshmukh,d_priyadarshan,g_romance);
%cf(a_riteshdeshmukh,d_daviddhawan,g_action);
%cf(a_riteshdeshmukh,d_daviddhawan,g_comedy);
%cf(a_riteshdeshmukh,d_daviddhawan,g_musical);
%cf(a_riteshdeshmukh,d_daviddhawan,g_romance);
%cf(a_riteshdeshmukh,d_rohitshetty,g_action);
%cf(a_riteshdeshmukh,d_rohitshetty,g_comedy);
%cf(a_riteshdeshmukh,d_rohitshetty,g_musical);
%cf(a_riteshdeshmukh,d_rohitshetty,g_romance);
%cf(a_riteshdeshmukh,d_mohitsuri,g_action);
%cf(a_riteshdeshmukh,d_mohitsuri,g_comedy);
%cf(a_riteshdeshmukh,d_mohitsuri,g_musical);
%cf(a_riteshdeshmukh,d_mohitsuri,g_romance);
%cf(a_bomanirani,d_priyadarshan,g_action);
%cf(a_bomanirani,d_priyadarshan,g_comedy);
%cf(a_bomanirani,d_priyadarshan,g_musical);
%cf(a_bomanirani,d_priyadarshan,g_romance);
%cf(a_bomanirani,d_daviddhawan,g_action);
%cf(a_bomanirani,d_daviddhawan,g_comedy);
%cf(a_bomanirani,d_daviddhawan,g_musical);
%cf(a_bomanirani,d_daviddhawan,g_romance);
%cf(a_bomanirani,d_rohitshetty,g_action);
%cf(a_bomanirani,d_rohitshetty,g_comedy);
%cf(a_bomanirani,d_rohitshetty,g_musical);
%cf(a_bomanirani,d_rohitshetty,g_romance);
%cf(a_bomanirani,d_mohitsuri,g_action);
%cf(a_bomanirani,d_mohitsuri,g_comedy);
%cf(a_bomanirani,d_mohitsuri,g_musical);
%cf(a_bomanirani,d_mohitsuri,g_romance);

proc freq data=temp5; tables rating; run;