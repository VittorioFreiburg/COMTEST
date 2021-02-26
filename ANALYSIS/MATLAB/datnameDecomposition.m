function [info,subjInfo,sName] = datnameDecomposition(fname,datname)
fname
datname
zz = 0;
for i = 1:length (datname)
    if strcmp(datname(i),'_')== 1
        zz = zz+1;
        if zz == 1;
            ini = datname (i+1:i+2);
        end
        
        if zz == 2;
            date = datname(i+1:i+6);
            year = 2000+str2num(date(1:2));
            month = str2num(date(3:4));
            day = str2num(date (5:6));
            
            sName = datname(1:i+6);
        end
        
        if zz == 3 && strcmp(datname(i+1),'a')
            if str2num(datname (i+2)) == 0;
                eye = 'ec';
            elseif str2num(datname (i+2)) == 1;
                eye ='eo';
            end   
 
            if isempty (str2num(datname(i+4:i+5)))
                trialNo = str2num(datname(i+4)); % einstellige Zahl
                break
            elseif str2num(datname(i+4)) == 0;
                trialNo = str2num(datname(i+4:i+5))+ 20; % Zweite Datei selbe Messung mit _0 + laufende Nummer
            else                
                trialNo = str2num(datname(i+4:i+5)); % zweistellige Zahl
                break
            end
        end           
        
    end
end

if exist('date')== 1;   
    subjInfo.date = date;
    subjInfo.year = year;
    subjInfo.month = month;
    subjInfo.day = day;   
end

subjInfo.ini = ini;

if exist('eye')== 1;
    info.eye = eye;
end
if exist('trialNo')== 1;
    info.trialNo = trialNo;
end



            