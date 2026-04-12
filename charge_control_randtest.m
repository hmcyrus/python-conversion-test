SoCcalc=C_bat-SoC;
E_C=E0_C-K_C*(C_bat./(C_bat-SoCcalc))+A_C.*exp(-B_C*SoCcalc);
surplus_P=(busPL+busPI+busPZ)-abs(busDGP);
charging_node_ind=PEV_parking_node;
SoC_ref=SoC_ideal_ref(SimIter)*ones(4*tot_bus,1);
% Ibatt=zeros(length(busV),1);
Ibatt(charging_node_ind)=I_Chg_max(charging_node_ind);
for ii=1:length(charging_node_ind);
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
end
for iter=1:50
    curr_mm_3p3_4w;
    if(max(abs(dI))<=1e-6)
        break;
    end
end
SoC(charging_node_ind)=SoC(charging_node_ind)+((1e5*(busBTP(charging_node_ind)*eta_coulomb))./Vbatt(charging_node_ind))*(1/60);