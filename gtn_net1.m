%% Gatton Network Model %%
% Development Started on 25th August 2015 %%%%% 
%%
% clear all;
% clear global;
kVA_base=10e6; % 10 MVA base;
kV_baseH=(11.00/sqrt(3))*1e3;
kV_baseL=(0.40/sqrt(3))*1e3;
Z_baseH=(kV_baseH^2)/kVA_base;
Z_baseL=(kV_baseL^2)/kVA_base;
I_baseL=kVA_base/kV_baseL;
Trf_Z=(0.00+0.04*1i);Trf_Y=inv(Trf_Z);
LDM=3.00;%(0.75/1.45)*1.0227; % Load Multiplier
PPL=-1.00;%*1.79*0.7290; % PV Penetration Level
% load_P=1.2576;
% load_Q=load_P*tan(acos(0.97));
% load_P_I=0.00;load_Q_I=load_P_I*tan(acos(0.97));
% load_P_Z=0.00;load_Q_Z=load_P_Z*tan(acos(0.97));
% p_P=0.6222;p_I=0.1029;p_Z=0.2749;
% q_P=0.6167;q_I=0.0029;q_Z=0.3803;
p_P=1.00;p_I=0.0;p_Z=0.0;
q_P=1.00;q_I=0.0;q_Z=0.0;
P_PQ=1.00;Q_PQ=1.00;
P_I=0.00;Q_I=0.00;
P_Z=0.00;Q_Z=0.00;
PPL_a=1.0;PPL_b=1.0;PPL_c=1.0;
bus={...
[1000] [1.05;1.05;1.05;0.00] [0.00;(-2*pi/3);(2*pi/3);0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [1] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00];
[1001] [1.00;1.00;1.00;0.00] [0.00;(-2*pi/3);(2*pi/3);0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [3] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00];
   [1] [1.00;1.00;1.00;0.00] [0.00;(-2*pi/3);(2*pi/3);0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [3] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00];
   [2] [1.00;1.00;1.00;0.00] [0.00;(-2*pi/3);(2*pi/3);0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [3] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00];
   [3] [1.00;1.00;1.00;0.00] [0.00;(-2*pi/3);(2*pi/3);0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00 ;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [3] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00];
   [4] [1.00;1.00;1.00;0.00] [0.00;(-2*pi/3);(2*pi/3);0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [3] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00];
   [5] [1.00;1.00;1.00;0.00] [0.00;(-2*pi/3);(2*pi/3);0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [3] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00];
   [6] [1.00;1.00;1.00;0.00] [0.00;(-2*pi/3);(2*pi/3);0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [3] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00];
   [7] [1.00;1.00;1.00;0.00] [0.00;(-2*pi/3);(2*pi/3);0.00] (1/3)*[1.00;1.00;1.00;0.00] (1/3)*(tan(acos(0.9))*[1.00;1.00;1.00;0.00]) [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [0.00;0.00;0.00;0.00] [3] (1/3)*[1.00;1.00;1.00;0.00] [0.00;0.00;0.00;0.00];
 };
%%%% different load for different nodes %%
load_P=1.0*ones(4*length(bus(:,1)),1);
load_Q=load_P.*tan(acos(0.96));
% node_based_load_variation; %%% change in this file for load variation
% time_instant=132; % change here to instruct the code in which instant of time you need the load flow solution
% load_P=tot__P(:,time_instant); 
% load_Q=tot__Q(:,time_instant);
%%%% different PV for different nodes %%
pv_curve_reshape_factor=ones(4*length(bus(:,1)),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
line_RX_CuXLPE=0.0985+0.0926*1i;
line_RX_Moon=0.284+0.350*1i;
 seqdata=[...
     3*(line_RX_CuXLPE)*(150/1000) 1*(line_RX_CuXLPE)*(150/1000);
     3*(line_RX_Moon)*((1530+1090)/1000) 1*(line_RX_Moon)*((1530+1090)/1000); 
     3*(line_RX_Moon)*(1680/1000) 1*(line_RX_Moon)*(1680/1000);
     3*(line_RX_Moon)*(1000/1000) 1*(line_RX_Moon)*(1000/1000);
     3*(line_RX_Moon)*(1200/1000) 1*(line_RX_Moon)*(1200/1000);
     3*(line_RX_CuXLPE)*(800/1000) 1*(line_RX_CuXLPE)*(800/1000);
 ];
seqdata_pu=seqdata./Z_baseH;
nline=length(seqdata_pu(:,1));
zz=seqdata_pu(:,1);zp=seqdata_pu(:,2);
imp_line=zeros(3,3,nline);
adm_line=zeros(4,4,nline);
imp_line_3w=zeros(4,4,nline);
for l=1:nline
    for i=1:3
        for j=1:3
            if i==j
              imp_line(i,j,l)=(2*zp(l)+zz(l))/3;
            else
              imp_line(i,j,l)=(zz(l)-zp(l))/3;
            end
        end
    end
    dummy=zeros(4,4);
    dummy(1:3,1:3)=inv(imp_line(:,:,l));
    adm_line(:,:,l)=dummy;
    dummy1=zeros(4,4);
    dummy1(1:3,1:3)=(imp_line(:,:,l));
    imp_line_3w(:,:,l)=dummy1;
    clear dummy dummy1;
end
reg1_imp=diag([0.0037+1i*0.2*0.0448;0.0037+1i*0.2*0.0448;0.0037+1i*0.2*0.0448])/10;
reg1_adm=zeros(4,4);
% reg1_adm(1:3,1:3)=inv(reg1_imp);
reg_yt=(1/(0.0037+1i*0.2*0.0448))/3;
reg1_adm(1:3,1:3)=[2*reg_yt -reg_yt -reg_yt;-reg_yt 2*reg_yt -reg_yt; -reg_yt -reg_yt 2*reg_yt];
% reg1_adm(1:3,1:3)=[reg_yt -reg_yt 0;-reg_yt 2*reg_yt -reg_yt; 0 -reg_yt reg_yt];
reg1_imp_dummy=zeros(4,4);reg1_imp_dummy(1:3,1:3)=reg1_imp;
reg1_imp=reg1_imp_dummy;
clear reg1_imp_dummy;

reg2_imp=diag([0.0009539+1i*0.0022;0.0009539+1i*0.0022;0.0009539+1i*0.0022])/10;
reg2_adm=zeros(4,4);
reg2_adm(1:3,1:3)=inv(reg2_imp);
reg3_imp=diag([0.0016+1i*0.0037;0.0016+1i*0.0037;0.0016+1i*0.0037])/5.5;
reg3_adm=zeros(4,4);
reg3_adm(1:3,1:3)=inv(reg3_imp);

seqdata_LV=[...
3*(line_RX_CuXLPE)*(150/1000) 1*(line_RX_CuXLPE)*(150/1000);
3*(line_RX_Moon)*((1530+1090)/1000) 1*(line_RX_Moon)*((1530+1090)/1000); 
3*(line_RX_Moon)*(1680/1000) 1*(line_RX_Moon)*(1680/1000);
3*(line_RX_Moon)*(1000/1000) 1*(line_RX_Moon)*(1000/1000);
3*(line_RX_Moon)*(1200/1000) 1*(line_RX_Moon)*(1200/1000);
3*(line_RX_CuXLPE)*(800/1000) 1*(line_RX_CuXLPE)*(800/1000);
];
unbalance=[1.00 1.00 0.780;1.00 0.970  0.860;0.780 0.860 1.03];  
nline_LV=length(seqdata_LV(:,1));
zz_LV=seqdata_LV(:,1)*1.0;zp_LV=seqdata_LV(:,2)*1.0;
%   bz=seqdata(:,3);bp=seqdata(:,4);
zz_LV=zz_LV/Z_baseL;zp_LV=zp_LV/Z_baseL;
  imp_line_LV=zeros(3,3,nline_LV);
  adm_line_LV=zeros(3,3,nline_LV);
  crg_line_LV=zeros(3,3,nline_LV);
  for l=1:nline_LV
    for i=1:3
      for j=1:3
          if i==j
              imp_line_LV(i,j,l)=(2*zp_LV(l)+zz_LV(l))/3;
%               crg_line(i,j,l)=(2*bp(l)+bz(l))/3;
          else
              imp_line_LV(i,j,l)=(zz_LV(l)-zp_LV(l))/3;
%               crg_line(i,j,l)=(bz(l)-bp(l))/3;
          end
      end
    end
%     imp_line(:,:,l)=imp_line(:,:,l).*unbalance;
    adm_line_LV(:,:,l)=inv(imp_line_LV(:,:,l));
  end
  zz_line=zeros(4,4,nline_LV);
  yy_line=zeros(4,4,nline_LV);
  for ii=1:nline_LV
      zline=zz_line(:,:,ii);
      zline(1:3,1:3)=imp_line_LV(:,:,ii);
      zline(4,1:3)=zline(1,2)*0.95;zline(1:3,4)=zline(1,2)*0.95;zline(4,4)=zline(2,2)*1.1;
      zz_line(:,:,ii)=zline;
      yy_line(:,:,ii)=inv(zz_line(:,:,ii));
  end
  AN=zeros(4,4);AN(1,1)=1;AN(1,4)=1;AN(4,1)=1;AN(4,4)=1;
  BN=zeros(4,4);BN(2,2)=1;BN(2,4)=1;BN(4,2)=1;BN(4,4)=1;
  CN=zeros(4,4);CN(3,3)=1;CN(3,4)=1;CN(4,3)=1;CN(4,4)=1;
  trafo_imp=diag([0.06*1i 0.06*1i 0.06*1i])*(400/3)/100; % Soultanis Model
  trafo_adm=inv(trafo_imp);
  line_12_13=zeros(3,3);
  imp_12_13=((((6.82+0.192*1i)*2)/1000)*20)/Z_baseL;
  line_12_13(3,3)=inv(imp_12_13);
  z_th=0.04+0.03*1i;
  z_th_imp=diag([z_th z_th z_th z_th]);
  z_th_imp(4,4)=0+0*1i;
  z_th_adm=inv(diag([z_th z_th z_th]));
  z_th_adm=[[z_th_adm [0;0;0]];[0 0 0 0]];
  trf_zmat=diag([Trf_Z Trf_Z Trf_Z Trf_Z]);trf_zmat(4,1:3)=-ones(1,3)*trf_zmat(4,4);trf_zmat(1:3,4)=-ones(3,1)*trf_zmat(4,4);trf_zmat(4,4)=3*trf_zmat(4,4);
  trf_ymat=diag([1/Trf_Z 1/Trf_Z 1/Trf_Z 1/Trf_Z]);trf_ymat(4,1:3)=-ones(1,3)*trf_ymat(4,4);trf_ymat(1:3,4)=-ones(3,1)*trf_ymat(4,4);trf_ymat(4,4)=3*trf_ymat(4,4);
line={...
    [1000] [1001]         [z_th_adm]  [zeros(4,4)];
    [1001]    [1]   [adm_line(:,:,1)]  [zeros(4,4)];
       [1]    [2]   [adm_line(:,:,2)]  [zeros(4,4)];
       [2]    [3]   [adm_line(:,:,3)]  [zeros(4,4)];
       [3]    [4]           [reg1_adm]  [zeros(4,4)];
       [4]    [5]   [adm_line(:,:,4)]  [zeros(4,4)];
       [5]    [6]   [adm_line(:,:,5)]  [zeros(4,4)];
       [6]    [7]   [adm_line(:,:,6)]  [zeros(4,4)];
            };
ld_bus1=[1:71];
ld_bus2=[72];
S=2.40/(length(ld_bus1)+length(ld_bus2))/3;
pf=0.95;
P=S*pf;
Q=S*sin(acos(pf));
T11=[0.00;0.00;0.00];
T12=[0.00;0.00;0.00];
T21=[0.00;0.00;0.00];
T22=[0.00;0.00;0.00];
T31=[0.00;0.00;0.00];
T32=[0.00;0.00;0.00];
S_f_bb_len=[0 0.1 1.1 4.7 10.1 16.1 16.7 19.9 20.9 24.8 25.8 29.2 33.9 38.5 41.6 44.6 51.4 51.6 53.6 67.7 68.1 68.7 71.3 78.2];
S_f_bb_line_ind=[1:9 11:17 19 26:27 29:33];
mul_ind=ones(1,24);
mul_ind([6 8 10:15 18 21:22])=2;
mul_ind(17)=3;
tot_3w_bus=9;
ind_3w_bus=[2:9];
imp_line_34w=zeros(4,4,length(line(:,3)));
imp_line_34w(:,:,1)=z_th_imp;
imp_line_34w(:,:,2)=imp_line_3w(:,:,1);
imp_line_34w(:,:,3)=imp_line_3w(:,:,2);
imp_line_34w(:,:,4)=imp_line_3w(:,:,3);
imp_line_34w(:,:,5)=reg1_imp;
imp_line_34w(:,:,6)=imp_line_3w(:,:,4);
imp_line_34w(:,:,7)=imp_line_3w(:,:,5);
imp_line_34w(:,:,8)=imp_line_3w(:,:,6);

% imp_line_34w(:,:,93)=trf_zmat;
% imp_line_34w(:,:,104)=trf_zmat;
% imp_line_34w(:,:,115)=trf_zmat;
% imp_line_34w(:,:,126)=trf_zmat;