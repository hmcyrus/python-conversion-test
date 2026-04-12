clear all;
clear global;
%% Initializations %%

% data_3ph4w; % run the data file
% binda_bigga_3p4w;
bb_pv_cluster1;
% bb_pv_cluster2;
ymat_3ph3_4w;
T11=[0.00;0.00;0.00];
T12=[0.00;0.00;0.00];
T21=[0.00;0.00;0.00];
T22=[0.00;0.00;0.00];
T31=[0.00;0.00;0.00];
T32=[0.00;0.00;0.00];
demand_curve;
% appl_load;
pv_curve;
Data_Volt=zeros(1,8);
Data_Tap=zeros(1,3);
% Data_Pflow=zeros(1,4);
% Data_Qflow=zeros(1,4);
Data_Sflow=zeros(1,4);
Data_Sflow_MV=zeros(1,4);
Data_Iflow=zeros(1,4);
Data_Loss=zeros(1,5);
Feeder_Load=zeros(1,1);
Feeder_PV=zeros(1,1);
Feeder_Load_abc=zeros(1,6);
Feeder_PV_abc=[];
% SOC=zeros(1,3);
% BTP=zeros(1,3);
% feeder_node_ind=[108:117];
feeder_node_ind=[131:150]; %%% 131:136 for Binda-Bigga
line_ind=[1:169]; %%% 1:13 for Binda-Bigga
line_ind_MV=[1];

%%%%%%%%% Ramp Rate Variables %%%%%%%%
volt1=0.98*[busV(aaa) busV(bbb) busV(ccc)];
% pv1=abs([busDGP(aaa) busDGP(bbb) busDGP(ccc)]);
ld1=abs([busPL(aaa) busPL(bbb) busPL(ccc)]);
btp1=abs([busBTP(aaa) busBTP(bbb) busBTP(ccc)]);

PVP=[]; %%% PV power ramp rate
PVP_MA=[]; %%% PV power moving average
iiii=1; % counter used in moving average
V_RampRate=zeros(1,3); %%% voltage ramp rate
V_RampRate_smooth=zeros(1,3); %%% voltage ramp rate after smoothing
PVP_RampRate=[]; %%% PV power ramp rate
LDP_RampRate=zeros(1,3); %%% Load ramp rate
Neg_Ramp_Flag=0;
Pos_Ramp_Flag=0;
Normal_Chg_Cond=1;
Normal_Dis_Cond=1;
%%%%%%%%%% Storage Parameter Initialization %%%%%%%%%%
%%% distributed storage at each PCC
SOC_Ref=[];
SOC=zeros(1,3);
I_Bat=[];
BTP=zeros(1,3);
C_bat=60;
DoDmax=0.5469;
SoCmax=0.999;
eta_coulomb=1.0; %%%% storage coulomb efficiency | charge current efficiency %%%
%%% community energy storage for total feeder
% C_bat=200;
% SOC_Ref=[];
% SOC=zeros(1,1);
% I_Bat=zeros(1,1);
% BTP=zeros(1,1);
% DoDmax=0.399;
% SoCmax=0.999;
% eta_coulomb=1.0; %%%% storage coulomb efficiency | charge current efficiency %%%

%%%%% Storage ref parameter initialization %%%%%%%%%%
SoC_ideal_ref=[];
SoC_ref_calc=DoDmax*C_bat;
SoC_actual_ref=[];
Ibatt_ref_calc=0.00;
% SoC_ref_gen;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Distributed Storage
% Ibatt=zeros(length(busV),1);
% I_bat_C_mem=zeros(length(busV),1);
% I_bat_D_mem=zeros(length(busV),1);
% BatP_mem=zeros(length(busV),1);
% Vbatt=zeros(length(busV),1);
% SoC_ref=C_bat*DoDmax*(ones(length(busV),1));
% SoC=C_bat*DoDmax*(ones(length(busV),1));%SoC(aaa)=0.66*C_bat;SoC(bbb)=0.53*C_bat;
% charge_time=(zeros(length(busV),1));
% Pchg=(zeros(length(busV),1));
% EfullCby5=15.95/6;
% EexpCby5=13.67/6;
% EnomCby5=12.80/6;
% EfullDby5=12.10/6;
% EexpDby5=11.10/6;
% EnomDby5=10.20/6;
% R=0.04/10;
% [A_C B_C K_C E0_C A_D B_D K_D E0_D]=cdparam(EfullCby5,EexpCby5,EnomCby5,EfullDby5,EexpDby5,EnomDby5,C_bat,R);
%% Distributed PEV Storage
Conv_Eff=0.95;
Ibatt=zeros(length(busV),1);
I_bat_C_mem=zeros(length(busV),1);
I_bat_D_mem=zeros(length(busV),1);
BatP_mem=zeros(length(busV),1);
Vbatt=zeros(length(busV),1);
SoC_ref=C_bat*DoDmax*(ones(length(busV),1));
SoC=C_bat*DoDmax*(ones(length(busV),1));
charge_time=(zeros(length(busV),1));
P_chg=(zeros(length(busV),1));
I_Chg_max=8.0175*ones(length(busV),1);
omega_Chg=(2.3697/60)*ones(length(busV),1);
CincSoC=((0.7734-0.0005)*C_bat)*ones(length(busV),1);
CdecSoC=((0.7734+0.0005)*C_bat)*ones(length(busV),1);
I_Dsch_max=zeros(length(busV),1);
omega_Dsch_max=zeros(length(busV),1);
DincSoC=zeros(length(busV),1);
DdecSoC=zeros(length(busV),1);
EfullC=400;
EexpC=390;
EnomC=350;
EfullD=400;
EexpD=390;
EnomD=350;
R=0.125;
[A_C B_C K_C E0_C A_D B_D K_D E0_D]=cdparam(EfullC,EexpC,EnomC,EfullD,EexpD,EnomD,C_bat,R);
NRF=0;
PRF=0;
FlucSuppCtr=0;
FlucSuppPeriod=10;
%% Community Energy Storage %%
% Ibatt=zeros(1,1);%zeros(length(busV),1);
% I_bat_C_mem=[];%zeros(length(busV),1);
% I_bat_D_mem=[];%zeros(length(busV),1);
% BatP_mem=[];%zeros(length(busV),1);
% Vbatt=zeros(1,1);%zeros(length(busV),1);
% SoC_ref=C_bat*DoDmax*(ones(length(busV),1));
% SoC=C_bat*DoDmax*ones(1,1);
% charge_time=(zeros(length(busV),1));
% Pchg=(zeros(length(busV),1));
% EfullC=425;
% EexpC=390;
% EnomC=380;
% EfullD=425;
% EexpD=390;
% EnomD=380;
% R=0.026;
% [A_C B_C K_C E0_C A_D B_D K_D E0_D]=cdparam(EfullC,EexpC,EnomC,EfullD,EexpD,EnomD,C_bat,R);
% C_Volt=(zeros(length(busV),1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PEV Parking Nodes 
PEV_parking_bus=[132 134 136 139 141 143 146 148 150]';%randsample([145:150],3)';
PEV_driving_bus1=[136 139 146];
PEV_driving_bus2=[134 148 150];
% PEV_parking_node=[];
PEV_driving_node1=[(4*(PEV_driving_bus1(1)-1)+(1:4)) (4*(PEV_driving_bus1(2)-1)+(1:4)) (4*(PEV_driving_bus1(3)-1)+(1:4))]';
PEV_driving_node2=[(4*(PEV_driving_bus2(1)-1)+(1:4)) (4*(PEV_driving_bus2(2)-1)+(1:4)) (4*(PEV_driving_bus2(3)-1)+(1:4))]';
% for ii=1:length(PEV_parking_bus)
%     PEV_parking_node=[PEV_parking_node;(4*(PEV_parking_bus(ii)-1)+(1:4))'];
% end
clear ii;
% SoC(PEV_driving_node)=C_bat*0.7418;
Cap_Bank_Bus1=[28;29;30;31]; %5;8;10;13;15;19;22;28;29;30;31
Cap_Bank_Node1=[4*(Cap_Bank_Bus1-1)+1;4*(Cap_Bank_Bus1-1)+2;4*(Cap_Bank_Bus1-1)+3];
Cap_Bank_Bus2=5;8;10;13;15;19;22;28;29;30;31;
Cap_Bank_Node2=[4*(Cap_Bank_Bus2-1)+1;4*(Cap_Bank_Bus2-1)+2;4*(Cap_Bank_Bus2-1)+3];
%%
SimTimRes=day_1min; %%% Simulation Time Resolution
ConTime=568;%(find(SimTimRes==8.5)+15);
CoffTime=973;%(find(SimTimRes==16.5)+15);
DonTime=(find(SimTimRes==18.0)+0);
DoffTime=(find(SimTimRes==24.00));
% DonTime1=find(SimTimRes==(1/60)); 
% DoffTime1=find(SimTimRes==8.5);
tt=clock;
ref_gen_flag=1;

NumofPEV=54;
VoltWitoutPEV=[1.0614 1.0614 1.0614];
VoltRiseMitig=[];
VoltSupp=[];
CustomerBus=[131:136 138:143 145:150];
CustomerNode=[];
for ii=1:length(CustomerBus)
    CustomerNode=[CustomerNode;(4*(CustomerBus(ii)-1)+(1:3))'];
end
clear ii;
RandPEVPcnt=round(1+(100-1).*rand(1,1));
RandPEVNum=round((RandPEVPcnt/100)*NumofPEV);
figure;
hist(RandPEVPcnt,10);
PEV_node_data=zeros(1000,54);
%%
for riter=1:1%length(RandPEVNum)
    Ibatt=zeros(length(busV),1);
    busBTP=zeros(length(busV),1);
    SoC=C_bat*(46.8406/C_bat)*(ones(length(busV),1));
    PEV_parking_node=randsample(CustomerNode,RandPEVNum(riter));
    PEV_parking_node=[585   534   538   526   578   570   586   521   553   542];
    daily_sim_for_random_run;
    data_voltrisemitg=[busV(aaa) busV(bbb) busV(ccc)];
    VoltRiseMitig=[VoltRiseMitig;data_voltrisemitg];
    PEV_node_data(riter,:)=[PEV_parking_node;zeros((54-RandPEVNum(riter)),1)];
%     [RandPEVNum(riter) size(PEV_parking_node) size(find(Ibatt>5))]
end
fprintf('\nSolution Time:%d\n',etime(clock,tt))