% GetTabels

close all
clear all 


load rotReize 
load transReize

load f12
load f32

%% Values to be chosen

%getMW =  0 = Einzelreize vs 1 = SubjMean        
                    
                    

x1m = [6];     % Gruppen ,3,4,5,6,9];%

x2m = [1:2];        % Augen EO = 1, EC = 2, ECC = 3  :2

x3m = [0:9];        % Reiznummern 

% Pfad wo Tabellen gespeichert werden sollen. Achtung: den Ordner muss es schon geben 
savePfad = 'D:\MATLAB\SWAY2012\Tabellen\ALStests\'; 

% in welcher Datei sind die Normalpersonen-Gruppen-Werte?
npFileName = 'NP.mat';

figOn.GFLag = 1;


is1 = 1;
%% empty arrays
subjects = [];
subjNr = 0;


SpSwTab = [];
SpSwTabAll = [];

PRTStabRot = [];
PRTStabTrans = [];
PRTStab = [];
PRTStabMW = [];


UBLBtab = [];
UBLBtabAll = [];

ModelTable = [];
ModelParasAll = [];

ModelTableMW = [];
ModelParas = [];

PairedModel = [];
PairedModelMW = [];

ModelStackedMW = [];


%%  vvvv %%%%%%  Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

%% ^^^^^ %%%%%%%%%%  Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Normalpersonen Vergleichsdaten laden

eval(['load ',npFileName])
NP = group;

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
    
    wStruct=what([pp1,pp2]);
    l1 = size(wStruct.mat);

    for is = is1:l1(1) 
        
        sName=wStruct.mat{is};
        eval(['load ',pp1,pp2,sName]);
        datname=sName(1:length(sName)-4)

        ls = size(subjects);
        if isempty (subjects) == 1
            subjects = [subjects;subject.subjInfo.subjIni];
            subjNr = 1;
        else
            for ss = 1:ls (1) 
                if strcmp (subjects(ss,:), subject.subjInfo.subjIni) == 1
                    subjNr = ss;
                    break
                elseif ss == ls(1)
                    subjects = [subjects;subject.subjInfo.subjIni];
                    subjNr = ls(1) + 1;
                end
            end
        end
        
        age = subject.subjInfo.age;
        weight = subject.subjInfo.weight;
        hBody = subject.subjInfo.hBody;
        hCOM = subject.subjInfo.hCOM;
        BMI = subject.subjInfo.BMI;
        gender = subject.subjInfo.gender;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alsTests = [subject.tests.ALS_FRS.results,...
            subject.tests.Balance.results,...
            subject.tests.BergBalance.results,...
            subject.tests.FAC.results,...
            subject.tests.fiveChair.results,...
            subject.tests.FRT.results,...
            subject.tests.Gait10m.results,...
            subject.tests.KrankheitsInfo.results,...
            subject.tests.SF36.results,...
            subject.tests.Tinetti_POMA.results,...
            subject.tests.TUG.results];

alsLabels = [subject.tests.ALS_FRS.colLabel,...
            subject.tests.Balance.colLabel,...
            subject.tests.BergBalance.colLabel,...
            subject.tests.FAC.colLabel,...
            subject.tests.fiveChair.colLabel,...
            subject.tests.FRT.colLabel,...
            subject.tests.Gait10m.colLabel,...
            subject.tests.KrankheitsInfo.colLabel,...
            subject.tests.SF36.colLabel,...
            subject.tests.Tinetti_POMA.colLabel,...
            subject.tests.TUG.colLabel];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        
        
        
        if strcmp(gender,'m')
            genderNr = 1;
        elseif strcmp (gender,'w')
            genderNr = 2;
        end
        
        trialMinutes = subject.subjInfo.trialMinutes; 
        
%         subjInfoPlus = [age,genderNr,weight,hBody,hCOM,BMI];

        for eye = 1:2
            
%%  vvvv %%%%%% SpSw Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
            rNr = 1;
            
            for marker = 1:4
                if marker == 1
                    mText = 'COP';
                elseif marker == 2
                    mText = 'LB';
                elseif marker == 3
                    mText = 'UB';
                elseif marker == 4
                    mText = 'COM';
                end

                for apml = 1:2
                    if apml == 2 && marker == 4
                        continue
                    end
                    for wdh = 1:2
                        if not(isempty(subject.eyes{eye}.reiz{rNr,wdh}.reizInfo))
                            ampRot = subject.eyes{eye}.reiz{rNr,wdh}.reizInfo.ampRot;

                            eval(['sdf = subject.eyes{eye}.reiz{rNr,wdh}.sponSway.',mText,'.paras.sdf(:,apml);'])
                            eval(['pos = subject.eyes{eye}.reiz{rNr,wdh}.sponSway.',mText,'.paras.pos(:,apml);'])
                            eval(['vel = subject.eyes{eye}.reiz{rNr,wdh}.sponSway.',mText,'.paras.vel(:,apml);'])
                            eval(['freq = subject.eyes{eye}.reiz{rNr,wdh}.sponSway.',mText,'.paras.freq(:,apml);'])

                            SpSwTabAll = [SpSwTabAll;...
                            x1,eye,rNr,subjNr,marker,wdh,ampRot,apml...
                            sdf',pos',vel',freq',...
                            age,genderNr,weight,hBody,hCOM,BMI];
                        end
                    end
                    
                    if not(isempty(subject.eyes{eye}.subjMean.sponSway));
                        ampRot = 0;
                        [datname,'  ', mText]
                        eval(['sdf = subject.eyes{eye}.subjMean.sponSway.',mText,'.paras.sdf(:,apml);'])
                        eval(['pos = subject.eyes{eye}.subjMean.sponSway.',mText,'.paras.pos(:,apml);'])
                        eval(['vel = subject.eyes{eye}.subjMean.sponSway.',mText,'.paras.vel(:,apml);'])
                        eval(['freq = subject.eyes{eye}.subjMean.sponSway.',mText,'.paras.freq(:,apml);'])


                        SpSwTab = [SpSwTab;...
                            x1,eye,rNr,subjNr,marker,trialMinutes,ampRot,apml...
                            sdf',pos',vel',freq',...
                            age,genderNr,weight,hBody,hCOM,BMI,alsTests];     
                    end
                    
                end
            end                        
%% ^^^^^ %%%%%%%%%% SpSw Tabels
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
               
            for rNr = 2:9;  % ReizNummer
                wdh = 1;
                if not(isempty(subject.eyes{eye}.reiz{rNr,1}.reizInfo))
                    ampRot = subject.eyes{eye}.reiz{rNr,1}.reizInfo.ampRot;
                    ampTrans = subject.eyes{eye}.reiz{rNr,1}.reizInfo.ampTrans;
                        
                        
%%  vvvv %%%%%%  PRTS Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
                    for marker = 2:4
                        if marker == 2
                            mText = 'angleLB';
                        elseif marker == 3
                            mText = 'angleUB';
                        elseif marker == 4
                            mText = 'angleCOM';
                        end

                        if ismember(rNr,rotReize) == 1

                            eval(['mag = subject.eyes{eye}.reiz{rNr,1}.prts.',mText,'.rot.mag;'])
                            eval(['pha = subject.eyes{eye}.reiz{rNr,1}.prts.',mText,'.rot.pha;'])
                            eval(['coh = subject.eyes{eye}.reiz{rNr,1}.prts.',mText,'.rot.coh;'])
        
                            % GF & Lag nicht einfach m�glich

                            PRTStabRot = [PRTStabRot;...
                                x1,eye,rNr,subjNr,marker,ampRot,ampTrans,trialMinutes,...
                                mag,pha,coh,mean(mag),mean(pha),mean(coh),...
                                age,genderNr,weight,hBody,hCOM,BMI,alsTests];
                        end
                        
                        

                        if ismember(rNr,transReize) == 1
                            
                            if marker == 2
                                mText = 'LB';
                            elseif marker == 3
                                mText = 'UB';
                            elseif marker == 4
                                mText = 'COM';
                            end

                            eval(['mag = subject.eyes{eye}.reiz{rNr,1}.prts.',mText,'.trans.mag;'])
                            eval(['pha = subject.eyes{eye}.reiz{rNr,1}.prts.',mText,'.trans.pha;'])
                            eval(['coh = subject.eyes{eye}.reiz{rNr,1}.prts.',mText,'.trans.coh;'])
                            
                            % GF & Lag nicht einfach m�glich

                            PRTStabTrans = [PRTStabTrans;...
                                x1,eye,rNr,subjNr,marker,ampRot,ampTrans,trialMinutes,...
                                mag,pha,coh,mean(mag),mean(pha),mean(coh),...
                                age,genderNr,weight,hBody,hCOM,BMI,alsTests];
                        end
                    end


%% ^^^^^ %%%%%%%%%% PRTS Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%  vvvv %%%%%%  UBLB Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

                        marker = 23;
                        if ismember(rNr,rotReize) == 1                                        
                            UBLBtabAll = [UBLBtabAll;...
                                x1,eye,rNr,subjNr,marker,ampRot,ampTrans,trialMinutes,...
                                subject.eyes{eye}.reiz{rNr,1}.prts.UBLBdiff.rot.mag,...
                                subject.eyes{eye}.reiz{rNr,1}.prts.UBLBdiff.rot.pha,...
                                mean(subject.eyes{eye}.reiz{rNr,1}.prts.UBLBdiff.rot.mag),...
                                mean(subject.eyes{eye}.reiz{rNr,1}.prts.UBLBdiff.rot.pha),...
                                subject.eyes{eye}.reiz{rNr,1}.prts.LBxUB.rot.mag,...
                                subject.eyes{eye}.reiz{rNr,1}.prts.LBxUB.rot.pha,...
                                mean(subject.eyes{eye}.reiz{rNr,1}.prts.LBxUB.rot.mag),...
                                mean(subject.eyes{eye}.reiz{rNr,1}.prts.LBxUB.rot.pha),...
                                age,genderNr,weight,hBody,hCOM,BMI,alsTests];
                         end
   
                         if ismember(rNr,transReize) == 1                                        
                            UBLBtabAll = [UBLBtabAll;...
                                x1,eye,rNr,subjNr,marker,ampRot,ampTrans,trialMinutes,...
                                subject.eyes{eye}.reiz{rNr,1}.prts.UBLBdiff.trans.mag,...
                                subject.eyes{eye}.reiz{rNr,1}.prts.UBLBdiff.trans.pha,...
                                mean(subject.eyes{eye}.reiz{rNr,1}.prts.UBLBdiff.trans.mag),...
                                mean(subject.eyes{eye}.reiz{rNr,1}.prts.UBLBdiff.trans.pha),...
                                subject.eyes{eye}.reiz{rNr,1}.prts.LBxUB.trans.mag,...
                                subject.eyes{eye}.reiz{rNr,1}.prts.LBxUB.trans.pha,...
                                mean(subject.eyes{eye}.reiz{rNr,1}.prts.LBxUB.trans.mag),...
                                mean(subject.eyes{eye}.reiz{rNr,1}.prts.LBxUB.trans.pha),...
                                age,genderNr,weight,hBody,hCOM,BMI,alsTests];
                         end



%% ^^^^^ %%%%%% UBLB Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


                    if ampRot > 0.1 && not(rNr == 1) % PRTS mit Rotation
                        ampRot = fix(ampRot*10)/10;
                            
                            
%%  vvvv %%%%%% Model Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        ModelTable = [ModelTable;...
                            x1,eye,rNr,subjNr,4,ampRot,...
                            subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.hCOM,...
                            subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.mass,...
                            real(subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.TF),... 
                            imag(subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.TF),...
                            abs(subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.TF),...
                            phase(subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.TF)*180/pi,...
                            subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.paras.all,...
                            age,genderNr,weight,hBody,hCOM,BMI,alsTests...
                            ];
                        ModelParasAll = [ModelParasAll;...
                            x1,eye,rNr,subjNr,4,ampRot,0,0,...
                            subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.hCOM,...
                            subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.mass,...
                            subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.paras.all,...
                            age,genderNr,weight,hBody,hCOM,BMI,alsTests...
                            ];
                        PairedModel = [PairedModel;...
                            x1,eye,rNr,subjNr,4,ampRot,...
                            subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.hCOM,...
                            subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.mass,...
                            real(subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.TF),... 
                            real(subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.paras.modelTF),...
                            imag(subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.basis.TF),...
                            imag(subject.eyes{eye}.reiz{rNr,1}.model.singelPendelCOMrot.paras.modelTF),...
                            age,genderNr,weight,hBody,hCOM,BMI,alsTests...
                            ];

                    end
                end
            end
                
%%  vvvv %%%%%% PRTS Tabel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
            for marker = 2:4
                if marker == 2
                    mText = 'angleLB';
                elseif marker == 3
                    mText = 'angleUB';
                elseif marker == 4
                    mText = 'angleCOM';
                end

                % SubjMean
                eval(['mag05 = subject.eyes{eye}.subjMean.prts.',mText,'.rot05.mag;'])
                eval(['pha05 = subject.eyes{eye}.subjMean.prts.',mText,'.rot05.pha;'])
                eval(['coh05 = subject.eyes{eye}.subjMean.prts.',mText,'.rot05.coh;'])
                eval(['mag_1 = subject.eyes{eye}.subjMean.prts.',mText,'.rot_1.mag;'])
                eval(['pha_1 = subject.eyes{eye}.subjMean.prts.',mText,'.rot_1.pha;'])
                eval(['coh_1 = subject.eyes{eye}.subjMean.prts.',mText,'.rot_1.coh;'])

                % NP values
                eval(['NPmag05 = NP.eyes{eye}.mean.prts.',mText,'.rot05.mag;'])
                eval(['NPpha05 = NP.eyes{eye}.mean.prts.',mText,'.rot05.pha;'])
                
                gf05 = mag05./NPmag05;
                tPha05 = pha05./360.*f12;
                NPtPha05 = NPpha05./360.*f12;
                lag05 = tPha05 - NPtPha05;

                eval(['NPmag_1 = NP.eyes{eye}.mean.prts.',mText,'.rot_1.mag;'])
                eval(['NPpha_1 = NP.eyes{eye}.mean.prts.',mText,'.rot_1.pha;'])

                gf_1 = mag_1./NPmag_1;
                tPha_1 = pha_1./360.*f12;
                NPtPha_1 = NPpha_1./360.*f12;
                lag_1 = tPha_1 - NPtPha_1;
                
                
                
                PRTStabMW = [PRTStabMW;...
                    x1,eye,258,subjNr,marker,0.5,ampTrans,trialMinutes,...
                    mag05,pha05,coh05,mean(mag05),mean(pha05),mean(coh05),...
                    gf05,lag05,tPha05,mean(gf05),mean(gf05(1:5)),mean(gf05(7:11)),...
                    mean(lag05),mean(lag05(1:5)),mean(lag05(7:11)),mean(tPha05),...
                    age,genderNr,weight,hBody,hCOM,BMI,alsTests;...
                    x1,eye,369,subjNr,marker,1,ampTrans,trialMinutes,...
                    mag_1,pha_1,coh_1,mean(mag_1),mean(pha_1),mean(coh_1),...
                    gf_1,lag_1,tPha_1,mean(gf_1),mean(gf_1(1:5)),mean(gf_1(7:11)),...
                    mean(lag_1),mean(lag_1(1:5)),mean(lag_1(7:11)),mean(tPha_1),...
                    age,genderNr,weight,hBody,hCOM,BMI,alsTests];

                
                
                
                % SubjMedian

                eval(['mag05 = subject.eyes{eye}.subjMedian.prts.',mText,'.rot05.mag;'])
                eval(['pha05 = subject.eyes{eye}.subjMedian.prts.',mText,'.rot05.pha;'])
                eval(['coh05 = subject.eyes{eye}.subjMedian.prts.',mText,'.rot05.coh;'])
                eval(['mag_1 = subject.eyes{eye}.subjMedian.prts.',mText,'.rot_1.mag;'])
                eval(['pha_1 = subject.eyes{eye}.subjMedian.prts.',mText,'.rot_1.pha;'])
                eval(['coh_1 = subject.eyes{eye}.subjMedian.prts.',mText,'.rot_1.coh;'])

               
                
                PRTStab = [PRTStab;...
                    x1,eye,258,subjNr,marker,0.5,ampTrans,trialMinutes,...
                    mag05,pha05,coh05,mean(mag05),mean(pha05),mean(coh05),...
                    age,genderNr,weight,hBody,hCOM,BMI,alsTests;...
                    x1,eye,369,subjNr,marker,1,ampTrans,trialMinutes,...
                    mag_1,pha_1,coh_1,mean(mag_1),mean(pha_1),mean(coh_1),...
                    age,genderNr,weight,hBody,hCOM,BMI,alsTests];


                if marker == 2
                    mText = 'LB';
                elseif marker == 3
                    mText = 'UB';
                elseif marker == 4
                    mText = 'COM';
                end

                % SubjMean
                eval(['mag08 = subject.eyes{eye}.subjMean.prts.',mText,'.trans08.mag;'])
                eval(['pha08 = subject.eyes{eye}.subjMean.prts.',mText,'.trans08.pha;'])
                eval(['coh08 = subject.eyes{eye}.subjMean.prts.',mText,'.trans08.coh;'])
                eval(['mag15 = subject.eyes{eye}.subjMean.prts.',mText,'.trans15.mag;'])
                eval(['pha15 = subject.eyes{eye}.subjMean.prts.',mText,'.trans15.pha;'])
                eval(['coh15 = subject.eyes{eye}.subjMean.prts.',mText,'.trans15.coh;'])
                
                
                % NP values
                eval(['NPmag08 = NP.eyes{eye}.mean.prts.',mText,'.trans08.mag;'])
                eval(['NPpha08 = NP.eyes{eye}.mean.prts.',mText,'.trans08.pha;'])
                
                gf08 = mag08./NPmag08;
                tPha08 = pha08./360.*f12;
                NPtPha08 = NPpha08./360.*f12;
                lag08 = tPha08 - NPtPha08;

                eval(['NPmag15 = NP.eyes{eye}.mean.prts.',mText,'.trans15.mag;'])
                eval(['NPpha15 = NP.eyes{eye}.mean.prts.',mText,'.trans15.pha;'])

                gf15 = mag15./NPmag15;
                tPha15 = pha15./360.*f12;
                NPtPha15 = NPpha15./360.*f12;
                lag15 = tPha15 - NPtPha15;
                
                

                PRTStabMW = [PRTStabMW;...
                    x1,eye,456,subjNr,marker,100,0.8,trialMinutes,...
                    mag08,pha08,coh08,mean(mag08),mean(pha08),mean(coh08),...
                    gf08,lag08,tPha08,mean(gf08),mean(gf08(1:5)),mean(gf08(7:11)),...
                    mean(lag08),mean(lag08(1:5)),mean(lag08(7:11)),mean(tPha08),...
                    age,genderNr,weight,hBody,hCOM,BMI,alsTests;...
                    x1,eye,789,subjNr,marker,100,1.5,trialMinutes,...
                    mag15,pha15,coh15,mean(mag15),mean(pha15),mean(coh15),...
                    gf15,lag15,tPha15,mean(gf15),mean(gf15(1:5)),mean(gf15(7:11)),...
                    mean(lag15),mean(lag15(1:5)),mean(lag15(7:11)),mean(tPha15),...
                    age,genderNr,weight,hBody,hCOM,BMI,alsTests];

               
                
                % SubjMedian
                eval(['mag08 = subject.eyes{eye}.subjMedian.prts.',mText,'.trans08.mag;'])
                eval(['pha08 = subject.eyes{eye}.subjMedian.prts.',mText,'.trans08.pha;'])
                eval(['coh08 = subject.eyes{eye}.subjMedian.prts.',mText,'.trans08.coh;'])
                eval(['mag15 = subject.eyes{eye}.subjMedian.prts.',mText,'.trans15.mag;'])
                eval(['pha15 = subject.eyes{eye}.subjMedian.prts.',mText,'.trans15.pha;'])
                eval(['coh15 = subject.eyes{eye}.subjMedian.prts.',mText,'.trans15.coh;'])

                PRTStab = [PRTStab;...
                    x1,eye,456,subjNr,marker,100,0.8,trialMinutes,...
                    mag08,pha08,coh08,mean(mag08),mean(pha08),mean(coh08),...                    
                    age,genderNr,weight,hBody,hCOM,BMI,alsTests;...
                    x1,eye,789,subjNr,marker,100,1.5,trialMinutes,...
                    mag15,pha15,coh15,mean(mag15),mean(pha15),mean(coh15),...                    
                    age,genderNr,weight,hBody,hCOM,BMI,alsTests];


                clear mag*
                clear pha*
                clear coh*
            end   
%% ^^^^^ %%%%%%%%%% PRTS Tabel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                 
%%  vvvv %%%%%%  UBLB Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                
            marker = 23;                                          
            UBLBtab = [UBLBtab;...
                x1,eye,258,subjNr,marker,100,0.5,trialMinutes,...
                subject.eyes{eye}.subjMean.prts.UBLBdiff.rot05.mag,...
                subject.eyes{eye}.subjMean.prts.UBLBdiff.rot05.pha,...
                mean(subject.eyes{eye}.subjMean.prts.UBLBdiff.rot05.mag),...
                mean(subject.eyes{eye}.subjMean.prts.UBLBdiff.rot05.pha),...
                subject.eyes{eye}.subjMean.prts.LBxUB.rot05.mag,...
                subject.eyes{eye}.subjMean.prts.LBxUB.rot05.pha,...
                mean(subject.eyes{eye}.subjMean.prts.LBxUB.rot05.mag),...
                mean(subject.eyes{eye}.subjMean.prts.LBxUB.rot05.pha),...
                age,genderNr,weight,hBody,hCOM,BMI,alsTests;...                    
                x1,eye,369,subjNr,marker,100,1,trialMinutes,...
                subject.eyes{eye}.subjMean.prts.UBLBdiff.rot_1.mag,...
                subject.eyes{eye}.subjMean.prts.UBLBdiff.rot_1.pha,...
                mean(subject.eyes{eye}.subjMean.prts.UBLBdiff.rot_1.mag),...
                mean(subject.eyes{eye}.subjMean.prts.UBLBdiff.rot_1.pha),...
                subject.eyes{eye}.subjMean.prts.LBxUB.rot_1.mag,...
                subject.eyes{eye}.subjMean.prts.LBxUB.rot_1.pha,...
                mean(subject.eyes{eye}.subjMean.prts.LBxUB.rot_1.mag),...
                mean(subject.eyes{eye}.subjMean.prts.LBxUB.rot_1.pha),...
                age,genderNr,weight,hBody,hCOM,BMI,alsTests;...                    
                x1,eye,456,subjNr,marker,100,0.8,trialMinutes,...
                subject.eyes{eye}.subjMean.prts.UBLBdiff.trans08.mag,...
                subject.eyes{eye}.subjMean.prts.UBLBdiff.trans08.pha,...
                mean(subject.eyes{eye}.subjMean.prts.UBLBdiff.trans08.mag),...
                mean(subject.eyes{eye}.subjMean.prts.UBLBdiff.trans08.pha),...
                subject.eyes{eye}.subjMean.prts.LBxUB.trans08.mag,...
                subject.eyes{eye}.subjMean.prts.LBxUB.trans08.pha,...
                mean(subject.eyes{eye}.subjMean.prts.LBxUB.trans08.mag),...
                mean(subject.eyes{eye}.subjMean.prts.LBxUB.trans08.pha),...
                age,genderNr,weight,hBody,hCOM,BMI,alsTests;...                    
                x1,eye,789,subjNr,marker,100,1.5,trialMinutes,...
                subject.eyes{eye}.subjMean.prts.UBLBdiff.trans15.mag,...
                subject.eyes{eye}.subjMean.prts.UBLBdiff.trans15.pha,...
                mean(subject.eyes{eye}.subjMean.prts.UBLBdiff.trans15.mag),...
                mean(subject.eyes{eye}.subjMean.prts.UBLBdiff.trans15.pha),...
                subject.eyes{eye}.subjMean.prts.LBxUB.trans15.mag,...
                subject.eyes{eye}.subjMean.prts.LBxUB.trans15.pha,...
                mean(subject.eyes{eye}.subjMean.prts.LBxUB.trans15.mag),...
                mean(subject.eyes{eye}.subjMean.prts.LBxUB.trans15.pha),...
                age,genderNr,weight,hBody,hCOM,BMI,alsTests];
                
%% ^^^^^ %%%%%% UBLB Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


            


                
%%  vvvv %%%%%% Model Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ModelTableMW = [ModelTableMW;...
                x1,eye,258,subjNr,4,0.5,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.hCOM,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.mass,...
                real(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.TF),... 
                imag(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.TF),...
                abs(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.TF),...
                phase(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.TF)*180/pi,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.paras.all,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.subjMeanParas.mean,...
                age,genderNr,weight,hBody,hCOM,BMI,alsTests;...
                x1,eye,369,subjNr,4,1,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.hCOM,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.mass,...
                real(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.TF),... 
                imag(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.TF),...
                abs(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.TF),...
                phase(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.TF)*180/pi,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.paras.all,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.subjMeanParas.mean,...
                age,genderNr,weight,hBody,hCOM,BMI,alsTests...
                ];
%                 ModelParas = [ModelParas;...
%                     x1,eye,258,subjNr,4,0.5,0,0,...
%                     subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.paras.all,...
%                     subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.mass,...
%                     subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.hCOM...
%                    age,genderNr,weight,hBody,hCOM,BMI,alsTests;...
%                     x1,eye,369,subjNr,4,1,0,0,...
%                     subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.paras.all,...
%                     subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.mass,...
%                     subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.hCOM,...
%                     age,genderNr,weight,hBody,hCOM,BMI,alsTests...
%                     ];
            ModelParas = [ModelParas;...
                x1,eye,258,subjNr,4,0.5,0,trialMinutes,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.subjMeanParas.mean,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.mass,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.hCOM,...
                age,genderNr,weight,hBody,hCOM,BMI,alsTests;...
                x1,eye,369,subjNr,4,1,0,trialMinutes,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.subjMeanParas.mean,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.mass,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.hCOM,...
                age,genderNr,weight,hBody,hCOM,BMI,alsTests...
                ];

            PairedModelMW = [PairedModelMW;...
                x1,eye,258,subjNr,4,0.5,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.hCOM,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.mass,...
                real(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.TF),... 
                real(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.paras.modelTF),... 
                imag(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.TF),...
                imag(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.paras.modelTF),...
                age,genderNr,weight,hBody,hCOM,BMI,alsTests;...
                x1,eye,369,subjNr,4,1,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.hCOM,...
                subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.mass,...
                real(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.TF),...
                real(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.paras.modelTF),... 
                imag(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.TF),...
                imag(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.paras.modelTF),...
                age,genderNr,weight,hBody,hCOM,BMI,alsTests...
                ];

                for ff = 1:11
                    ModelStackedMW = [ModelStackedMW;...
                    x1,eye,258,subjNr,4,0.5,...
                    subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.hCOM,...
                    subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.mass,...
                    real(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.TF(ff)),... 
                    real(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.paras.modelTF(ff)),... 
                    imag(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.TF(ff)),...
                    imag(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.paras.modelTF(ff)),...
                    subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot05.basis.f(ff),...
                    age,genderNr,weight,hBody,hCOM,BMI,alsTests;...
                    x1,eye,369,subjNr,4,1,...
                    subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.hCOM,...
                    subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.mass,...
                    real(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.TF(ff)),...
                    real(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.paras.modelTF(ff)),... 
                    imag(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.TF(ff)),...
                    imag(subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.paras.modelTF(ff)),...
                    subject.eyes{eye}.subjMean.model.singelPendelCOMrot.rot_1.basis.f(ff),...
                    age,genderNr,weight,hBody,hCOM,BMI,alsTests...
                    ];   
                end

%%^^^^^ %%%%%%%%%% Model Tabels %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        end
    end
end

eval(['save ',savePfad, 'subjects.mat subjects'])

eval(['save ',savePfad, 'SpSwTab SpSwTab'])
eval(['save ',savePfad, 'SpSwTab.txt SpSwTab -ascii'])

eval(['save ',savePfad, 'SpSwTabAll SpSwTabAll'])
eval(['save ',savePfad, 'SpSwTabAll.txt SpSwTabAll -ascii'])

eval(['save ',savePfad, 'PRTStab PRTStab']) % SubjMedian
eval(['save ',savePfad, 'PRTStab.txt PRTStab -ascii'])

eval(['save ',savePfad, 'PRTStabMW PRTStabMW'])
eval(['save ',savePfad, 'PRTStabMW.txt PRTStabMW -ascii'])

eval(['save ',savePfad, 'PRTStabRot PRTStabRot'])
eval(['save ',savePfad, 'PRTStabRot.txt PRTStabRot -ascii'])
eval(['save ',savePfad, 'PRTStabTrans PRTStabTrans'])
eval(['save ',savePfad, 'PRTStabTrans.txt PRTStabTrans -ascii'])

eval(['save ',savePfad, 'UBLBtabAll UBLBtabAll'])
eval(['save ',savePfad, 'UBLBtabAll.txt UBLBtabAll -ascii'])

eval(['save ',savePfad, 'UBLBtab UBLBtab'])
eval(['save ',savePfad, 'UBLBtab.txt UBLBtab -ascii'])

eval(['save ',savePfad, 'ModelTable ModelTable'])
eval(['save ',savePfad, 'ModelTable.txt ModelTable -ascii'])

eval(['save ',savePfad, 'ModelParasAll ModelParasAll'])
eval(['save ',savePfad, 'ModelParasAll.txt ModelParasAll -ascii'])

eval(['save ',savePfad, 'ModelTableMW ModelTableMW'])
eval(['save ',savePfad, 'ModelTableMW.txt ModelTableMW -ascii'])

eval(['save ',savePfad, 'ModelParas ModelParas'])
eval(['save ',savePfad, 'ModelParas.txt ModelParas -ascii'])

eval(['save ',savePfad, 'PairedModel PairedModel'])
eval(['save ',savePfad, 'PairedModel.txt PairedModel -ascii'])

eval(['save ',savePfad, 'PairedModelMW PairedModelMW'])
eval(['save ',savePfad, 'PairedModelMW.txt PairedModelMW -ascii'])

eval(['save ',savePfad, 'ModelStackedMW ModelStackedMW'])
eval(['save ',savePfad, 'ModelStackedMW.txt ModelStackedMW -ascii'])


