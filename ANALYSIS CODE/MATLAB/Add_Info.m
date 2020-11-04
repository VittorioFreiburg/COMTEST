%Add_Info
clear all

x1m = [70:73];     % Gruppe auswählen
anzahlBuchstabenGruppe = 3;

%% Tabellen Laden
% .txt Dateien mit folgendem Namen,
% im Data/Gruppe/Tests Ordner (siehe Pfad=)

uiopen('C:\D\Data\GenderGroessePNPStudy_1_2.xls',1)
% uiopen('D:\DATA\GenderGroesseHunt.xls',1)

display 'Erst ImportWizard bestätigen damit Datei importiert wird'
display 'dann ins Command Window klicken und Enter drücken damit es weiter geht'
pause 

fNames = textdata(2:end,:);
genderGroesse = data;

%%
for x1x = 1:length(x1m) ;     
    x1 = x1m(x1x);
    
    pp1='C:\D\Data\';
    [pp2,plotInfo,iniGr]=pp2_plotInfo(x1);
    ppT = 'Tests\'; % Ordner in dem Tests gespeichert werden sollen
    




%% subject Files laden
    wStruct=what([pp1,pp2]);
    l1 = size(wStruct.mat);
    for is = 1:l1(1) 
        
        sName=wStruct.mat{is};
       
        eval(['load ',pp1,pp2,sName]);
        datname=sName(1:length(sName)-4)
        
        subject.fileInfo.path = [pp1,pp2];
        subject.fileInfo.sName = 'sName';
        
%         if not(isfield(subject.subjInfo,'weight'))
%             if x1 == 10 || x1 == 9
%                 load D:\DATA\HSP\alt\MatfuerGewicht\Gewicht.mat
%             end
%             eval(['weight = Gewicht.',subject.subjInfo.ini,';'])
%             subject.subjInfo.weight = weight;
%         end
        
        subject.subjInfo.age = [];
        subject.subjInfo.gender = [];
        subject.subjInfo.hBody = [];
        subject.subjInfo.hCOM = [];
        subject.subjInfo.BMI = [];
        
        
%% Gewicht gemittelt aus 4? Spontanschwankbedingungen
            gewicht =[];
            for eye = 1:2
                for wdh = 1:2
                    if not(isempty(subject.eyes{eye}.reiz{1,wdh}.reizInfo))
                        gewicht = [gewicht;subject.eyes{eye}.reiz{1,wdh}.reizInfo.gewicht];
                    end
                end
            end

            subject.subjInfo.weight = mean(gewicht);
        
%% gender & groesse
        for i = 1:length (genderGroesse)
            group = cell2mat(fNames(i,1));
%             group = group(1:anzahlBuchstabenGruppe);
            ini = cell2mat(fNames(i,2));
            datum = cell2mat(fNames(i,3));        
            fNameSubj = [group,'_',ini,'_',datum,'.mat'];
            
            if strcmp (sName,fNameSubj)==1
                
                genderNr = genderGroesse (i,1);
                
                if genderNr == 1
                    geschlecht = 'm';
                else
                    geschlecht = 'w';
                end
        
                subject.subjInfo.gender = geschlecht;
        
                hBody = genderGroesse (i,2);
                
                if hBody > 100
                    hBody = hBody/100;
                end

                subject.subjInfo.hBody = hBody;
                break
            elseif i == length (genderGroesse)
                
                display 'no matches in tabel with gender and size found for'
                sName
%                 Fehler

            end
        end
        
        
%% Infos aus einzel-Reizdateien rauslesen
        for rNr = 2:8
            if not(isempty (subject.eyes{2}.reiz{rNr,1}.reizInfo))
                subject.subjInfo.age = subject.eyes{2}.reiz{rNr,1}.reizInfo.age;
                if isfield(subject.eyes{2}.reiz{rNr,1}.reizInfo,'hCOM')
                    subject.subjInfo.hCOM = subject.eyes{2}.reiz{rNr,1}.reizInfo.hCOM;
                else
                    hh = subject.eyes{2}.reiz{rNr,1}.reizInfo.h3 +0.05;
                    hs = subject.eyes{2}.reiz{rNr,1}.reizInfo.h3 +0.05;
                    hCOM = (hh + 1/4*(hs-hh))*100;
                    subject.subjInfo.hCOM = hCOM;
                end
                
                %% Dauer Reize in Min
                tll = length(subject.eyes{2}.reiz{rNr,1}.data);
                subject.subjInfo.trialMinutes = tll/6000;

                break
            end
        end

        BMI = subject.subjInfo.weight/(hBody)^2;
        subject.subjInfo.BMI = BMI;
        
%% executed Scripts
        
        for x2 = 1:2 % eye
            for rNr = 1:9
                if not(isempty(subject.eyes{x2}.reiz{rNr,1}.data))

                    subject.fileInfo.executedScripts.combine2SubjectFile{rNr,x2} = (rNr);
                    
                    if isfield (subject.eyes{x2}.reiz{rNr,1}.sponSway.UB,'paras')
                        subject.fileInfo.executedScripts.SponSway2012= 1;
                    end
                    
                    if isfield (subject.eyes{x2}.reiz{rNr,1},'prts')
                        subject.fileInfo.executedScripts.prts= 1;
                    end

                    if isfield (subject.eyes{x2},'subjMean')
                        subject.fileInfo.executedScripts.subjMean= 1;
                        subject.fileInfo.executedScripts.subjSD= 1;
                    end
                    if isfield (subject.eyes{x2},'subjMedian')
                        subject.fileInfo.executedScripts.subjMedian= 1;
                    end
                    
                    if isfield (subject.eyes{x2}.reiz{rNr,1},'model')
                        subject.fileInfo.executedScripts.model= {'singelPendelCOMrot'};
                    end
                    
                end
                if rNr == 1 && not(isempty(subject.eyes{x2}.reiz{rNr,2}.data))
                    subject.fileInfo.executedScripts.combine2SubjectFile{10,x2} = (rNr);
                    if isfield (subject.eyes{x2}.reiz{rNr,2}.sponSway.UB,'paras')
                        subject.fileInfo.executedScripts.SponSway2012 = 1;
                    end
                end

            end
        end
        
       eval (['save ',pp1,pp2,sName,' subject'])

     end
end
        
