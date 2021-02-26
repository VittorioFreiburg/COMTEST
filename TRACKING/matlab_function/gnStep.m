%% gnStep
function [deltaParams,totalError] = gnStep(j,j_long,q1,q2,delta,constraint)
[errors,jacobi] = getErrorAndJac_1D(q1,q2,j,j_long,delta,constraint);
deltaParams = sum(jacobi)%-(mldivide((jacobi'*jacobi),jacobi'*errors));
totalError = norm(errors);
end


