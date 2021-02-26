function [pp2,plotInfo,iniGr]=pp2_plotInfo(x1)

if x1==1;pp2='Patient\';        gName = 'Pat '; farbe = 'c';  symb = 'o';  lin = '-'; iniGr = 'pat '; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Healthy Controls
if x1==2;   pp2='NP\NP\';       gName = 'NP  '; farbe = 'k';  symb = 'o';  lin = '-';  iniGr = 'np  ';end
if x1==3;   pp2='NP\Mittel\';   gName = 'Mitt'; farbe = 'g';  symb = 's';  lin = '--'; iniGr = 'np  ';end
if x1==30;  pp2='NP\Jung\';     gName = 'Jung'; farbe = 'k';  symb = 'o';  lin = '-';  iniGr = 'np  ';end       
if x1==31;  pp2='NP\Mittel\';   gName = 'Mitt'; farbe = 'r';  symb = 's';  lin = '--'; iniGr = 'np  ';end
if x1==32;  pp2='NP\Alt\';      gName = 'Alt '; farbe = 'r';  symb = 'h';  lin = '--'; iniGr = 'np  ';end 

if x1==33;  pp2='NP\NP_HSP\';   gName = 'nHSP'; farbe = 'm';  symb = '^';  lin = '-';  iniGr = 'np  ';end
if x1==34;  pp2='SensorAnzug\'; gName = 'npSA'; farbe = 'k';  symb = 'o';  lin = '-';  iniGr = 'np  ';end
if x1==35;  pp2='NP\NP1min\';   gName = '1min'; farbe = 'r';  symb = 'x';  lin = '-';  iniGr = 'np  ';end
if x1==36;  pp2='NP\NP2min\';   gName = '2min'; farbe = 'g';  symb = 'v';  lin = '-';  iniGr = 'np  ';end
if x1==37;  pp2='NP\npMann\';   gName = 'Mann'; farbe = 'c';  symb = 'x';  lin = '-';  iniGr = 'np  ';end
if x1==38;  pp2='NP\npFrau\';   gName = 'Frau'; farbe = 'm';  symb = 'v';  lin = '-';  iniGr = 'np  ';end
if x1==39;  pp2='NP\Kinder\';   gName = 'Kind'; farbe = 'g';  symb = 'v';  lin = '-';  iniGr = 'npk ';end

% if x1==20;  pp2='OnkoPNP\onkoNP\';gName = 'NPo '; farbe = 'k';  symb = 'o'; lin = '-';iniGr = 'np  ';end
% if x1==21;  pp2='';    gName = ''; farbe = 'c';  symb = '.';  lin = '-.';iniGr = 'np  ';end
% if x1==22;  pp2='';    gName = ''; farbe = 'r';  symb = '.';  lin = '--';iniGr = 'np  ';end
if x1==21;  pp2='NP\Standtrainer\';	gName = 'NPst'; farbe = 'r';  symb = 'h';  lin = '--';iniGr = 'np  ';end
if x1==22;  pp2='NP\NpLum\';	gName = 'NPst'; farbe = 'r';  symb = 'h';  lin = '--';iniGr = 'np  ';end
if x1==23;  pp2='NP\NpPNP\';	gName = 'NPst'; farbe = 'r';  symb = 'h';  lin = '--';iniGr = 'np  ';end

% Altentraining    
if x1==24;  pp2='NP\NPat\NPak1\';   gName = 'Nak1'; farbe = 'c';  symb = 'p';  lin = ':';  iniGr = 'npak';end
if x1==25;  pp2='NP\NPat\NPak2\';   gName = 'Nak2'; farbe = 'b';  symb = 'h';  lin = '-.'; iniGr = 'npak';end
if x1==26;  pp2='NP\NPat\NPat1\';   gName = 'Nat1'; farbe = 'g';  symb = '^';  lin = ':';  iniGr = 'npat';end
if x1==27;  pp2='NP\NPat\NPat2\';   gName = 'Nat2'; farbe = 'r';  symb = 'd';  lin = '-';  iniGr = 'npat';end

if x1==28;  pp2='NP\NPimke\';   gName = 'NPij'; farbe = 'k';  symb = 'o';  lin = '-';  iniGr = 'np  ';end
if x1==29;  pp2='NP\npALS\';    gName = 'NPik'; farbe = 'k';  symb = 'o';  lin = '-';  iniGr = 'np  ';end
% if x1==4;  pp2='NP\NPFuss\alle\';    gName = 'NPfu'; farbe = 'k';  symb = 'o';  lin = '-';  iniGr = 'np  ';end
if x1==4;  pp2='NP\NPFussPlatt\';    gName = 'NPfu'; farbe = 'k';  symb = 'o';  lin = '-';  iniGr = 'np  ';end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Patienten Mix
if x1==6;   pp2='ALS\';         gName = 'ALS '; farbe = 'r';  symb = 's';  lin = '-'; iniGr = 'als ';end
if x1==7;   pp2='BPLS\Krank\';  gName = 'BPLS'; farbe = 'b';  symb = 'o';  lin = '-'; iniGr = 'bpls';end
if x1==8;   pp2='BPLS\nLag\';   gName = 'LSpL'; farbe = 'b';  symb = 'd';  lin = '-'; iniGr = 'bpls';end
if x1==9;   pp2='HSP\Pre\';     gName = 'Pre '; farbe = 'b';  symb = 'o';  lin = '-'; iniGr = 'hsp ';end
if x1==10;  pp2='HSP\Post\';    gName = 'Post'; farbe = 'r';  symb = 'o';  lin = ':'; iniGr = 'hsp ';end
% if x1==11;  pp2 ='OT\';         gName = 'OT  '; farbe = 'm';  symb = 'p';  lin = '-'; iniGr = 'ot  ';end
if x1==11;  pp2='Lablos\';      gName = 'LL  '; farbe = 'r';  symb = 'o';  lin = '-';iniGr = 'LL  ';end
if x1==12;	pp2='ADHS\unmediziert\';    gName = 'ADHS'; farbe = 'm';  symb = 'v';  lin = '-'; iniGr = 'adh ';end
if x1==13;  pp2='ADHS\mediziert\';      gName = 'ADHR'; farbe = 'r';  symb = 'd';  lin = ':'; iniGr = 'adh ';end
if x1==14;  pp2='OnkoPNP\OnkoPNP1\';    gName = 'pre '; farbe = 'b';  symb = 's';  lin = ':'; iniGr = 'pnp1';end
if x1==15;  pp2='OnkoPNP\OnkoPNP2\';    gName = 'post'; farbe = 'r';  symb = '^';  lin = '--'; iniGr = 'pnp2';end
if x1==16;  pp2='OnkoPNP\OnkoPNPKontrolle\';gName = 'hCon'; farbe = 'k';  symb = 'o'; lin = '-';iniGr = 'np  ';end
if x1==20;  pp2='OnkoPNP\NP\';gName = 'oNPk'; farbe = 'm';  symb = 's'; lin = ':';iniGr = 'np  ';end
if x1==17;  pp2='PNP\';      gName = 'PNP   '; farbe = 'r';  symb = 'o';  lin = '-';iniGr = 'PNP ';end
if x1==18;  pp2='Lum\pre\';     gName = 'lum '; farbe = 'm';  symb = 'd';  lin = '-';iniGr = 'lum ';end
if x1==19;  pp2='Lum\post\';    gName = 'lum0'; farbe = 'g';  symb = 'v';  lin = ':';iniGr = 'lum0';end   
    
% if x1==;  pp2='wii\pre\';     gName = 'wiNP'; farbe = 'm';  symb = 'd';  lin = '-';iniGr = 'np  ';end
% if x1==;  pp2='wii\post\';    gName = 'wii2'; farbe = 'c';  symb = 's'; lin = ':';iniGr = 'np  ';end
% if x1==;    pp2='cervikalS\';   iniGr = 'cs  ';end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4 Parkinson STNdual Studie PD g grün
if x1==40;   pp2='PD\STNdual\s0d0\';    gName = 'PD00'; farbe = 'g';  symb = 'v';  lin = '-';iniGr = 'pd  ';end
if x1==41;  pp2='PD\STNdual\s0d1\';     gName = 'PD01'; farbe = 'b';  symb = 's';  lin = '-.';iniGr = 'pd  ';end
if x1==42;  pp2='PD\STNdual\s1d0\';     gName = 'PD10'; farbe = 'm';  symb = 'p';  lin = '-';iniGr = 'pd  ';end
if x1==43;  pp2='PD\STNdual\s1d1\';     gName = 'PD11'; farbe = 'r';  symb = 'o';  lin = '-';iniGr = 'pd  ';end
if x1==44;  pp2='PD\STNdual\';    gName = 'PD  '; farbe = 'g';  symb = 's';  lin = '-';iniGr = 'pd  ';end
if x1==45;  pp2='PD\STNdual\sxd0\';    gName = 'PDx0'; farbe = 'y';  symb = '^';  lin = '-';end
if x1==46;  pp2='PD\STNdual\sxd1\';    gName = 'PDx1'; farbe = 'c';  symb = 'd';  lin = '-';end

% Parkinson NP und PSP in München gemessen
if x1==47;  pp2='Munchen\MuCO\';    gName = 'PSP '; farbe = 'm';  symb = 'd';  lin = '-';iniGr = 'M np';end
if x1==48;  pp2='Munchen\MuIPS\';   gName = 'IPS '; farbe = 'g';  symb = 'v';  lin = '-';iniGr = 'Misp';end
if x1==49;  pp2='Munchen\MuPSP\';   gName = 'NPco'; farbe = 'b';  symb = '*';  lin = '-';iniGr = 'Mpsp';end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5 50er & 60er Huntington      m magenta
% Verlauf
if x1==5;   pp2='Hunt\Allin1\';        gName = 'HD0 '; farbe = 'm';  symb = 'p';  lin = '-'; iniGr = 'hunt';end
if x1==50;  pp2='Hunt\preOP\0_Mon\';   gName = 'HD0 '; farbe = 'm';  symb = 'p';  lin = '-'; iniGr = 'hunt';end
if x1==53;  pp2='Hunt\preOP\3_Mon\';   gName = 'HD3 '; farbe = 'y';  symb = 'p';  lin = '-'; iniGr = 'hunt';end
if x1==56;  pp2='Hunt\preOP\6_Mon\';   gName = 'HD6 '; farbe = 'c';  symb = 'p';  lin = '-'; iniGr = 'hunt';end
if x1==52;  pp2='Hunt\preOP\12Mon\';   gName = 'HD12'; farbe = 'b';  symb = 'p';  lin = '-'; iniGr = 'hunt';end
if x1==55;  pp2='Hunt\preOP\15Mon\';   gName = 'HD15'; farbe = 'r';  symb = 'p';  lin = '-'; iniGr = 'hunt';end
if x1==58;  pp2='Hunt\preOP\18Mon\';    gName = 'HD18'; farbe = 'g';  symb = 'p';  lin = '-'; iniGr = 'hunt';end
if x1==54;  pp2='Hunt\preOP\24Mon\';    gName = 'HD24'; farbe = 'y';  symb = 'p';  lin = '-'; iniGr = 'hunt';end
if x1==51;  pp2='Hunt\preOP\Jahr_2\';    gName = 'H2J '; farbe = 'c';  symb = 'p';  lin = '-'; iniGr = 'hunt';end
% if x1==55;  pp2='Hunt\preOP\Jahr_3\';    gName = 'H3J '; farbe = 'b';  symb = 'p';  lin = '-'; iniGr = 'hunt';end 
if x1==57;  pp2='Hunt\preOP\Jahr_4\';    gName = 'H4J '; farbe = 'r';  symb = 'h';  lin = '-'; iniGr = 'hunt';end
if x1==59;  pp2='Hunt\preOP\All\';    gName = 'H5J '; farbe = 'g';  symb = 'h';  lin = '-'; iniGr = 'hunt';end 

% Stammzelltransplantation
if x1==60;  pp2='Hunt\OP\preOP\';   gName = 'Hpre'; farbe = 'm';  symb = 'p';  lin = '-'; iniGr = 'hunt';end
if x1==63;  pp2='Hunt\OP\OP_3m\';  gName = 'H3O '; farbe = 'c';  symb = 'd';  lin = '-'; iniGr = 'hunt';end
if x1==66;  pp2='Hunt\OP\OP_6m\';  gName = 'H6O '; farbe = 'b';  symb = 'd';  lin = '-'; iniGr = 'hunt';end
if x1==62;  pp2='Hunt\OP\OP_12m\'; gName = 'H12O'; farbe = 'r';  symb = 'd';  lin = '-'; iniGr = 'hunt';end
if x1==65;  pp2='Hunt\OP\OP_15m\'; gName = 'H15O'; farbe = 'g';  symb = 'd';  lin = '-'; iniGr = 'hunt';end
if x1==68;  pp2='Hunt\OP\OP_18m\'; gName = 'H18O'; farbe = 'y';  symb = 'd';  lin = '-'; iniGr = 'hunt';end
if x1==64;  pp2='Hunt\OP\1J_OP\';   gName = 'H24O'; farbe = 'g';  symb = 'd';  lin = '-'; iniGr = 'hunt';end
if x1==61;  pp2='Hunt\OP\2J_OP\';   gName = 'H2JO'; farbe = 'c';  symb = 'd';  lin = '-'; iniGr = 'hunt';end
% if x1==65;  pp2='Hunt\OP\3J_OP\';   gName = 'H3JO'; farbe = 'b';  symb = 'd';  lin = '-';iniGr = 'hunt';end    
if x1==67;  pp2='Hunt\OP\4J_OP\';   gName = 'H4JO'; farbe = 'r';  symb = 's';  lin = '-';iniGr = 'hunt';end
if x1==69;  pp2='Hunt\OP\5J_OP\';   gName = 'H5JO'; farbe = 'g';  symb = 's';  lin = '-';iniGr = 'hunt';end  
if x1==70;  pp2='PNP_Simon\PNP_Study_A\T0\'; gName = 'pre '; farbe = 'g';  symb = 's';  lin = ':'; iniGr = 'pnpe';end
if x1==71;  pp2='PNP_Simon\PNP_Study_A\T1\'; gName = 'post '; farbe = 'b';  symb = 's';  lin = ':'; iniGr = 'pnpe';end
if x1==72;  pp2='PNP_Simon\PNP_Study_B\T0\'; gName = 'pre '; farbe = 'r';  symb = 's';  lin = ':'; iniGr = 'pnpb';end
if x1==73;  pp2='PNP_Simon\PNP_Study_B\T1\'; gName = 'post '; farbe = 'k';  symb = 's';  lin = ':'; iniGr = 'pnpb';end

% Eurobench
if x1==80;  pp2='Eurobench\Lucy\';   gName = 'Lucy'; farbe = 'm';  symb = 'p';  lin = '-'; iniGr = 'euro';end
if x1==81;  pp2='Eurobench\Posturob\';  gName = 'Prob '; farbe = 'c';  symb = 'd';  lin = '-'; iniGr = 'euro';end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plotInfo.name = gName;
plotInfo.combi = [farbe,symb,lin];
plotInfo.color = farbe;
plotInfo.marker = symb;
plotInfo.line = lin;

