%% Data Folder Path - add your data folder in the 'pathstr' variable %%
% if using your own location
pathstr='C:\Users\uqmalam8\Desktop\Official\Gatton Research\GattonData\Gatton EIF PV Plant Data\';
% If using G:\energy drive
% pathstr='G:\energy\GattonData\Gatton EIF PV Plant Data\'; 

%% Data Month -  specify the month here with first letter in capital %%
monthstr='March\';
% monthstr_arry={'March\' 'April\' 'May\' 'June\' 'July\' 'August\'};
%% Specify Year and Month in the 'folderstr' variable %% 
% For example if the year and month you are interested in is 2015 March, the string will be 'Analong_201503\'
folderstr='Analog_201503\';
% folderstr_arry={'Analog_201503\' 'Analog_201504\' 'Analog_201503\';

%% Specify Date in the 'daterstr' variable %% 
% For example if the date you are interested in is 19th March 2015, the string will be '2015-03-19'
% datestr='2015-03-19';

%% Specify the file names you would like to access - these are actually the PLC tags %%
% In this example, I am accessing Inverter AC output, Energy, and
% Phase-Neutral Voltage at Connection Point
% datevec=[17:20 23:31]';
datevec=[19]';
Energy_FT1=[];Energy_FT2=[];Energy_FT3=[];Energy_SAT=[];Energy_DAT=[];
for ii=1:length(datevec)
datestr=strcat('2015-03-',num2str(datevec(ii)))
filename_F1_INV_P=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P001_InvA.Sts.P_kW_',datestr,'.csv');
filename_F2_INV_P=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P001_InvB.Sts.P_kW_',datestr,'.csv');
filename_F3_INV_P=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P002_InvA.Sts.P_kW_',datestr,'.csv');
filename_SAT_INV_P=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P002_InvB.Sts.P_kW_',datestr,'.csv');
filename_DAT_INV_P=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P003_InvA.Sts.P_kW_',datestr,'.csv');
% filename_PLT_P=strcat(pathstr,monthstr,folderstr,'AQG1_B001_PM001.Sts.P_kW_',datestr,'.csv');

filename_F1_INV_E=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P001_InvA.Sts.Daily_Wh_',datestr,'.csv');
filename_F2_INV_E=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P001_InvB.Sts.Daily_Wh_',datestr,'.csv');
filename_F3_INV_E=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P002_InvA.Sts.Daily_Wh_',datestr,'.csv');
filename_SAT_INV_E=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P002_InvB.Sts.Daily_Wh_',datestr,'.csv');
filename_DAT_INV_E=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P003_InvA.Sts.Daily_Wh_',datestr,'.csv');

% filename_F1_INV_E=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P001_InvA.Sts.Tot_Wh_',datestr,'.csv');
% filename_F2_INV_E=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P001_InvB.Sts.Tot_Wh_',datestr,'.csv');
% filename_F3_INV_E=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P002_InvA.Sts.Tot_Wh_',datestr,'.csv');
% filename_SAT_INV_E=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P002_InvB.Sts.Tot_Wh_',datestr,'.csv');
% filename_DAT_INV_E=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P003_InvA.Sts.Tot_Wh_',datestr,'.csv');
% 
% filename_Plant_Van=strcat(pathstr,monthstr,folderstr,'AQG1_B001_PM001.Sts.VAN_kV_',datestr,'.csv');
% filename_Plant_Vbn=strcat(pathstr,monthstr,folderstr,'AQG1_B001_PM001.Sts.VBN_kV_',datestr,'.csv');
% filename_Plant_Vcn=strcat(pathstr,monthstr,folderstr,'AQG1_B001_PM001.Sts.VCN_kV_',datestr,'.csv');

% %% Creat your own plotting codes - this is just an example
% figure;
ABC=xlsread(filename_F1_INV_P,1,'B3:C31855');
plot(ABC(:,1),ABC(:,2));
hold on;
ABC=xlsread(filename_F2_INV_P,1,'B3:C31855');
plot(ABC(:,1),ABC(:,2));
ABC=xlsread(filename_F3_INV_P,1,'B3:C31855');
plot(ABC(:,1),ABC(:,2));
ABC=xlsread(filename_SAT_INV_P,1,'B3:C31855');
plot(ABC(:,1),ABC(:,2));
ABC=xlsread(filename_DAT_INV_P,1,'B3:C31855');
plot(ABC(:,1),ABC(:,2));
% 
% 
figure;
ABC=xlsread(filename_F1_INV_E,1,'B3:C31855');
ABC_E=ABC(:,2);
ABC_E=ABC_E-ABC_E(1);
Energy_FT1=[Energy_FT1;ABC(length(ABC(:,1)))];
% Yield_FT1=ABC(length(ABC(:,1)))/(630e3);
plot(ABC(:,1),ABC(:,2));
hold on;
ABC=xlsread(filename_F2_INV_E,1,'B3:C31855');
% ABC=ABC-ABC(1);
Energy_FT2=[Energy_FT2;ABC(length(ABC(:,1)))];
% Yield_FT2=ABC(length(ABC(:,1)))/(630e3);
plot(ABC(:,1),ABC(:,2));
ABC=xlsread(filename_F3_INV_E,1,'B3:C31855');
% ABC=ABC-ABC(1);
Energy_FT3=[Energy_FT3;ABC(length(ABC(:,1)))];
% Yield_FT3=ABC(length(ABC(:,1)))/(630e3);
plot(ABC(:,1),ABC(:,2));
ABC=xlsread(filename_SAT_INV_E,1,'B3:C31855');
% ABC=ABC-ABC(1);
Energy_SAT=[Energy_SAT;ABC(length(ABC(:,1)))];
% Yield_SAT=ABC(length(ABC(:,1)))/(630e3);
plot(ABC(:,1),ABC(:,2));
ABC=xlsread(filename_DAT_INV_E,1,'B3:C31855');
% ABC=ABC-ABC(1);
Energy_DAT=[Energy_DAT;ABC(length(ABC(:,1)))];
% Yield_DAT=ABC(length(ABC(:,1)))/(630e3);
plot(ABC(:,1),ABC(:,2));
% 
% figure;
% ABC=xlsread(filename_Plant_Van,1,'C3:C31855');
% plot(ABC);
% hold on;
% ABC=xlsread(filename_Plant_Vbn,1,'C3:C31855');
% plot(ABC);
% ABC=xlsread(filename_Plant_Vcn,1,'C3:C31855');
% plot(ABC);
end
% % filename_DAT_INV_P=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P003_InvA.Sts.P_kW_',datestr,'.csv');
% % ABC=xlsread(filename_DAT_INV_P,1,'C3:C31855');
% % filename_DAT_INV_PDC=strcat(pathstr,monthstr,folderstr,'AQG1_B001_P003_InvA.Sts.PDC_kW_',datestr,'.csv');
% % ABC1=xlsread(filename_DAT_INV_PDC,1,'C3:C31855');
% % figure;
% % plot((ABC./ABC1)*100);
% MonthlyEnergy=[804033-376337;1212931-804033;1526575-1212931;1884881-1526575;2343448-1884881]/1e3;
% y=[Energy_FT1 Energy_FT2 Energy_FT3 Energy_SAT Energy_DAT];

% figure;
% P_FT1=xlsread(filename_F1_INV_P,1,'C3:C31855');
% plot(P_FT1);
% hold on;
% P_FT2=xlsread(filename_F2_INV_P,1,'C3:C31855');
% plot(P_FT2);
% P_FT3=xlsread(filename_F3_INV_P,1,'C3:C31855');
% plot(P_FT3);
% P_SAT=xlsread(filename_SAT_INV_P,1,'C3:C31855');
% plot(P_SAT);
% P_DAT=xlsread(filename_DAT_INV_P,1,'C3:C31855');
% plot(P_DAT);
% P_PLT_Calc=P_FT1(1:30769)+P_FT2(1:30769)+P_FT3(1:30769)+P_SAT(1:30769)+P_DAT(1:30769);
% P_PLT=-xlsread(filename_PLT_P,1,'C3:C31855');
% plot(P_PLT_Calc);
% RR_Mat=[(diff(P_FT1(1:30769))/(630*1))*100 (diff(P_FT2(1:30769))/(630*1))*100 ...
%     (diff(P_FT3(1:30769))/(630*1))*100 (diff(P_SAT(1:30769))/(630*1))*100 ...
%     (diff(P_DAT(1:30769))/(630*1))*100 (diff(P_PLT_Calc(1:30769))/(630*5))*100];
% boxplot(RR_Mat)
