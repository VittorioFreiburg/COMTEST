function fill_subjInfo
%nicht fertig
if isfield (file.info,'age');
                        age = file.info.age; % Alter
                    else
                        age = 0;
                    end

                    if isfield (file.info,'gender')&& not(isnan(file.info.gender));
                        gender = file.info.gender; 
                    else
                        [gender] = findGender(sName);
                        eval([datname,'.info.gender=gender'])
                        eval (['save ',pp,fname,' ',datname])
                        
                    end
                    subjInfo.gender = gender;
                    
                    
                    if isfield (file.info,'size');
                        subjInfo.size = file.info.size;
                    elseif hh < 3
                        subjInfo.size = hh+0.1; % geschätzte Größe Kopfmarkerhöhe +5cm +5cm ankle
                    else
                        subjInfo.size = NaN;
                    end
                    
                    [subjnr, subjects]= SubjNumbers (subjects,subjIni);
                    
                    
                    
                    
                    reizInfo.hCOM = hCOM/100;
                    
                    
                    