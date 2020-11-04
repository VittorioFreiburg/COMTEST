function heading = limitHeading(heading)
for i = 1:length(heading)   
    while(heading(i) < -pi)
        heading(i) = heading(i) + 2*pi;
    end
    while(heading(i) > pi)
        heading(i) = heading(i) - 2*pi;
    end
end
end