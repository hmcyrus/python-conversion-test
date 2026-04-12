for SimIter=782:782
    time_indx=SimIter;
    if ((time_indx>=568)&&(ref_gen_flag==1))
        SoC_ref_gen;
        ref_gen_flag=0;
    end
    LDM=2.20;%demand_curve_shape_factor(ii);
%     load_P=tot_load_P(ii);
%     load_Q=tot_load_Q(ii);
%%%% load variation using demand_curve.m %%%%%%%%%%%%%    
    load_P=demand_curve_shape_factor(SimIter)*ones(4*tot_bus,1);
    load_Q=demand_curve_shape_factor(SimIter)*ones(4*tot_bus,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% load variation using appl_load.m %%%%%%%%%%%%% 
%     load_P=tot__P(:,ii);
%     load_Q=tot__Q(:,ii);
%     p_P=p_P_agg(ii);
%     p_Z=p_Z_agg(ii);
%     p_I=p_I_agg(ii);
%     q_P=q_P_agg(ii);
%     q_Z=q_Z_agg(ii);
%     q_I=q_I_agg(ii);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    busPL=p_P*LDM*(load_P.*cell2mat(bus(:,4)));
    busQL=q_P*LDM*(load_Q.*cell2mat(bus(:,5)));
    if (time_indx>1050&&time_indx<=1440)%(time_indx<500||time_indx>1020)
        busV(4*(1-1)+(1:3))=[1.18;1.18;1.18];
        busQL(Cap_Bank_Node1)=-0.20;
    else
        busV(4*(1-1)+(1:3))=[1.13;1.13;1.13];
        busQL(Cap_Bank_Node1)=-0.1;
    end
    PPL=-2.0*1.79*pv_curve_shape_factor(SimIter);
    pv_curve_reshape_factor=reshape_factor(:,SimIter);
    busDGP=PPL*(cell2mat(bus(:,15)));
    busDGP=pv_curve_reshape_factor.*busDGP;
    pv1=1e2*reshape_factor(:,(SimIter-1)).*abs((-2.0*1.79*pv_curve_shape_factor(SimIter-1))*(cell2mat(bus(:,15))));
    pv2=1e2*abs(busDGP);
    pvp_ramprate=(pv2-pv1);
    PVP_RampRate=[PVP_RampRate;pvp_ramprate];
    nrci3ph4w; % run newton-raphson current injection based three phase power flow
%     lineflow_3p4w;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
volt2=[busV(aaa) busV(bbb) busV(ccc)];
v_ramprate=((volt2-volt1)./volt1)*100;
V_RampRate=[V_RampRate;v_ramprate];

pvp=abs([busDGP(aaa) busDGP(bbb) busDGP(ccc)]);
PVP=[PVP;pvp];
PVP_sum=zeros(14,3);
ma_win=60; % length of the moving average window
if iiii>=ma_win
%     pvp_ma=(PVP((((iiii-5)*14+1):((iiii-4)*14)),:)+PVP((((iiii-4)*14+1):((iiii-3)*14)),:)+PVP((((iiii-3)*14+1):((iiii-2)*14)),:)+PVP((((iiii-2)*14+1):((iiii-1)*14)),:)+PVP((((iiii-1)*14+1):((iiii-0)*14)),:))/5;
    for ma_cntr=((iiii-ma_win)+1):iiii
        PVP_sum=PVP_sum+PVP(((ma_cntr-1)*14+1):(ma_cntr*14),:);
    end
    pvp_ma=PVP_sum/ma_win;
    PVP_MA=[PVP_MA;pvp_ma];
end
iiii=iiii+1;


ld2=abs([busPL(aaa) busPL(bbb) busPL(ccc)]);
ldp_ramprate=((ld2-ld1)./ld1)*100;
LDP_RampRate=[LDP_RampRate;ldp_ramprate];

charge_control_randtest;

volt3=[busV(aaa) busV(bbb) busV(ccc)];
v_ramprate_smooth=((volt3-volt1)./volt1)*100;
V_RampRate_smooth=[V_RampRate_smooth;v_ramprate_smooth];

btp1=abs([busBTP(aaa) busBTP(bbb) busBTP(ccc)]);
Neg_Ramp_Flag=0;
Pos_Ramp_Flag=0;
volt1=volt2;
% pv1=pv2;
ld1=ld2;
%     storage_cont;
%     data=[busV(aaa) busA(aaa)*(180/pi) busV(bbb) busA(bbb)*(180/pi) busV(ccc) busA(ccc)*(180/pi)];
% V_Reg_L=0.94;
% V_Reg_H=1.09;
% if (busV(4*(18-1)+1)<V_Reg_L||busV(4*(18-1)+1)>V_Reg_H||busV(4*(18-1)+2)<V_Reg_L||busV(4*(18-1)+2)>V_Reg_H||busV(4*(18-1)+3)<V_Reg_L||busV(4*(18-1)+3)>V_Reg_H)
%     reg_bb1;
% end;
% if (busV(4*(26-1)+1)<V_Reg_L||busV(4*(26-1)+1)>V_Reg_H||busV(4*(26-1)+2)<V_Reg_L||busV(4*(26-1)+2)>V_Reg_H||busV(4*(26-1)+3)<V_Reg_L||busV(4*(26-1)+3)>V_Reg_H)
%     reg_bb2;
% end;
% if (busV(4*(28-1)+1)<V_Reg_L||busV(4*(28-1)+1)>V_Reg_H||busV(4*(28-1)+2)<V_Reg_L||busV(4*(28-1)+2)>V_Reg_H||busV(4*(28-1)+3)<V_Reg_L||busV(4*(28-1)+3)>V_Reg_H)
%     reg_bb3;
% end;
    lineflow_3p4w;
end
