% clear all;
% A=csvread('20100327.txt');
%%% 27th March is a nearly clear day
%%% 25th March is a nearly worst case day
% Oahu_Data=A(:,19);
% clear A;
% Oahu_Data(1)=[];
% t=5:(1/3600):20;
% t(length(t))=[];
% plot(t,Oahu_Data);
% before_day_length=length(1:1:(4*3600+59*60+59));
% after_night_length=length((8*3600):1:(11*3600+59*60+59));
% Oahu_Data=[zeros(1,before_day_length) Oahu_Data' zeros(1,after_night_length)];
% Oahu_Data=Oahu_Data/max(Oahu_Data);
% t=0:(1/3600):((23+(59/60)+(59/3600)));
% figure;
% del_Oahu_Data=zeros(length(Oahu_Data),1);
% for ii=2:(length(Oahu_Data))
% %     del_Oahu_Data(ii)=((Oahu_Data(ii)-Oahu_Data(ii-1))/Oahu_Data(ii-1))*100;
%     del_Oahu_Data(ii)=((Oahu_Data(ii)-Oahu_Data(ii-1))/max(Oahu_Data))*100;
% end
% figure;
% plot(t,Oahu_Data,'-');
% figure;
% stem(t,del_Oahu_Data);
Loadfilename='C:\Users\uqmalam8\Desktop\Official\Gatton Research\GattonData\LoadPV.xls';
PVfilename='Gatton Sub0 2013 Data Raw.xlsx';
% PVfilename='C:\Users\uqmalam8\Desktop\Official\Gatton Research\GattonData\LoadPV.xls';
% PVfilename='C:\Users\uqmalam8\Downloads\UQ Data After September\Analog_201511\AQG1_B001_PM001.Sts.P_kW_2015-11-23.csv';
% dayrange={'U32757:U32852','U32853:U32948','U32949:U33044','U33045:U33140','U33141:U33236','U33237:U33332','U33333:U33428'};
rawloaddata=[];
% rawloaddata=[rawloaddata;xlsread(filename,1,'U2643:U2738')];
% rawloaddata=[rawloaddata;xlsread(Loadfilename,2,'J17538:J18209')]; %% 1st-7th Oct 2015
rawloaddata=[rawloaddata;xlsread(Loadfilename,2,'J16003:J16098')]; %9th April:'J779:J874'/15th Sep: 'J16003:J16098'/23rd Nov: 'J22626:J22721' %'J22626:J22733'
day1PV=xlsread(PVfilename,3,'AM4:AM844'); %% 9th April : L/15th Sep: W/  23rd Nov: AM / 24th January 2016: AQ / AU/
% day1PV=-xlsread(PVfilename,1,'C18527:C22126'); % Historian data
% day1PV=[zeros(19800,1);day1PV;zeros(19800,1)];
% day1PV=xlsread(PVfilename,2,'L17538:L18209'); %% 1st-7th Oct 2015
day1PV=[zeros(300,1);day1PV;zeros(299,1);zeros(0,1)];%% for next day simulation, added zeros(180,1) 
% daysmthPV=xlsread(filename,3,'U4:U844');
% daysmthPV=[zeros(300,1);daysmthPV;zeros(299,1)];
% dayslgtvarPV=xlsread(filename,3,'W4:W844');
% dayslgtvarPV=[zeros(300,1);dayslgtvarPV;zeros(299,1)];
% dayhghvarPV=xlsread(filename,3,'AA4:AA844');
% dayhghvarPV=[zeros(300,1);dayhghvarPV;zeros(299,1)];
% figure;
% plot(1:1440,daysmthPV);
% hold on;
% plot(1441:2*1440,dayslgtvarPV);
% plot(2881:3*1440,dayhghvarPV);
% figure;
% load('data_smthPV.mat')
% plot(1:749,-3*Feeder_PV_abc(CustomerBus(1):tot_bus:length(Feeder_PV_abc(:,1)),1))
% hold on;
% plot(1:749,3*BTP(CustomerBus(1):tot_bus:length(BTP(:,1)),1))
% plot(1:749,-3*(Feeder_PV_abc(CustomerBus(1):tot_bus:length(Feeder_PV_abc(:,1)),1)+BTP(CustomerBus(1):tot_bus:length(BTP(:,1)),1)));
% load('data_slightvarPV.mat')
% plot(750:(2*749),-3*Feeder_PV_abc(CustomerBus(1):tot_bus:length(Feeder_PV_abc(:,1)),1))
% plot(750:(2*749),3*BTP(CustomerBus(1):tot_bus:length(BTP(:,1)),1))
% plot(750:(2*749),-3*(Feeder_PV_abc(CustomerBus(1):tot_bus:length(Feeder_PV_abc(:,1)),1)+BTP(CustomerBus(1):tot_bus:length(BTP(:,1)),1)));
% load('data_highvarPV.mat')
% plot(1499:(3*749),-3*Feeder_PV_abc(CustomerBus(1):tot_bus:length(Feeder_PV_abc(:,1)),1))
% plot(1499:(3*749),3*BTP(CustomerBus(1):tot_bus:length(BTP(:,1)),1))
% plot(1499:(3*749),-3*(Feeder_PV_abc(CustomerBus(1):tot_bus:length(Feeder_PV_abc(:,1)),1)+BTP(CustomerBus(1):tot_bus:length(BTP(:,1)),1)));
% 
% figure;
% load('data_smthPV.mat')
% plot(PVP_RampRate(CustomerBus:tot_bus:length(Feeder_PV_abc(:,1)),1)/kVA_base,'o')
% hold on;
% plot(1:749,contdiff,'o')
% load('data_slightvarPV.mat')
% plot(750:(2*749),PVP_RampRate(CustomerBus:tot_bus:length(Feeder_PV_abc(:,1)),1)/kVA_base,'o')
% plot(750:(2*749),contdiff,'o')
% load('data_highvarPV.mat')
% plot(1499:(3*749),PVP_RampRate(CustomerBus:tot_bus:length(Feeder_PV_abc(:,1)),1)/kVA_base,'o')
% plot(1499:(3*749),contdiff,'o')
% 
% figure;
% load('data_smthPV.mat')
% plot(1:749,100*SOC(CustomerBus:tot_bus:length(SOC(:,1)),1))
% hold on;
% load('data_slightvarPV.mat')
% plot(750:(2*749),100*SOC(CustomerBus:tot_bus:length(SOC(:,1)),1))
% load('data_highvarPV.mat')
% plot(1499:(3*749),100*SOC(CustomerBus:tot_bus:length(SOC(:,1)),1))
%

