Ibatt=I_bat_C_mem;
I_Chg_max(PEV_night_charge_node)=1.0474;
CincSoC(PEV_night_charge_node)=(0.5702-0.0000)*C_bat;
CdecSoC(PEV_night_charge_node)=(0.6167+0.0000)*C_bat;
omega_Chg(PEV_night_charge_node)=0.3928/60;
SoCcalc=C_bat-SoC;
E_C=E0_C-K_C*(C_bat./(C_bat-SoCcalc))+A_C.*exp(-B_C*SoCcalc);

charging_node_ind=PEV_night_charge_node;

%% Reference SoC %%
% if time_indx>=526
% SoC_ref=SoC_ideal_ref(SimIter)*ones(4*tot_bus,1);
% end

%%

% if isempty(charging_node_ind)==0 
for ii=1:length(charging_node_ind);
if (SoC(charging_node_ind(ii))<(SoCmax*C_bat))
%%%%%% tappered charging profile %%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    if SoC(charging_node_ind(ii))<=CincSoC(charging_node_ind(ii))
        Ibatt(charging_node_ind(ii))=Ibatt(charging_node_ind(ii))+(omega_Chg(charging_node_ind(ii)));
        if Ibatt(charging_node_ind(ii))>I_Chg_max(charging_node_ind(ii));
            Ibatt(charging_node_ind(ii))=I_Chg_max(charging_node_ind(ii));
        end
    elseif SoC(charging_node_ind(ii))>=CdecSoC(charging_node_ind(ii))
        Ibatt(charging_node_ind(ii))=Ibatt(charging_node_ind(ii))-(omega_Chg(charging_node_ind(ii)));
    elseif (SoC(charging_node_ind(ii))<=CincSoC(charging_node_ind(ii)))&&(SoC(charging_node_ind(ii))>=CdecSoC(charging_node_ind(ii)))
       Ibatt(charging_node_ind(ii))=I_Chg_max(charging_node_ind(ii));
    end
    if Ibatt(charging_node_ind(ii))<0
        Ibatt(charging_node_ind(ii))=0;
    end
end
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
% Ibatt(charging_node_ind(ii))=2.5599;
Vbatt(charging_node_ind(ii))=1*1*(E_C(charging_node_ind(ii))+1*R*Ibatt(charging_node_ind(ii)));
P_chg(charging_node_ind(ii))=(1e-5*Vbatt(charging_node_ind(ii))*(Ibatt(charging_node_ind(ii))))/Conv_Eff;
busBTP(charging_node_ind(ii))=P_chg(charging_node_ind(ii));
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