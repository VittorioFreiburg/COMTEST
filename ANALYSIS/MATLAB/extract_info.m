function extract_info
n=1;
subjects = [];


pp1='D:\Data\';



for x1 = 38
    
    [pp2,plotInfo,iniGr]=pp2_plotInfo(x1);
    
    pp = [pp1,pp2];
    wStruct = what(pp);
    l1 = size(wStruct.mat);
    
    for is = 20:l1(1)
        sName=wStruct.mat{is};
        eval(['load ',pp1,pp2,sName]);
        
       [sName,' = ',num2str(subject.subjInfo.weight)]
       pause
    
%         table = [x1,0,0,n,age,subject.subjInfo.weight,size,hCOM];
%         
%         subjects = [subjects;subject.subjInfo.subjIni];
%         n = n+1;
    end
end
    