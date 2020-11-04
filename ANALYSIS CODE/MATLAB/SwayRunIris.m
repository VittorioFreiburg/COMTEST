%% SwayRun

close all
clear all 


global rotReize transReize
%% Values to be chosen

x1m = [6,29];     % welche Gruppen sollen angezeigt oder bearbeitet werden? 
                % mehrere mit , trennen 

neueDatei = [];     % falls nur eine neue Datei zum subject File kombiniert werden sollen, 
                    % Dateiname von zu erwartendem subject-Struktur-File eingeben
                    % d.h. Gruppe_Initialien_Datum   ohne a0/a1 und ohne Filen
                    % Beispiel: 'np_JB_120613'
gender = [];        % auch gender ('m'/'w') und Größe (hBody in Metern) eingeben
hBody = [];         % Anschließend neueDatei, Gender und hBody
                    % wieder auf '  =[];  ' einstellen

                            
% for calc =  hier einstellen, was Du machen möchtest: 
% 1:7 macht neue Berechnungen, ändert die Daten, aber warnt vorher (etwas nervig...)
% 11,12,13 zum Figures angucken
% falls 12 nicht funktioniert, nochmal 10 laufen lassen 
for calc =6:6;           
                    % 1 = combine2subjectFile --> immer einzeln ausführen
                   
                    % 2 = Analyse Raw Traces --> immer einzeln ausführen
                    %                        --> dauert relativ lange
                    
                    % 3 = UB-LB Differenz 
                    % 4 = Subject Mean & Subject Standard Deviation
                    % 5 = Subject Median
                    % 6 = Model
                    
                    % 7 = Powerspektrum Minus stimulierte Frequenzen
                    
                    % 10 = Fill Group Structures
                    % 11 = Single Subject Figures
                    % 12 = Group Figures
                    % 13 = Gruppen Raw Response Figures

% Welche Figures sollen gezeigt werden?
% if 0 no figure, if 1 displays figures
figOn.SpSw = 1;     
figOn.PRTS = 1;
figOn.UBLB = 0;
figOn.Model = 0;

newPlotInfo = [];       % wenn eine andere Farbkombination gewünscht ist, 
                        % farbe symbol linie - wie bei plot üblich angeben
                        % geht nur bei einer Gruppe gleichzeitig

                        
                        
                        
NParay = [2,29,30,35,34];% [12;2;3;21;22;23]; % Wer sind die Normalpersonen/Vergleichsgruppe für GF/Lag?

x2m = [1:2];        % Augen EO = 1, EC = 2, ECC = 3  :2

x3m = [0:9];        % Reiznummern 0,;%,1,9];%[0,1 2,3,5,6,8,9]0]2:9;

is1 = 1;

allesNeu = 1;
                            
ExSubjIni = ['x   SG';'np  SG'];

fBer_Hz = 5; % Frequenz Bereich für den Spontan Schwanken analysiert werden soll
fBer = fBer_Hz * 20;  

agePat = 0;    % Alter Patient -> nur VPs mit ähnl Alter als Vergleich
                % agePat = 0 -> egal welches Alter
ageSpan = 1;    % How many years +/- agePat are acceptable

exclude = 0;    % exclude = 1 -> exclude bad trials

PatIni = [];%   'NPakGL'; %  Gruppe + Initialien wenn man eine Versuchsperson den Gruppen gegenüberstellen möchte.

HDIni = [];     % Einzelner Huntington Patient von dem alle Messungen angezeigt werden sollen

check = 0;      % richtige Sortierung kontrollieren?
correction = 0; % if saved files have to be corrected

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Warnung
if calc <= 7
    display 'Warnung!!! Möchtest Du wirklich etwas überschreiben?'
    display 'dann drücke ENTER'
    display 'sonst drück schnell STRG und C gleichzeitig, am besten mehrfach'
    pause
end


%% Arrays 

rotReize    = [2 3 5 6 8 9];
transReize  = [4:9];

subjects = [];
subj = 'empty';
useSubj = 1;

load f12
load f32

JahrAmpReiz = [];
legende=[];

figNr = 1;

%% Counter

zl = 0;
zz = 0;

zeile = 0;
az = 1; % agelist Zähler

zCol = 1;
zSym = 1;
zLin = 1;
%% Which data set / subject group? -> Path to load data from 

% Dateistruktur:
%   Gruppe\
%       je a1(EO), a2 (EC) und a3(ECC) (auch leere Ordner)
%       Dateien in Ordner b0 - b9 
%       Program entscheidet ob  SpSw oder PRTS

pp1='D:\Data\';

for x1x = 1:length(x1m) ;     
    x1 = x1m(x1x);
    
% Path
    [pp2,plotInfo,iniGr]=pp2_plotInfo(x1);
    
    if sum(ismember (NParay,x1)) >= 1;
        gr = 2;
    end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% calc = 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    if calc == 1  % nur wenn je ein Subject File aus a und b Ordnern erstellt werden soll  

        for x2x = 1:length(x2m);       % eye   
            x2 = x2m(x2x);

            pp3=(['a',num2str(x2),'\']);

            % x3 = Reiznummer
            % 0 = Reize aus Kinetics Script 
            % 1-9 Reize aus PRTS Skript
            for x3x = 1:length(x3m) ;     
                x3 = x3m(x3x); 
                exes = [x1,x2,x3];
                
                pp4=(['b',num2str(x3),'\']);
                pp = ([pp1,pp2,pp3,pp4])
            
            


                wa=what(pp);
                wStruct=what([pp1,pp2]);
                l1 = size(wStruct.mat);
                if isempty (wa) == 1
                    continue
                elseif allesNeu == 1 || not(isempty(neueDatei))
                    
%                     display 'Achtung!!!!! Achtung!!!'
%                     display 'Du bist dabei eine Subject-Structur-Datei mit allen Auswertungen zu löschen'
%                     display 'Wenn Du das wirklich willst, halte das Programm an'
%                     display 'und kommentiere (%) das Wort Fehler, dass den Fehler verursacht aus'
%                     display 'klicke auf den unterstrichenen Teil der roten Fehlermeldung um dorthin zu kommen'
%                     
%                     Fehler
       
                    combine2SubjectFile(exes,pp,pp1,pp2,wa,iniGr,wStruct,neueDatei)
                end
            
             end % for x3
        end % for x2 
    end % if calc == 1 
% [ppG]=GeschlechterTrennung(gender);
% 
% eval(['save ',ppG,pp3,pp4,datname,' ',datname]) 


                
            
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Skripte, die nur auf subject-Gesamtfile beruhen %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% LOAD SUBJECT FILE
if not(calc==1)
    

    group = [];
    group.plotInfo = plotInfo;
    group.info.path = [pp1,pp2];
    
    wStruct=what([pp1,pp2]);
    l1 = size(wStruct.mat);

    for is = is1:l1(1) 
        
        sName=wStruct.mat{is};
        
        if isempty(neueDatei) == 0
            lnd = length(neueDatei);

            if strcmp(sName(1:lnd),neueDatei) == 0
                continue
            end
        end
        
        eval(['load ',pp1,pp2,sName]);
        datname=sName(1:length(sName)-4)

        subject.plotInfo = plotInfo;
        subjects = [subjects;subject.subjInfo.subjIni];
        
        if not(isfield(subject,'fileInfo')) || strcmp(subject.fileInfo.path,[pp1,pp2]) == 0   ;
           subject.fileInfo.path = [pp1,pp2];
           eval (['save ',pp1,pp2,sName,' subject'])
        end 
        
        if not(strcmp(subject.plotInfo.name,plotInfo.name))
            subject.plotInfo.name = plotInfo.name;
            eval (['save ',pp1,pp2,sName,' subject'])
        end
        
        subject.fileInfo.sName = eval(['sName']);
        eval (['save ',pp1,pp2,sName,' subject'])    
        

            
%% %%%%%%%%%% Calc = 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        if calc == 2 % Analyse Subject Files
            for x2x = 1:length(x2m);       % eye   
                x2 = x2m(x2x);
                for rNr = 1:9
                    for wdh = 1:2
                        if not(isempty(subject.eyes{x2}.reiz{rNr,wdh}.data))
                            % Spontanschwank-Analyse
                            [subject.eyes{x2}.reiz{rNr,wdh}.sponSway.UB]= SponSway2012(fBer,subject.eyes{x2}.reiz{rNr,wdh}.sponSway.UB);
                            [subject.eyes{x2}.reiz{rNr,wdh}.sponSway.LB]= SponSway2012(fBer,subject.eyes{x2}.reiz{rNr,wdh}.sponSway.LB);
                            [subject.eyes{x2}.reiz{rNr,wdh}.sponSway.COP]= SponSway2012(fBer,subject.eyes{x2}.reiz{rNr,wdh}.sponSway.COP);
                            [subject.eyes{x2}.reiz{rNr,wdh}.sponSway.COM]= SponSway2012(fBer,subject.eyes{x2}.reiz{rNr,wdh}.sponSway.COM);
                            [subject.eyes{x2}.reiz{rNr,wdh}.sponSway.Plattf]= SponSway2012(fBer,subject.eyes{x2}.reiz{rNr,wdh}.sponSway.Plattf);
                            [subject.eyes{x2}.reiz{rNr,wdh}.sponSway.angleUB]= SponSway2012(fBer,subject.eyes{x2}.reiz{rNr,wdh}.sponSway.angleUB);
                            [subject.eyes{x2}.reiz{rNr,wdh}.sponSway.angleLB]= SponSway2012(fBer,subject.eyes{x2}.reiz{rNr,wdh}.sponSway.angleLB);
                            [subject.eyes{x2}.reiz{rNr,wdh}.sponSway.angleCOM]= SponSway2012(fBer,subject.eyes{x2}.reiz{rNr,wdh}.sponSway.angleCOM);

                            
                            
                            if rNr >= 2 % PRTS-Analyse
                                load npPha
                                stim.rot = (subject.eyes{x2}.reiz{rNr,wdh}.data(:,38))*-1;
                                stim.trans = subject.eyes{x2}.reiz{rNr,wdh}.data(:,40);

                                data = subject.eyes{x2}.reiz{rNr,wdh};
                                ampRot = data.reizInfo.ampRot;
                                ampTrans = data.reizInfo.ampTrans;

                                [subject.eyes{x2}.reiz{rNr,wdh}.prts.angleUB] = PRTS2012(stim,data.sponSway.angleUB.raw,ampRot,ampTrans);
                                [subject.eyes{x2}.reiz{rNr,wdh}.prts.angleLB] = PRTS2012(stim,data.sponSway.angleLB.raw,ampRot,ampTrans);
                                [subject.eyes{x2}.reiz{rNr,wdh}.prts.angleCOM] = PRTS2012(stim,data.sponSway.angleCOM.raw,ampRot,ampTrans);

                                [subject.eyes{x2}.reiz{rNr,wdh}.prts.UB] = PRTS2012(stim,data.sponSway.UB.raw(:,1),ampRot,ampTrans);
                                [subject.eyes{x2}.reiz{rNr,wdh}.prts.LB] = PRTS2012(stim,data.sponSway.LB.raw(:,1),ampRot,ampTrans);
                                [subject.eyes{x2}.reiz{rNr,wdh}.prts.COM] = PRTS2012(stim,data.sponSway.COM.raw(:,1),ampRot,ampTrans);
                            end

                            %% Dauer Reize in Min
                            tll = length(subject.eyes{1}.reiz{rNr,1}.data);
                            subject.subjInfo.trialMinutes = tll/6000;
                            
                        end % not isempty wdh 
                    end % for wdh
                end % rNr           
            end  % x2 eye
            
            % Gewicht gemittelt aus 4? Spontanschwankbedingungen
            gewicht =[];
            for eye = 1:2
                for wdh = 1:2
                    if not(isempty(subject.eyes{eye}.reiz{1,wdh}.reizInfo))
                        gewicht = [gewicht;subject.eyes{eye}.reiz{1,wdh}.reizInfo.gewicht];
                    end
                end
            end

            subject.subjInfo.weight = mean(gewicht);
            
            
            if not(isempty(neueDatei))
                subject.subjInfo.gender = gender;
                subject.subjInfo.hBody = hBody;
           
                BMI = subject.subjInfo.weight/(hBody)^2;
                subject.subjInfo.BMI = BMI;
            end
        
            subject.fileInfo.executedScripts.SponSway2012= 1;
            subject.fileInfo.executedScripts.prts= 1;
            
            eval (['save ',pp1,pp2,sName,' subject'])           
        end %calc = 2
%% %%%%%%%%%% Ende Roh-Analyse %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%Anfang %%%%%%%%%%%%% UB-LB Differenzen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if calc == 3
            for eye = 1:2
                for rNr = 2:9
                    if not(isempty( subject.eyes{eye}.reiz{rNr,1}.reizInfo))
                        data = subject.eyes{eye}.reiz{rNr,1}.prts;
                        
                        [UBLB_diff,LBxUB] = UBLBdiff(data); 
                        subject.eyes{eye}.reiz{rNr,1}.prts.UBLBdiff = UBLB_diff;
                        subject.eyes{eye}.reiz{rNr,1}.prts.LBxUB = LBxUB;
                        
                        if not(isfield(subject.subjInfo,'trialMinutes'))
                            tll = length (subject.eyes{eye}.reiz{rNr,1}.data);
                            subject.subjInfo.trialMinutes = tll/6000;
                        end
                        
                     end
                end
            end

            subject.fileInfo.executedScripts.UBLBdiff = 1;
            
            eval (['save ',pp1,pp2,sName,' subject'])
        end
%%% Ende %%%%%%%%%%%%% UB-LB Differenzen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        

        
        
%% SubjectMean        
        if calc == 4 % SubjectMean
            [subject]=calcSubjMean(subject);
            
            subject.fileInfo.executedScripts.subjMean= 1;
            subject.fileInfo.executedScripts.subjSD= 1;
            
            eval (['save ',pp1,pp2,sName,' subject'])
        end
        
        
%% SubjectMedian        
        if calc == 5 % SubjectMedian       
            [subject]=calcSubjMedian(subject);
            
            subject.fileInfo.executedScripts.subjMedian= 1;
            
            eval (['save ',pp1,pp2,sName,' subject'])
        end
%% Modellierung
        if calc == 6 % Model 
            %% COM            
            markerText= 'angleCOM.';
            rotTransText = 'rot';

            reizNr = [2,5,8;3,6,9];

            for eye = 1:2
                eyeText = ['eyes{1,',num2str(eye),'}.'];
                for amp = 1:2 
                    if amp == 1
                       ampRot = 0.5;
                       ampText = '05';
                    elseif amp == 2
                       ampRot = 1;
                       ampText = '_1';
                    end

                    sammel = zeros(3,8); sammel (:,:) = NaN;
                    
                    for rNr = 1:3
                        reizText = ['reiz{',num2str(reizNr(amp,rNr)),',1}.'];            
                        eyeReizText = ['subject.',eyeText,reizText];
                        reizInfoText = [eyeReizText,'reizInfo.'];
                        
                        eval (['dateiFehlt = isempty(',eyeReizText,'reizInfo);']);
                        if not(dateiFehlt == 1)
                            
                % Variablen aus Struktur auslesen            
                            if isfield (reizInfoText,'hCOM') == 1
                                hs=eval([reizInfoText,'hCOM']);

                            else % falls hCOM nicht im Subject File gespeichert ist
                                hh = eval([reizInfoText,'h3;']); % Hüfthöhe
                                hs = eval([reizInfoText,'h2;']); % Schulterhöhe
                                data = eval([eyeReizText,'data']); % Roh Data

                                [COMx,angleCOM,hCOM] = COMcalculation(data,hh,hs);

                                eval([reizInfoText,'hCOM =',num2str(hCOM)]);
                                hs = hCOM;
                            end

                            hs = hs/100 ;% COM height
                            massText = 'gewicht';
                            ms=eval([reizInfoText,massText]); % mass                        
                            J=70; %moment of inertia
                            mgh=ms*hs*9.81;
            
                        
                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Model Start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% Model Singel Pendel COM Rotation %%%%%%%%%%%%%%%%%%

                            modelText = 'model.singelPendelCOMrot';

                            % für EinzelReiz
                            TF = eval([eyeReizText,'prts.',markerText,rotTransText,'.tf']);
                            Fd = eval([eyeReizText,'prts.',markerText,rotTransText,'.f']);

                            [ModelParas] = Model_SingelPendelCOMrotIris(Fd,TF,J,mgh,ms);

                            ModelParas.basis.hCOM = hCOM;
                            zielText = [eyeReizText,modelText];
                            eval([zielText,' = ModelParas;']);
                            clear ModelParas

                            eval(['sammel(',num2str(rNr),',:) =', zielText,'.paras.all;']);
                            
                            if not(isfield(subject.subjInfo,'trialMinutes'))
                                tll = eval(['length (',eyeReizText,'data);'])
                                subject.subjInfo.trialMinutes = tll/6000;
                            end
                            
                        end
                        % für SubjectMean
                        if rNr == 3
                            TF = eval(['subject.',eyeText,'subjMean.prts.',markerText,rotTransText,ampText,'.tf']);
                            Fd = eval(['subject.',eyeText,'subjMean.prts.',markerText,rotTransText,ampText,'.f']);

                            [ModelParas] = Model_SingelPendelCOMrotIris(Fd,TF,J,mgh,ms);

                            ModelParas.basis.hCOM = hCOM;
                            zielText = ['subject.',eyeText,'subjMean.',modelText,'.',rotTransText,ampText];

                            % SubjectMean aus Einzel-Reizwiederholungen statt neuem Fit
                            ModelParas.subjMeanParas.all = sammel;
                            ModelParas.subjMeanParas.mean = nanmean (sammel);
                            ModelParas.subjMeanParas.std = nanstd (sammel);


                            eval([zielText,' = ModelParas;']);
                            clear ModelParas
                        end
                    end
                end
            end
            
            subject.fileInfo.executedScripts.model= {'singelPendelCOMrot'};
            
            eval (['save ',pp1,pp2,sName,' subject'])
        end


%%Anfang %%%%%%%%%%%%% Powerspektrum ohne stimulierte Frequenzen %%%%%%%%%
        if calc == 7
            Reize = [2,3,4,7];
            wdh=1;
            for x2 = 1:2
                for rr = 1:4
                    rNr = Reize(rr);
                    
                    
                    stim.rot = (subject.eyes{x2}.reiz{rNr,wdh}.data(:,38))*-1;
                    stim.trans = subject.eyes{x2}.reiz{rNr,wdh}.data(:,40);

                    data = subject.eyes{x2}.reiz{rNr,wdh};
                    ampRot = data.reizInfo.ampRot;
                    ampTrans = data.reizInfo.ampTrans;
                    
                    [subject.eyes{x2}.reiz{rNr,wdh}.SponSwayMinusStim.angleCOM] = SpSw_Minus_Stimulus(stim,data.sponSway.angleCOM.raw,ampRot,ampTrans);

                    Sammel.eyes{x2}.reiz{rr}(:,is)=subject.eyes{x2}.reiz{rNr,wdh}.SponSwayMinusStim.angleCOM.ps;
                end
                
            end
            if is == l1(1)
                mark = [subject.plotInfo.color,subject.plotInfo.line];
                ff = subject.eyes{x2}.reiz{rNr,wdh}.SponSwayMinusStim.angleCOM.f;
                
                figure(figNr)
                subplot(2,2,1)
                loglog(ff,nanmean(Sammel.eyes{1}.reiz{1},2),mark)
                hold on
                xlabel ('f[Hz]')
                ylabel ('spectral Power')
                title ('COM 0.5° Rotation EO')
                
                subplot(2,2,2)
                loglog(ff,nanmean(Sammel.eyes{1}.reiz{2},2),mark)
                hold on
                xlabel ('f[Hz]')
                ylabel ('spectral Power')
                title ('COM 1° Rotation EO')
                
                subplot(2,2,3)
                loglog(ff,nanmean(Sammel.eyes{2}.reiz{1},2),mark)
                hold on
                xlabel ('f[Hz]')
                ylabel ('spectral Power')
                title ('COM 0.5° Rotation EC')
                
                subplot(2,2,4)
                loglog(ff,nanmean(Sammel.eyes{2}.reiz{2},2),mark)
                hold on
                xlabel ('f[Hz]')
                ylabel ('spectral Power')
                title ('COM 1° Rotation EC')
                
            end

            subject.fileInfo.executedScripts.SpSw_Minus_Stimulus = [2,3,4,7]
            
            eval (['save ',pp1,pp2,sName,' subject'])
        end
%%% Ende %%%%%%%%%%%%% Powerspektrum ohne stimulierte Frequenzen %%%%%%%%%        
        
        
        
        
        
        
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Figures   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if calc == 11 % Single Subject Plots

            figNr = 1;
            % individuelle Farben/Marker pro Subject kombinieren
            allColor = ['r';'g';'b';'c';'m';'y';'k'];
            allMarker = ['+';'o';'*';'.';'x';'s';'d';'^';'v';'>';'<';'p';'h'];
            fillMarker = ['o';'^';'p';'s';'>';'d';'v';'h';'<'];
            allLine = ['- ';'--';': ';'-.'];              

            plotInfo.color = allColor(zCol);
            plotInfo.marker = fillMarker(zSym);
            plotInfo.line = allLine(zLin,:);
            plotInfo.name = subject.subjInfo.subjIni;
            plotInfo.combi = [plotInfo.color,plotInfo.marker,plotInfo.line];
            subject.plotInfo = plotInfo;
            legende = [legende;plotInfo.name];

            if zCol<7; zCol=zCol+1; else zCol=1; end
            if zSym<9; zSym=zSym+1; else zSym=1; end
            if zLin<4; zLin=zLin+1; else zLin=1; end

%% Figures Spontanschwanken

            if figOn.SpSw == 1
                sText = 'subject.eyes{eye}.subjMean.sponSway.';
                errBar = 'subject.eyes{eye}.subjSD.sponSway.';


                mText = 'COP';
                [figNr] = plotSponSway(subject,sText,mText,legende,figNr,errBar);
                if is1 == l1(1)
                    figure(figNr-1)
                    for supl = 1:16
                        subplot(4,4,supl)
                        plot (0:5,0:5,'k:')
                    end
                end



                mText = 'UB';
                [figNr] = plotSponSway(subject,sText,mText,legende,figNr,errBar);
                if is == l1(1)
                    figure(figNr-1)
                    for supl = 1:16
                        subplot(4,4,supl)
                        plot (0:5,0:5,'k:')
                    end
                end

                mText = 'LB';
                [figNr] = plotSponSway(subject,sText,mText,legende,figNr,errBar);
                if is == l1(1)
                    figure(figNr-1)
                    for supl = 1:16
                        subplot(4,4,supl)
                        plot (0:5,0:5,'k:')
                    end
                end
            end  
            
%% PRTS

        if figOn.PRTS == 1
            sText = 'subject.eyes{eye}.subjMean.prts.';
            errBar = 'subject.eyes{eye}.subjSD.prts.';
            mText = 'UB';
            [figNr] = plotTransferfunktion(subject,sText,mText,legende,figNr,errBar);

            sText = 'subject.eyes{eye}.subjMean.prts.';
            errBar = 'subject.eyes{eye}.subjSD.prts.';
            mText = 'LB';
            [figNr] = plotTransferfunktion(subject,sText,mText,legende,figNr,errBar);

            sText = 'subject.eyes{eye}.subjMean.prts.';
            errBar = 'subject.eyes{eye}.subjSD.prts.';
            mText = 'COM';
            [figNr] = plotTransferfunktion(subject,sText,mText,legende,figNr,errBar);
        end
        
%% Figures Model 
            if figOn.Model == 1
                sText = 'subject.eyes{eye}.subjMean.model.singelPendelCOMrot';
                errBar = [];%'subject.eyes{eye}.sd.model.singelPendelCOMrot.';
                mText = 'COM';

                 [figNr] = plotModel(subject,sText,mText,legende,figNr,errBar);
            end
            
%% Figure UBLB       

            if figOn.UBLB == 1
                sText = 'subject.eyes{eye}.subjMean.prts';
                errBar = [];
                [figNr]=plotUBLB(subject,sText,legende,figNr,errBar);                
            end


%                 plotSingleSubj(subject,datname,is)
            
%             close all
display 'Pause! mit Enter  geht es weiter(evtl. erst auf Figure oder Command Window klicken)'
pause
        end

        if calc == 10 && isempty(neueDatei) == 1

            % if x1 == 5;                    
            %     [usefile,g] = HuntLoader (sName,HDIni);
            % else
            %     usefile = 1;
            % end %HuntLoader
            % if usefile == 1;




            group.info.subjects(is,:) = subject.subjInfo.subjIni;
            [group] = fillGroup(subject,is,l1,group);  
            
 
            if is == l1(1)
                
                if not(isempty(newPlotInfo))&& length(x1m)==1
                    group.plotInfo.combi = newPlotInfo;
                    group.plotInfo.color = newPlotInfo(1);
                    group.plotInfo.marker = newPlotInfo(2);
                    group.plotInfo.line = newPlotInfo(3:end);
                end
                
                gName = group.plotInfo.name;
                eval(['save ',gName,' group'])
            end
        end
        
        
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        if calc == 12       
            gName = group.plotInfo.name
            eval(['load ',gName])
            
            if not(isempty(newPlotInfo))&& length(x1m)==1
                group.plotInfo.combi = newPlotInfo;
                group.plotInfo.color = newPlotInfo(1);
                group.plotInfo.marker = newPlotInfo(2);
                group.plotInfo.line = newPlotInfo(3:end);

                eval(['save ',gName,' group'])
            end
            
            
            
            numSubj = size(group.info.subjects);
            if numSubj(1) == l1 (1)  
                
                subject = group;

                figNr = 1;
                legende = [legende;plotInfo.name];
                errBar =[];
                

                

%% Figures Spontanschwanken

                if figOn.SpSw == 1
                    sText = 'subject.eyes{eye}.mean.sponSway.';
                    errBar = 'subject.eyes{eye}.sd.sponSway.';


                    mText = 'COP';
                    [figNr] = plotSponSway(subject,sText,mText,legende,figNr,errBar);
                    figure(figNr-1)
                    for supl = 1:16
                        subplot(4,4,supl)
                        plot (0:5,0:5,'k:')
                    end



                    mText = 'UB';
                    [figNr] = plotSponSway(subject,sText,mText,legende,figNr,errBar);

                    figure(figNr-1)
                    for supl = 1:16
                        subplot(4,4,supl)
                        plot (0:5,0:5,'k:')
                    end

                    mText = 'LB';
                    [figNr] = plotSponSway(subject,sText,mText,legende,figNr,errBar);

                    figure(figNr-1)
                    for supl = 1:16
                        subplot(4,4,supl)
                        plot (0:5,0:5,'k:')
                    end
                end





%% Figures PRTS

                if figOn.PRTS == 1
                    sText = 'subject.eyes{eye}.mean.prts.';
                    errBar = 'subject.eyes{eye}.sd.prts.';


                    mText = 'UB';
                    [figNr] = plotTransferfunktion(group,sText,mText,legende,figNr,errBar);    

                    mText = 'LB';
                    [figNr] = plotTransferfunktion(group,sText,mText,legende,figNr,errBar); 

                    mText = 'COM';
                    [figNr] = plotTransferfunktion(group,sText,mText,legende,figNr,errBar); 
                end
%% Figures UBLB
                if figOn.UBLB == 1
                    sText = 'subject.eyes{eye}.mean.prts';
                    [figNr]=plotUBLB(group,sText,legende,figNr,errBar);                
                end
                
%% Figures Model 
                if figOn.Model == 1
                    sText = 'subject.eyes{eye}.mean.model.singelPendelCOMrot';
                    errBar = 'subject.eyes{eye}.sd.model.singelPendelCOMrot.';
                    mText = 'COM';

                     [figNr] = plotModel(group,sText,mText,legende,figNr,errBar);
                end
                
%%
                break % ohne alle Subject-Files im Ordner zu laden
            else
                display 'nicht alle Versuchspersonen in Gruppendatei erst calc == 10 ausführen'
                Fehler
            end
        end
         
%% plot Raw Response Figures       
        if calc == 13
                        
            for eye = 1:2
                Sammel.eyes{eye}.rot05.angleUB(:,is) = subject.eyes{eye}.reiz{2,1}.sponSway.angleUB.raw(1:6000,:);
                Sammel.eyes{eye}.rot05.angleLB(:,is) = subject.eyes{eye}.reiz{2,1}.sponSway.angleLB.raw(1:6000,:);            
                Sammel.eyes{eye}.rot05.stim(:,is) = subject.eyes{eye}.reiz{2,1}.data(1:6000,38)*-1;    

                Sammel.eyes{eye}.rot_1.angleUB(:,is) = subject.eyes{eye}.reiz{3,1}.sponSway.angleUB.raw(1:6000,:);
                Sammel.eyes{eye}.rot_1.angleLB(:,is) = subject.eyes{eye}.reiz{3,1}.sponSway.angleLB.raw(1:6000,:);            
                Sammel.eyes{eye}.rot_1.stim(:,is) = subject.eyes{eye}.reiz{3,1}.data(1:6000,38)*-1;    
            end
            
            if is == l1(1)
                legende = [legende;plotInfo.name;'zero'];
                mark = [plotInfo.color,plotInfo.line];
                [figNr] = plotRawResp(Sammel,figNr,mark,legende);
            end
            
        end
        
        
        
        
         save subjects subjects
    end    





end %not calc ==1
end % for xx (x1)
end % calc 1



