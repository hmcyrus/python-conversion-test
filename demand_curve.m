% day_t=15:15:(24*4*15);
day_15min=(15/60):(15/60):24;%27;
day_5min=(5/60):(5/60):24;%27;
day_1min=(1/60):(1/60):24;%27;
day_1sec=(1/3600):(1/3600):24;
day_2sec=(2/3600):(2/3600):24;
% feeder_demand=[...
%      8.80 8.80 8.80 8.80 8.80 8.94 8.92 8.80 8.60 9.00 9.00 8.80 8.90 9.00 8.80 8.90 9.20 9.20 9.20 9.20 9.40 9.40 9.80 9.70 10.00 10.40 10.60 11.00 11.00 11.00 11.20...
%     11.10 11.20 11.40 11.20 11.30 11.60 11.70 11.70 11.80 11.78 11.72 11.60 11.65 11.60 11.60 11.65 11.55 11.60 11.55 11.50 11.20 10.80 10.75 10.80 10.80 10.90 10.75...
%     10.75 10.70 10.60 10.30 10.20 10.00 10.40 9.90 10.00 10.10 10.00 9.90 9.70 9.95 9.80 10.10 9.95 10.10 10.30 10.90 11.20 11.80 12.40 12.70 12.60 12.60 12.60 12.05...
%     12.00 11.90 11.50 11.10 11.20 10.80 10.20 9.80 9.60 8.80];% 8.80 8.10;% 8.40;
% feeder_demand=[...
%      8.80 8.80 8.80 8.80 8.80 8.94 8.92 8.80 8.60 9.00 9.00 8.80 8.90 9.00 8.80 8.90 9.20 9.20 9.20 9.20 9.40 9.40 9.80 9.70 10.00 10.40 10.60 11.00 11.00 11.00 11.20...
%     11.10 11.20 11.40 11.20 11.30 11.60 11.70 11.70 11.80 11.78 11.72 11.60 11.65 11.60 11.60 11.65 11.55 11.60 11.55 11.50 11.20 10.80 10.75 10.80 10.80 10.90 10.75...
%     10.75 10.70 10.60 10.30 10.20 10.00 10.40 9.90 10.00 10.10 10.00 9.90 9.70 9.95 9.80 10.10 9.95 10.10 10.30 10.90 11.20 11.80*1.1 12.40*1.15 12.70*1.15 12.60*1.2 12.60*1.2 12.60*1.2 12.05*1.15...
%     12.00*1.15 11.90*1.1 11.50 11.10 11.20 10.80 10.20 9.80 9.60 8.80];% 8.80 8.10;% 8.40;
% feeder_demand(80:88)=[11.9 12.1 12.2 12.3 12.2 12.1 11.9 12.1 12];
feeder_demand=rawloaddata;
% demand_curve_shape_factor=feeder_demand/max(feeder_demand);
demand_curve_shape_factor=(feeder_demand*1e3)/kVA_base;
demand_curve_shape_factor=interp1(day_15min,demand_curve_shape_factor,day_1min,'linear');

% demand_curve_shape_factor(1200)=demand_curve_shape_factor(1200)*1.6; %%% sudden increase of load

% demand_curve_shape_factor=interp1(day_1min,demand_curve_shape_factor,day_2sec,'linear');


%%%%%%%% addition of random noise %%%%%%%%%%%
% r_demand=-0.01+(0.01-(-0.01)).*rand(1,length(demand_curve_shape_factor(1:1:length(demand_curve_shape_factor))));
% demand_curve_shape_factor(1:1:length(demand_curve_shape_factor))=demand_curve_shape_factor(1:1:length(demand_curve_shape_factor))+r_demand;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% evening to morning rotation %%
% demand_curve_shape_factor=[demand_curve_shape_factor(1380:1440) demand_curve_shape_factor(1:1379)];
%%

% demand_curve_shape_factor_a=demand_curve_shape_factor;
% demand_curve_shape_factor_b=demand_curve_shape_factor;
% demand_curve_shape_factor_c=demand_curve_shape_factor;
