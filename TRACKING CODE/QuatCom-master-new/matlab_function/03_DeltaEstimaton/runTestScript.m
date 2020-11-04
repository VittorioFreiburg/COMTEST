phiIn = [1,zeros(1,200)];
rate = 100
time =linspace(0,20,20*rate);
quat1 = [ones(1,20*rate);zeros(3,20*rate)];
quat2 = [ones(1,20*rate);zeros(3,20*rate)];


output = getDelta_1D_Kai(time,rate, quat1,quat2 , "euler_1d", [0,1,0], 'backward')