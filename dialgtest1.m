clear all;
clear global;

imshow('gatton_bess_demo_screen1.jpg','InitialMagnification','fit');
fig1=gcf;set(fig1, 'WindowStyle','normal');
scrsz=get(groot,'ScreenSize');
% set(fig1,'Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
set(fig1,'Position',[1 1 scrsz(3)/1 scrsz(4)/1]);
useresp2='N';

% while strcmp(useresp2,'N')==1
prompt={'Excess PV Store?:','Start Time:', 'Stop Time:','Start SoC:','Stop SoC:',...
    'Discharge Support?','Start Time','Stop Time','Start SoC:','Stop SoC:',...
    'Charge Maiclcntenance?','Start Time','Stop Time','Start SoC:','Stop SoC:',...
    'Enable Export Control?','Export Limit:',...
    'Enable Peak Demand Reduction?','Peak Demand Limit:','Ramp Rate Limit (kW/min):'};
dlg_title='Gatton Energy Storage Control Panel';
num_lines=1;%[20 1;20 4;20 4;20 1;20 4;20 4];
options.Resize='on';
options.WindowStyle='normal';
options.Position='[300 300 800 200]';
defaultresp1={'Y','0732','1440','0.2','0.95','N','1441','1800','0.5','0.2','N','2400','2500','0.5','0.5','N','(400/3)*1e3','N','(2550/3)*1e3','50000'};
useresp1=inputdlg(prompt,dlg_title,num_lines,defaultresp1,options);
% ConTime=useresp1{2};
% CoffTime=useresp1{3};
% ConTime=60*str2num(ConTime(1:2))+str2num(ConTime(3:4));
% CoffTime=60*str2num(CoffTime(1:2))+str2num(CoffTime(3:4));
% figure;
% a1=animatedline('Color',[0.0 0.0 0.0]);
% axis([1 (CoffTime-ConTime) 0 20])
% timeax=1:(CoffTime-ConTime);
% % clearpoints(a1);
% for ii=1:length(timeax);
%     xii=timeax(ii);
%     yii=timeax(ii)/100;
%     addpoints(a1,xii,yii); 
%     pause(0.01);
%     drawnow update
%     fig2=gcf;
% end
tsc=1;%30

ConTime=useresp1{2};
CoffTime=useresp1{3};
ConSoC=str2num(useresp1{4});
CoffSoC=str2num(useresp1{5});
DonTime=useresp1{7};
DoffTime=useresp1{8};
DonSoC=str2num(useresp1{9});
DoffSoC=str2num(useresp1{10});
CMonTime=useresp1{12};
CMoffTime=useresp1{13};
CMonSoC=str2num(useresp1{14});
CMoffSoC=str2num(useresp1{15});
ConTime=tsc*(60*str2num(ConTime(1:2))+str2num(ConTime(3:4)));
CoffTime=tsc*(60*str2num(CoffTime(1:2))+str2num(CoffTime(3:4)));
DonTime=tsc*(60*str2num(DonTime(1:2))+str2num(DonTime(3:4)));
DoffTime=tsc*(60*str2num(DoffTime(1:2))+str2num(DoffTime(3:4)));
CMonTime=tsc*(60*str2num(CMonTime(1:2))+str2num(CMonTime(3:4)));
CMoffTime=tsc*(60*str2num(CMoffTime(1:2))+str2num(CMoffTime(3:4)));
P_Expt_Lim=str2num(useresp1{17});
Pk_Dem_Lim=str2num(useresp1{19});
Str_Flg=strcmp(useresp1{1},'Y');
Spt_Flg=strcmp(useresp1{6},'Y');
Cmt_Flg=strcmp(useresp1{11},'Y');
ExptCtrl_Flg=strcmp(useresp1{16},'Y');
PkDemRed_Flg=strcmp(useresp1{18},'Y');
RRlim=str2num(useresp1{20});

daily_sim_combined_CD_test2;
useresp2=inputdlg('Terminate operation?','Terminate Demo',1);
% close(figP); close(figExImp); close(figSoC); close(figRamp);
% end
% close(fig1);
