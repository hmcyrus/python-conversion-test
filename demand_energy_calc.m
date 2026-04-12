% plot(day_1min(find(day_1min==20):find(day_1min==22)),demand_curve_shape_factor(find(day_1min==20):find(day_1min==22)));
% area(day_1min(find(day_1min==20):find(day_1min==22)),demand_curve_shape_factor(find(day_1min==20):find(day_1min==22)));
% area(day_1min(find(day_1min==20):find(day_1min==22)),0.7*ones(length(find(day_1min==20):find(day_1min==22)),1));
% evening_demand_data=(2.2*demand_curve_shape_factor(find(day_1min==17):find(day_1min==24)));
% SE=6.7998;
% PST=0.0;
% PST_data=[];
% epsilon=0.01;
% for ii=1:100
%     evening_demand=evening_demand_data-PST;
%     evening_demand(evening_demand<0)=0;
%     DE=(trapz(evening_demand))/60;
%     if (SE-DE)>epsilon
%         PST=PST-epsilon;
%     elseif (SE-DE)<-epsilon
%         PST=PST+epsilon;
%     else
%         PST=0;
%     end
%     PST_data=[PST_data;PST];
% end
% PST
% DE=(trapz(evening_demand))/60
%% Surplus Energy Calc
% Surplus_Pwr=(100*Feeder_Load_abc(:,1)/6)-abs(100*Feeder_PV_abc(:,1)/6);
% Surplus_Pwr(Surplus_Pwr>0)=0;
% % plot(day_1min(480:1079),Surplus_Pwr,'r')
% Surplus_Enrg=trapz(Surplus_Pwr)/60
% % Surplus_Enrg=trapz(day_1min(480:1079),Surplus_Pwr)


%% rate-limiter
% I1=zeros(30,1);
% I1(1:10)=1;
% I1(11:20)=1.5;
% I1(21:30)=0.8;
% I2_data=[];
% I2_mem=0;
% for ii=1:length(I1)
% %     if abs(I1(ii)-I2_mem)>0.001
%         I2=I2_mem+(I1(ii)-I2_mem)/2;
% %     else
% %         I2=I1(ii);
% %     end
%     I2_data=[I2_data;I2];
%     I2_mem=I2;
% end
% clear ii;
Ibatt_adj=zeros(1440,1);
Ibatt_act=zeros(1440,1);
SoC_act=(C_bat*SoC_HH)*ones(1440,1);
SoC_new_ideal_ref=SoC_ideal_ref;
SoC_new_ideal_ref(1130)=41;
DR_Comp=zeros(1440,1);
DR_STD_comp=0;
ctr=1;
PEV_out_time=1200;
PEV_return_time=1230;
PEV_return_SoC=38.47;
for ii=1170:1420
    Ibatt_act(ii)=Ibatt_ref(ii);
%     SoC_act(ii)=SoC_ideal_ref(ii);
    if ((ii>=PEV_out_time)&&(ii<=(PEV_return_time-1)))
        Ibatt_act(ii)=0;
%         SoC_act(ii)=40;
    end
if ii>=PEV_return_time
    SoC_act(1230-1)=PEV_return_SoC;
    new_SoC=SoC_act(ii-1)-(Ibatt_act(ii)*(1/60));
%     actual_comp=(SoC_ideal_ref(ii)-new_SoC);
%     DR_Comp(ii)=DR_Comp(ii-1)+(0.4/actual_comp);%(actual_comp/(5*(ctr^3)));
%     ctr=ctr+1;
%    if DR_Comp(ii)>(actual_comp)
%        DR_Comp(ii)=actual_comp;
%    end
%     actual_comp=(SoC_ideal_ref(PEV_out_time)-PEV_return_SoC);
%     DR_Comp(ii)=(actual_comp*60)/(1319-PEV_return_time+1);
    actual_comp=(SoC_ideal_ref(ii)-new_SoC);
    DR_Comp(ii)=(actual_comp*60)/(1420-ii+1);
    Ibatt_act(ii)=Ibatt_ref(ii)-DR_Comp(ii);
%     if (Ibatt_act(ii)-Ibatt_act(ii-1))>0.3
%         Ibatt_act(ii)=Ibatt_act(ii-1)+0.3;
%     elseif (Ibatt_act(ii)-Ibatt_act(ii-1))<-0.3
%         Ibatt_act(ii)=Ibatt_act(ii-1)-0.3;
%     end
    if Ibatt_act(ii)<0
        Ibatt_act(ii)=0;
    end
%     DR_Comp(ii)=DR_STD_comp;
end
if SoC_act(ii-1)>(DoDmax*C_bat)
    SoC_act(ii)=SoC_act(ii-1)-(Ibatt_act(ii)*(1/60));
else
    SoC_act(ii)=SoC_act(ii-1);
end
end

% for ii=1131:1440
%     SoC_new_ideal_ref(ii)=SoC_new_ideal_ref(ii-1)-((SoC_ideal_ref(ii-1)-SoC_ideal_ref(ii))/(SoC_ideal_ref(1130)-(DoDmax*C_bat)))*(41-(DoDmax*C_bat));
% end
% 
% for ii=2:1440
%     Ibatt_act(ii)=Ibatt_ref(ii);
%     if ((ii>=1115)&&(ii<=1130))
%         Ibatt_act(ii)=0;
%     end
% if ii>=1131
%     SoC_act(1130)=42;
%     Ibatt_act(1130)=3.575;
%     DR_STD_comp=(SoC_new_ideal_ref(ii-1)-SoC_new_ideal_ref(ii));
%     DR_Comp(ii)=DR_STD_comp;
%     Ibatt_act(ii)=Ibatt_act(ii-1)+DR_STD_comp;
% %     if Ibatt_act(ii)<0
% %         Ibatt_act(ii)=0;
% %     end
% end
% if SoC_act(ii-1)>(DoDmax*C_bat)
%     SoC_act(ii)=SoC_act(ii-1)-(Ibatt_act(ii)*(1/60));
% else
%     SoC_act(ii)=SoC_act(ii-1);
% end
% end

