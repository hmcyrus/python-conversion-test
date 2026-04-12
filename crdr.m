 %% Determination of Charging and Discharging Rates %%
%  C=250;
%  T=8;
%  DoDm=0.399;
%  Usable_C=C*(0.999-DoDm);%*0.9990; %% 0.5835
%  h1=Usable_C/T;
% %  ToS1=0.70-0.005;
% %  CapToS1=(ToS1-DoDm)*C;
%  ConstChrg=0.0*C; % Charge stoted during constant charging period
% 
%  [result feval exit output]=...
%  fsolve(@(x)[x(1)^2+(2*h1-T*x(2))*x(1)+h1^2;(T-2*(h1/x(2))-2*(x(1)/x(2)))*(h1+x(1))-ConstChrg],[12 15])
% %      fsolve(@(x)[x(1)^2+(2*h1-T*x(2))*x(1)+h1^2;x(1)^2+2*x(1)*h1-CapToS1*x(2)+h1^2;(T-2*(h1/x(2))-2*(x(1)/x(2)))*(h1+x(1))-0.3*C],[0 1])
%  h2=result(1)
%  SCR=result(2)
%  0.5*((h1+h2)^2/SCR)
%  (h1+h2)*(T+T-2*(h1/SCR)-2*(h2/SCR))*0.5
 
 %% formulation for PEV paper
%  C_PEV=C_bat;
%  SoC_LL=DoDmax;
 C_PEV=C_bat;
%  T_Chg=6.7667;
 T_Chg=((CoffTime/tsc)-(ConTime/tsc))/60;
 SoC_LL=0.2;
%  kCA=0.5;
%  kCB=0.0;
 SoC_C_A=SoC_LL+(SoCmax-SoC_LL)*kCA;
 SoC_C_B=SoC_C_A+(SoCmax-SoC_LL)*kCB;
 [result feval exit output]=fsolve(@(x)...
     [(0.5*x(1)^2)/x(2)-C_PEV*(SoC_C_A-SoC_LL);(T_Chg-2*(x(1)/x(2)))*x(1)-C_PEV*(SoC_C_B-SoC_C_A)],[0.1 0.1]);
 I_PEV_Chg_max=result(1)
 omega_Chg_PEV=result(2)
%%% for night charge %%%
%  T_Chg=8;
%  SoC_LL=0.5469;
%  SoC_C_A=SoC_LL+(0.640-SoC_LL)*0.25;
%  SoC_C_B=SoC_C_A+(0.640-SoC_LL)*0.5;
%  [result feval exit output]=fsolve(@(x)...
%      [(0.5*x(1)^2)/x(2)-C_PEV*(SoC_C_A-SoC_LL);(T_Chg-2*(x(1)/x(2)))*x(1)-C_PEV*(SoC_C_B-SoC_C_A)],[0.01 0.01]);
%  I_PEV_Chg_max=result(1)
%  omega_Chg_PEV=result(2)
%%% Constant Charging Rate %%%
% I_PEV_Chg_max=C_PEV*(SoCmax-SoC_LL)/T_Chg
% omega_Chg_PEV=0
%% Discharge
 DoDmax=0.500;
 T_Dsch=4;
 SoC_HH=0.91; % 0.7418
 kDA=0.5;
 kDB=0.0;
 SoC_D_A=SoC_HH-(SoC_HH-DoDmax)*kDA;
 SoC_D_B=SoC_D_A-(SoC_HH-DoDmax)*kDB;
 [result feval exit output]=fsolve(@(x)...
     [(0.5*x(1)^2)/x(2)-C_PEV*(SoC_HH-SoC_D_A);(T_Dsch-2*(x(1)/x(2)))*x(1)-C_PEV*(SoC_D_A-SoC_D_B)],[1 1]);
 I_PEV_Dsch_max=result(1)
 omega_Dsch_PEV=result(2)
 
%  I_PEV_Dsch_max=(C_PEV*(SoC_HH-DoDmax))/(0.5*T_Dsch);
%  omega_Dsch_PEV=I_PEV_Dsch_max/T_Dsch;
 
 %% formulation for IAS paper
% PeakLoad=2.2e3;
% beta=0.3;
% DoDmax=0.5469;
% SoC_HH=0.7184; % 0.7418
% SoC_D_A=SoC_HH-(SoC_HH-DoDmax)*0.25;
% SoC_D_B=SoC_D_A-(SoC_HH-DoDmax)*0.5;
% I_PEV_Dsch_max=(1-beta)*PeakLoad*(1/350);
% T1=(C_PEV*(SoC_HH-SoC_D_A))/(0.5*I_PEV_Dsch_max);
% T2=(C_PEV*(SoC_D_A-SoC_D_B))/(I_PEV_Dsch_max);
% T_Dsch=2*T1+T2
% omega_Dsch_PEV=I_PEV_Dsch_max/T1

 
%  PeakLoad=2.2e3;
% %  SoC_data=0.6:0.01:0.8;
%  PSI=0.2:0.01:1.0;
%  DoDmax=0.5469;
%  SoC_HH=0.6; % 0.7418
%  SoC_D_A=SoC_HH-(SoC_HH-DoDmax)*0.25;
%  SoC_D_B=SoC_D_A-(SoC_HH-DoDmax)*0.5;
% T_Dsch_data=[];
% omega_Dsch_data=[];
% for ii=1:length(PSI)
%     I_PEV_Dsch_max=(PSI(ii)*PeakLoad)/350;
%     T1=(C_PEV*(SoC_HH-SoC_D_A))/(0.5*I_PEV_Dsch_max);
%     T2=(C_PEV*(SoC_D_A-SoC_D_B))/(I_PEV_Dsch_max);
%     T_Dsch=2*T1+T2;
%     T_Dsch_data=[T_Dsch_data;T_Dsch];
%     omega_Dsch_PEV=I_PEV_Dsch_max/T1;
%     omega_Dsch_data=[omega_Dsch_data;omega_Dsch_PEV];
% end
% % figure;
% plot(PSI,T_Dsch_data)

% T_Dsch=6;
% PSI_data=[];
% for ii=1:length(SoC_data)
%     SoC_HH=SoC_data(ii);
%     SoC_D_A=SoC_HH-(SoC_HH-DoDmax)*0.25;
%     SoC_D_B=SoC_D_A-(SoC_HH-DoDmax)*0.5;
%     result=fsolve(@(x)...
%         [(0.5*x(1)^2)/x(2)-C_PEV*(SoC_HH-SoC_D_A);(T_Dsch-2*(x(1)/x(2)))*x(1)-C_PEV*(SoC_D_A-SoC_D_B)],[0.01 0.01]);
%     PSI_data=[PSI_data;(result(1)*350)/PeakLoad];
% end
% plot(SoC_data,PSI_data)

 