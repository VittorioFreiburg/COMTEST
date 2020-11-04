function npMeanGainPhase

load TFall

ll = size (TFall);

info = real(TFall(:,1:7));

reizAmp= [  0    0
            0.5  0
            1    0
            0    0.8
            0.5  0.8
            1    0.8
            0    1.5
            0.5  1.5
            1    1.5 ];
               
tfLBeo05=[];  tfLBeo08=[];  tfLBeo_1=[];  tfLBeo15=[];
tfUBeo05=[];  tfUBeo08=[];  tfUBeo_1=[];  tfUBeo15=[];
tfLBec05=[];  tfLBec08=[];  tfLBec_1=[];  tfLBec15=[];
tfUBec05=[];  tfUBec08=[];  tfUBec_1=[];  tfUBec15=[];


for i = 1:ll(1)
    if info(i,2)==1; %eye
        if info(i,5) == 2 % LBeo
            % Rotation
            if info(i,6)>= 0.4 && info(i,6)<= 0.6
                tfLBeo05 = [tfLBeo05;TFall(i,1:19)];
            elseif info(i,6)>= 0.9 && info(i,6)<= 1.1
                tfLBeo_1 = [tfLBeo_1;TFall(i,1:19)];
            end

            if info(i,7)>= 0.7 && info(i,7)<= 0.85
                tfLBeo08 = [tfLBeo08;TFall(i,1:8),TFall(i,20:30)];
            elseif info(i,7)>= 1.4 && info(i,7)<= 1.6
                tfLBeo15 = [tfLBeo15;TFall(i,1:8),TFall(i,20:30)];
            end
        elseif info(i,5) == 3 % UBeo
            % Rotation
            if info(i,6)>= 0.4 && info(i,6)<= 0.6
                tfUBeo05 = [tfUBeo05;TFall(i,1:19)];
            elseif info(i,6)>= 0.9 && info(i,6)<= 1.1
                tfUBeo_1 = [tfUBeo_1;TFall(i,1:19)];
            end

            if info(i,7)>= 0.7 && info(i,7)<= 0.85
                tfUBeo08 = [tfUBeo08;TFall(i,1:8),TFall(i,20:30)];
            elseif info(i,7)>= 1.4 && info(i,7)<= 1.6
                tfUBeo15 = [tfUBeo15;TFall(i,1:8),TFall(i,20:30)];
            end
        end
    elseif info(i,2)==2; %eye
        if info(i,5) == 2 % LBec
            % Rotation
            if info(i,6)>= 0.4 && info(i,6)<= 0.6
                tfLBec05 = [tfLBec05;TFall(i,1:19)];
            elseif info(i,6)>= 0.9 && info(i,6)<= 1.1
                tfLBec_1 = [tfLBec_1;TFall(i,1:19)];
            end

            if info(i,7)>= 0.7 && info(i,7)<= 0.85
                tfLBec08 = [tfLBec08;TFall(i,1:8),TFall(i,20:30)];
            elseif info(i,7)>= 1.4 && info(i,7)<= 1.6
                tfLBec15 = [tfLBec15;TFall(i,1:8),TFall(i,20:30)];
            end
        elseif info(i,5) == 3 % UBec
            % Rotation
            if info(i,6)>= 0.4 && info(i,6)<= 0.6
                tfUBec05 = [tfUBec05;TFall(i,1:19)];
            elseif info(i,6)>= 0.9 && info(i,6)<= 1.1
                tfUBec_1 = [tfUBec_1;TFall(i,1:19)];
            end

            if info(i,7)>= 0.7 && info(i,7)<= 0.85
                tfUBec08 = [tfUBec08;TFall(i,1:8),TFall(i,20:30)];
            elseif info(i,7)>= 1.4 && info(i,7)<= 1.6
                tfUBec15 = [tfUBec15;TFall(i,1:8),TFall(i,20:30)];
            end
        end
    end
end



NPsubject.eyes{1}.prts.LB.Rot05.tf = mean(tfLBeo05);
NPsubject.eyes{1}.prts.LB.Rot_1.tf = mean(tfLBeo_1);
NPsubject.eyes{1}.prts.LB.trans08.tf = mean(tfLBeo08);  
NPsubject.eyes{1}.prts.LB.trans15.tf = mean(tfLBeo15);

NPsubject.eyes{1}.prts.UB.Rot05.tf = mean(tfUBeo05);
NPsubject.eyes{1}.prts.UB.Rot_1.tf = mean(tfUBeo_1);
NPsubject.eyes{1}.prts.UB.trans08.tf = mean(tfUBeo08);  
NPsubject.eyes{1}.prts.UB.trans15.tf = mean(tfUBeo15);
        
NPsubject.eyes{2}.prts.LB.Rot05.tf = mean(tfLBec05);
NPsubject.eyes{2}.prts.LB.Rot_1.tf = mean(tfLBec_1);
NPsubject.eyes{2}.prts.LB.trans08.tf = mean(tfLBec08);  
NPsubject.eyes{2}.prts.LB.trans15.tf = mean(tfLBec15);

NPsubject.eyes{2}.prts.UB.Rot05.tf = mean(tfUBec05);
NPsubject.eyes{2}.prts.UB.Rot_1.tf = mean(tfUBec_1);
NPsubject.eyes{2}.prts.UB.trans08.tf = mean(tfUBec08);  
NPsubject.eyes{2}.prts.UB.trans15.tf = mean(tfUBec15);

save NPsubject.mat NP
        
