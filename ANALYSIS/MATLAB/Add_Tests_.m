%%% Add_Tests
clear all

x1m = [9,10];     % Gruppe auswählen
anzahlBuchstabenGruppe = 3;
    
%% Tabellen Laden
% Excel Datei mit Namen TextTabelle im Ordner D:\DATA\ ohne Unterordner
% nur ein Tabellenblatt
% 1.Zeile mit Spalten-Überschriften
% 1.Spalte Gruppe
% 2.Spalte Initialien
% 3.Spalte Datum Zellen müssen als Text formatiert sein
% Inhalt genauso wie im Dateinamen, ohne Unterstriche
% 4.bis letzte Spalte Tests
% genaues beachten dieser Regeln ganz wichtig
% Matlab trennt die Datei in eine Text und eine Zahlen Variable

uiopen('D:\DATA\TestTabelle.xls',1)

display 'Erst ImportWizard bestätigen damit Datei importiert wird'
display 'dann ins Command Window klicken und Enter drücken damit es weiter geht'
pause 

fNames = textdata(2:end,:);
TestTabelle = data;
colLabels = textdata(1,4:end);                                        %    

%% Spalten Nummern angeben
% jeweils zwei Zahlen [AnfangTest, EndeTest] 
% nur von den Spalten mit den Tests 
% --> Matlab macht eine reine Zahlentabelle, 
% d.h. die erste Spalte des ersten Tests ist Spalte 1, 
% danach müsst ihr durchzählen (geht bei Excel ganz einfach)
% falls Test nicht existiert - kein Problem - leere Klammern [];

% Krankheitsspezifische Tests
    spDiseaseChar = [];     % Disease Characteristics Onset/ Years since Diagnosis /Genetics
    
    spUPDRS = [];           % UPDRS Parkinson
    spUHDRS = [];           % UHDRS Huntington
    spALSFRS = [];          % ALS FRS ALS
    spADHS = [];            % ADHS - Checkliste nach DSM-4
    spSPRS = [];            % Spastic Paraplegia Rating Scale
    spffbHR = [];           % ffb-H-R  Funktionsfragebogen Rückenschmerz    

  
% Neurologische / Nerventests    
    spNeuroSt = [];         % Neurologischer Status Neurochirurgie    
    spEPhys = [];           % Electrophysiologie
    spSensoOSG = [];        % Sensorik Sprunggelenk (Stimmgabeltest x/8)
    spPain = [];            % Schmerzskalen, z.B. VAS
    spASH = [];             % Ashworth Scale (Spasticity    
    spROM = [];             % ROM Range of Motion    
    
    % Balance/Gleichgewichtstests
    spBal = [];             % Balancetest
    spCTSIB = [];           % CTSIB Clinical Test for sensory Interaction in Balance
    spStandBal = [];        % Standing Balance nach Bohannon
    spSemiTandem = [];      % Semi Tandem Test
    spBBS = [];             % Berg Balance Scale
    
    % Motoriktests
    spTin = [];             % Tinetti / POMA
    spWMFT = [];            % Wolf Motor Function Test Lower Extremity
    spMAL = [];             % Motor Activity Log
    spTUG = [];             % Timed Up and Go
    sp5ch = [];             % 5-chair-Test
    spFRT = [];             % Functional Reach Test
    
    % Lokomotions/Gangtests
    spFAC = [];             % Functional Ambulatory Category
    sp10mG = [];            % 10 meter Gait  
    spGang_LB = [];         % Gang auf dem Laufband

    % Kognitive & Quality of Life Tests
    spMM = [];              % Mini Mental State Test
    spSF36 = [];            % SF36
    spBI = [];              % Barthel Index
    
    % Sturzrisiko Tests
    spFES = [];             % Falls Efficacy Scale
    spSR = [];              % Safety Rating - Wie sicher fühlen sie sich auf der Plattform
    spNFalls = [];          % Falls/Halten während der Posturographie    
    
   % Trainingsparameter
    spLBT = [];             % Laufband Training Parameter   
    
   % Psychofragebögen
    spAKV = [];             % Angstfragebogen allgemein
    spAngst = [];           % VAS zur Angst
    spBDI = [];             % Depression Screening
    
    spCAARSs =[];           % ADHS - CAARS ausführlich Selbstbeurteilung
    spCAARSo =[];           % ADHS - CAARS observer
    spWURS = [];            % ADHS - Kinheitsymptomatik
    
    
%% subject Files laden    
for x1x = 1:length(x1m) ;     
    x1 = x1m(x1x);
    
    pp1='D:\Data\';
    [pp2,plotInfo,iniGr]=pp2_plotInfo(x1);
    ppT = 'Tests\'; % Ordner in dem Tests gespeichert werden sollen    

    wStruct=what([pp1,pp2]);
    l1 = size(wStruct.mat);


     for is = 1:l1(1) 
        
        sName=wStruct.mat{is};
       
        eval(['load ',pp1,pp2,sName]);
        datname=sName(1:length(sName)-4)
        
        ll = size(fNames);
        
        for i = 1:ll (1)
            
            group = cell2mat(fNames(i,1));
            group = group(1:anzahlBuchstabenGruppe);
            ini = cell2mat(fNames(i,2));
            datum = cell2mat(fNames(i,3));        
            fNameSubj = [group,'_',ini,'_',datum,'.mat'];
            
            
            if strcmp (fNameSubj,sName) == 1
                
                % Krankheitsspezifische Tests
                if not(isempty(spDiseaseChar))
                    subject.tests.KrankheitsInfo.results = TestTabelle (i,spDiseaseChar(1):spDiseaseChar(2)); 
                    subject.tests.KrankheitsInfo.colLabel = colLabels (1,spDiseaseChar(1):spDiseaseChar(2));
                end 
                if not(isempty(spUPDRS))
                    subject.tests.UPDRS.results = TestTabelle (i,spUPDRS(1):spUPDRS(2)); 
                    subject.tests.UPDRS.colLabel = colLabels (1,spUPDRS(1):spUPDRS(2));
                end
                if not(isempty(spUHDRS))
                    subject.tests.UHDRS.results = TestTabelle (i,spUHDRS(1):spUHDRS(2));
                    subject.tests.UHDRS.colLabel = colLabels (1,spUHDRS(1):spUHDRS(2));
                end
                if not(isempty(spALSFRS))
                    subject.tests.ALS_FRS.results = TestTabelle (i,spALSFRS(1):spALSFRS(2)); 
                    subject.tests.ALS_FRS.colLabel = colLabels (1,spALSFRS(1):spALSFRS(2));
                end
                if not(isempty(spADHS))
                    subject.tests.ADHS.results = TestTabelle (i,spADHS(1):spADHS(2));
                    subject.tests.ADHS.colLabel = colLabels (1,spADHS(1):spADHS(2));
                end
                if not(isempty(spSPRS))
                    subject.tests.SPRS.results = TestTabelle (i,spSPRS(1):spSPRS(2)); 
                    subject.tests.SPRS.colLabel = colLabels (1,spSPRS(1):spSPRS(2));
                end       
                if not(isempty(spffbHR))
                    subject.tests.ffbRuecken.results = TestTabelle (i,spffbHR(1):spffbHR(2)); 
                    subject.tests.ffbRuecken.colLabel = colLabels (1,spffbHR(1):spffbHR(2));
                end
                
                % Neurologische Tests
                if not(isempty(spNeuroSt))
                    subject.tests.NeuroStatus_NCh.results = TestTabelle (i,spNeuroSt(1):spNeuroSt(2)); 
                    subject.tests.NeuroStatus_NCh.colLabel = colLabels (1,spNeuroSt(1):spNeuroSt(2));
                end
                if not(isempty(spEPhys))
                    subject.tests.EPhys.results = TestTabelle (i,spEPhys(1):spEPhys(2)); 
                    subject.tests.EPhys.colLabel = colLabels (1,spEPhys(1):spEPhys(2));
                end  
                if not(isempty(spSensoOSG))
                    subject.tests.SensoOSG.results = TestTabelle (i,spSensoOSG(1):spSensoOSG(2)); 
                    subject.tests.SensoOSG.colLabel = colLabels (1,spSensoOSG(1):spSensoOSG(2));
                end
                if not(isempty(spPain))
                    subject.tests.Pain.results = TestTabelle (i,spPain(1):spPain(2)); 
                    subject.tests.Pain.colLabel = colLabels (1,spPain(1):spPain(2));
                end
                if not(isempty(spASH))
                    subject.tests.ASH.results = TestTabelle (i,spASH(1):spASH(2)); 
                    subject.tests.ASH.colLabel = colLabels (1,spASH(1):spASH(2));
                end
                if not(isempty(spROM))
                    subject.tests.ROM.results = TestTabelle (i,spROM(1):spROM(2)); 
                    subject.tests.ROM.colLabel = colLabels (1,spROM(1):spROM(2));
                end
                
                % Balance Gleichgewichtstests
                if not(isempty(spBal))
                    subject.tests.Balance.results = TestTabelle (i,spBal(1):spBal(2)); 
                    subject.tests.Balance.colLabel = colLabels (1,spBal(1):spBal(2));
                end
                if not(isempty(spCTSIB))
                    subject.tests.CTSIB.results = TestTabelle (i,spCTSIB(1):spCTSIB(2)); 
                    subject.tests.CTSIB.colLabel = colLabels (1,spCTSIB(1):spCTSIB(2));
                end
                if not(isempty(spStandBal))
                    subject.tests.StandBal.results = TestTabelle (i,spStandBal(1):spStandBal(2)); 
                    subject.tests.StandBal.colLabel = colLabels (1,spStandBal(1):spStandBal(2));
                end
                if not(isempty(spSemiTandem))
                    subject.tests.SemiTandem.results = TestTabelle (i,spSemiTandem(1):spSemiTandem(2)); 
                    subject.tests.SemiTandem.colLabel = colLabels (1,spSemiTandem(1):spSemiTandem(2));
                end                
                if not(isempty(spBBS))
                    subject.tests.BergBalance.results = TestTabelle (i,spBBS(1):spBBS(2)); 
                    subject.tests.BergBalance.colLabel = colLabels (1,spBBS(1):spBBS(2)); 
                end
                
                % Motoriktests
                if not(isempty(spTin))
                    subject.tests.Tinetti_POMA.results = TestTabelle (i,spTin(1):spTin(2)); 
                    subject.tests.Tinetti_POMA.colLabel = colLabels (1,spTin(1):spTin(2));
                end
                if not(isempty(spWMFT))
                    subject.tests.WMFT.results = TestTabelle (i,spWMFT(1):spWMFT(2)); 
                    subject.tests.WMFT.colLabel = colLabels (1,spWMFT(1):spWMFT(2));
                end
                if not(isempty(spMAL))
                    subject.tests.MAL.results = TestTabelle (i,spMAL(1):spMAL(2)); 
                    subject.tests.MAL.colLabel = colLabels (1,spMAL(1):spMAL(2));
                end                
                if not(isempty(spTUG))
                    subject.tests.TUG.results = TestTabelle (i,spTUG(1):spTUG(2)); 
                    subject.tests.TUG.colLabel = colLabels (1,spTUG(1):spTUG(2));
                end
                if not(isempty(sp5ch))
                    subject.tests.fiveChair.results = TestTabelle (i,sp5ch(1):sp5ch(2));
                    subject.tests.fiveChair.colLabel = colLabels (1,sp5ch(1):sp5ch(2));
                end                
                if not(isempty(spFRT))
                    subject.tests.FRT.results = TestTabelle (i,spFRT(1):spFRT(2)); 
                    subject.tests.FRT.colLabel = colLabels (1,spFRT(1):spFRT(2));
                end
                
               
                % Lokomotions/Gangtests
                if not(isempty(spFAC))
                    subject.tests.FAC.results = TestTabelle (i,spFAC(1):spFAC(2)); 
                    subject.tests.FAC.colLabel = colLabels (1,spFAC(1):spFAC(2));
                end
                if not(isempty(sp10mG))
                    subject.tests.Gait10m.results = TestTabelle (i,sp10mG(1):sp10mG(2));
                    subject.tests.Gait10m.colLabel = colLabels (1,sp10mG(1):sp10mG(2));
                end
                if not(isempty(spGang_LB))
                    subject.tests.Gang_LB.results = TestTabelle (i,spGang_LB(1):spGang_LB(2)); 
                    subject.tests.Gang_LB.colLabel = colLabels (1,spGang_LB(1):spGang_LB(2));
                end 
                
                
                
                % Kognitive & Quality of Life Tests
                if not(isempty(spMM))
                    subject.tests.MiniMental.results = TestTabelle (i,spMM(1):spMM(2)); 
                    subject.tests.MiniMental.colLabel = colLabels (1,spMM(1):spMM(2));
                end
                if not(isempty(spSF36))
                    subject.tests.SF36.results = TestTabelle (i,spSF36(1):spSF36(2)); 
                    subject.tests.SF36.colLabel = colLabels (1,spSF36(1):spSF36(2));
                end
                if not(isempty(spBI))
                    subject.tests.BI.results = TestTabelle (i,spBI(1):spBI(2)); 
                    subject.tests.BI.colLabel = colLabels (1,spBI(1):spBI(2));
                end
                
                
                % Sturzrisiko Tests
                if not(isempty(spFES))
                    subject.tests.FES.results = TestTabelle (i,spFES(1):spFES(2)); 
                    subject.tests.FES.colLabel = colLabels (1,spFES(1):spFES(2));
                end
                if not(isempty(spSR))
                    subject.tests.safetyRating.results = TestTabelle (i,spSR(1):spSR(2));
                    subject.tests.safetyRating.colLabel = colLabels (1,spSR(1):spSR(2)); 
                end
                if not(isempty(spNFalls))
                    subject.tests.NFalls.results = TestTabelle (i,spNFalls(1):spNFalls(2)); 
                    subject.tests.NFalls.colLabel = colLabels (1,spNFalls(1):spNFalls(2));
                end              
                
             
                % Trainingsparameter
                if not(isempty(spLBT))
                    subject.tests.LBT.results = TestTabelle (i,spLBT(1):spLBT(2)); 
                    subject.tests.LBT.colLabel = colLabels (1,spLBT(1):spLBT(2));
                end
                
                
                % Psycho-Fragebögen
                if not(isempty(spAKV))
                    subject.tests.AKV.results = TestTabelle (i,spAKV(1):spAKV(2)); 
                    subject.tests.AKV.colLabel = colLabels (1,spAKV(1):spAKV(2));
                end
                if not(isempty(spAngst))
                    subject.tests.VAS_Angst.results = TestTabelle (i,spAngst(1):spAngst(2)); 
                    subject.tests.VAS_Angst.colLabel = colLabels (1,spAngst(1):spAngst(2));
                end
                if not(isempty(spBDI))
                    subject.tests.BDI.results = TestTabelle (i,spBDI(1):spBDI(2)); 
                    subject.tests.BDI.colLabel = colLabels (1,spBDI(1):spBDI(2));
                end
                if not(isempty(spCAARSs))
                    subject.tests.CAARSs.results = TestTabelle (i,spCAARSs(1):spCAARSs(2)); 
                    subject.tests.CAARSs.colLabel = colLabels (1,spCAARSs(1):spCAARSs(2));
                end
                if not(isempty(spCAARSo))
                    subject.tests.CAARSo.results = TestTabelle (i,spCAARSo(1):spCAARSo(2)); 
                    subject.tests.CAARSo.colLabel = colLabels (1,spCAARSo(1):spCAARSo(2));
                end
                if not(isempty(spWURS))
                    subject.tests.WURS.results = TestTabelle (i,spWURS(1):spWURS(2)); 
                    subject.tests.WURS.colLabel = colLabels (1,spWURS(1):spWURS(2));
                end
           
                
                eval (['save ',pp1,pp2,sName,' subject'])
                break
            elseif i == ll;
                display 'subject values not found'
                Fehler
            end
        end
     end
end
        
