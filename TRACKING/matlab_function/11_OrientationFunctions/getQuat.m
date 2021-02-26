function out = getQuat(angle,axis)

if(abs(angle) < eps)
    out = [1 0 0 0];
    return
end
axis = axis/norm(axis);
out = [cos(angle/2),sin(angle/2) * axis];
end