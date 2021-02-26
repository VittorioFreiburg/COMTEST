function out = relativeQuaternion(q1,q2)
% out = quaternionMultiply(quaternionInvert(q1),q2);

[shape,~] = size(q1);
out = zeros(shape,4);
out(:, 1) = q1(:, 1) .* q2(:, 1) + q1(:, 2) .* q2(:, 2) + q1(:, 3) .* q2(:, 3) + q1(:, 4) .* q2(:, 4);
out(:, 2) = q1(:, 1) .* q2(:, 2) - q1(:, 2) .* q2(:, 1) - q1(:, 3) .* q2(:, 4) + q1(:, 4) .* q2(:, 3);
out(:, 3) = q1(:, 1) .* q2(:, 3) + q1(:, 2) .* q2(:, 4) - q1(:, 3) .* q2(:, 1) - q1(:, 4) .* q2(:, 2);
out(:, 4) = q1(:, 1) .* q2(:, 4) - q1(:, 2) .* q2(:, 3) + q1(:, 3) .* q2(:, 2) - q1(:, 4) .* q2(:, 1);


end