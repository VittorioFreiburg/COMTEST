function [spSway]=SponSway2012(fBer,spSway)
%
% derived from SponSway
% Analyse des Spontanschwankens
%
% ohne laden, ohne Marker/ML Schleifen und 
% ohne Ergebnissein eine Sammeltabelle zu stecken
%
% stattdessen werden die Ergebnisse in einer Datei pro Subject und Messtag
% zusammengeführt unter
%
% sponSway
%   .dftPos und :dftVel = Fourriertransformierte Position und Velocity
%   .paras enthält alle Parameter sortiert nach
%       .sdf = Stabilogram Diffusion Function Werte
%       .pos = Positionsparameter
%       .vel = Velocityparameter
%       .freq= Frequenparameter
% 
%   Achtung bisher nur 
%       für einen Frequenzbereich -> 5Hz bei mehr evtl. Namen ändern. 
%       für bestimmte Kanäle, die von aussen übergeben werden, einfach zu
%       ändern
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ss = size (spSway.raw);

for chNr = 1:ss(2);
    difLength = ss(1)-6200;
    if difLength < 0
        display 'Achtung, Messdauer zu kurz!!!'
        display 'Datei kürzer 6200 Punkte'
        
        if difLength >=-200 % von 20 auf 200 erhöht
            for dL = 1:difLength*-1
                spSway.raw(ss(1)+dL,:)= spSway.raw(ss(1),:);
            end
            display 'Differenz gering, interpoliert'
        end
% pause
    end
                
    if length(spSway.raw(:,chNr))<6200; % zusätzliche Sicherheit
        cp = spSway.raw(:,chNr);
    else
        cp = spSway.raw(1:6200,chNr);
    end
    % cp ist jeder Marker, der analysiert werden soll 
    
    cp=cp-mean(cp);
%         gf1=3;gf2=41;
%         cp=sgolayfilt(cp,gf1,gf2);
%% FILTER
    if fBer <= 200              % 10 Hz filter only if no frequencies above 10 Hz are analysed
        [b,a]=butter(4,5/50);   % 10 Hz LP filter on stimulus velocity waveform
        cp=filtfilt(b,a,cp);
    end
%%
    cpv=(cp(2:end)-cp(1:end-1))*100;    % Velocity = difference between neighbouring points * Sampling Rate
    cpv=[cpv;cpv(end)];
%         cpv=sgolayfilt(cpv,gf1,gf2);
%         cgv=(cg(2:end)-cg(1:end-1))*100;
    rate=100;
    maxdt=1000;
    dt=(0:1/rate:(maxdt-1));			% form delta t vector
    dt(1:10);           %%???
    dr=zeros(size(dt));                 % form empty result vector
    n=max(size(cp));

    for ii=1:maxdt                       % calculate result
        cp2=cp(1:n-ii+1);
        dr(ii)=mean((cp(ii:n)-cp2).^2);   % units mm^2
    end
    drv=(dr(2:end)-dr(1:end-1));
    dra=(drv(2:end)-drv(1:end-1));
%     drnull=find(drv<0);
%     if drnull(1)>50;drnull=find(dra<0);end
%     if drnull(1)>200;drnull=200;end
    st=polyfit(dt(1:0.9*rate),dr(1:0.9*rate),1);
    lt=polyfit(dt(1*rate:maxdt),dr(1*rate:maxdt),1);
%     st=polyfit(dt(1:drnull(1)),dr(1:drnull(1)),1);
%     lt=polyfit(dt(2*rate:maxdt),dr(2*rate:maxdt),1);
    Ds=st(1)/2;		% diffusion coefficient is 1/2 of slope
    Dl=lt(1)/2;
    stf=polyval(st,dt);
    ltf=polyval(lt,dt);
    critdt=(lt(2)-st(2))/(st(1)-lt(1));	% critical point time (s)
    critx=st(1)*critdt+st(2);


%% Figure                       
%     figure(1)
%     %subplot(211),
%     plot(dt,dr); axis([0 10 0 1.5*max(dr)]);
%     plot(dt,dr,dt,stf,'r',dt,ltf,'r'); axis([0 maxdt/rate 0 1.5*max(dr)]);
%     s=['Ds= ',num2str(Ds),' Dl= ',num2str(Dl)];
%     text(1.5,0.9*1.5*max(dr),s);
%     s=['tc = ',num2str(critdt),' Xc= ',num2str(critx)];
%     text(1.5,0.1*1.5*max(dr),s);
%     ylabel('SDF (mm^2)');
%     pause


    n=max(size(cp));
    rms=sqrt(mean((cp-mean(cp)).^2));
    rmsv=sqrt(mean((cpv-mean(cpv)).^2));
    meanvel=mean(abs(cpv));
    area=max(cp)-min(cp);
    varea=max(cpv)-min(cpv);
    totex=sum(abs(cpv));
    areacc=1.645*rms;
    meandist=mean(abs(cp));
    meanfreq=meanvel/(4*sqrt(2)*meandist);
%     Gys=zeros(length(cp)/2000,fBer);
%     Gyvs=zeros(length(cp)/2000,fBer);
%     for ll=1:1
    for ll=1:length(cp)/2000
%         [yo,f]=dft1(cp((ll-1)*2000+1:(ll-1)*2000+2000),100,100);	% COP pos amp spectrum bis 5 Hz
        [yo,f]=dft1(cp((ll-1)*2000+1:(ll-1)*2000+2000),100,fBer);    % COP pos amp spectrum bis 20 Hz
%         Gy=(conj(yo).*yo)/(2*(f(2)-f(1)));	% raw output power spectra
        Gy=(conj(yo).*yo);	% raw output power spectra
        Gys(ll,:)=Gy;
%         [yov,f]=dft1(cpv((ll-1)*2000+1:(ll-1)*2000+2000),100,100);	% COP pos amp spectrum
        [yov,f]=dft1(cpv((ll-1)*2000+1:(ll-1)*2000+2000),100,fBer);	% COP pos amp spectrum
%         Gy=(conj(yo).*yo)/(2*(f(2)-f(1)));	% raw output power spectra
        Gyv=(conj(yov).*yov);	% raw output power spectra
        Gyvs(ll,:)=Gyv;
    end

    if (length(cp)/2000)> 2
        Gy=mean(Gys);
        Gyv=mean(Gyvs);
    end
    GyNb=(1:length(Gy(3:end)));


%% Powerspectrum Analysis Position

    totalpower=sum(Gy(3:end));
    totalpower2=sum(Gy(3:24));
    Gymom1=sum((GyNb*(f(2)-f(1))).*Gy(3:end));      % Summe der Frequenz*der Energie
    Gymom2=sum(((GyNb*(f(2)-f(1))).^2).*Gy(3:end)); % Summe der Frequenz zum Quadrat *der Energie
    fi=3;
    while sum(Gy(3:fi))<(totalpower*0.5);
        fi=fi+1;
    end
    powerfreq50=f(fi);
    fi=98;
    while sum(Gy(fi:98))<(totalpower*0.05);
        fi=fi-1;
    end
    powerfreq95=f(fi);
    centerfreq=sqrt(Gymom2/totalpower);
    freqdisp=sqrt(1-((Gymom1^2)/(totalpower*Gymom2)));

%% Powerspectrum Analysis Velocity
    GyNb=(1:length(Gyv(1:end)));

    totalpowerV=sum(Gyv(1:end));
    totalpowerV2=sum(Gyv(1:end));
    Gymom1=sum((GyNb*(f(2)-f(1))).*Gyv(1:end));
    Gymom2=sum(((GyNb*(f(2)-f(1))).^2).*Gyv(1:end));
    fi=3;
    while sum(Gyv(1:fi))<(totalpowerV*0.5);
        fi=fi+1;
    end
    powerfreq50V=f(fi);
    fi=98;
    while sum(Gyv(fi:end))<(totalpowerV*0.05);
        fi=fi-1;
    end
    powerfreq95V=f(fi);
    centerfreqV=sqrt(Gymom2/totalpowerV);
    freqdispV=sqrt(1-((Gymom1^2)/(totalpowerV*Gymom2)));
    
       
% fill in of values


    spSway.dftPos.yo(:,chNr) = yo;       
    spSway.dftPos.f (:,chNr) = f;
    spSway.dftPos.ps(:,chNr) = Gy;
  
    spSway.dftVel.yo(:,chNr) = yov;
    spSway.dftVel.f (:,chNr) = f;
    spSway.dftVel.ps(:,chNr) = Gyv;
    
    spSway.paras.sdf (:,chNr) = [critdt;critx;Ds;Dl];
    spSway.paras.pos (:,chNr) = [rms;meandist;area;totalpower];
    spSway.paras.vel (:,chNr) = [rmsv;meanvel;varea;totalpowerV;totex];
    spSway.paras.freq(:,chNr) = [powerfreq50;powerfreq95;centerfreq;freqdisp];
    
    
end % alle Kanäle

    spSway.fBerHz = fBer/20;
    spSway.paras.rowLabels.sdf = [{'critdt'};{'critx'};{'Ds'};{'Dl'}];
    spSway.paras.rowLabels.pos = [{'rms'};{'meanDist'};{'area'};{'totalPower'}];
    spSway.paras.rowLabels.vel = [{'rmsVel'};{'meanVel'};{'max-minVel'};{'totalPowerVel'};{'totalExcursion'}];
    spSway.paras.rowLabels.freq= [{'powerFreq50'};{'powerFreq95'};{'centerFreq'};{'freqDisp'}];
