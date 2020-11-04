function [subject]=calcSubjMedian(subject)

%% Spontanschwanken
rNr = 1;
for eye = 1:2
    if not(isempty(subject.eyes{eye}.reiz{rNr,1}.data))||not(isempty(subject.eyes{eye}.reiz{rNr,2}.data))
        wdh = 1;
        if isempty(subject.eyes{eye}.reiz{rNr,wdh}.data)
            wdh = wdh +1;
        end
            
        data = subject.eyes{eye}.reiz{rNr,wdh}.sponSway;
    
        % fieldnames ausnutzen
        % body part
        fn1=fieldnames(data); 
        lfn1 = size (fn1);
        for fn1z = 1:lfn1(1);
            fn1Text = cell2mat(fn1(fn1z));
            % dft/paras
            fn2=eval(['fieldnames(data.',fn1Text,')']);
            fn1Text;
            for fn2z = 2:4;
                fn2Text = cell2mat(fn2(fn2z));
                % tf/sdf-pos-vel-freq
                fn3=eval(['fieldnames(data.',fn1Text,'.',fn2Text,')']);
                lfn3 = size (fn3);
                for fn3z = 1:lfn3(1);
                    if fn3z == 5
                        break
                    end
                    fn3Text = cell2mat(fn3(fn3z));
                    sammel = [];
                     for wdh = 1:2
                        if not(isempty(subject.eyes{eye}.reiz{rNr,wdh}.data))
                            data = subject.eyes{eye}.reiz{rNr,wdh}.sponSway; 
                            eval(['sammel(:,:,wdh) = data.',fn1Text,'.',fn2Text,'.',fn3Text,';']);
                        elseif not(isempty(sammel))
                            sammel (:,:,wdh) = NaN;
                        end
                        if wdh==2
                            eval(['subject.eyes{eye}.subjMedian.sponSway.',fn1Text,'.',fn2Text,'.',fn3Text,'= nanmedian(sammel,3);']);
%                             eval(['subject.eyes{eye}.subjSD.sponSway.',fn1Text,'.',fn2Text,'.',fn3Text,'= nanstd(sammel,0,3);']);
                            if strcmp(fn2Text,'paras')&& strcmp(fn3Text,'freq')
                                eval(['paraRowLabels = data.',fn1Text,'.paras.rowLabels;']);
                                eval(['subject.eyes{eye}.subjMedian.sponSway.',fn1Text,'.',fn2Text,'.rowLabels = paraRowLabels;'])
                            end
                        end
                     end%wdh 1:2
                end % fn3
            end %fn2
        end %fn1
    end % isempty eye
end %eye
                

                



%% PRTS

reizMat = [2 5 8; 3 6 9;4 5 6; 7 8 9]; 
 
for eye = 1:2
rNr = 5;    
    while isempty(subject.eyes{eye}.reiz{rNr,1}.data)
        rNr = rNr+1;
        if rNr == 9 && eye == 2
            return
        elseif rNr == 9 && eye == 1
            rNr = 5;
            eye = 2;
        end
    end
    sammel = [];
    wdh = 1;    
    data = subject.eyes{eye}.reiz{rNr,wdh}.prts; % nur wegen fieldnames

    % fieldnames ausnutzen
    % body part
    fn1=fieldnames(data); 
    lfn1 = size (fn1);
    for fn1z = 1:lfn1(1);
        fn1Text = cell2mat(fn1(fn1z));
        % rot/trans
        fn2=eval(['fieldnames(data.',fn1Text,')']);
        for rm = 1:4 % zeile Reizmatrix;
            rtNames = ['rot05  ';'rot_1  ';'trans08';'trans15'];
            if rm <3
                fn2TextNew = rtNames(rm,1:5);
                fn2Text = cell2mat(fn2(1)); % .rot
            else
                fn2TextNew = rtNames(rm,:);
                fn2Text = cell2mat(fn2(2)); %.trans
            end
            % tf-yo-f-mag-pha-coh
            fn3=eval(['fieldnames(data.',fn1Text,'.',fn2Text,')']);
            lfn3 = size (fn3);
            for fn3z = 1:lfn3
                fn3Text = cell2mat(fn3(fn3z));
                sammel = [];
                for rr = 1:3
                    rNr = reizMat(rm,rr);
                    if not(isempty(subject.eyes{eye}.reiz{rNr,wdh}.data))
                        data = subject.eyes{eye}.reiz{rNr,wdh}.prts;
                        eval(['sammel(:,:,rr) = data.',fn1Text,'.',fn2Text,'.',fn3Text,';']);
                    elseif not(isempty(sammel))
                        sammel(:,:,rr) = NaN;
                    end

                    if rr == 3
                        eval(['subject.eyes{eye}.subjMedian.prts.',fn1Text,'.',fn2TextNew,'.',fn3Text,'= nanmedian(sammel,3);']);
%                         eval(['subject.eyes{eye}.subjSD.prts.',fn1Text,'.',fn2TextNew,'.',fn3Text,'= nanstd(sammel,0,3);']);
                       
                    end
                end % rr
            end % fn3
            

            eval(['tf =subject.eyes{eye}.subjMedian.prts.',fn1Text,'.',fn2TextNew,'.tf;']);
            eval(['subject.eyes{eye}.subjMedian.prts.',fn1Text,'.',fn2TextNew,'.mag = abs(tf);']); %Gain
            
            eval(['pha = phase(tf)*180/pi;']); 

            if rm < 2
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
            end

            eval(['subject.eyes{eye}.subjMedian.prts.',fn1Text,'.',fn2TextNew,'.pha = pha;']);            
            
        end % rm
    end % fn1
end %eye            








