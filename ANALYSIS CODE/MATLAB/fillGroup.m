function [group]=fillGroup(subject,is,l1,group);
%
%% Spontanschwanken
rNr = 1;
for eye = 1:2
    
    if isfield(subject.eyes{eye},'mean') || isfield(subject.eyes{eye},'subjMean')
        if not(isfield(subject.eyes{eye}.subjMean, 'sponSway'))
            ['no spontaneous Sway for ',subject.subjInfo.subjIni,'_',subject.subjInfo.date, ' eye=',num2str(eye)]
        else    
            data = subject.eyes{eye}.subjMean.sponSway;
            % fieldnames ausnutzen
            % body part
            fn1=fieldnames(data); 
            lfn1 = size (fn1);
            for fn1z = 1:lfn1(1);
                fn1Text = cell2mat(fn1(fn1z));
                % dft/paras
                fn2=eval(['fieldnames(data.',fn1Text,')']);
                for fn2z = 1:3;
                    fn2Text = cell2mat(fn2(fn2z));
                    % tf/sdf-pos-vel-freq
                    fn3=eval(['fieldnames(data.',fn1Text,'.',fn2Text,')']);
                    lfn3 = size (fn3);
                    for fn3z = 1:lfn3(1);
                        if fn3z == 5
                            break
                        end
                        fn3Text = cell2mat(fn3(fn3z));         

                        eval(['sammel = data.',fn1Text,'.',fn2Text,'.',fn3Text,';']);
                        eval(['group.eyes{eye}.subjMean.sponSway.',fn1Text,'.',fn2Text,'.',fn3Text,'(:,:,is)= sammel;']);

                        if is > 1 % Nullen durch NaNs ersetzen
                            eval(['null2NaN = sum(group.eyes{eye}.subjMean.sponSway.',fn1Text,'.',fn2Text,'.',fn3Text,'(:,:,is-1));']);
                            if null2NaN == 0
                                eval(['group.eyes{eye}.subjMean.sponSway.',fn1Text,'.',fn2Text,'.',fn3Text,'(:,:,is-1)= NaN;']);
                            end
                        end

                        if is == l1(1) 
                            eval(['mw =nanmean(group.eyes{eye}.subjMean.sponSway.',fn1Text,'.',fn2Text,'.',fn3Text,',3);']);
                            eval(['group.eyes{eye}.mean.sponSway.',fn1Text,'.',fn2Text,'.',fn3Text,'= mw;']);

                            eval(['sd = nanstd(group.eyes{eye}.subjMean.sponSway.',fn1Text,'.',fn2Text,'.',fn3Text,',0,3);']);
                            eval(['group.eyes{eye}.sd.sponSway.',fn1Text,'.',fn2Text,'.',fn3Text,'= sd;']);

                            if strcmp(fn2Text,'paras')&& strcmp(fn3Text,'freq')
                                eval(['paraRowLabels = data.',fn1Text,'.paras.rowLabels;']);
                                eval(['group.eyes{eye}.mean.sponSway.',fn1Text,'.',fn2Text,'.rowLabels = paraRowLabels;'])
                            end
                        end % is
                    end % fn3
                end %fn2
            end %fn1 
        end
    end
end %eye


                



%% PRTS

reizMat = [2 5 8; 3 6 9;4 5 6; 7 8 9]; 

% 
 
for eye = 1:2
    sammel = [];
    if not(isfield (subject.eyes{eye}, 'subjMean'))
        ['no subject Means, ',subject.subjInfo.subjIni,'_',subject.subjInfo.date, ' eye=',num2str(eye)]
    else
%         break
%     end
 
    data = subject.eyes{eye}.subjMean.prts; % nur wegen fieldnames

    % fieldnames ausnutzen
    % body part
    fn1=fieldnames(data); 
    lfn1 = size (fn1);
    for fn1z = 1:lfn1(1);
        fn1Text = cell2mat(fn1(fn1z));
        % rot/trans
        fn2=eval(['fieldnames(data.',fn1Text,')']);
        lfn2 = size (fn2);
        for fn2z = 1:lfn2 % zeile Reizmatrix;
            fn2Text = cell2mat(fn2(fn2z));
            % tf-yo-f-mag-pha-coh
            fn3=eval(['fieldnames(data.',fn1Text,'.',fn2Text,');']);
            lfn3 = size (fn3);
            for fn3z = 1:lfn3
                fn3Text = cell2mat(fn3(fn3z));
  
                eval(['sammel = data.',fn1Text,'.',fn2Text,'.',fn3Text,';']);
                eval(['group.eyes{eye}.subjMean.prts.',fn1Text,'.',fn2Text,'.',fn3Text,'(:,:,is)= sammel;']);
                
                if is > 1 % Nullen durch NaNs ersetzen
                    eval(['null2NaN = sum(group.eyes{eye}.subjMean.prts.',fn1Text,'.',fn2Text,'.',fn3Text,'(:,:,is-1));']);
                    if null2NaN == 0
                        eval(['group.eyes{eye}.subjMean.prts.',fn1Text,'.',fn2Text,'.',fn3Text,'(:,:,is-1)= NaN;']);
                    end
                end

               
                if is == l1(1) 
                    eval(['mw = nanmean(group.eyes{eye}.subjMean.prts.',fn1Text,'.',fn2Text,'.',fn3Text,',3);']);
                    eval(['group.eyes{eye}.mean.prts.',fn1Text,'.',fn2Text,'.',fn3Text,'= mw;']);
                    
                    eval(['sd = nanstd(group.eyes{eye}.subjMean.prts.',fn1Text,'.',fn2Text,'.',fn3Text,',0,3);']);
                    eval(['group.eyes{eye}.sd.prts.',fn1Text,'.',fn2Text,'.',fn3Text,'= sd;']);
                end % is
            end % fn3
            
            eval(['tf =group.eyes{eye}.subjMean.prts.',fn1Text,'.',fn2Text,'.tf(:,:,is);']);
            eval(['group.eyes{eye}.subjMean.prts.',fn1Text,'.',fn2Text,'.mag(:,:,is) = abs(tf);']); %Gain

            eval(['pha = phase(tf)*180/pi;']);  

            for zz = 1:11
                if zz == 1
                    if pha(zz)>180;pha=pha-360;end;		
                    if pha(zz)<-180;pha=pha+360;end;	
                else
                    if abs(pha(zz)- pha(zz-1))> abs(pha(zz)+360- pha(zz-1))
                        pha=pha+360;
                    end
                    if abs(pha(zz)- pha(zz-1))> abs(pha(zz)-360- pha(zz-1))    
                        pha=pha-360;
                    end
                end
            end

            eval(['group.eyes{eye}.subjMean.prts.',fn1Text,'.',fn2Text,'.pha(:,:,is) = pha;']); 
            
        end % fn2
    end % fn1
    end
end


%% Model
for eye = 1:2
    if not(isempty(subject.eyes{eye}.reiz{2}.reizInfo))|| not(isempty(subject.eyes{eye}.reiz{3}.reizInfo))
        reizMat = [2 5 8; 3 6 9]; 
        sammel = [];
        if not(isfield (subject.eyes{eye}.subjMean,'model'))
            ['no model results, ',subject.subjInfo.subjIni,'_',subject.subjInfo.date, ' eye=',num2str(eye)]
            break
        end

        data = subject.eyes{eye}.subjMean.model.singelPendelCOMrot; % nur wegen fieldnames

        % fieldnames ausnutzen
        fn1=fieldnames(data); % rot05/toz1/trans
        lfn1 = size (fn1);
        for fn1z = 1:lfn1(1);
            fn1Text = cell2mat(fn1(fn1z));

            fn2=eval(['fieldnames(data.',fn1Text,')']);%basis paras subjMeanParas
            lfn2 = size (fn2);
            for fn2z = 1:lfn2 % zeile Reizmatrix;
                fn2Text = cell2mat(fn2(fn2z));
                fn3=eval(['fieldnames(data.',fn1Text,'.',fn2Text,');']);
                lfn3 = size (fn3);
                for fn3z = 1:lfn3
                    fn3Text = cell2mat(fn3(fn3z));

                    eval(['sammel = data.',fn1Text,'.',fn2Text,'.',fn3Text,';']);
                    eval(['group.eyes{eye}.subjMean.model.singelPendelCOMrot.',fn1Text,'.',fn2Text,'.',fn3Text,'(:,:,is)= sammel;']);

                    if is > 1 % Nullen durch NaNs ersetzen
                        eval(['null2NaN = sum(group.eyes{eye}.subjMean.model.singelPendelCOMrot.',fn1Text,'.',fn2Text,'.',fn3Text,'(:,:,is-1));']);
                        if null2NaN == 0
                            eval(['group.eyes{eye}.subjMean.model.singelPendelCOMrot.',fn1Text,'.',fn2Text,'.',fn3Text,'(:,:,is-1)= NaN;']);
                        end
                    end


                    if is == l1(1) 
                        eval(['mw = nanmean(group.eyes{eye}.subjMean.model.singelPendelCOMrot.',fn1Text,'.',fn2Text,'.',fn3Text,',3);']);
                        eval(['group.eyes{eye}.mean.model.singelPendelCOMrot.',fn1Text,'.',fn2Text,'.',fn3Text,'= mw;']);

                        eval(['sd = nanstd(group.eyes{eye}.subjMean.model.singelPendelCOMrot.',fn1Text,'.',fn2Text,'.',fn3Text,',0,3);']);
                        eval(['group.eyes{eye}.sd.model.singelPendelCOMrot.',fn1Text,'.',fn2Text,'.',fn3Text,'= sd;']);
                    end % is
                end % fn3
            end % fn2
        end % fn1
    end
end %eye            


 
