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

uiopen('D:\DATA\TestTabelleHSP.xls',1)

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
    spDiseaseChar = [4,6];      % Disease Characteristics Onset/ Years since Diagnosis /Genetics
    
    spUPDRS = [];           % UPDRS Parkinson
    spUHDRS = [];           % UHDRS Huntington
    spALSFRS = [];          % ALS FRS ALS
    spADHS = [];            % ADHS
    spSPRS = [54,67];            % Spastic Paraplegia Rating Scale
    spffbHR = [];           % ffb-H-R  Funktionsfragebogen Rückenschmerz    
 
% Neurologische / Nerventests    
    spNeuroSt = [];         % Neurologischer Status Neurochirurgie    
    spEPhys = [2,3];           % Electrophysiologie
    spSensoOSG = [1,1];        % Sensorik Sprunggelenk (Stimmgabeltest x/8)
    spASH = [15,18];             % Ashworth Scale (Spasticity    
    spROM = [23,43];            % ROM Range of Motion    
    
    % Balance/Gleichgewichtstests
    spBal = [];             % Balancetest
    spCTSIB = [];           % CTSIB Clinical Test for sensory Interaction in Balance
    spStandBal = [19,19];       % Standing Balance nach Bohannon
    spSemiTandem = [20,20];       % Semi Tandem Test
    spBBS = [];                 % Berg Balance Scale
    
    % Motoriktests
    spTin = [44,46];             % Tinetti / POMA
    spWMFT = [8,11];            % Wolf Motor Function Test Lower Extremity
    spMAL = [12,14];             % Motor Activity Log
    spTUG = [47,48];             % Timed Up and Go
    sp5ch = [21,22];             % 5-chair-Test
    spFRT = [];             % Functional Reach Test
    
    % Lokomotions/Gangtests
    spFAC = [];             % Functional Ambulatory Category
    sp10mG = [];            % 10 meter Gait  
    spGang_LB = [71,82];         % Gang auf dem Laufband

    % Kognitive & Quality of Life Tests
    spMM = [];              % Mini Mental State Test
    spSF36 = [];            % SF36
    spBI = [49,49];              % Barthel Index
    
    % Sturzrisiko Tests
    spFES = [];             % Falls Efficacy Scale
    spSR = [];              % Safety Rating - Wie sicher fühlen sie sich auf der Plattform
    spNFalls = [68,70];          % Falls/Halten während der Posturographie    
    
   % Trainingsparameter
    spLBT = [50,53];             % Laufband Training Parameter   
    
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
                    subject.tests.KrankheitsInfo.info = colLabels (1,spDiseaseChar(1):spDiseaseChar(2));
                end 
                if not(isempty(spUPDRS))
                    subject.tests.UPDRS.results = TestTabelle (i,spUPDRS(1):spUPDRS(2)); 
                    subject.tests.UPDRS.info = colLabels (1,spUPDRS(1):spUPDRS(2));
                end
                if not(isempty(spUHDRS))
                    subject.tests.UHDRS.results = TestTabelle (i,spUHDRS(1):spUHDRS(2));
                    subject.tests.UHDRS.info = colLabels (1,spUHDRS(1):spUHDRS(2));
                end
                if not(isempty(spALSFRS))
                    subject.tests.ALS_FRS.results = TestTabelle (i,spALSFRS(1):spALSFRS(2)); 
                    subject.tests.ALS_FRS.info = colLabels (1,spALSFRS(1):spALSFRS(2));
                end
                if not(isempty(spADHS))
                    subject.tests.ADHS.results = TestTabelle (i,spADHS(1):spADHS(2));
                    subject.tests.ADHS.info = colLabels (1,spADHS(1):spADHS(2));
                end
                if not(isempty(spSPRS))
                    subject.tests.SPRS.results = TestTabelle (i,spSPRS(1):spSPRS(2)); 
                    subject.tests.SPRS.info = colLabels (1,spSPRS(1):spSPRS(2));
                end       
                if not(isempty(spffbHR))
                    subject.tests.ffbRuecken.results = TestTabelle (i,spffbHR(1):spffbHR(2)); 
                    subject.tests.ffbRuecken.info = colLabels (1,spffbHR(1):spffbHR(2));
                end
                
                % Neurologische Tests
                if not(isempty(spNeuroSt))
                    subject.tests.NeuroStatus_NCh.results = TestTabelle (i,spNeuroSt(1):spNeuroSt(2)); 
                    subject.tests.NeuroStatus_NCh.info = colLabels (1,spNeuroSt(1):spNeuroSt(2));
                end
                if not(isempty(spEPhys))
                    subject.tests.EPhys.results = TestTabelle (i,spEPhys(1):spEPhys(2)); 
                    subject.tests.EPhys.info = colLabels (1,spEPhys(1):spEPhys(2));
                end  
                if not(isempty(spSensoOSG))
                    subject.tests.SensoOSG.results = TestTabelle (i,spSensoOSG(1):spSensoOSG(2)); 
                    subject.tests.SensoOSG.info = colLabels (1,spSensoOSG(1):spSensoOSG(2));
                end
                if not(isempty(spASH))
                    subject.tests.ASH.results = TestTabelle (i,spASH(1):spASH(2)); 
                    subject.tests.ASH.info = colLabels (1,spASH(1):spASH(2));
                end
                if not(isempty(spROM))
                    subject.tests.ROM.results = TestTabelle (i,spROM(1):spROM(2)); 
                    subject.tests.ROM.info = colLabels (1,spROM(1):spROM(2));
                end
                
                % Balance Gleichgewichtstests
                if not(isempty(spBal))
                    subject.tests.Balance.results = TestTabelle (i,spBal(1):spBal(2)); 
                    subject.tests.Balance.info = colLabels (1,spBal(1):spBal(2));
                end
                if not(isempty(spCTSIB))
                    subject.tests.CTSIB.results = TestTabelle (i,spCTSIB(1):spCTSIB(2)); 
                    subject.tests.CTSIB.info = colLabels (1,spCTSIB(1):spCTSIB(2));
                end
                if not(isempty(spStandBal))
                    subject.tests.StandBal.results = TestTabelle (i,spStandBal(1):spStandBal(2)); 
                    subject.tests.StandBal.info = colLabels (1,spStandBal(1):spStandBal(2));
                end
                if not(isempty(spSemiTandem))
                    subject.tests.SemiTandem.results = TestTabelle (i,spSemiTandem(1):spSemiTandem(2)); 
                    subject.tests.SemiTandem.info = colLabels (1,spSemiTandem(1):spSemiTandem(2));
                end                
                if not(isempty(spBBS))
                    subject.tests.BergBalance.results = TestTabelle (i,spBBS(1):spBBS(2)); 
                    subject.tests.BergBalance.info = colLabels (1,spBBS(1):spBBS(2)); 
                end
                
                % Motoriktests
                if not(isempty(spTin))
                    subject.tests.Tinetti_POMA.results = TestTabelle (i,spTin(1):spTin(2)); 
                    subject.tests.Tinetti_POMA.info = colLabels (1,spTin(1):spTin(2));
                end
                if not(isempty(spWMFT))
                    subject.tests.WMFT.results = TestTabelle (i,spWMFT(1):spWMFT(2)); 
                    subject.tests.WMFT.info = colLabels (1,spWMFT(1):spWMFT(2));
                end
                if not(isempty(spMAL))
                    subject.tests.MAL.results = TestTabelle (i,spMAL(1):spMAL(2)); 
                    subject.tests.MAL.info = colLabels (1,spMAL(1):spMAL(2));
                end                
                if not(isempty(spTUG))
                    subject.tests.TUG.results = TestTabelle (i,spTUG(1):spTUG(2)); 
                    subject.tests.TUG.info = colLabels (1,spTUG(1):spTUG(2));
                end
                if not(isempty(sp5ch))
                    subject.tests.fiveChair.results = TestTabelle (i,sp5ch(1):sp5ch(2));
                    subject.tests.fiveChair.info = colLabels (1,sp5ch(1):sp5ch(2));
                end                
                if not(isempty(spFRT))
                    subject.tests.FRT.results = TestTabelle (i,spFRT(1):spFRT(2)); 
                    subject.tests.FRT.info = colLabels (1,spFRT(1):spFRT(2));
                end
                
               
                % Lokomotions/Gangtests
                if not(isempty(spFAC))
                    subject.tests.FAC.results = TestTabelle (i,spFAC(1):spFAC(2)); 
                    subject.tests.FAC.info = colLabels (1,spFAC(1):spFAC(2));
                end
                if not(isempty(sp10mG))
                    subject.tests.Gait10m.results = TestTabelle (i,sp10mG(1):sp10mG(2));
                    subject.tests.Gait10m.info = colLabels (1,sp10mG(1):sp10mG(2));
                end
                if not(isempty(spGang_LB))
                    subject.tests.Gang_LB.results = TestTabelle (i,spGang_LB(1):spGang_LB(2)); 
                    subject.tests.Gang_LB.info = colLabels (1,spGang_LB(1):spGang_LB(2));
                end 
                
                
                
                % Kognitive & Quality of Life Tests
                if not(isempty(spMM))
                    subject.tests.MiniMental.results = TestTabelle (i,spMM(1):spMM(2)); 
                    subject.tests.MiniMental.info = colLabels (1,spMM(1):spMM(2));
                end
                if not(isempty(spSF36))
                    subject.tests.SF36.results = TestTabelle (i,spSF36(1):spSF36(2)); 
                    subject.tests.SF36.info = colLabels (1,spSF36(1):spSF36(2));
                end
                if not(isempty(spBI))
                    subject.tests.BI.results = TestTabelle (i,spBI(1):spBI(2)); 
                    subject.tests.BI.info = colLabels (1,spBI(1):spBI(2));
                end
                
                
                % Sturzrisiko Tests
                if not(isempty(spFES))
                    subject.tests.FES.results = TestTabelle (i,spFES(1):spFES(2)); 
                    subject.tests.FES.info = colLabels (1,spFES(1):spFES(2));
                end
                if not(isempty(spSR))
                    subject.tests.safetyRating.results = TestTabelle (i,spSR(1):spSR(2));
                    subject.tests.safetyRating.info = colLabels (1,spSR(1):spSR(2)); 
                end
                if not(isempty(spNFalls))
                    subject.tests.NFalls.results = TestTabelle (i,spNFalls(1):spNFalls(2)); 
                    subject.tests.NFalls.info = colLabels (1,spNFalls(1):spNFalls(2));
                end              
                
             
                % Trainingsparameter
                if not(isempty(spLBT))
                    subject.tests.LBT.results = TestTabelle (i,spLBT(1):spLBT(2)); 
                    subject.tests.LBT.info = colLabels (1,spLBT(1):spLBT(2));
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
        
