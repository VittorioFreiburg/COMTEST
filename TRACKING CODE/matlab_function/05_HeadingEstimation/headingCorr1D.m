function delta = headingCorr1D(deltaIn,q1,q2,axis)

[steps,~] = size(q1);

delta = zeros(steps,1);
for k=1:steps
    v1 = quaternionRotate(q1(k,:),axis);
    v2 = quaternionRotate(q2(k,:),axis);
    delta_k = atan2(v2(:,2), v2(:,1)) - atan2(v1(:,2), v1(:,1));
    delta_k = delta_k - deltaIn;
    delta(k) = delta_k;    
end
end