Ibatt=I_bat_C_mem;

SoCcalc=C_bat-SoC;
E_C=E0_C-K_C*(C_bat./(C_bat-SoCcalc))+A_C.*exp(-B_C*SoCcalc);

SoC_ref=SoC_ideal_ref(SimIter)*ones(4*tot_bus,1);

surplus_P=(busPL+busPI+busPZ)-abs(busDGP);
charging_node_ind=PEV_parking_node;
RR_lim=0.1;
NRF_array=zeros(length(busV),1);
PRF_array=zeros(length(busV),1);
smoothing_node_ind_n=find(pvp_ramprate<-RR_lim);
smoothing_node_ind_p=find(pvp_ramprate>RR_lim);
if isempty(smoothing_node_ind_n)==0
    NRF_array(smoothing_node_ind_n)=1;
    PRF_array(smoothing_node_ind_n)=0;
end
if isempty(smoothing_node_ind_p)==0
    PRF_array(smoothing_node_ind_p)=1;
    NRF_array(smoothing_node_ind_p)=0;
end

support_node_ind_n=find((abs(pvp_ramprate)<RR_lim)&(NRF_array==1)&(PRF_array==0));
chg_node_ind=find((abs(pvp_ramprate)<RR_lim)&(NRF_array==0)&(surplus_P<0)&(SoC<(SoCmax*C_bat)));

Ibatt_inc_ind=find(SoC<=CincSoC);
Ibatt_const_ind=find((SoC>CincSoC)&(SoC<CdecSoC));
Ibatt_dec_ind=find(SoC>=CincSoC);
Ibatt(Ibatt_inc_ind)=Ibatt(Ibatt_inc_ind)+omega_Chg(Ibatt_inc_ind);
Ibatt(Ibatt_const_ind)=I_Chg_max(Ibatt_const_ind);
Ibatt(Ibatt_dec_ind)=Ibatt(Ibatt_dec_ind)-omega_Chg(Ibatt_dec_ind);
Ibatt(Ibatt<0)=0;
Ibatt(chg_node_ind)=Ibatt(chg_node_ind)+(SoC_ref(chg_node_ind)-SoC(chg_node_ind));
Vbatt=E_C+1*R*Ibatt;
P_chg(chg_node_ind)=Vbatt(chg_node_ind).*Ibatt(chg_node_ind);
full_chg_P_ind=find((abs(surplus_P)-P_chg)>=0);
part_chg_P_ind=find((abs(surplus_P)-P_chg)<0);
busBTP(full_chg_P_ind)=1e-5*P_chg(full_chg_P_ind);
busBTP(part_chg_P_ind)=abs(surplus_P(part_chg_P_ind));
busBTP(smoothing_node_ind_n)=-1e-2*((pv1(smoothing_node_ind_n)-RR_lim)-pv2(smoothing_node_ind_n));
% busBTP(smoothing_node_ind_p)=1e-2*(pv2(smoothing_node_ind_p)-(pv1(smoothing_node_ind_p)+RR_lim));


btp_switch=zeros(length(busV),1);
btp_switch(charging_node_ind)=1;
busBTP=busBTP.*btp_switch;

SoC(busBTP>=0)=SoC(busBTP>=0)+((1e5*busBTP(busBTP>=0))./Vbatt(busBTP>=0))*(1/60);
SoC(busBTP<0)=SoC(busBTP<0)-((1e5*busBTP(busBTP<0))./Vbatt(busBTP<0))*(1/60);

I_bat_C_mem(chg_node_ind)=Ibatt(chg_node_ind);

for iter=1:50
    curr_mm_3p3_4w;
%     max(abs(delta_I))
    if(max(abs(dI))<=1e-6)
        break;
    end
end
charge_time(charging_node_ind)=charge_time(charging_node_ind)+1*(1/60);

oldV(charging_node_ind)=busV(charging_node_ind);
oldA(charging_node_ind)=busA(charging_node_ind);
