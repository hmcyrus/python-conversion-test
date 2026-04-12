DoDmax=0.500;
T_Dsch=4;
SoC_HH=0.91;%SoC(CustomerNode(1));
I_PEV_Dsch_max=(C_bat*(SoC_HH-DoDmax))/(0.5*T_Dsch)
omega_Dsch_PEV=I_PEV_Dsch_max/T_Dsch
SoC_ref_calc=SoC;
I_ref_calc=zeros(600,1);
I_ref_calc(CustomerNode)=zeros;
I_ref_data=[];
SoC_ref_data=[];
for ii=1:1440
    inc_ind=find(SoC_ref_calc>DincSoC);
    dec_ind=find(SoC_ref_calc<DdecSoC);
    const_ind=find((SoC_ref_calc<=DincSoC)&(SoC_ref_calc>=DdecSoC));
    if ((ii>=342)&&(ii<=(342+(2.5*60))))
        if ii==342
           I_ref_calc(CustomerNode)=zeros;
        end
        I_ref_calc(CustomerNode)=I_ref_calc(CustomerNode)+omega_Dsch_PEV/60; %% simple triangular
        SoC_ref_calc(CustomerNode)=SoC_ref_calc(CustomerNode)-(I_ref_calc(CustomerNode)/60);
    end
    if ((ii>=1080)&&(ii<=(1080+(5*60))))
        if ii==1080
           I_ref_calc(CustomerNode)=I_PEV_Dsch_max;
        end
%         I_ref_calc(inc_ind)=I_ref_calc(inc_ind)+(omega_Dsch(inc_ind)/1);
%         I_ref_calc(dec_ind)=I_ref_calc(dec_ind)-(omega_Dsch(dec_ind)/1);
%         I_ref_calc(const_ind)=I_Dsch_max(const_ind);
%         I_ref_calc(I_ref_calc<0)=0;
%         I_ref_dummy=I_ref_calc(CustomerNode);
%         I_ref_dummy(RandomArrivalTime>day_1min(ii))=0;
%         I_ref_calc(CustomerNode)=I_ref_dummy;
        I_ref_calc(CustomerNode)=I_ref_calc(CustomerNode)-omega_Dsch_PEV/60; %% simple triangular
        SoC_ref_calc(CustomerNode)=SoC_ref_calc(CustomerNode)-(I_ref_calc(CustomerNode)/60);
    end
%     I_ref_data=[I_ref_data;[I_ref_calc(aaa) I_ref_calc(bbb) I_ref_calc(ccc) I_ref_calc(ddd)]];
%     SoC_ref_data=[SoC_ref_data;[SoC_ref_calc(aaa) SoC_ref_calc(bbb) SoC_ref_calc(ccc) SoC_ref_calc(ddd)]];
    I_ref_data=[I_ref_data;I_ref_calc];
    SoC_ref_data=[SoC_ref_data;SoC_ref_calc];
end
disp('Reference SoC Calculation Finished!')
    

