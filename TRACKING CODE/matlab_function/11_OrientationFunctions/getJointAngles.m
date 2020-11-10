function jointAngles = getJointAngles(data,seg1,seg2,delta)

steps = length(data(seg1).t);
j1 = data(seg2).axes{1};
j2 = data(seg2).axes{2};

if(isempty(delta))
    delta = zeros(1,steps);
end
jointAngles = zeros(steps,3);
for i = 1:steps
    q_e2_e1  = getQuat(delta(i),[0 0 1]);
    q_b2_s2 = getQuat(acos(dot([0, 1, 0], j2)), cross([0, 1, 0], j2));
    q_b1_s1 = getQuat(acos(dot([0, 0, 1], j1)), cross([0, 0, 1], j1));    
    q_e1_b1 = quaternionMultiply(q_b1_s1,quaternionInvert(data(seg1).q(i,:)));
    q_e2_b1 = quaternionMultiply(q_e1_b1,q_e2_e1);
    q_s2_b1 = quaternionMultiply(q_e2_b1,data(seg2).q(i,:));
    q_b2_b1 = quaternionMultiply(q_s2_b1,q_b2_s2);
    [jointAngles(i,:)] = getEulerAngles(q_b2_b1,'zxy',true);    
end