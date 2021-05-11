
ampTrans=1.5;
ampRot=1.5;
stim.rot=subject.eyes{EY}.reiz{9, 1}.data(:,38); 
stim.trans=subject.eyes{EY}.reiz{9, 1}.data(:,40);
resp1=subject.eyes{EY}.reiz{9, 1}.sponSway.angleCOM.raw;
[TF,yis1,yos1,f1,Gxs1,Gxys1] = PRTS2012(stim,resp1,ampRot,ampTrans);
Fr=[0.05, 0.15, 0.25, 0.35, 0.45, 0.55, 0.65, 0.75, 0.85, 0.95, 1.05, 1.15, 1.25, 1.35, 1.45, 1.55, 1.65, 1.75, 1.85, 1.95, 2.05, 2.15, 2.25, 2.35, 2.45];
%
subplot(3,1,1)
plot(fs1,abs((yis1))); hold on
rectangle('Position',[0,0,(Fr(1)+Fr(2))/2,4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
rectangle('Position',[(Fr(3)+Fr(2))/2,0,Fr(4)-(Fr(3)+Fr(2))/2,4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
rectangle('Position',[Fr(5),0,Fr(7)-Fr(5),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
 rectangle('Position',[Fr(6),0,Fr(7)-Fr(6),4],'FaceColor',[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9]);
rectangle('Position',[Fr(8),0,Fr(11)-Fr(8),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
 rectangle('Position',[Fr(8),0,Fr(9)-Fr(8),4],'FaceColor',[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9]);
rectangle('Position',[Fr(12),0,Fr(16)-Fr(12),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
 rectangle('Position',[Fr(12),0,Fr(13)-Fr(12),4],'FaceColor',[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9]);
rectangle('Position',[Fr(20),0,Fr(25)-Fr(20),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
plot(fs1,abs((yis1)),'b'); hold on
title('PRTS powerspectrum')
xlabel('freq [Hz]')
ylabel('gain')
axis([0,2.45,0,0.4])
set(gca, 'Layer', 'top')


subplot(3,1,2)
TF25=Gxys1./Gxs1;
%[fs1(1:2) 
%mean(fs1(3:4)) mean(fs1(4:5))
%mean(fs1(5:7)) mean(fs1(6:9)) 
%mean(fs1(8:11)) mean(fs1(10:13)),...
%   mean(fs1(12:16)) mean(fs1(16:20)) 
%mean(fs1(20:25))]
stem(fs1(1:2:end),abs((TF25))); hold on
rectangle('Position',[0,0,(Fr(1)+Fr(2))/2,4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
rectangle('Position',[(Fr(3)+Fr(2))/2,0,Fr(4)-(Fr(3)+Fr(2))/2,4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
rectangle('Position',[Fr(5),0,Fr(7)-Fr(5),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
 rectangle('Position',[Fr(6),0,Fr(7)-Fr(6),4],'FaceColor',[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9]);
rectangle('Position',[Fr(8),0,Fr(11)-Fr(8),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
 rectangle('Position',[Fr(8),0,Fr(9)-Fr(8),4],'FaceColor',[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9]);
rectangle('Position',[Fr(12),0,Fr(16)-Fr(12),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
 rectangle('Position',[Fr(12),0,Fr(13)-Fr(12),4],'FaceColor',[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9]);
rectangle('Position',[Fr(20),0,Fr(25)-Fr(20),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);

 hold on
stem(fs1(1:2:end),abs((TF25)),'b'); hold on
title('Example empirical transfer function')
xlabel('freq [Hz]')
ylabel('gain')
axis([0,2.45,0,4])
set(gca, 'Layer', 'top')


subplot(3,1,3)

stem(TF.rot.f,TF.rot.mag,'b');
rectangle('Position',[0,0,(Fr(1)+Fr(2))/2,4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
rectangle('Position',[(Fr(3)+Fr(2))/2,0,Fr(4)-(Fr(3)+Fr(2))/2,4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
rectangle('Position',[Fr(5),0,Fr(7)-Fr(5),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
 rectangle('Position',[Fr(6),0,Fr(7)-Fr(6),4],'FaceColor',[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9]);
rectangle('Position',[Fr(8),0,Fr(11)-Fr(8),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
 rectangle('Position',[Fr(8),0,Fr(9)-Fr(8),4],'FaceColor',[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9]);
rectangle('Position',[Fr(12),0,Fr(16)-Fr(12),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
 rectangle('Position',[Fr(12),0,Fr(13)-Fr(12),4],'FaceColor',[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9]);
rectangle('Position',[Fr(20),0,Fr(25)-Fr(20),4],'FaceColor',[.8 .85 .8],'EdgeColor',[.8 .85 .8]);
 hold on
 stem(TF.rot.f,TF.rot.mag,'b');
title('FRF')
xlabel('freq [Hz]')
ylabel('gain')
%axis([0,2.45,0,0.4])
axis([0,2.45,0,4])
set(gca, 'Layer', 'top')
