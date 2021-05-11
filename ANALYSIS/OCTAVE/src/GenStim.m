% Stimulus samples generator
fb=([0,0,-1,1]); % Calc of the theoretical stimulus
seedx=([0 0 0 1]);
[x,x3out]=pseudogen3(4,fb,seedx,25);
prts=x3out*100/(max(x3out)-min(x3out));
ln=913;
prts=([prts(ln:end) prts(1:ln-1)])-prts(ln);
prts1=prts/max(prts);
%             prts1=prts/std(abs(prts))*std(abs(stim1));

