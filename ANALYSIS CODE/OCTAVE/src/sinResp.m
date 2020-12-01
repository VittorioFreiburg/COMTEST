function s=sinResp(u,y,t)

%%% Gain
s.ppGain=(max(y)-min(y))/(max(u)-min(u));
% empirical sinusoid
U=fft(u);
gU=abs(U);
pU=angle(U);
Y=fft(y);
gY=abs(Y);
pY=angle(Y);
pitch=find(gU==max(gU),1,'first');
s.gain=gY(pitch)/gU(pitch);
%%% Phaselag
s.phase=pY(pitch)-pU(pitch);
%%% power
s.power=sum(gY.^2)/sum(gU.^2);