clear all;
startsoc=50;
socul=90;
daycap=socul-startsoc;
socprof=50:1:85;
ontime=1;
offtime=5;
timedur=offtime-ontime;
timeprof=1:(1/60):5;
timeband=0.5*timedur-(offtime-timeprof);
% timeaxis=timeprof;
% socband=0.5*daycap-(socul-socprof);
% socaxis=(socul-daycap)+0.5*daycap+socband;
% pbess=(max(abs(socband)))^2-socband.^2;
pbess=max(timeband.^2)-timeband.^2;
% plot(socaxis,pbess)
plot(timeprof,pbess);
pbessact=pbess*(daycap/trapz(pbess));
trapz(pbessact)
hold on
plot(timeprof,pbessact);