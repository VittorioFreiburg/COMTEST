%time domain example
%
FILES=dir('*.mat');
NS= length(FILES);

CASE=1;
EY=1;
fig=figure(7);

load(FILES(CASE).name);


subplot(3,1,1);
STIM1=subject.eyes{EY}.reiz{9, 1}.data(:,38);
t=(0:(length(STIM1)-1))*0.01;
plot(t,STIM1);
xlabel('t [s]');

subplot(3,1,2);
plot(t,STIM3);
xlabel('t [s]');
subplot(3,1,3);
COM=subject.eyes{EY}.reiz{9, 1}.prts.angleCOM;
plot(t,COM);
xlabel('t [s]');
ylabel(



fig.WindowState = 'maximized';
saveas(fig,'TimeDomain.png')