function [gender] = findGender(sName)
gender = [];
ppG = 'D:\MATLAB\gender\';
for i = 1:7
    if strcmp(sName(i),'_')
        group = sName(1:i);
        ini = sName(i+1:i+2);
        break
    end
end

eval(['load ',ppG,group,'w']);
eval(['wList = ',group,'w;']) 

eval(['load ',ppG,group,'m']);
eval(['mList = ',group,'m;']) 

for i = 1:length(mList)
    if strcmp(mList(i,:),ini)
        gender = 'm';
        break
    end
end

for i = 1:length(wList)
    if strcmp(wList(i,:),ini)
        gender = 'w';
        break
    end
end

if isempty(gender)
    gender = NaN;
end
