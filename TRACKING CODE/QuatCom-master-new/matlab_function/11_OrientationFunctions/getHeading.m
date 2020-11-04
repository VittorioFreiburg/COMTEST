function heading = getHeading(quat,varargin)

% heading = 2*atan2(dot(axis,[x y z]),w);

x_global = quaternionRotate(quat, [1,0,0]);
heading = atan2(x_global(:,1), x_global(:,2));


for k = 1:length(heading)
while(heading(k) < 0)
    heading(k) = heading(k) + 2*pi;
end
end
if(nargin>1)
    heading = heading * 180 / pi;
end

end