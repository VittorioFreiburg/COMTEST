function useSubj= match_age(age,agePat,ageSpan,x1,NParay)

if agePat == 0
    useSubj = 1;
else
    if sum(ismember (NParay,x1)) >= 1;
        if agePat-ageSpan <= age && age <= agePat+ageSpan
            useSubj = 1;
        else
            useSubj = 0;
        end
    else
        useSubj=1;
    end
end