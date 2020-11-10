function angle = angleBetweenAxes(axis1,axis2)
angle = acos(dot(axis1,axis2)/(norm(axis1)*norm(axis2)));
end

