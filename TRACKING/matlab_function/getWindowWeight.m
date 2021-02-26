%% getWindowWeight
function out = getWindowWeight(q1,q2,j, delta, lastDelta)
v1 = quaternionRotate(q1,j);
v2 = quaternionRotate(q2,j);
if(abs(delta - lastDelta)>1) 
  weight = 0;
else
  weight = sqrt(v1(:,1).^2 + v1(:,2).^2) .* sqrt(v2(:,1).^2 + v2(:,2).^2);
end
out = rms(weight);

end