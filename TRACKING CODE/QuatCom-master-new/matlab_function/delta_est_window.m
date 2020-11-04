%% delta_est_window
function delta = delta_est_window(q1,q2,j,j_long,gnSteps,startVal)
delta = startVal;
constraint = "euler_1d"
for i = 1:gnSteps
    deltaParams  = gnStep(j,j_long,q1,q2,delta,constraint);
    delta               = delta + deltaParams;
end
delta = limitHeading(delta);
end


