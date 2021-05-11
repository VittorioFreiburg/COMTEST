%compute matrix
SET1=[];

EY=1;
resp=1;
rot=3
    for trans = 1:3
        SET1=[SET1;SAMPLES{EY1,resp,rot1,trans1}];
    end


Sigma= cov(SET1);
m= mean(SET1);

%size(SET1) =    228    11
