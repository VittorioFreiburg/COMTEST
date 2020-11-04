function check_sorting

%% Which data set / subject group? -> Path to load data from 

% Dateistruktur:
%   Gruppe\
%       je a1(EO), a2 (EC) und a3(ECC) (auch leere Ordner)
%       Dateien in Ordner b0 - b9 
%       Program entscheidet ob  SpSw oder PRTS


x1m = [80];     % Gruppen ,3,4,5,6,9];%
x1l = length (x1m);

x2m = [1:2];        % Augen EO = 1, EC = 2, ECC = 3
x2l = length (x2m);

x3m = [0:9];        % Reiznummern 0,;%,1,9];%[0,1 2,3,5,6,8,9]0]2:9;
x3l = length (x3m);

Reiztab = [ 1	0       0;
            2   0.5     0;
            3   1       0;
            4   0       0.8;
            5   0.5     0.8;
            6   1       0.8;
            7   0       1.5;
            8   0.5     1.5;
            9   1       1.5; ];
            


pp1='D:\Data\';

for x1x = 1:x1l ;     
    x1 = x1m(x1x);
    lsz = 1;
    
    [pp2,plotInfo,iniGr]=pp2_plotInfo(x1)
  
    for x2x = 1:x2l;       % eye   
        x2 = x2m(x2x);
        
        pp3=(['a',num2str(x2),'\']);
        
        % x3 = Reiznummer
        % 0 = Reize aus Kinetics Script 
        % 1-9 Reize aus PRTS Skript
        for x3x = 1:x3l ;     
            x3 = x3m(x3x);  
            pp4=(['b',num2str(x3),'\']);
        
            pp = ([pp1,pp2,pp3,pp4])
            wa=what(pp);

            if isempty (wa) == 1
                continue
            else 
                l1=length(wa.mat);
            end

        
%% load data  
            for is=1:l1
                fname=wa.mat{is};
                eval(['load ',pp,fname]);
                datname=fname(1:length(fname)-4)
                num=fname(1:6);


                eval(['hk = ',datname,'.info.h1;']); % Hüfte
                eval(['hs = ',datname,'.info.h2;']); % Schulter
                eval(['hh = ',datname,'.info.h3;']); % Kopf
                
                eval(['isfield (',datname,'.info,''age'');']);
                if ans == 1
                    eval(['age = ',datname,'.info.age;']); % Alter
                else
                    ans = 'no age'
                    [pp,fname]
                     pause
                end
                
                eval(['stim1=-',datname,'.data(:,38);']);   % rot
                eval(['stim3=',datname,'.data(:,40);']);    % trans
%                 eval(['ax=',datname,'.data(:,35);']);       % b2x=9,b3x=15,b4x=21,fx=31,ax=35
%                 eval(['b2x=',datname,'.data(:,9);']);       % b2x=9,b3x=15,b4x=21,fx=31,ax=35
                eval(['b4x=',datname,'.data(:,21);']);      % b2x=9,b3x=15,b4x=21,fx=31,ax=35       
                b4x = mean (abs(b4x));
                
                amptext1=(round((max(stim1)-min(stim1))*100))/100;
                stim3=stim3/1.77;
                amptext3=(round((max(stim3)-min(stim3))*100))/100;
                
                
                
        

%% Which amplitudes in which folder?
if x3 == 0
    x3=1;
end
                Rot = Reiztab(x3,2);
                Trans = Reiztab(x3,3);
                
                
%% if wrong folder show amplitudes, path and datname and make a pause
                ok = zeros (1,2);
                
                if Rot+Trans == 0 && amptext1 > 0.04  
                   [Rot, Trans]
                   [amptext1, amptext3]
                   pp
                   pause
                end
                    
                if Rot+Trans == 0 && amptext3 > 0.05
                   [Rot, Trans]
                   [amptext1, amptext3]
                   pp
                   pause
                end 
                
                if Rot-0.1 < amptext1 && amptext1 < Rot + 0.1
                    ok(1) = 1;
                else
                    [Rot,Trans]
                    [amptext1, amptext3]
                    pp
                    pause
                end
                if Trans-0.1 < amptext3 && amptext3 < Trans + 0.1
                    ok(2) = 1;
                else
                    [Rot,Trans]
                    [amptext1, amptext3]
                    pp
                    pause
                end
                
                if sum(ok) ~= 2
                    Difftab = zeros (9,4);
                    Difftab(:,1) = Reiztab(:,1);
                    Difftab(:,2) = Reiztab(:,2)-amptext1;
                    Difftab(:,3) = Reiztab(:,3)-amptext3;
                    Difftab(:,4) = abs(Difftab(:,2)+ Difftab(:,3));
                   
                    
                    for tt = 1:9
                        if Difftab(tt,4) == min(Difftab(:,4));
                            x3neu = tt;
                            break
                        end
                    end                               
                

%                     if ok(2) == 0
%                         for tt = 1:9
%                             if Reiztab(tt,3) == Rot
%                                 if Reiztab (tt,3)- 0.1 > amptext3 && amptext3 > Reiztab (tt,3)+ 0.1
%                                     x3neu = tt;
%                                     break
%                                 end
%                             end
%                         end
%                     end

%                     [amptext1;amptext3;b4x]
%                     ppNeu = pp(1:(length(pp))-2);
%                     speichern(lsz,:)= [ppNeu,num2str(x3neu),'\',fname];
%                     loeschen(lsz,:) = [pp,fname];
%                     lsz = lsz+1;
%                     eval(['save ',ppNeu,datname])
%                     pause
                    
                end
                
                
                
                if x3 <2 % Spontan Schwank Ordner
                    if amptext1 > 0.1 || amptext3 > 0.1
                        if b4x < 0.1
                            Achtung = 'Achtung - Plattform aus!'
%                             [amptext1;amptext3;b4x]
%                             [pp,fname]
                             pause
                        end
                    end
                end
                
                clear *_c_z
                clear *_c
            end
        end
    end
    
%     for i = 1:lsz-1
% %         datei = eval(['load ',loeschen(i,:)]);
%         pfad = (speichern(i,:));
% %         eval(['save ',pfad,' ',datei])
%     end
end


