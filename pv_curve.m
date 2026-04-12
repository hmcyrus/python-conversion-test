% pv_data;
% day_hr=1:1:24;
% day_15min=1:(15/60):24;
% day_5min=1:(5/60):24;
% day_1min=(1/60):(1/60):24;
% day_1sec=(1/3600):(1/3600):24;
% pv_curve_shape_factor=pv_data_CSIRO; %%% from pv_data
% reshape_factor=ones(tot_bus*4,length(day_1min));
% data_read;
% pv_curve_shape_factor=Oahu_Data;
% pv_curve_shape_factor=day1PV/max(day1PV);
pv_curve_shape_factor=(day1PV*1e3)/kVA_base;
% pv_curve_shape_factor(pv_curve_shape_factor<0.01)=0.00;
