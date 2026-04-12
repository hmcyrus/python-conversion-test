
SoCcalc=C_bat-SoC;
E_D=E0_D-K_D*(C_bat./(C_bat-SoCcalc))+A_D.*exp(-B_D*SoCcalc);

if isempty(smoothing_node_ind)==0
for ii=1:length(smoothing_node_ind)
    if (SoC(smoothing_node_ind(ii))>=(DoDmax*C_bat))&&(SoC(smoothing_node_ind(ii))<=(SoCmax*C_bat))
        if smoothing_counter<5
%             Ibatt(smoothing_node_ind(ii))=abs(v_ramprate(smoothing_node_ind(ii)))*30;
%             Ibatt(smoothing_node_ind(ii))=abs(pvp_ramprate(smoothing_node_ind(ii)))*0.5;
%             Ibatt(smoothing_node_ind(ii))=((pv1(smoothing_node_ind(ii))-pv2(smoothing_node_ind(ii)))-1*btp1(smoothing_node_ind(ii))-0*ld1(smoothing_node_ind(ii)))*(1e5/11);
            diff_pvp_ma=1*abs(pvp_ma(smoothing_node_ind(ii))-pv2(smoothing_node_ind(ii)));
            if diff_pvp_ma<=btp1(smoothing_node_ind(ii))
                Ibatt(smoothing_node_ind(ii))=(diff_pvp_ma-0*(btp1(smoothing_node_ind(ii))))*(1e5/22);
            else
                Ibatt(smoothing_node_ind(ii))=(diff_pvp_ma-1.0*(btp1(smoothing_node_ind(ii))))*(1e5/22);
            end
            if (pv2(smoothing_node_ind(ii))-ld2(smoothing_node_ind(ii)))>(0.7/100)
                Ibatt(smoothing_node_ind(ii))=Ibatt(smoothing_node_ind(ii))*0.3;
            end               
%         else
%             Ibatt(smoothing_node_ind(ii))=Ibatt(smoothing_node_ind(ii))+10;
%         Ibatt(smoothing_node_ind(ii))=DRMax+smoothing_counter*5; 
    end
%     (Ibatt(smoothing_node_ind))'
    Vbatt(smoothing_node_ind(ii))=2*6*(E_D(smoothing_node_ind(ii))-1*R*Ibatt(smoothing_node_ind(ii)));
    if (SoC(smoothing_node_ind(ii))/C_bat)>DoDmax;
        busBTP(smoothing_node_ind(ii))=-Vbatt(smoothing_node_ind(ii))*Ibatt(smoothing_node_ind(ii))*1e-5;
    else
        busBTP(smoothing_node_ind(ii))=0.00;
    end
    end
end
smoothing_counter=smoothing_counter+1;
% busBTP=busBTP*eta_coulomb;
for iter=1:50
    curr_mm;
    if(max(abs(dI))<=1e-6)
        break;
    end
end
max(abs(dI));
end

% (Ibatt(smoothing_node_ind))'
% SoC(discharge_node_ind)=SoC(discharge_node_ind)-((-1e5*busBTP(discharge_node_ind))./D_Volt_Dby10(discharge_node_ind))*((15/60)*(1/3));
SoC(smoothing_node_ind)=SoC(smoothing_node_ind)-((-1e5*(busBTP(smoothing_node_ind)/eta_coulomb))./Vbatt(smoothing_node_ind))*(1/60);
% busBTP=zeros(length(busV),1);
% sum(busPL((4*((108:117)-1)+(2))))+sum(busPI((4*((108:117)-1)+(2))))+sum(busPZ((4*((108:117)-1)+(2))))
oldV(smoothing_node_ind)=busV(smoothing_node_ind);
oldA(smoothing_node_ind)=busA(smoothing_node_ind);
% clear busV busA
