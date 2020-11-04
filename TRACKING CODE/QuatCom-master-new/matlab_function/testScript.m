close all

figure();
    
for i = 500:500:4500
    %figure();
    time = 0:1/40:i/40;
    metaRate = 40
    data1 = h_quat(1:i,:)
    data2 = tr_quat(1:i,:)
    constraint = "euler_1d"
    alignment = "backward"
    %data1 = struct();
    %data1.time = time;
    %data1.quat = h_quat(1:i,:);

    %data2 = struct();
    %data2.time = time;
    %data2.quat = tr_quat(1:i,:);

    joint = [0,1,0];
    %meta = struct();
    %meta.rate = 40 ;%ist noch n bug in Dustins code 
    %test = getDelta_1D(meta,data1,data2,joint);
    test = getDelta_1D_Kai(time,metaRate,data1,data2,constraint,joint,alignment)
    plot(test+ 0.000001*i);
    hold on
    %length(data1.time)
    %length(test)
    
end


return 
delta = 0:0.01:2*pi
costFunction2d = zeros(length(delta),0);

for i = 1:length(delta)
   abcd = getErrorAndJac_1D(h_quat(1:4500,:),tl_quat(1:4500,:),[0 1 0],[1 0 0],d,"1d_corr");
   size(abcd)
   costFunction2d(i) = abcd;
end
plot(errors)
mean(errors)
figure
%imshow(costFunction2d)
%surf(costFunction2d);
%colormap('gray');
%colormap(costFunction2d);

%I = costFunction2d;
%dims = size(I');
%figure(1), imagesc(I), axis equal, axis([0.5 dims(2)+0.5 0.5 dims(1)+0.5]), colormap gray

plot(delta, costFunction2d);