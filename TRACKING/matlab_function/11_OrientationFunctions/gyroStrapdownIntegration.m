function q  = gyroStrapdownIntegration(gyr,rate)

[steps,~] =  size(gyr);

q = zeros(steps,4);
q(1,:) = [1 0 0 0];

dt = 1/rate;

for i = 2:steps
    gyrAngle = norm(gyr(i,:)) *  dt;
    gyrAxis = gyr(i,:) / norm(gyr(i,:));
    if(norm(gyr(i,:)) == 0)
        gyrAxis = [0 0 0];
    end
    quatRot = getQuat(gyrAngle,gyrAxis);
    q(i,:) = quaternionMultiply(q(i-1,:),quatRot);
end

end