function combine2SubjectFile(exes,pp,pp1,pp2,wa,iniGr,wStruct,neueDatei)


x2 = exes(2);
x3 = exes(3);

%% load data 

l1=length(wa.mat);

for is=1:l1
    fname=wa.mat{is};
    
    if isempty(neueDatei) == 0
        lnd = length(neueDatei);
        
        if strcmp(fname(1:lnd),neueDatei) == 0
            continue
        end
    end

    eval(['load ',pp,fname]);
    datname=fname(1:length(fname)-4);
    file = eval([datname]);



    eval(['hk = ',datname,'.info.h1;']); % Hüfte
    eval(['hs = ',datname,'.info.h2;']); % Schulter
    eval(['hh = ',datname,'.info.h3;']); % Kopf

    eval(['stim1=-',datname,'.data(:,38);']);   % rot
    eval(['stim3=',datname,'.data(:,40);']);    % trans

    eval(['LBx=',datname,'.data(:,15);']);% b2x=9,LBx=15,b4x=21,fx=31,ax=35
    eval(['b2x=',datname,'.data(:,9);']);% b2x=9,b3x=15,b4x=21,fx=31,ax=35

    h = hh*100;
    angleLB = 180/pi*asin((LBx)/h);

    UBx = b2x-LBx;
    h = (hs-hh)*100;
    angleUB = 180/pi*asin((UBx)/h);

    eval(['b4x=',datname,'.data(:,21);']);      % UBx=9,LBx=15,b4x=21,fx=31,ax=35

    ampRot=(round((max(stim1)-min(stim1))*100))/100;
    stim3=stim3/1.77;
    ampTrans=(round((max(stim3)-min(stim3))*100))/100;
    platext = max(b4x)-min(b4x);    


    % COM Berechnung

    [COMx,angleCOM,hCOM] = COMcalculation(file.data,hh,hs);
    
%% Subject Structure
    % Subject Info    
    [info,subjInfo,sName] = datnameDecomposition(fname,datname);
    subjIni = [iniGr,subjInfo.ini];


    if ismember([sName,'.mat'],wStruct.mat) 
        if x3==0 && x2 == 1
            subject = Make_Struct;
        else
            eval(['load ',pp1,pp2,sName]);
        end
    else
        subject = Make_Struct;
    end


    fz=file.data(:,33); % Gewicht = COP z
    % kgN = mean (fz) * 1000/(5 * 9.81)      % fz in kN -- 1kN = 5V
    mw_fz = mean (fz);
    kg = 0.048 * mw_fz + 0.103;
    file.info.gewicht = round(kg);

% find ReizNummer (check_sorting script)
%     [rNr,reizNr] = reizNummer (ampRot,ampTrans,platext,x3,datname,check);
if (not(x3==0))
    rNr = x3;
else 
    rNr = 1;
end


% Wie vielte Wiederholung des Reizes
if isempty(subject.eyes{x2}.reiz{rNr,1}.data)
    wdh = 1;
else
    wdh = 1;
    while not(isempty(subject.eyes{x2}.reiz{rNr,wdh}.data))
        if subject.eyes{x2}.reiz{rNr,wdh}.data(9,9) == file.data(9,9)
            break
        else
            wdh = wdh+1;
        end
    end
end


    subjInfo.iniGr = iniGr;
    subjInfo.subjIni = subjIni;
    subject.subjInfo = subjInfo;
    subject.subjInfo.hCOM = hCOM;
        

    reizInfo = file.info;
    reizInfo.ampRot = ampRot;
    reizInfo.ampTrans = ampTrans;
    reizInfo.length = length(subject.eyes{x2}.reiz{rNr,wdh}.data);
    reizInfo.trialNo = info.trialNo;
    reizInfo.path = pp;

    subject.eyes{x2}.reiz{rNr,wdh}.reizInfo = reizInfo;

    
    subject.eyes{x2}.reiz{rNr,wdh}.data = file.data; 
    subject.eyes{x2}.reiz{rNr,wdh}.channelLabels = file.columnlabels;
    
    
    
    subject.eyes{x2}.reiz{rNr,wdh}.sponSway.UB.raw = [file.data(:,9),file.data(:,8),file.data(:,7)];
    subject.eyes{x2}.reiz{rNr,wdh}.sponSway.LB.raw = [file.data(:,15),file.data(:,14),file.data(:,13)];
    subject.eyes{x2}.reiz{rNr,wdh}.sponSway.COP.raw = file.data(:,35:36);
    subject.eyes{x2}.reiz{rNr,wdh}.sponSway.COP.raw(:,3) = 0; %z Spalte mit Nullen füllen
    subject.eyes{x2}.reiz{rNr,wdh}.sponSway.COM.raw(:,1) = COMx;
    subject.eyes{x2}.reiz{rNr,wdh}.sponSway.Plattf.raw = [file.data(:,21),file.data(:,20),file.data(:,19)];
    
    subject.eyes{x2}.reiz{rNr,wdh}.sponSway.angleUB.raw = angleUB;
    subject.eyes{x2}.reiz{rNr,wdh}.sponSway.angleLB.raw = angleLB; 
    subject.eyes{x2}.reiz{rNr,wdh}.sponSway.angleCOM.raw = angleCOM; 
    
    subject.fileInfo.path = [pp1,pp2];
    subject.fileInfo.sName = 'sName';
    
    subject.fileInfo.executedScripts.combine2SubjectFile{rNr,x2} = (rNr);
     
    if rNr ==1 
        if wdh == 1
            subject.fileInfo.executedScripts.combine2SubjectFile{rNr,x2} = (rNr);
        else
            subject.fileInfo.executedScripts.combine2SubjectFile{10,x2} = (rNr);
        end
    end
    
    eval (['save ',pp1,pp2,sName,' subject'])

    clear *_c_z
    clear *_c 
    clear *_c_z_md
    clear *_c_md_z
    clear subject

end % for is
    

            
            
            
            
            
