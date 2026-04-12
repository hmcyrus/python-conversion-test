% datevec={};
% dates=1:24;
% for ii=1:length(dates)
%     if dates(ii)<=9
%         datevec{ii}=strcat('16060',num2str(dates(ii)),'00');
%     else
%         datevec{ii}=strcat('1606',num2str(dates(ii)),'00');
%     end
% end
% % datevec='16053100';
% 
% UQGGridImport=[];
% UQGPV=[];
% UQGDemand=[];
% UQGCalcLoad_P=[];
% UQGPBESS_B1=[];
% UQGPBESS_B2=[];
% UQGSoCBESS_B1=[];
% UQGSoCBESS_B2=[];
% UQGMinTempBESS_B1=[];
% UQGMaxTempBESS_B1=[];
% UQGMinTempBESS_B2=[];
% UQGMaxTempBESS_B2=[];
% UQGEImpBESS_B1=[];
% UQGEExpBESS_B1=[];
% UQGEImpBESS_B2=[];
% UQGEExpBESS_B2=[];
% 
% for ii=1:length(datevec)
% 
% Incomer1052_File=strcat('P:\Gatton Data\RL8167.7\logs\Incm1052\',datevec{ii},'.csv');
% Feeder1152_File=strcat('P:\Gatton Data\RL8167.7\logs\Fdr1152\',datevec{ii},'.csv');
% InvF1_File=strcat('P:\Gatton Data\RL8167.7\logs\Inv1\',datevec{ii},'.csv');
% InvF2_File=strcat('P:\Gatton Data\RL8167.7\logs\Inv2\',datevec{ii},'.csv');
% InvF3_File=strcat('P:\Gatton Data\RL8167.7\logs\Inv3\',datevec{ii},'.csv');
% InvSA_File=strcat('P:\Gatton Data\RL8167.7\logs\InvSA\',datevec{ii},'.csv');
% InvDA_File=strcat('P:\Gatton Data\RL8167.7\logs\InvDA\',datevec{ii},'.csv');
% BMS_File=strcat('P:\Gatton Data\RL8167.7\logs\BatSys1m\',datevec{ii},'.csv');
% BInv1_File=strcat('P:\Gatton Data\RL8167.7\logs\Batt1\',datevec{ii},'.csv');
% BInv2_File=strcat('P:\Gatton Data\RL8167.7\logs\Batt2\',datevec{ii},'.csv');
% Calc_File=strcat('P:\Gatton Data\RL8167.7\logs\Calcs\',datevec{ii},'.csv');
% 
% P_Incomer1052=xlsread(Incomer1052_File,1,'R2:R1441');
% P_Feeder1152=xlsread(Feeder1152_File,1,'R2:R1441');
% CalcLoad_P=xlsread(Calc_File,1,'D2:D1441');
% P_InvF1=xlsread(InvF1_File,1,'D2:D1441');
% P_InvF2=xlsread(InvF2_File,1,'D2:D1441');
% P_InvF3=xlsread(InvF3_File,1,'D2:D1441');
% P_InvSA=xlsread(InvSA_File,1,'D2:D1441');
% P_InvDA=xlsread(InvDA_File,1,'D2:D1441');
% PBESS_B1=xlsread(BInv1_File,1,'R2:R1441');
% PBESS_B2=xlsread(BInv2_File,1,'R2:R1441');
% SoCBESS_B1=xlsread(BMS_File,1,'I2:I1441');
% SoCBESS_B2=xlsread(BMS_File,1,'Q2:Q1441');
% MinTempBESS_B1=xlsread(BMS_File,1,'O2:O1441');
% MaxTempBESS_B1=xlsread(BMS_File,1,'P2:P1441');
% MinTempBESS_B2=xlsread(BMS_File,1,'W2:W1441');
% MaxTempBESS_B2=xlsread(BMS_File,1,'X2:X1441');
% 
% 
% %%% SoC data filtering %%%
% SoCdiff=abs(diff(SoCBESS_B1));
% diff_ind=find(SoCdiff>=3);
% diff_ind(2:2:length(diff_ind))=[];
% SoCBESS_B1(diff_ind+1)=SoCBESS_B1(diff_ind);
% SoCdiff=abs(diff(SoCBESS_B2));
% diff_ind=find(SoCdiff>=3);
% diff_ind(2:2:length(diff_ind))=[];
% SoCBESS_B2(diff_ind+1)=SoCBESS_B2(diff_ind);
% 
% %% Temp data filtering %%%
% % Tempdiff=abs(diff(MinTempBESS_B1));
% % diff_ind=find(Tempdiff>=0.2);
% % diff_ind(2:2:length(diff_ind))=[];
% % MinTempBESS_B1(diff_ind+1)=MinTempBESS_B1(diff_ind);
% % 
% % Tempdiff=abs(diff(MaxTempBESS_B1));
% % diff_ind=find(Tempdiff>=0.2);
% % diff_ind(2:2:length(diff_ind))=[];
% % MaxTempBESS_B1(diff_ind+1)=MaxTempBESS_B1(diff_ind);
% % 
% % Tempdiff=abs(diff(MinTempBESS_B2));
% % diff_ind=find(Tempdiff>=0.2);
% % diff_ind(2:2:length(diff_ind))=[];
% % MinTempBESS_B2(diff_ind+1)=MinTempBESS_B2(diff_ind);
% % 
% % Tempdiff=abs(diff(MaxTempBESS_B2));
% % diff_ind=find(Tempdiff>=0.2);
% % diff_ind(2:2:length(diff_ind))=[];
% % MaxTempBESS_B2(diff_ind+1)=MaxTempBESS_B2(diff_ind);
% 
% EImpBESS_B1=xlsread(BInv1_File,1,'AE2:AE1441');
% EExpBESS_B1=xlsread(BInv1_File,1,'AF2:AF1441');
% EImpBESS_B2=xlsread(BInv2_File,1,'AE2:AE1441');
% EExpBESS_B2=xlsread(BInv2_File,1,'AF2:AF1441');
% 
% UQGGridImport=vertcat(UQGGridImport,P_Incomer1052);
% l_F1=length(P_InvF1);l_F2=length(P_InvF2);l_F3=length(P_InvF3);l_SA=length(P_InvSA);l_DA=length(P_InvDA);
% l_min=min([l_F1,l_F2,l_F3,l_SA,l_DA]);
% UQGPV=vertcat(UQGPV,-(P_InvF1(1:l_min)+P_InvF2(1:l_min)+P_InvF3(1:l_min)+P_InvSA(1:l_min)+P_InvDA(1:l_min)));
% UQGCalcLoad_P=vertcat(UQGCalcLoad_P,CalcLoad_P);
% % UQGPV=vertcat(UQGPV,-P_Feeder1152);
% UQGPBESS_B1=vertcat(UQGPBESS_B1,PBESS_B1);
% UQGPBESS_B2=vertcat(UQGPBESS_B2,PBESS_B2);
% UQGSoCBESS_B1=vertcat(UQGSoCBESS_B1,SoCBESS_B1);
% UQGSoCBESS_B2=vertcat(UQGSoCBESS_B2,SoCBESS_B2);
% UQGMinTempBESS_B1=vertcat(UQGMinTempBESS_B1,MinTempBESS_B1);
% UQGMaxTempBESS_B1=vertcat(UQGMaxTempBESS_B1,MaxTempBESS_B1);
% UQGMinTempBESS_B2=vertcat(UQGMinTempBESS_B2,MinTempBESS_B2);
% UQGMaxTempBESS_B2=vertcat(UQGMaxTempBESS_B2,MaxTempBESS_B2);
% UQGEImpBESS_B1=vertcat(UQGEImpBESS_B1,EImpBESS_B1);
% UQGEExpBESS_B1=vertcat(UQGEExpBESS_B1,EExpBESS_B1);
% UQGEImpBESS_B2=vertcat(UQGEImpBESS_B2,EImpBESS_B2);
% UQGEExpBESS_B2=vertcat(UQGEExpBESS_B2,EExpBESS_B2);
% 
% end
% UQGPBESS_Sys=UQGPBESS_B1+UQGPBESS_B2;
% UQGPBESS_Sys_C=UQGPBESS_Sys;
% UQGPBESS_Sys_D=UQGPBESS_Sys;
% UQGPBESS_Sys_C(UQGPBESS_Sys<0)=0;
% UQGPBESS_Sys_D(UQGPBESS_Sys>0)=0;
% figure;
% plot(UQGGridImport);
% hold on
% plot(UQGPV);
% plot(UQGGridImport+UQGPV)
% plot(-UQGPBESS_Sys)
% plot(UQGGridImport+UQGPV-UQGPBESS_Sys)
% plot(UQGGridImport-UQGPBESS_Sys)
% UQGDemand=UQGGridImport+UQGPV;
% plot(UQGDemand);
% figure;
% plot(UQGCalcLoad_P-UQGPBESS_Sys_C)
% hold on
% plot(UQGPV)
% plot(UQGPBESS_Sys_C)
% figure;
% plot(UQGPBESS_B1);
% hold on;
% plot(UQGPBESS_B2);
% figure;
% plot(UQGSoCBESS_B1);
% hold on;
% plot(UQGSoCBESS_B2);
% figure;
% plot(UQGEImpBESS_B1);
% hold on;
% plot(UQGEExpBESS_B1);
UQGPBESS_Sys_C_E=[];
UQGPBESS_Sys_D_E=[];
UQGPBESS_Sys_C_PV_E=[];
UQGPBESS_Sys_D_PS_E=[];
UQGPBESS_Sys_C_PV=UQGPBESS_Sys_C;
UQGPBESS_Sys_D_PS=[];%UQGPBESS_Sys_D;
UQGPBESS_Sys_C_PV(UQGGridImport>0)=0;
% UQGPBESS_Sys_D_PS(UQGGridImport<0)=0;

for ii=1:15
    dummy1=trapz(UQGPBESS_Sys_C((1440*(ii-1))+(1:1440)))/60;
    dummy2=trapz(-UQGPBESS_Sys_D((1440*(ii-1))+(1:1440)))/60;
    dummy3=trapz(UQGPBESS_Sys_C_PV((1440*(ii-1))+(1:1440)))/60;
    dummy4=UQGPBESS_Sys_D((1440*(ii-1))+(1:1440));
    dummy4(400:950)=0;
    UQGPBESS_Sys_D_PS=[UQGPBESS_Sys_D_PS;dummy4];
%     dummy4=trapz(-UQGPBESS_Sys_D_PS((1440*(ii-1))+(1:1440)))/60;
    UQGPBESS_Sys_C_E=[UQGPBESS_Sys_C_E;dummy1];
    UQGPBESS_Sys_D_E=[UQGPBESS_Sys_D_E;dummy2];
    UQGPBESS_Sys_C_PV_E=[UQGPBESS_Sys_C_PV_E;dummy3];
    UQGPBESS_Sys_D_PS_E=[UQGPBESS_Sys_D_PS_E;-trapz(dummy4)/60];
    clear dummy1 dummy2 dummy3 dummy4;
end
% dataCE=[];
% dataCEPV=[];
% dataDE=[];
% dataDEPS=[];
% dataCE=[dataCE;UQGPBESS_Sys_C_E];
% dataCEPV=[dataCEPV;UQGPBESS_Sys_C_PV_E];
% dataDE=[dataDE;UQGPBESS_Sys_D_E];
% dataDEPS=[dataDEPS;UQGPBESS_Sys_D_PS_E];