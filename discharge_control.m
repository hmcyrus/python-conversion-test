Ibatt=I_bat_D_mem;

% I_Dsch_max(PEV_parking_node)=5.7740;
% omega_Dsch(PEV_parking_node)=1.9247/60;
% DincSoC(PEV_parking_node)=(0.6939+0.0005)*C_bat;
% DdecSoC(PEV_parking_node)=(0.6939-0.0005)*C_bat;

% I_Dsch_max(PEV_driving_node1)=3.8980;
% omega_Dsch(PEV_driving_node1)=1.2993/60;
% DincSoC(PEV_driving_node1)=(0.6443+0.0005)*C_bat;
% DdecSoC(PEV_driving_node1)=(0.6443-0.0005)*C_bat;
% 
% I_Dsch_max(PEV_driving_node2)=3.4300;
% omega_Dsch(PEV_driving_node2)=1.1433/60;
% DincSoC(PEV_driving_node2)=(0.6327+0.0005)*C_bat;
% DdecSoC(PEV_driving_node2)=(0.6327-0.0005)*C_bat;

SoCcalc=C_bat-SoC;
E_D=E0_D-K_D*(C_bat./(C_bat-SoCcalc))+A_D.*exp(-B_D*SoCcalc);
discharge_node_ind=CustomerNode;%PEV_parking_node;
SoC_ref=SoC_ref_data(600*(SimIter-1)+(1:600));
I_ref=I_ref_data(600*(SimIter-1)+(1:600));
% Ibatt=I_ref;

for ii=1:length(discharge_node_ind)
    if (SoC(discharge_node_ind(ii))>(DoDmax*C_bat))
%%% tappered discharging profile %%%%%%%%%%%
        if SoC(discharge_node_ind(ii))>DincSoC(discharge_node_ind(ii))
            Ibatt(discharge_node_ind(ii))=Ibatt(discharge_node_ind(ii))+(omega_Dsch(discharge_node_ind(ii))); %37.5;
%             if Ibatt(discharge_node_ind(ii))>I_Dsch_max(discharge_node_ind(ii))
%                 Ibatt(discharge_node_ind(ii))=I_Dsch_max(discharge_node_ind(ii));
%             end
        elseif SoC(discharge_node_ind(ii))<DdecSoC(discharge_node_ind(ii))
            Ibatt(discharge_node_ind(ii))=Ibatt(discharge_node_ind(ii))-(omega_Dsch(discharge_node_ind(ii))); %37.5;
        elseif ((SoC(discharge_node_ind(ii))<=DincSoC(discharge_node_ind(ii)))&&(SoC(discharge_node_ind(ii))>=DdecSoC(discharge_node_ind(ii))))
            Ibatt(discharge_node_ind(ii))=I_Dsch_max(discharge_node_ind(ii));
        end
%           Ibatt(discharge_node_ind(ii))=(1e5*(busPL(discharge_node_ind(ii))-0.02))/Vbatt(discharge_node_ind(ii));
          if Ibatt(discharge_node_ind(ii))<0
              Ibatt(discharge_node_ind(ii))=0;
          end
          if day_1min(SimIter)<RandomArrivalTime(ii)
              Ibatt(discharge_node_ind(ii))=0;
          elseif day_1min(SimIter)>=RandomArrivalTime(ii)
              Ibatt(discharge_node_ind(ii))=Ibatt(discharge_node_ind(ii));
          end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%

%     Ibatt(discharge_node_ind(ii))= 2.8870;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     SoC_ref(discharge_node_ind(ii))=SoC_ref(discharge_node_ind(ii))-Ibatt(discharge_node_ind(ii))*(1/60);
%     SoC_comp=SoC(discharge_node_ind(ii))-Ibatt(discharge_node_ind(ii))*(1/60);
%     DR_STHD_comp_flg=0;
%     if SoC_ref(discharge_node_ind(ii))>SoC_comp
%         DR_STHD_comp_flg=1;
%         DR_STHD_comp=(SoC_ref(discharge_node_ind(ii))-SoC_comp)*1.0;
%         Ibatt(discharge_node_ind(ii))=Ibatt(discharge_node_ind(ii))-DR_STHD_comp;
%     elseif SoC_ref(discharge_node_ind(ii))<SoC_comp
%         DR_STHD_comp_flg=1;
%         DR_STHD_comp=(SoC_ref(discharge_node_ind(ii))-SoC_comp)*1.0;
%         Ibatt(discharge_node_ind(ii))=Ibatt(discharge_node_ind(ii))-DR_STHD_comp;
%     elseif SoC_ref(discharge_node_ind(ii))==SoC_comp
%         DR_STHD_comp_flg=0;
%         DR_STHD_comp=0;
%         Ibatt(discharge_node_ind(ii))=Ibatt(discharge_node_ind(ii));
%     end
    if ((SimIter>=PEV_night_out_time)&&(SimIter<=(PEV_night_return_time-1)))
%         disp('y')
        Ibatt(PEV_night_out_node)=0;
    end
    if (SimIter==(PEV_night_return_time-1))
        SoC(PEV_night_out_node)=PEV_night_return_SoC;
    end
    DR_Comp=0;
    if SimIter>=PEV_night_return_time
        new_SoC=SoC(PEV_night_out_node)-(Ibatt(PEV_night_out_node)*(1/60));
        actual_comp=(SoC_ref(PEV_night_out_node)-new_SoC);
        if actual_comp>0
            DR_Comp=(actual_comp*60)/(1410-SimIter+1);
        else
            DR_Comp=0;
        end
        Ibatt(PEV_night_out_node)=I_ref(PEV_night_out_node)-DR_Comp;
%         Ibatt(PEV_night_out_node)=Ibatt(PEV_night_out_node)-DR_Comp;
    end
    if Ibatt(discharge_node_ind(ii))<0
        Ibatt(discharge_node_ind(ii))=0;
    end   
    Vbatt(discharge_node_ind(ii))=1*(E_D(discharge_node_ind(ii))-1*R*Ibatt(discharge_node_ind(ii)));
    clear P_dsch;
    P_dsch=-Vbatt(discharge_node_ind(ii))*Ibatt(discharge_node_ind(ii))*1e-5;
%     if SimIter>=PEV_night_return_time
%         Ibatt(PEV_night_out_node)=Ibatt(PEV_night_out_node)+DR_Comp;
%     end
    
    if ((SoC(discharge_node_ind(ii))/C_bat)>DoDmax)&&(SimIter<DoffTime)
        if busPL(discharge_node_ind(ii))>=abs(P_dsch)
            busBTP(discharge_node_ind(ii))=P_dsch;
        elseif busPL(discharge_node_ind(ii))<abs(P_dsch)
            busBTP(discharge_node_ind(ii))=-busPL(discharge_node_ind(ii));
        end
    else
        busBTP(discharge_node_ind(ii))=0.00;
    end
%     if day_1min(SimIter)<RandomArrivalTime(ii)
%         busBTP(discharge_node_ind(ii))=0;
%     elseif day_1min(SimIter)>=RandomArrivalTime(ii)
%         busBTP(discharge_node_ind(ii))=busBTP(discharge_node_ind(ii));
%     end
% if DR_STHD_comp_flg==1
%     Ibatt(discharge_node_ind(ii))=Ibatt(discharge_node_ind(ii))+DR_STHD_comp;
% end
% clear DR_STHD_comp;
end

P_Bat=[P_Bat;((Vbatt(discharge_node_ind).*Ibatt(discharge_node_ind))*1e-3)];
[DR_Comp Ibatt(PEV_night_out_node) busPL(PEV_night_out_node) ((Vbatt(PEV_night_out_node)*Ibatt(PEV_night_out_node))*1e-5)]
DR_Comp_Data=[DR_Comp_Data;DR_Comp];
I_bat_D_mem=Ibatt;
for iter=1:50
    curr_mm_3p3_4w;
%     max(abs(delta_I))
    if(max(abs(dI))<=1e-6)
        break;
    end
end
SoC(discharge_node_ind)=SoC(discharge_node_ind)-((-1e5*(busBTP(discharge_node_ind)/eta_coulomb))./Vbatt(discharge_node_ind))*(1/60);
% SoC(discharge_node_ind)=SoC(discharge_node_ind)-(Ibatt(discharge_node_ind)*(1/60));
oldV(discharge_node_ind)=busV(discharge_node_ind);
oldA(discharge_node_ind)=busA(discharge_node_ind);
% clear busV busA