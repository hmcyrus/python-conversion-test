Ibatt=I_bat_C_mem;
% CRSat1=8.0175;%(C_bat/6.5662); %%% 6.25
% CRSat2=(C_bat/6.29)*1.00;
% I_Chg_max(PEV_parking_node)=8.0175;
% CincSoC(PEV_parking_node)=(0.7734-0.0005)*C_bat;
% CdecSoC(PEV_parking_node)=(0.7734+0.0005)*C_bat;
% omega_Chg(PEV_parking_node)=2.3697/60;
SoCcalc=C_bat-SoC;
E_C=E0_C-K_C*(C_bat./(C_bat-SoCcalc))+A_C.*exp(-B_C*SoCcalc);


surplus_P=(busPL+busPI+busPZ)-abs(busDGP);
% surplus_P(ddd)=[];
% charging_node_ind=(577:600)';%find(surplus_P<-(0.1/100));
charging_node_ind=PEV_parking_node;

%% Reference SoC %%
% if time_indx>=526
SoC_ref=SoC_ideal_ref(SimIter)*ones(4*tot_bus,1);
% end

%%

% if isempty(charging_node_ind)==0 
for ii=1:length(charging_node_ind);
% if (SoC(charging_node_ind(ii))<(SoCmax*C_bat))
% %%%%%% tappered charging profile %%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%     if SoC(charging_node_ind(ii))<=CincSoC(charging_node_ind(ii))
%         Ibatt(charging_node_ind(ii))=Ibatt(charging_node_ind(ii))+(omega_Chg(charging_node_ind(ii)));
%         if Ibatt(charging_node_ind(ii))>I_Chg_max(charging_node_ind(ii));
%             Ibatt(charging_node_ind(ii))=I_Chg_max(charging_node_ind(ii));
%         end
%     elseif SoC(charging_node_ind(ii))>=CdecSoC(charging_node_ind(ii))
%         Ibatt(charging_node_ind(ii))=Ibatt(charging_node_ind(ii))-(omega_Chg(charging_node_ind(ii)));
%     elseif (SoC(charging_node_ind(ii))<=CincSoC(charging_node_ind(ii)))&&(SoC(charging_node_ind(ii))>=CdecSoC(charging_node_ind(ii)))
%        Ibatt(charging_node_ind(ii))=I_Chg_max(charging_node_ind(ii));
%     
% %%%%%%%%%%%%% constant charging profile %%%%%%%%%%%
% %     Ibatt(charging_node_ind(ii))=CRMax;
% % else
% %     Ibatt(charging_node_ind(ii))=0;
%     end
%     if Ibatt(charging_node_ind(ii))<0
%         Ibatt(charging_node_ind(ii))=0;
%     end
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%
% SoC_comp=SoC(charging_node_ind(ii))+1*Ibatt(charging_node_ind(ii))*(1/60);
% CR_STD_comp_flg=0;
% 
% if SoC_ref(charging_node_ind(ii))~=SoC_comp
%     if SoC(charging_node_ind(ii))<SoCmax*C_bat
%        CR_STD_comp=(SoC_ref(charging_node_ind(ii))-SoC_comp)*1.0;
%        CR_STD_comp_flg=1;
%        Ibatt(charging_node_ind(ii))=Ibatt(charging_node_ind(ii))+CR_STD_comp;
%     end
% end
%% PEV Battery Current Rate-Limiter
% if abs(Ibatt(charging_node_ind(ii))-I_bat_C_mem(charging_node_ind(ii)))>(10/60)
% %     disp('yes')
%     Ibatt(charging_node_ind(ii))=I_bat_C_mem(charging_node_ind(ii))+(Ibatt(charging_node_ind(ii))-I_bat_C_mem(charging_node_ind(ii)))/3;
% else
% %     disp('no')
%     Ibatt(charging_node_ind(ii))=Ibatt(charging_node_ind(ii));
% end

%%
Ibatt(charging_node_ind(ii))=2.5599;
Vbatt(charging_node_ind(ii))=1*1*(E_C(charging_node_ind(ii))+1*R*Ibatt(charging_node_ind(ii)));
P_chg(charging_node_ind(ii))=(1e-5*Vbatt(charging_node_ind(ii))*(Ibatt(charging_node_ind(ii))))/Conv_Eff;

if ((surplus_P(charging_node_ind(ii)))<0)&&(P_chg(charging_node_ind(ii))>0)
    if abs(surplus_P(charging_node_ind(ii)))>=(P_chg(charging_node_ind(ii)))
        if (SoC(charging_node_ind(ii))/C_bat)<=SoCmax
            busBTP(charging_node_ind(ii))=P_chg(charging_node_ind(ii));
        end
    elseif abs(surplus_P(charging_node_ind(ii)))<(P_chg(charging_node_ind(ii)))
        if (SoC(charging_node_ind(ii))/C_bat)<=SoCmax
            busBTP(charging_node_ind(ii))=abs(surplus_P(charging_node_ind(ii)))/1.0;
        end
    end
elseif ((surplus_P(charging_node_ind(ii)))>=0||(P_chg(charging_node_ind(ii))==0))
    busBTP(charging_node_ind(ii))=0;
end   
% [Ibatt(charging_node_ind) I_bat_C_mem(charging_node_ind)]
I_bat_C_mem(charging_node_ind(ii))=Ibatt(charging_node_ind(ii));
% if CR_STD_comp_flg==1
%     Ibatt(charging_node_ind(ii))=Ibatt(charging_node_ind(ii))-CR_STD_comp;
% end
end
% Ibatt(597)
% if (SimIter>=705&&SimIter<=735)
%     busBTP(PEV_driving_node1)=0;
% end
for iter=1:50
    curr_mm_3p3_4w;
%     max(abs(delta_I))
    if(max(abs(dI))<=1e-6)
        break;
    end
end
% end
SoC(charging_node_ind)=SoC(charging_node_ind)+((1e5*(busBTP(charging_node_ind)*eta_coulomb))./Vbatt(charging_node_ind))*(1/60);
% SoC(charging_node_ind)=SoC(charging_node_ind)+((Ibatt(charging_node_ind)*eta_coulomb))*(1/60);  %%% basic change into SoC calculation
charge_time(charging_node_ind)=charge_time(charging_node_ind)+1*(1/60);
% SoC(charging_node_ind)=SoC(charging_node_ind)+((1e5*busBTP(charging_node_ind))/V_bat)*(15/60);
% SoC(charging_node_ind)
oldV(charging_node_ind)=busV(charging_node_ind);
oldA(charging_node_ind)=busA(charging_node_ind);
% clear busV busA