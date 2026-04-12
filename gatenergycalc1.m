% day_1min=transpose(0:(1/60):(24-(1/60)));
% day_15min=transpose(0:(15/60):(24-(15/60)));
% filename='Gatton Sub0 2013 Data Raw.xlsx';
% sheet=1;
% % dayrange={'U32757:U32852','U32853:U32948','U32949:U33044','U33045:U33140','U33141:U33236','U33237:U33332','U33333:U33428'};
% rawloaddata=[];
% rawloaddata=[rawloaddata;xlsread(filename,sheet,'U51:U4274')];
% rawloaddata=[rawloaddata;xlsread(filename,sheet,'U4343:U6646')];
% rawloaddata=[rawloaddata;xlsread(filename,sheet,'U6742:U15381')];
% rawloaddata=[rawloaddata;xlsread(filename,sheet,'U15478:U30549')];
% rawloaddata=[rawloaddata;xlsread(filename,sheet,'U30645:U34196')];
% day1PV=xlsread(filename,3,'O4:O844');
% day1PV=[zeros(300,1);day1PV;zeros(299,1)];
% PVenergy=trapz(day1PV)/60;
% ownusedenergy=[];
% surplusenergy=[];
% onedayload={};
% surplusP={};
% onedayloaddata=[];
% onedaypvdata=[];
% actualenergydata=[];
% E_BESSch=zeros(352,1);
% 
% %% Scheduled Capacity per Day According to Cycle Life %%
% RatedCycle=4000;
% RatedDoD=0.8;
% RatedCap=760;
% PlantLife=20*365; %% 20 years
% % PlantLife=(1:20)*365; %% sensitivity
% RatedDailyCap=(RatedCap*RatedDoD*RatedCycle)./PlantLife;
% RatedkWhThruput=(RatedCap*RatedDoD*RatedCycle);
% ScheduledDailyCap=[RatedDailyCap];
% E_BESSch(1)=RatedDailyCap;
% %%
% % for ii=1:7
% %     day1load=xlsread(filename,sheet,dayrange{ii});
% %     day1load=interp1(day_15min,day1load,day_1min,'spline');
% %     surplus=(day1PV-day1load);
% %     surplus(surplus<0)=0;
% %     surplusenergy=[surplusenergy;trapz(surplus)/60];
% %     ownusedenergy=[ownusedenergy;(PVenergy-surplusenergy(ii))];
% % end
%     
% for ii=1:352
%     if ii>=2
%         ScheduledDailyCapCalc=(RatedDailyCap+(ScheduledDailyCap(ii-1)-surplusenergy(ii-1)));
%         ScheduledDailyCap=[ScheduledDailyCap;ScheduledDailyCapCalc];
%     end
%     day1load=rawloaddata((((ii-1)*96)+1):(ii*96));
%     day1load=interp1(day_15min,day1load,day_1min,'spline');
%     onedayload{ii}=day1load;
%     onedayloaddata=[onedayloaddata;day1load];
%     onedaypvdata=[onedaypvdata;day1PV];
%     surplus=(day1PV-day1load);
%     surplus(surplus<0)=0;
%     surplusP{ii}=surplus;
%     surplusenergy=[surplusenergy;trapz(surplus)/60];
%     if surplusenergy(ii)<RatedDailyCap
%         actualenergy=surplusenergy(ii);
%     else
%         actualenergy=RatedDailyCap;
%     end
%     actualenergydata=[actualenergydata;actualenergy];
%     if ii>=2
%         E_BESSch(ii)=(RatedkWhThruput-sum(actualenergydata))/(PlantLife-(ii-0));
%     end
%     ownusedenergy=[ownusedenergy;(PVenergy-surplusenergy(ii))];
% end
% dayidx=20;
% % onedayload=(onedayloaddata(((((dayidx-1)*1440)+1):(dayidx*1440))));
% onedayload=(onedayload{dayidx});
% surplus_P=(79.92/surplusenergy(20))*(surplusP{20});
% for ii=1:1440
%     Eng(ii)=trapz(surplus_P(1:ii))/60;
% end
%% Capacity Management Working Codes %%
C_bat=300;
ConTime=492;
CoffTime=910;
SoCmax=0.9;
tsc=1;
day_1min=(1/60):(1/60):24;
kCA_data=0.0001:0.05:0.5;
kCB_data=1-2*kCA_data;
figure;
hold on;
for ii=1:length(kCA_data)
    kCA=kCA_data(ii);
    kCB=kCB_data(ii);
    crdr;
    SoC_ref_gen;
%     plot(Ibatt_ref*0.666);
    plot(SoC_ideal_ref);
end