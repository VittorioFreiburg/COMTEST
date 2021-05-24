%compute matrix
SET1=[];

EY=2;
resp=1;
rot=3
    for trans = 1:3
        SET1=[SET1;SAMPLES{EY,resp,rot,trans}];
    end

SETr=realcoeff(SET1);
Sigma= cov(SETr);
invSigma=inv(Sigma);
m= mean(SETr);

%size(SET1) =    228    11
