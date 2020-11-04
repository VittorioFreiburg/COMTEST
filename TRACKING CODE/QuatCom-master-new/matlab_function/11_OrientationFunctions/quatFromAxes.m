function quat = quatFromAxes(x,y,z,exactAxis)
axes = [x;y;z];
for i = 1:3
   zero_axes(i) = not(any(axes(i,:))); 
end
if(sum(zero_axes) ~=1)
    error('one axis needs to be zero');
end
zeroAxis = find(zero_axes,1);

if not(isempty(exactAxis))
    
    
end

end
