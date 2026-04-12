% C_bat=250;
% DoDmax=0.54;
% SoCmax=0.999;
% tot_bus=1;
CRMax=I_PEV_Chg_max; %%% 6.25
CincSoC_ref=(SoC_C_A-0.0005)*C_bat;
CdecSoC_ref=(SoC_C_B+0.0005)*C_bat;
% DRMax=I_PEV_Dsch_max; %
% DincSoC=(SoC_D_A-0.0005)*C_bat; % (0.6420)
% DdecSoC=(SoC_D_B+0.0005)*C_bat; % (0.6420)
SoC_ideal_ref=0.2*C_bat*ones(1440*tsc,1);
SoC_ref_calc=0.2*C_bat;
% SoC_ideal_ref=0.7665*C_bat*ones(length(day_1sec),1);
% SoC_ref_calc=0.7665*C_bat;
Ibatt_ref_calc=0.00;
Ibatt_ref=zeros(1440*tsc,1);

for ii=1:length(day_1min)
    if ((ii>=ConTime)&&(ii<=CoffTime))
    if (SoC_ref_calc<=(SoCmax*C_bat))
%%%%%% tappered charging profile %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if SoC_ref_calc<=CincSoC_ref
        Ibatt_ref_calc=Ibatt_ref_calc+(omega_Chg_PEV/(60*tsc));
        if Ibatt_ref_calc>CRMax
            Ibatt_ref_calc=CRMax;
        end
    elseif SoC_ref_calc>=CdecSoC_ref
        Ibatt_ref_calc=Ibatt_ref_calc-(omega_Chg_PEV/(60*tsc));
        if Ibatt_ref_calc<0
            Ibat_ref_calc=0;
        end
    elseif (SoC_ref_calc<=CincSoC_ref)&&(SoC_ref_calc>=CdecSoC_ref)
       Ibatt_ref_calc=CRMax;
    end
%%%%%%%%%%%%% constant charging profile %%%%%%%%%%%
%     Ibatt_ref_calc=CRMax;
%     else
%     Ibatt_ref_calc=0;
%     if Ibatt_ref_calc<0
%         Ibatt_ref_calc=0;
%     end
    end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%
% 
    else
        Ibatt_ref_calc=0;
    end
%     if ((ii>=1170)&&(ii<=1410))
%     if (SoC_ref_calc>=(DoDmax*C_bat))
% %%%%%% tappered charging profile %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     if SoC_ref_calc>=DincSoC
%         Ibatt_ref_calc=Ibatt_ref_calc+(omega_Dsch_PEV/60);
%         if Ibatt_ref_calc>DRMax
%             Ibatt_ref_calc=DRMax;
%         end
%     elseif SoC_ref_calc<=DdecSoC
%         Ibatt_ref_calc=Ibatt_ref_calc-(omega_Dsch_PEV/60);
%         if Ibatt_ref_calc<0
%             Ibat_ref_calc=0;
%         end
%     elseif (SoC_ref_calc<DincSoC)&&(SoC_ref_calc>DdecSoC)
%        Ibatt_ref_calc=DRMax;
%     end
% %%%%%%%%%%%%% constant charging profile %%%%%%%%%%%
% %     Ibatt_ref_calc=CRMax;
% % else
% %     Ibatt_ref_calc=0;
%     if Ibatt_ref_calc<0
%         Ibatt_ref_calc=0;
%     end
%     end
%     end

%%%%%%%%%%%%%%%%%%%%%%%%%
% 
    SoC_ref_calc=SoC_ref_calc+Ibatt_ref_calc*(1/(60*tsc)); %% charging
%     SoC_ref_calc=SoC_ref_calc-Ibatt_ref_calc*(1/60); %% discharging
    Ibatt_ref(ii)=Ibatt_ref_calc;
    SoC_ideal_ref(ii)=SoC_ref_calc;
end
adjustment=0.0*Ibatt_ref((452+173):(452+260));
Ibatt_ref((452+173):(452+260))=Ibatt_ref((452+173):(452+260))-adjustment;
Ibatt_ref((452+83):(452+170))=Ibatt_ref((452+83):(452+170))+adjustment;
SoC_ideal_ref=(0.2*C_bat)+cumsum(Ibatt_ref/60);
clear ii;
