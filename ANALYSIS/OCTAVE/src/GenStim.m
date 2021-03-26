% Stimulus samples generator
STD=1;
numsamples = 6391;
N1=80*25-3;  % SS stim
N3=80*12.5-2;  % SS stim

plot
fb=([0,0,-1,1]); % Calc of the theoretical stimulus
seedx=([0 0 0 1]);
[x,x3out]=pseudogen3(4,fb,seedx,25);
prts=x3out*100/(max(x3out)-min(x3out));
ln=913;
prts=([prts(ln:end) prts(1:ln-1)])-prts(ln);
prts1=-prts/std(abs(prts))*STD;
%             prts1=prts/std(abs(prts))*std(abs(stim1));
prts3=prts(2:2:end);
prts3=-prts3/std(abs(prts3))*STD;
%             prts3=prts3/std(abs(prts3))*std(abs(stim3));
startidx1=200;		% start index, # cycles of PRTS for non-SR trials
startidx3=200;		% start index, # cycles of PRTS for non-SR trials
stimdel=-4;          % delay between platf command and movement
% 			startidx1=181;		% start index, # cycles of PRTS for non-SR trials
% 			startidx3=177;		% start index, # cycles of PRTS for non-SR trials
cycles1=fix((numsamples)/N1);
cycles3=fix((numsamples)/N3);