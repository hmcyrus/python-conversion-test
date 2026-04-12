%% major modifications%%%
% 1. Combined application of charging/discharging algorithm. Date: 17th June 2014
%%
clear all;
clear global;
tsc=1; %% Time Scale Converter. Set to 60 for "1-second" interval simulation
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
data_read;
demand_curve;
% appl_load;
pv_curve;
%%
SimTimRes=day_1min; %%% Simulation Time Resolution
ConTime=492;%34074;%(find(SimTimRes==8.5)+15);
CoffTime=928;%58380;%973;%(find(SimTimRes==16.5)+15);
DonTime=(find(SimTimRes==19.50)+0);
DoffTime=(find(SimTimRes==23.50));
% DonTime1=find(SimTimRes==(1/60)); 
% DoffTime1=find(SimTimRes==8.5);
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
feeder_node_ind=[1:150]; %%% 131:136 for Binda-Bigga
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
V_Bat=[];
I_Bat_act=[];
BTP=zeros(1,3);
C_bat=165;
DoDmax=0.50;%0.5469;
SoCmax=0.90;% 0.99;
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
% SoC_ideal_ref=[];
% SoC_ref_calc=DoDmax*C_bat;
% SoC_actual_ref=[];
% Ibatt_ref_calc=0.00;
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
Conv_Eff=0.96;
Ibatt=zeros(length(busV),1);
Ibatt_act=zeros(length(busV),1);
I_bat_C_mem=zeros(length(busV),1);
I_bat_D_mem=zeros(length(busV),1);
BatP_mem=zeros(length(busV),1);
P_ref_mem=zeros(length(busV),1);
Vbatt=zeros(length(busV),1);
Vbatt_C=zeros(length(busV),1);
Vbatt_D=zeros(length(busV),1);
SoC_ref=C_bat*DoDmax*(ones(length(busV),1));
SoC=C_bat*0.5*(ones(length(busV),1));
charge_time=(zeros(length(busV),1));
P_chg=(zeros(length(busV),1));
kCA=0.5;
kCB=0.0;
crdr; %%% run charging parameter calculation algorithm
I_Chg_max=I_PEV_Chg_max*ones(length(busV),1);
omega_Chg=(omega_Chg_PEV/(60*tsc))*ones(length(busV),1);
CincSoC=((SoC_C_A-0.0005)*C_bat)*ones(length(busV),1);
CdecSoC=((SoC_C_B+0.0005)*C_bat)*ones(length(busV),1);
% I_Dsch_max=zeros(length(busV),1);
% omega_Dsch=zeros(length(busV),1);
% DincSoC=zeros(length(busV),1);
% DdecSoC=zeros(length(busV),1);
I_Dsch_max=I_PEV_Dsch_max*ones(length(busV),1);
omega_Dsch=(omega_Dsch_PEV/(60*tsc))*ones(length(busV),1);
DincSoC=((SoC_D_A-0.0005)*C_bat)*ones(length(busV),1);
DdecSoC=((SoC_D_B+0.0005)*C_bat)*ones(length(busV),1);
%%% random SoC selection, assigning and determination of discharge parameters
% CustomerBus=[131:136 138:143 145:150]';
CustomerBus=[14]'; %%for Utility Scale PV plant 
CustomerNode=[];
for ii=1:length(CustomerBus)
    CustomerNode=[CustomerNode;(4*(CustomerBus(ii)-1)+(1:3))'];
end
clear ii;
% P_ref_mem=zeros(length(CustomerNode),1);
supp_ctr=zeros(length(CustomerNode),1);
% load SoC_Arrival_random_IASpaper_data1;
% % SoCRandom=0.6+(0.8-0.6).*rand(length(CustomerNode),1);
% T_Dsch=4*ones(length(SoCRandom),1);
% T_Dsch(RandomArrivalTime>19.5)=T_Dsch(RandomArrivalTime>19.5)-(RandomArrivalTime(RandomArrivalTime>19.5)-19.5);
% % RandomArrivalTime=18+(1).*randn(length(CustomerNode),1);
% % PEV_Late_Comer=[581;535;527;558;583;537;587;577;557;582];
% for ii=1:length(SoCRandom)
%     SoC_HH=SoCRandom(ii);
%     SoC_D_A=SoC_HH-(SoC_HH-DoDmax)*0.25;
%     SoC_D_B=SoC_D_A-(SoC_HH-DoDmax)*0.5;
%     result=fsolve(@(x)...
%         [(0.5*x(1)^2)/x(2)-C_bat*(SoC_HH-SoC_D_A);(T_Dsch(ii)-2*(x(1)/x(2)))*x(1)-C_bat*(SoC_D_A-SoC_D_B)],[0.01 0.01]);
%     DincSoC(CustomerNode(ii))=C_bat*SoC_D_A;
%     DdecSoC(CustomerNode(ii))=C_bat*SoC_D_B;
%     I_Dsch_max(CustomerNode(ii))=result(1);
%     omega_Dsch(CustomerNode(ii))=result(2)/60;
% end
% clear ii;
% SoC=C_bat*0.823*(ones(length(busV),1));
% SoC(CustomerNode)=(C_bat*(SoCRandom));
% SoC_ref_gen_dsch;

EfullC=756;
EexpC=666;
EnomC=576;
EfullD=700;
EexpD=626;
EnomD=541;
R=(100*(0.65*1e-3))/4;
[A_C B_C K_C E0_C A_D B_D K_D E0_D]=cdparam(EfullC,EexpC,EnomC,EfullD,EexpD,EnomD,C_bat,R);
NRF=0;
PRF=0;
FlucSuppCtr=0;
FlucSuppPeriod=2;
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
PEV_night_charge_bus=[133 135 137 140 142 144 147 149]';
PEV_driving_bus1=[136 139 146]';
PEV_driving_bus2=[134 148 150]';
PEV_parking_node=[];
PEV_night_charge_node=[];
PEV_driving_node1=[(4*(PEV_driving_bus1(1)-1)+(1:3)) (4*(PEV_driving_bus1(2)-1)+(1:3)) (4*(PEV_driving_bus1(3)-1)+(1:3))]';
PEV_driving_node2=[(4*(PEV_driving_bus2(1)-1)+(1:3)) (4*(PEV_driving_bus2(2)-1)+(1:3)) (4*(PEV_driving_bus2(3)-1)+(1:3))]';
for ii=1:length(PEV_parking_bus)
    PEV_parking_node=[PEV_parking_node;(4*(PEV_parking_bus(ii)-1)+(1:3))'];
end
clear ii;
for ii=1:length(PEV_night_charge_bus)
    PEV_night_charge_node=[PEV_night_charge_node;(4*(PEV_night_charge_bus(ii)-1)+(1:3))'];
end
clear ii;
[~,~,ib]=intersect(PEV_driving_node1,CustomerNode);
CustomerDrivingInd1=ib;
clear ib;
% SoC(PEV_driving_node)=C_bat*0.7418;
Cap_Bank_Bus1=[28;29;30;31]; %5;8;10;13;15;19;22;28;29;30;31
Cap_Bank_Node1=[4*(Cap_Bank_Bus1-1)+1;4*(Cap_Bank_Bus1-1)+2;4*(Cap_Bank_Bus1-1)+3];
Cap_Bank_Bus2=5;8;10;13;15;19;22;28;29;30;31;
Cap_Bank_Node2=[4*(Cap_Bank_Bus2-1)+1;4*(Cap_Bank_Bus2-1)+2;4*(Cap_Bank_Bus2-1)+3];


tt=clock;
ref_gen_flag=1;
% simu_snapshot=[find(day_1sec==11.35)-14 find(day_1sec==11.45)+400];
simu_snapshot=[452 (452+476)];
SoC_ref_gen;
SoC=SoC_ideal_ref(simu_snapshot(1))*(ones(length(busV),1));
I_bat_C_mem=Ibatt_ref(simu_snapshot(1))*(ones(length(busV),1));

for SimIter=simu_snapshot(1):simu_snapshot(2);%;find(day_1min==(1/60)):1:find(day_1min==(14))%length(day_15min)%length(demand_curve_shape_factor)
    SoC_ref=SoC_ideal_ref(SimIter)*ones(4*tot_bus,1);
    time_indx=SimIter;
    iiii
%     if ((time_indx>=ConTime)&&(ref_gen_flag==1))
%         SoC_ref_gen;
%         ref_gen_flag=0;
%     end
% if time_indx==735
%     SoC(PEV_driving_node1)=SoC(PEV_driving_node1)-5;
% end
    LDM=2.20;%demand_curve_shape_factor(ii);
%     load_P=tot_load_P(ii);
%     load_Q=tot_load_Q(ii);
%%%% load variation using demand_curve.m %%%%%%%%%%%%%    
    load_P=demand_curve_shape_factor(SimIter)*ones(4*tot_bus,1);
    load_Q=demand_curve_shape_factor(SimIter)*ones(4*tot_bus,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% load variation using appl_load.m %%%%%%%%%%%%% 
%     load_P=tot__P(:,ii);
%     load_Q=tot__Q(:,ii);
%     p_P=p_P_agg(ii);
%     p_Z=p_Z_agg(ii);
%     p_I=p_I_agg(ii);
%     q_P=q_P_agg(ii);
%     q_Z=q_Z_agg(ii);
%     q_I=q_I_agg(ii);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    busPL=p_P*LDM*(load_P.*cell2mat(bus(:,4)));
    busQL=q_P*LDM*(load_Q.*cell2mat(bus(:,5)));
%     if (time_indx>1020&&time_indx<=1350)%(time_indx<500||time_indx>1020)
%         busV(4*(1-1)+(1:3))=[1.07;1.07;1.07];
%         busQL(Cap_Bank_Node)=-0.06;
%     elseif (time_indx<=420||time_indx>1350)%(time_indx<500||time_indx>1020)
%         busV(4*(1-1)+(1:3))=[1.05;1.05;1.05];
%         busQL(Cap_Bank_Node)=-0.00;
%     elseif (time_indx>540&&time_indx<1020)
%         busV(4*(1-1)+(1:3))=[1.05;1.05;1.05];
%         busQL(Cap_Bank_Node)=-0.00;
%     elseif (time_indx>420&&time_indx<=540)
%         busV(4*(1-1)+(1:3))=[1.10;1.10;1.10];
%         busQL(Cap_Bank_Node)=-0.10;
%     end
%% PEV based Storage Park
% busBTP(4*(144-1)+(1:3))=0.1;
%% Cap. Bank Switching and Zone Substation (Swing Bus) Voltage Setpoint 
    if (time_indx>960&&time_indx<=1440)%(time_indx<500||time_indx>1020)
        busV(4*(1-1)+(1:3))=[1.13;1.13;1.13];
        busQL(Cap_Bank_Node1)=-0.20;
        busQL(Cap_Bank_Node2)=-0.20;
    else
        busV(4*(1-1)+(1:3))=[1.11;1.11;1.11];
        busQL(Cap_Bank_Node2)=-0.20;
    end
    %%% night charge
%     if (time_indx>1&&time_indx<=580)%(time_indx<500||time_indx>1020)
%         busV(4*(1-1)+(1:3))=[1.18;1.18;1.18];
%         busQL(Cap_Bank_Node1)=-0.20;
%     else
%         busV(4*(1-1)+(1:3))=[1.13;1.13;1.13];
%         busQL(Cap_Bank_Node1)=-0.1;
%     end
    %%
    PPL=-2.0*1.79*pv_curve_shape_factor(SimIter);
%     pv_curve_reshape_factor=reshape_factor(:,SimIter);
    busDGP=PPL*(cell2mat(bus(:,15)));
    busDGP=pv_curve_reshape_factor.*busDGP;
    pv1=1e2*abs((-2.0*1.79*pv_curve_shape_factor(SimIter-1))*(cell2mat(bus(:,15))))+0*busBTP;
    pv2=1e2*abs(busDGP);
    pvp_ramprate=(pv2-pv1);
    pvp_ramprate=[pvp_ramprate(aaa) pvp_ramprate(bbb) pvp_ramprate(ccc) pvp_ramprate(ddd)];
    PVP_RampRate=[PVP_RampRate;pvp_ramprate];
%     nrci3ph4w; % run newton-raphson current injection based three phase power flow
%     lineflow_3p4w;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
volt2=[busV(aaa) busV(bbb) busV(ccc)];
v_ramprate=((volt2-volt1)./volt1)*100;
V_RampRate=[V_RampRate;v_ramprate];

pvp=abs([busDGP(aaa) busDGP(bbb) busDGP(ccc)]);
PVP=[PVP;pvp];
PVP_sum=zeros(14,3);
ma_win=60; % length of the moving average window
if iiii>=ma_win
%     pvp_ma=(PVP((((iiii-5)*14+1):((iiii-4)*14)),:)+PVP((((iiii-4)*14+1):((iiii-3)*14)),:)+PVP((((iiii-3)*14+1):((iiii-2)*14)),:)+PVP((((iiii-2)*14+1):((iiii-1)*14)),:)+PVP((((iiii-1)*14+1):((iiii-0)*14)),:))/5;
    for ma_cntr=((iiii-ma_win)+1):iiii
        PVP_sum=PVP_sum+PVP(((ma_cntr-1)*14+1):(ma_cntr*14),:);
    end
    pvp_ma=PVP_sum/ma_win;
    PVP_MA=[PVP_MA;pvp_ma];
end
iiii=iiii+1;


ld2=abs([busPL(aaa) busPL(bbb) busPL(ccc)]);
ldp_ramprate=((ld2-ld1)./ld1)*100;
LDP_RampRate=[LDP_RampRate;ldp_ramprate];

oldV=busV;
oldA=busA;

%% P_ref based control
P_ref=zeros(length(CustomerNode),1);

PR=(busPL-abs(busDGP));
PR(PR>0)=0;
PR=1e2*abs(PR);

P_shape_ref=zeros(length(CustomerNode),1);
PR_pcc=PR(CustomerNode);
SoCcalc=C_bat-SoC;
E_C=E0_C-K_C*(C_bat./(C_bat-SoCcalc))+A_C.*exp(-B_C*SoCcalc);
E_D=E0_D-K_D*(C_bat./(C_bat-SoCcalc))+A_D.*exp(-B_D*SoCcalc);
Vbatt(CustomerNode)=1*E_C(CustomerNode);
Vbatt_C(CustomerNode)=1*E_C(CustomerNode);
Vbatt_D(CustomerNode)=1*E_D(CustomerNode);
charging_node_ind=CustomerNode;
Ibatt=I_bat_C_mem;
SoC_ref=SoC_ideal_ref(SimIter)*ones(4*tot_bus,1);

for ii=1:length(CustomerNode)
    if SoC(charging_node_ind(ii))<=CincSoC(charging_node_ind(ii))
        Ibatt(charging_node_ind(ii))=Ibatt(charging_node_ind(ii))+(omega_Chg(charging_node_ind(ii)));
    elseif SoC(charging_node_ind(ii))>=CdecSoC(charging_node_ind(ii))
        Ibatt(charging_node_ind(ii))=Ibatt(charging_node_ind(ii))-(omega_Chg(charging_node_ind(ii)));
    elseif (SoC(charging_node_ind(ii))<=CincSoC(charging_node_ind(ii)))&&(SoC(charging_node_ind(ii))>=CdecSoC(charging_node_ind(ii)))
       Ibatt(charging_node_ind(ii))=I_Chg_max(charging_node_ind(ii));
    end
    if Ibatt(charging_node_ind(ii))<0
        Ibatt(charging_node_ind(ii))=0;
    end
    SoC_comp=SoC(charging_node_ind(ii))+1*Ibatt(charging_node_ind(ii))*(1/(60*tsc));
    CR_STD_comp_flg=0;
    CR_STD_comp=0;
    if SoC_ref(charging_node_ind(ii))~=SoC_comp
            CR_STD_comp=(SoC_ref(charging_node_ind(ii))-SoC_comp)*((60*tsc)/10); % spread time: 20 sec 
            CR_STD_comp_flg=1;
            if CR_STD_comp>0.01
                CR_STD_comp=(CR_STD_comp/1);
            end
            Ibatt(charging_node_ind(ii))=Ibatt(charging_node_ind(ii))+CR_STD_comp;
    end
    P_shape_ref(ii)=(1e-3*Vbatt_C(CustomerNode(ii))*Ibatt(charging_node_ind(ii)));
    if CR_STD_comp_flg==1
        Ibatt(charging_node_ind(ii))=Ibatt(charging_node_ind(ii))-CR_STD_comp;
    end
    if PR(CustomerNode(ii))>0
        if (P_shape_ref(ii))<=PR(CustomerNode(ii))
            %         disp('1');
            P_shape_ref(ii)=P_shape_ref(ii);
        elseif (P_shape_ref(ii))>PR(CustomerNode(ii))
            P_shape_ref(ii)=PR(CustomerNode(ii));
            %         disp('2');
        end
    else
        P_shape_ref(ii)=0;
    end
end
% P_shape_ref=zeros(length(CustomerNode),1);
P_support_ref=50*zeros(length(CustomerNode),1);
% CR_STD_comp;
del_pv=pvp_ramprate(14,1);
curr_PVP=pv2(CustomerNode(1));
prev_PVP=pv1(CustomerNode(1));
prev_BatP=P_ref_mem(CustomerNode(1));
LIM=5;
if SimIter<CoffTime
for ii=1:length(CustomerNode)
    if curr_PVP-prev_PVP<-LIM
%         disp('1')
        NRF=1;PRF=0;
        supp_ctr(ii)=0;
        if curr_PVP-(prev_PVP+prev_BatP)<=-LIM
%             disp('1_1')
            P_ref(ii)=-LIM+(prev_PVP+prev_BatP)-curr_PVP;
        elseif curr_PVP-(prev_PVP+prev_BatP)>=LIM
%             disp('1_2')
            P_ref(ii)=LIM+(prev_PVP+prev_BatP)-curr_PVP;
        elseif ((curr_PVP-(prev_PVP+prev_BatP)>-LIM)&&(curr_PVP-(prev_PVP+prev_BatP)<LIM))
%             disp('1_3')
            P_ref(ii)=0;
        end
    elseif curr_PVP-prev_PVP>LIM
%         disp('2')
        PRF=1;NRF=0;
        if curr_PVP-(prev_PVP+prev_BatP)>=LIM
            P_ref(ii)=LIM+(prev_PVP+prev_BatP)-curr_PVP;
        elseif curr_PVP-(prev_PVP+prev_BatP)<=-LIM
            P_ref(ii)=-LIM+(prev_PVP+prev_BatP)-curr_PVP;
        elseif ((curr_PVP-(prev_PVP+prev_BatP)>-LIM)&&(curr_PVP-(prev_PVP+prev_BatP)<LIM))
            P_ref(ii)=0;
        end
    elseif PR(CustomerNode(ii))==0%(NRF==1)&&(PR(CustomerNode(ii))==0)
%         disp('3')
        if (curr_PVP+P_support_ref(ii))-(prev_PVP+prev_BatP)<=-LIM
%             disp('3_1')
            P_ref(ii)=-LIM+(prev_PVP+prev_BatP)-curr_PVP;
        elseif (curr_PVP+P_support_ref(ii))-(prev_PVP+prev_BatP)>=LIM
%             disp('3_2')
            P_ref(ii)=LIM+(prev_PVP+prev_BatP)-curr_PVP;
        elseif (((curr_PVP+P_support_ref(ii))-(prev_PVP+prev_BatP)>-LIM)&&((curr_PVP+P_support_ref(ii))-(prev_PVP+prev_BatP)<LIM))
%             disp('3_3')
            P_ref(ii)=P_support_ref(ii);
        end
    elseif PR(CustomerNode(ii))>0
%         disp('4')
        NRF=0;PRF=0;
        if (curr_PVP+(-P_shape_ref(ii)))-(prev_PVP+prev_BatP)<=-LIM
            P_ref(ii)=-LIM+(prev_PVP+prev_BatP)-curr_PVP;
        elseif (curr_PVP+(-P_shape_ref(ii)))-(prev_PVP+prev_BatP)>=LIM
            P_ref(ii)=LIM+(prev_PVP+prev_BatP)-curr_PVP;
        else
            P_ref(ii)=-P_shape_ref(ii);
        end
    else
%         disp('5')
        NRF=0;PRF=0;
        if curr_PVP-(prev_PVP+prev_BatP)<=-LIM
            P_ref(ii)=-LIM+(prev_PVP+prev_BatP)-curr_PVP;
        elseif curr_PVP-(prev_PVP+prev_BatP)>=LIM
            P_ref(ii)=LIM+(prev_PVP+prev_BatP)-curr_PVP;
        elseif ((curr_PVP-(prev_PVP+prev_BatP)>-LIM)&&(curr_PVP-(prev_PVP+prev_BatP)<LIM))
            P_ref(ii)=0;
        end
    end
end
end

%%% Driving Interventions %%%
% if (SimIter>=705&&SimIter<=735)
%     P_ref(CustomerDrivingInd1)=0;
% end
%% Peak Shaving Strategies %%
% if (SimIter>=342&&SimIter<=(342+(2.5*60)))
%     if SimIter==342
%         SoC_ref_gen_dsch;
%     end
%     Ibatt=I_ref_data(((4*tot_bus)*(SimIter-1)+1):((4*tot_bus)*(SimIter)),:);
%     P_ref=1e-3*Vbatt(CustomerNode).*Ibatt(CustomerNode);
% end
% if (SimIter>=1080&&SimIter<=(1080+(3*60)))
% %     if SimIter==1080
% %         SoC_ref_gen_dsch;
% %     end
%     Ibatt=I_ref_data(((4*tot_bus)*(SimIter-1)+1):((4*tot_bus)*(SimIter)),:);
%     P_ref=1e-3*Vbatt(CustomerNode).*Ibatt(CustomerNode);
% end
if (SimIter>=929)
    if (SimIter==929)
        SoC(CustomerNode)=SoC(CustomerNode)*0.98;
    end
    PF=(busPL-abs(busDGP));
    PF(PF<0)=0;
    PF=1e2*abs(PF);
    P_ref=PF(CustomerNode).*(((SoC(CustomerNode)/C_bat)-0.5)*1.4);
 %     if SimIter==1080
%         SoC_ref_gen_dsch;
%     end
%     Ibatt=I_ref_data(((4*tot_bus)*(SimIter-1)+1):((4*tot_bus)*(SimIter)),:);
%     P_ref=1e-3*Vbatt(CustomerNode).*Ibatt(CustomerNode);
end
%%% SoC and Battery Voltage %%%
P_batt=P_ref*1000;
% P_batt=sum(P_ref)*1000; %% for central storage
SoCcalc=C_bat-SoC;
E_C=E0_C-K_C*(C_bat./(C_bat-SoCcalc))+A_C.*exp(-B_C*SoCcalc);
E_D=E0_D-K_D*(C_bat./(C_bat-SoCcalc))+A_D.*exp(-B_D*SoCcalc);
for ii=1:length(P_batt)
    if P_ref(ii)>=0
        Vbatt(CustomerNode(ii))=1*(E_D(CustomerNode(ii)))-((P_batt(ii)/Vbatt_D(CustomerNode(ii)))*R);
%         if SoC(CustomerNode(ii))>((DoDmax*C_bat)+0.01)
            SoC(CustomerNode(ii))=SoC(CustomerNode(ii))-abs(((P_batt(ii)/Conv_Eff)/Vbatt(CustomerNode(ii))))*(1/(60*tsc));
%         end
    elseif P_ref(ii)<0
        Vbatt(CustomerNode(ii))=1*(E_C(CustomerNode(ii)))+((P_batt(ii)/Vbatt_C(CustomerNode(ii)))*R);
        if SoC(CustomerNode(ii))<((SoCmax*C_bat)-0.01) 
            SoC(CustomerNode(ii))=SoC(CustomerNode(ii))+abs(((P_batt(ii)*Conv_Eff)/Vbatt(CustomerNode(ii))))*(1/(60*tsc));
        end
    end
    Ibatt_act(CustomerNode(ii))=(-P_batt(ii))/Vbatt(CustomerNode(ii));
end
%%%%
P_ref_mem(CustomerNode)=P_ref;
I_bat_C_mem=Ibatt;
%%
busBTP(CustomerNode)=-1*1e-2*P_ref;
% busBTP(CustomerNode)=zeros;
for iter=1:50
    curr_mm_3p3_4w;
    if(max(abs(dI))<=1e-6)
        break;
    end
end
% iter
volt3=[busV(aaa) busV(bbb) busV(ccc)];
v_ramprate_smooth=((volt3-volt1)./volt1)*100;
V_RampRate_smooth=[V_RampRate_smooth;v_ramprate_smooth];

btp1=abs([busBTP(aaa) busBTP(bbb) busBTP(ccc)]);
Neg_Ramp_Flag=0;
Pos_Ramp_Flag=0;
volt1=volt2;
% pv1=pv2;
ld1=ld2;
%     storage_cont;
%     data=[busV(aaa) busA(aaa)*(180/pi) busV(bbb) busA(bbb)*(180/pi) busV(ccc) busA(ccc)*(180/pi)];
% V_Reg_L=0.94;
% V_Reg_H=1.09;
% if (busV(4*(18-1)+1)<V_Reg_L||busV(4*(18-1)+1)>V_Reg_H||busV(4*(18-1)+2)<V_Reg_L||busV(4*(18-1)+2)>V_Reg_H||busV(4*(18-1)+3)<V_Reg_L||busV(4*(18-1)+3)>V_Reg_H)
%     reg_bb1;
% end;
% if (busV(4*(26-1)+1)<V_Reg_L||busV(4*(26-1)+1)>V_Reg_H||busV(4*(26-1)+2)<V_Reg_L||busV(4*(26-1)+2)>V_Reg_H||busV(4*(26-1)+3)<V_Reg_L||busV(4*(26-1)+3)>V_Reg_H)
%     reg_bb2;
% end;
% if (busV(4*(28-1)+1)<V_Reg_L||busV(4*(28-1)+1)>V_Reg_H||busV(4*(28-1)+2)<V_Reg_L||busV(4*(28-1)+2)>V_Reg_H||busV(4*(28-1)+3)<V_Reg_L||busV(4*(28-1)+3)>V_Reg_H)
%     reg_bb3;
% end;
    lineflow_3p4w;
%     pv_cont;
%     OldV=busV;
%     OldA=busA;

%     feeder_Load=sum(busPL((4*(108-1)+1):(4*(117-1)+4)))+sum(busPI((4*(108-1)+1):(4*(117-1)+4)))+sum(busPZ((4*(108-1)+1):(4*(117-1)+4)))+...
%         sum(busQL((4*(108-1)+1):(4*(117-1)+4)))+sum(busQI((4*(108-1)+1):(4*(117-1)+4)))+sum(busQZ((4*(108-1)+1):(4*(117-1)+4)));
%     feeder_PV=sum(busDGP((4*(108-1)+1):(4*(117-1)+4)));
    feeder_Load=sum(busPL((4*(5-1)+1):(4*(14-1)+4)))+sum(busPI((4*(5-1)+1):(4*(14-1)+4)))+sum(busPZ((4*(5-1)+1):(4*(14-1)+4)))+...
        sum(busQL((4*(5-1)+1):(4*(14-1)+4)))+sum(busQI((4*(5-1)+1):(4*(14-1)+4)))+sum(busQZ((4*(5-1)+1):(4*(14-1)+4)));
    feeder_PV=sum(busDGP((4*(5-1)+1):(4*(14-1)+4)));
    Feeder_Load=vertcat(Feeder_Load,feeder_Load);
    feeder_load_a_P=((busPL(4*(feeder_node_ind-1)+1))+(busPI(4*(feeder_node_ind-1)+1))+(busPZ(4*(feeder_node_ind-1)+1)));
    feeder_load_a_Q=((busQL(4*(feeder_node_ind-1)+1))+(busQI(4*(feeder_node_ind-1)+1))+(busQZ(4*(feeder_node_ind-1)+1)));
    feeder_load_b_P=((busPL(4*(feeder_node_ind-1)+2))+(busPI(4*(feeder_node_ind-1)+2))+(busPZ(4*(feeder_node_ind-1)+2)));
    feeder_load_b_Q=((busQL(4*(feeder_node_ind-1)+2))+(busQI(4*(feeder_node_ind-1)+2))+(busQZ(4*(feeder_node_ind-1)+2)));
    feeder_load_c_P=((busPL(4*(feeder_node_ind-1)+3))+(busPI(4*(feeder_node_ind-1)+3))+(busPZ(4*(feeder_node_ind-1)+3)));
    feeder_load_c_Q=((busQL(4*(feeder_node_ind-1)+3))+(busQI(4*(feeder_node_ind-1)+3))+(busQZ(4*(feeder_node_ind-1)+3)));
    feeder_load_abc=[feeder_load_a_P feeder_load_a_Q feeder_load_b_P feeder_load_b_Q feeder_load_c_P feeder_load_c_Q];
    Feeder_Load_abc=vertcat(Feeder_Load_abc,feeder_load_abc);
    Feeder_PV=vertcat(Feeder_PV,feeder_PV);
    feeder_PV_abc=[(busDGP((4*(feeder_node_ind-1)+1))) (busDGP((4*(feeder_node_ind-1)+2))) (busDGP((4*(feeder_node_ind-1)+3)))];
    Feeder_PV_abc=vertcat(Feeder_PV_abc,feeder_PV_abc);
    data_volt=[busV(aaa) busA(aaa)*(180/pi) busV(bbb) busA(bbb)*(180/pi) busV(ccc) busA(ccc)*(180/pi) busV(ddd) busA(ddd)*(180/pi)];
%     data_volt=[OldV(aaa) OldA(aaa)*(180/pi) OldV(bbb) OldA(bbb)*(180/pi) OldV(ccc) OldA(ccc)*(180/pi)];
    data_tap=[T12 T22 T32]/0.00625;
    Data_Volt=vertcat(Data_Volt,data_volt);
    Data_Tap=vertcat(Data_Tap,data_tap);
%     data_pflow=transpose(real(S_from(4*(127-1)+(1:4))))*(kVA_base*1e-3);
%     data_qflow=transpose(imag(S_from(4*(127-1)+(1:4))))*(kVA_base*1e-3);
    data_sflow=[S_from(4*(line_ind-1)+1) S_from(4*(line_ind-1)+2) S_from(4*(line_ind-1)+3) S_from(4*(line_ind-1)+4)];
    data_sflow_MV=[S_from(4*(line_ind_MV-1)+1) S_from(4*(line_ind_MV-1)+2) S_from(4*(line_ind_MV-1)+3) S_from(4*(line_ind_MV-1)+4)];
    data_iflow=[I_from(4*(line_ind-1)+1) I_from(4*(line_ind-1)+2) I_from(4*(line_ind-1)+3) I_from(4*(line_ind-1)+4)];
    data_loss=[line_loss_a line_loss_b line_loss_c line_loss_n line_loss]*(kVA_base*1e-3);
%     Data_Pflow=vertcat(Data_Pflow,data_pflow);
%     Data_Qflow=vertcat(Data_Qflow,data_qflow);
    Data_Sflow=vertcat(Data_Sflow,data_sflow);
    Data_Iflow=vertcat(Data_Iflow,data_iflow);
    Data_Sflow_MV=vertcat(Data_Sflow_MV,data_sflow_MV);
    Data_Loss=vertcat(Data_Loss,data_loss);
    
    SOC_Ref=vertcat(SOC_Ref,[SoC_ref(4*(feeder_node_ind-1)+1) SoC_ref(4*(feeder_node_ind-1)+2) SoC_ref(4*(feeder_node_ind-1)+3)]/C_bat);
    SOC=vertcat(SOC,[SoC(4*(feeder_node_ind-1)+1) SoC(4*(feeder_node_ind-1)+2) SoC(4*(feeder_node_ind-1)+3)]/C_bat);
    I_Bat=vertcat(I_Bat,[Ibatt(4*(feeder_node_ind-1)+1) Ibatt(4*(feeder_node_ind-1)+2) Ibatt(4*(feeder_node_ind-1)+3)]);
    I_Bat_act=vertcat(I_Bat_act,[Ibatt_act(4*(feeder_node_ind-1)+1) Ibatt_act(4*(feeder_node_ind-1)+2) Ibatt_act(4*(feeder_node_ind-1)+3)]);
    V_Bat=vertcat(V_Bat,[Vbatt(4*(feeder_node_ind-1)+1) Vbatt(4*(feeder_node_ind-1)+2) Vbatt(4*(feeder_node_ind-1)+3)]);
    BTP=vertcat(BTP,[busBTP(4*(feeder_node_ind-1)+1) busBTP(4*(feeder_node_ind-1)+2) busBTP(4*(feeder_node_ind-1)+3)]);
    Ibatt=zeros(length(busV),1);
%     clear data_volt data_tap data_pflow data_qflow data_loss feeder_load feeder_load_abc;
end
fprintf('\nSolution Time:%d\n',etime(clock,tt))
Data_Volt(1,:)=[];
Data_Tap(1,:)=[];
% Data_Pflow(1,:)=[];
% Data_Qflow(1,:)=[];
Data_Sflow(1,:)=[];
Data_Sflow_MV(1,:)=[];
Data_Iflow(1,:)=[];
Data_Loss(1,:)=[];
Feeder_Load_abc(1,:)=[];
Feeder_PV(1,:)=[];
SOC(1,:)=[];
BTP(1,:)=[];
contprof=-(Feeder_PV_abc(14:150:length(Feeder_PV_abc(:,1)),1)+BTP(14:150:length(BTP(:,1)),1));
for ijj=2:length(contprof)
    contdiff(ijj)=contprof(ijj)-contprof(ijj-1);
end
% [max(busV(4*((5:14)-1)+4)*kV_baseL)  max(busV(4*((5:14)-1)+4)*kV_baseL)] %%% maximum NG voltage 