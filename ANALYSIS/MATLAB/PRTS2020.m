function [TF] = PRTS2012(stim,resp1,ampRot,ampTrans) 

stim1 = stim.rot;
stim3 = stim.trans;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Derived from 
%     - STNdual_SS (Single Subjects)
%     - PRTS_SS
%     - PRTS
%
% Script to calculate gain, phase, and coherence from an dual input- single
% output 
% time series obtained from two uncorrelated PRTS stimuli.  The specific PRTSa used
% here were a 242 state sequences with N sample points per state and sampling
% rate of 100/s.  This gives a cycle time of 242*N/100 s (therefore 242*N points
% per cycle).  In this case, N was 20 for one PRTS and 10 for the other.
%
% The following functions are called: 
%	dft	- Dr. Bob's personal slow discrete Fourier transform
%	decimate2 - Dr. Bob's personal decimation function (no filtering, just undersampling)
%	phase - a MATLAB function from the System Identification toolbox
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






trialanderror=0;
figureon=0; % if 0 no figure, if 1 than group figures
figureindiv=1; % if figureindiv==1; plot single subject figures, if 0; plot nothing
sdscale=1;

  
%% create empty arrays 
l1 = 1;
is = 1;

oH31=zeros(l1,11);
oH31corr=zeros(l1,11);
oCoh12=zeros(l1,11);
oH33=zeros(l1,11);
oH33corr=zeros(l1,11);
oCoh32=zeros(l1,11);
oavgi=zeros(l1,11);

titext1=(['tilt ',num2str(ampRot),' deg']);
titext2=(['trans ',num2str(ampTrans),' cm']);
% titext3=([num2str(fname)]);

 resp3=resp1;    % resp3 f�r Translationsanalyse
 
% resp2=ax;

%     rmsbodyangle=sqrt(mean((180/pi*asin((m_ch)/h)-mean(180/pi*asin((m_ch)/h))).^2));
%     rmsax=sqrt(mean((ax-mean(ax)).^2));
%     rms_m_ch=sqrt(mean((m_ch-mean(m_ch)).^2));
%     stim1v=diff(stim1)*100;
%     stim3v=diff(stim3)*100;
%     respv=diff(resp1)*100;

N1=80*25-3;  % SS stim
N3=80*12.5-2;  % SS stim

tt=(1:length(stim1))/100;
if figureon==1
    figure(5)
    plot(tt,stim1,tt,stim3,tt,resp1,'r')
    title(datname);
end

%             pause

tc1=(0:(N1+2))/100;		% time
tc1=tc1';
tc3=(0:(N3+1))/100;		% time
tc3=tc3';

numsamples=max(size(stim1));
% You will need to reduce the size of these vectors to about 1/3 for a 80 state PRTS
yis1=zeros(1,50);		% input amplitude spectrum
yos1=zeros(1,50);		% output amplitude spectrum
Gxys1=zeros(1,25);		% cross power spectrum
Gxs1=zeros(1,25);		% input power spectrum
Gys1=zeros(1,25);		% output power spectrum
avgi1=zeros(size(tc1));	% average input time series
avgo1=zeros(size(tc1));	% average output time series
yis3=zeros(1,50);		% input amplitude spectrum
yos3=zeros(1,50);		% output amplitude spectrum
Gxys3=zeros(1,25);		% cross power spectrum
Gxs3=zeros(1,25);		% input power spectrum
Gys3=zeros(1,25);		% output power spectrum
avgi3=zeros(size(tc3));	% average input time series
avgo3=zeros(size(tc3));	% average output time series

% Figure out how many stimulus cycles there are (you will need to modify this)
fb=([0,0,-1,1]); % Calc of the theoretical stimulus
seedx=([0 0 0 1]);
[x,x3out]=pseudogen3(4,fb,seedx,25);
%             prts3=prts3/std(abs(prts3))*std(abs(stim3));
startidx1=200;		% start index, # cycles of PRTS for non-SR trials
startidx3=200;		% start index, # cycles of PRTS for non-SR trials
stimdel=-4;          % delay between platf command and movement
% 			startidx1=181;		% start index, # cycles of PRTS for non-SR trials
% 			startidx3=177;		% start index, # cycles of PRTS for non-SR trials
cycles1=fix((numsamples)/N1);
cycles3=fix((numsamples)/N3);

if cycles1>1		% analyze tilt data
    for k=2:cycles1

        % Calculate discrete Fourier transform of the stimulus (platform position signal)
        %
        %	The vector "stim" was the input stimulus waveform (sampled actual stimulus, not the ideal stimulus waveform)

        [yi1,f1]=dft(stim1((startidx1+stimdel+(k-1)*N1):(startidx1+stimdel+k*N1+2)),100,50);	% amp spectra
        avgi1=avgi1+stim1((startidx1+stimdel+(k-1)*N1):(startidx1+stimdel+k*N1+2));
% 					[yi1,f1]=dft(prts1',100,50);	% amp spectra
% 					avgi1=avgi1+prts1';
        % Calculate discrete Fourier transform of the response (e.g. joint angle position signal)			  
        %
        %	The vector "resp" was the output response waveform
        avgo1=avgo1+resp1((startidx1+(k-1)*N1):(startidx1+k*N1+2));
        [yo1,f1]=dft(resp1((startidx1+(k-1)*N1):(startidx1+k*N1+2)),100,50);	% COG pos amp spectrum

        Gxy1=conj(yi1).*yo1;	% raw cross power spectra
        Gx1=conj(yi1).*yi1;	% raw input power spectra
        Gy1=conj(yo1).*yo1;	% raw output power spectra

        yis1=yis1+yi1;					% summed amp spectra
        yos1=yos1+yo1;

        Gxys1=Gxys1+decimate2(Gxy1,2);	% summed power spectra
        Gxs1=Gxs1+decimate2(Gx1,2);
        Gys1=Gys1+decimate2(Gy1,2);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if figureon==1
            figure(7)
            subplot(211);plot(tc1,stim1((startidx1+stimdel+(k-1)*N1):(startidx1+stimdel+k*N1+2)),'b');
            axis([0 60.5 -3 3])
            ylabel('Stim Average (Nm)')
            hold on
            hold off
            subplot(212);plot(tc1,resp1((startidx1+(k-1)*N1):(startidx1+k*N1+2)),'b');
            axis([0 60.5 -3 3])
            ylabel('Resp Average+/-95% c.l. (deg)')
            xlabel('Time (s)')
            hold on
            hold off
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     pause



    end	%for k=1:cycles
end % if cycles1>1		% analyze tilt data
avgi1=avgi1/(cycles1-1);	% average stimulus - just for looking at
avgo1=avgo1/(cycles1-1);	% average response

yis1=yis1/(cycles1-1);		% average amp spectra - just to look at
yos1=yos1/(cycles1-1);

Gxys1=Gxys1/(cycles1-1);	% average power spectra - just to look at
Gxs1=Gxs1/(cycles1-1);
Gys1=Gys1/(cycles1-1);

fs1=decimate2(f1,2);	% frequency of sample pts with stimulus energy (every other point for a PRTS signal)
yisd1=decimate2(yis1,2);
yosd1=decimate2(yos1,2);

fs12=decimate2(f1(2:50),2);		% frequency of sample pts without stimulus energy
yisd12=decimate2(yis1(2:50),2);	% abs(yisd2) should be essentially zero if you are doing things right
yosd12=decimate2(yos1(2:50),2);

% The immediately following are calculations of transfer function gain, phase, coherence at each frequency point
% with stimulus energy (every other point) provided by the dft output.  At this point averaging has been done 
% over the number of cycles.  At higher frequencies, there will be a lot of variability in the results since
% there is not much power in the stimulus (position stimulus waveform) at these higher frequencies.
% Addition frequency averaging is needed (see below) in order to reduce this variability.

% Additional frequency averaging - 1,1,2,2,3,4,4,4,5,5,6,8,9,10,11,13,15 parital overlapping pts

% you will need to modify this to account for the lower number of points in your spectra from 80 state PRTS

f12=[fs1(1:2) mean(fs1(3:4)) mean(fs1(4:5)) mean(fs1(5:7)) mean(fs1(6:9)) mean(fs1(8:11)) mean(fs1(10:13)),...
    mean(fs1(12:16)) mean(fs1(16:20)) mean(fs1(20:25))];
yi12=[yis1(1:2) mean(yis1(3:4)) mean(yis1(4:5)) mean(yis1(5:7)) mean(yis1(6:9)) mean(yis1(8:11)) mean(yis1(10:13)),...
    mean(yis1(12:16)) mean(yis1(16:20)) mean(yis1(20:25))];
yo12=[yos1(1:2) mean(yos1(3:4)) mean(yos1(4:5)) mean(yos1(5:7)) mean(yos1(6:9)) mean(yos1(8:11)) mean(yos1(10:13)),...
    mean(yos1(12:16)) mean(yos1(16:20)) mean(yos1(20:25))];
Gxy12=[Gxys1(1:2) mean(Gxys1(3:4)) mean(Gxys1(4:5)) mean(Gxys1(5:7)) mean(Gxys1(6:9)) mean(Gxys1(8:11)) mean(Gxys1(10:13)),...
    mean(Gxys1(12:16)) mean(Gxys1(16:20)) mean(Gxys1(20:25))];
Gx12=[Gxs1(1:2) mean(Gxs1(3:4)) mean(Gxs1(4:5)) mean(Gxs1(5:7)) mean(Gxs1(6:9)) mean(Gxs1(8:11)) mean(Gxs1(10:13)),...
    mean(Gxs1(12:16)) mean(Gxs1(16:20)) mean(Gxs1(20:25))];
Gy12=[Gys1(1:2) mean(Gys1(3:4)) mean(Gys1(4:5)) mean(Gys1(5:7)) mean(Gys1(6:9)) mean(Gys1(8:11)) mean(Gys1(10:13)),...
    mean(Gys1(12:16)) mean(Gys1(16:20)) mean(Gys1(20:25))];
Coh12=(abs(Gxy12).^2)./(Gx12.*Gy12);	% Coherence based on BB position data
dof1=cycles1*2*[1,1,2,2,3,4,4,4,5,5,6];	% degrees of freedom used for confidence limit calculations
%
%  F dist 2,pts*cycles*2-2;alpha=0.05
%
F2=[19.0 19.0 5.14 5.14 4.10 3.74 3.74 3.74 3.55 3.55 ...
    3.44]; % F dist specific for 2 cycles and given averaging
F3=[6.94 6.94 4.10 4.10 3.63 3.44 3.44 3.44 3.34 3.34 ...
    3.28]; % F dist specific for 3 cycles and given averaging
F4=[5.14 5.14 3.74 3.74 3.44 3.32 3.32 3.32 3.25 3.25 ...
    3.20]; % F dist specific for 4 cycles and given averaging
F5=[4.46 4.46 3.55 3.55 3.34 3.25 3.25 3.25 3.19 3.19 ...
    3.15]; % F dist specific for 5 cycles and given averaging
F6=[4.10 4.10 3.44 3.44 3.28 3.20 3.20 3.20 3.15 3.15 ...
    3.13]; % F dist specific for 6 cycles and given averaging
F7=[3.89 3.89 3.40 3.40 3.27 3.19 3.19 3.19 3.15 3.15 ...
    3.13]; % F dist specific for 7 cycles and given averaging
F8=[3.74 3.74 3.32 3.32 3.20 3.15 3.15 3.15 3.12 3.12 ...
    3.10]; % F dist specific for 8 cycles and given averaging
F10=[3.55 3.55 3.24 3.24 3.15 3.12 3.12 3.12 3.09 3.09 ...
    3.07]; % F dist specific for 10 cycles and given averaging
F40=[3.12 3.12 3.05 3.05 3.04 3.04 3.04 3.04 3.03 3.03 ...
    3.03]; % F dist specific for 40 cycles and given averaging
F80=[3.04 3.04 3.04 3.04 3.04 3.03 3.03 3.03 3.02 3.02 ...
    3.02]; % F dist specific for 80 cycles and given averaging

if cycles1==2 F=F2; end
if cycles1==3 F=F3; end
if cycles1==4 F=F4; end
if cycles1==5 F=F5; end
if cycles1==6 F=F6; end
if cycles1==7 F=F7; end
if cycles1==8 F=F8; end
if cycles1==9 F=(F8+F10)/2; end
if cycles1>=10 & cycles1<=40
    F=F10+((F40-F10)*(cycles1-10)/30); end
if cycles1>40 & cycles1<=80
    F=F40+((F80-F40)*(cycles1-40)/40); end
if cycles1>80 F=F80; end

r=sqrt((((2*(1-Coh12)).*F)./(dof1-2)).*(Gy12./Gx12));
H31=Gxy12./Gx12;		% transfer function calculation from frequency-averaged power spectra
Mag31=abs(H31);         % transfer function gain

MagUp1=Mag31+r;         % 95% confidence bands on Magnitude
MagDwn1=Mag31-r;
MagDwn1(find(MagDwn1<0))=0.0001;

Pha31=phase(H31)*180/pi;% transfer function phase


for zz = 1:11
    if zz == 1
        if Pha31(zz)>180;Pha31=Pha31-360;end;		
        if Pha31(zz)<-180;Pha31=Pha31+360;end;	
    else
        if abs(Pha31(zz)- Pha31(zz-1))> abs(Pha31(zz)+360- Pha31(zz-1))
            Pha31=Pha31+360;
        end
        if abs(Pha31(zz)- Pha31(zz-1))> abs(Pha31(zz)-360- Pha31(zz-1))    
            Pha31=Pha31-360;
        end
    end
end


    p=180/pi*asin(r./Mag31);
    PhaUp1=Pha31+p;     % 95% limits on Phase
    PhaDwn1=Pha31-p;
% % 			ms=65;hs=1.10;J=70; % mass, height, moment of inertia
% % 			mgh=ms*hs*9.81;
% %             TF=H31;
% %             Fd=f12;

%% Results Rot

TF.rot.tf = H31;
TF.rot.f = f12;
TF.rot.mag = Mag31;
TF.rot.magConf95 = r;
TF.rot.pha = Pha31;
TF.rot.phaConf95 = p;
TF.rot.coh = Coh12;

%%



if cycles3>1		% analyze trans data
    for k=2:cycles3

        [yi3,f3]=dft(stim3((startidx3+stimdel+(k-1)*N3):(startidx3+stimdel+k*N3+1)),100,50);	% amp spectra
        avgi3=avgi3+stim3((startidx3+stimdel+(k-1)*N3):(startidx3+stimdel+k*N3+1));
%                     [yi3,f3]=dft(prts3',100,50);	% amp spectra
% 					avgi3=avgi3+prts3';

        avgo3=avgo3+resp3((startidx3+(k-1)*N3):(startidx3+k*N3+1));
        [yo3,f3]=dft(resp3((startidx3+(k-1)*N3):(startidx3+k*N3+1)),100,50);	% COG pos amp spectrum

        Gxy3=conj(yi3).*yo3;	% raw cross power spectra
        Gx3=conj(yi3).*yi3;     % raw input power spectra
        Gy3=conj(yo3).*yo3;     % raw output power spectra

        yis3=yis3+yi3;					% summed amp spectra
        yos3=yos3+yo3;

        Gxys3=Gxys3+decimate2(Gxy3,2);	% summed power spectra
        Gxs3=Gxs3+decimate2(Gx3,2);
        Gys3=Gys3+decimate2(Gy3,2);

    end	%for k=1:cycles
end % if cycles3>1		% analyze trans data
avgi3=avgi3/(cycles3-1);	% average stimulus - just for looking at
avgo3=avgo3/(cycles3-1);	% average response

yis3=yis3/(cycles3-1);		% average amp spectra - just to look at
yos3=yos3/(cycles3-1);

Gxys3=Gxys3/(cycles3-1);	% average power spectra - just to look at
Gxs3=Gxs3/(cycles3-1);
Gys3=Gys3/(cycles3-1);

fs3=decimate2(f3,2);	% frequency of sample pts with stimulus energy (every other point for a PRTS signal)
yisd3=decimate2(yis3,2);
yosd3=decimate2(yos3,2);

fs32=decimate2(f3(2:50),2);		% frequency of sample pts without stimulus energy
yisd32=decimate2(yis3(2:50),2);	% abs(yisd2) should be essentially zero if you are doing things right
yosd32=decimate2(yos3(2:50),2);

f32=[fs3(1:2) mean(fs3(3:4)) mean(fs3(4:5)) mean(fs3(5:7)) mean(fs3(6:9)) mean(fs3(8:11)) mean(fs3(10:13)),...
    mean(fs3(12:16)) mean(fs3(16:20)) mean(fs3(20:25))];
yi32=[yis3(1:2) mean(yis3(3:4)) mean(yis3(4:5)) mean(yis3(5:7)) mean(yis3(6:9)) mean(yis3(8:11)) mean(yis3(10:13)),...
    mean(yis3(12:16)) mean(yis3(16:20)) mean(yis3(20:25))];
yo32=[yos3(1:2) mean(yos3(3:4)) mean(yos3(4:5)) mean(yos3(5:7)) mean(yos3(6:9)) mean(yos3(8:11)) mean(yos3(10:13)),...
    mean(yos3(12:16)) mean(yos3(16:20)) mean(yos3(20:25))];
Gxy32=[Gxys3(1:2) mean(Gxys3(3:4)) mean(Gxys3(4:5)) mean(Gxys3(5:7)) mean(Gxys3(6:9)) mean(Gxys3(8:11)) mean(Gxys3(10:13)),...
    mean(Gxys3(12:16)) mean(Gxys3(16:20)) mean(Gxys3(20:25))];
Gx32=[Gxs3(1:2) mean(Gxs3(3:4)) mean(Gxs3(4:5)) mean(Gxs3(5:7)) mean(Gxs3(6:9)) mean(Gxs3(8:11)) mean(Gxs3(10:13)),...
    mean(Gxs3(12:16)) mean(Gxs3(16:20)) mean(Gxs3(20:25))];
Gy32=[Gys3(1:2) mean(Gys3(3:4)) mean(Gys3(4:5)) mean(Gys3(5:7)) mean(Gys3(6:9)) mean(Gys3(8:11)) mean(Gys3(10:13)),...
    mean(Gys3(12:16)) mean(Gys3(16:20)) mean(Gys3(20:25))];
Coh32=(abs(Gxy32).^2)./(Gx32.*Gy32);	% Coherence based on BB position data
dof3=cycles3*2*[1,1,2,2,3,4,4,4,5,5,6];	% degrees of freedom used for confidence limit calculations
%
%  F dist 2,pts*cycles*2-2;alpha=0.05
%
if cycles3==2 F=F2; end
if cycles3==3 F=F3; end
if cycles3==4 F=F4; end
if cycles3==5 F=F5; end
if cycles3==6 F=F6; end
if cycles3==7 F=F7; end
if cycles3==8 F=F8; end
if cycles3==9 F=(F8+F10)/2; end
if cycles3>=10 & cycles1<=40
    F=F10+((F40-F10)*(cycles3-10)/30); end
if cycles3>40 & cycles3<=80
    F=F40+((F80-F40)*(cycles3-40)/40); end
if cycles3>80 F=F80; end

r=sqrt((((2*(1-Coh32)).*F)./(dof3-2)).*(Gy32./Gx32));
H33=Gxy32./Gx32;		% transfer function calculation from frequency-averaged power spectra
Mag33=abs(H33);         % transfer function gain

MagUp3=Mag33+r;         % 95% confidence bands on Magnitude
MagDwn3=Mag33-r;
MagDwn3(find(MagDwn3<0))=0.0001;

Pha33=phase(H33)*180/pi;% transfer function phase

for zz = 1:11
    if zz == 1
        if Pha33(zz)>180;Pha33=Pha33-360;end;		
        if Pha33(zz)<-180;Pha33=Pha33+360;end;	
    else
        if abs(Pha33(zz)- Pha33(zz-1))> abs(Pha33(zz)+360- Pha33(zz-1))
            Pha33=Pha33+360;
        end
        if abs(Pha33(zz)- Pha33(zz-1))> abs(Pha33(zz)-360- Pha33(zz-1))    
            Pha33=Pha33-360;
        end
    end
end

    p=180/pi*asin(r./Mag33);
    PhaUp3=Pha33+p;	% 95% limits on Phase
    PhaDwn3=Pha33-p;

%% Results

TF.trans.tf = H33;
TF.trans.f = f32;
TF.trans.mag = Mag33;
TF.trans.magConf95 = r;
TF.trans.pha = Pha33;
TF.trans.phaConf95 = p;
TF.trans.coh = Coh32;



    






