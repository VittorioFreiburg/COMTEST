function delta = headingCorr1D_filt(deltaIn,q1,q2,axis,samplingTime)

[steps,~] = size(q1);

delta= zeros(steps,1);
for k=1:steps
    v1 = quaternionRotate(q1(k,:),axis);
    v2 = quaternionRotate(q2(k,:),axis);
    delta_k = atan2(v2(:,2), v2(:,1)) - atan2(v1(:,2), v1(:,1));
    delta_k = delta_k - deltaIn;
    
    r_k = min(norm(v1(1:2)),norm(v2(1:2)));
    
    if(k>1)
        delta(k) = delta(k-1) + r_k * (1-exp(-samplingTime)) * clip(delta_k-delta(k-1),-0.05,0.05);
    else
        delta(k) = delta_k;
    end    
end
end