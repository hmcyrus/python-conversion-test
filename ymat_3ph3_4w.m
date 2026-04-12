n_ph=4;
tot_bus=length(bus(:,1)); % total no. of buses 
bus_ind=cell2mat(bus(:,1)); % bus index vector
busV=cell2mat(bus(:,2));
busV0=busV;
busA=cell2mat(bus(:,3));
busA0=busA;
% LDM
busPL=p_P*LDM*(load_P.*cell2mat(bus(:,4)));
busP0L=busPL;
busQL=q_P*LDM*(load_Q.*cell2mat(bus(:,5)));
busQ0L=busQL;
%%%%%%%%%%%%%%%%%%%% Binda Bigga Loading
% ld_bus_ind1=zeros(length(ld_bus1),1);
% ld_bus_ind2=zeros(length(ld_bus2),1);
% for ii=1:length(ld_bus1)
%     ld_bus_ind1(ii)=find(ld_bus1(ii)==bus_ind);
% end
% for ii=1:length(ld_bus2)
%     ld_bus_ind2(ii)=find(ld_bus2(ii)==bus_ind);
% end
% clear ii;
% busPL(4*(ld_bus_ind1-1)+1)=P;busPL(4*(ld_bus_ind1-1)+2)=P;busPL(4*(ld_bus_ind1-1)+3)=P;%busPL(1:10)=0;busPL(11:20)=busPL(11:20)*2; %%%%%%% for binda_bigga load
% busPL(4*(ld_bus_ind2-1)+1)=P;busPL(4*(ld_bus_ind2-1)+2)=P;busPL(4*(ld_bus_ind2-1)+3)=P;
% busP0L=busPL;
% busQL=LDM*cell2mat(bus(:,5));
% busQL(4*(ld_bus_ind1-1)+1)=Q;busQL(4*(ld_bus_ind1-1)+2)=Q;busQL(4*(ld_bus_ind1-1)+3)=Q;%busQL(1:10)=0;busQL(11:20)=busQL(11:20)*2; %%%%%%%% for binda-bigga load
% busQL(4*(ld_bus_ind2-1)+1)=Q;busQL(4*(ld_bus_ind1-1)+2)=Q;busQL(4*(ld_bus_ind1-1)+3)=Q;
% busQ0L=busQL;
% busDGP=PPL*(cell2mat(bus(:,15)));
% busDGP=PPL*busPL;
% busDGP=1.00*busDGP;
% busDGQ=1.00*PPL*(cell2mat(bus(:,15)));
% busDGQ=zeros(3*tot_bus,1);
% dg_bus=19;
% dg_bus=find(dg_bus==bus_ind);
% busDGQ(3*(dg_bus-1)+(1:3))=-0.1*1.0;
% busDGQ=0.00*(tan(acos(0.98)).*busDGP);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
busPG=cell2mat(bus(:,6));
busQG=cell2mat(bus(:,7));
busPZ=p_Z*LDM*(load_P.*cell2mat(bus(:,8)));
busP0Z=busPZ;
busQZ=q_Z*LDM*(load_Q.*cell2mat(bus(:,9)));
busQ0Z=busQZ;
busPI=p_I*LDM*(load_P.*cell2mat(bus(:,10)));
busP0I=busPI;
busQI=q_I*LDM*(load_Q.*cell2mat(bus(:,11)));
busQ0I=busQI;
busSR=(cell2mat(bus(:,12)))./LDM;
busSI=(cell2mat(bus(:,13)))./LDM;
busDGP=PPL*(cell2mat(bus(:,15)));
% busDGP=pv_curve_reshape_factor.*busDGP;
% DGP(4)=DGP(4)*(1+0.0058*12);
% DGP(6)=DGP(6)*(1+0.0206*12);
% DGP(4)=DGP(4)*(1+0.2609);
% DGP(6)=DGP(6)*(1+0.1304);
% DGQ=PPL*cell2mat(bus(:,4));
aaa=4*((1:tot_bus)-1)+1;
bbb=4*((1:tot_bus)-1)+2;
ccc=4*((1:tot_bus)-1)+3;
ddd=4*((1:tot_bus)-1)+4;
% busDGP(aaa)=PPL_a*busDGP(aaa);
% busDGP(bbb)=PPL_b*busDGP(bbb);
% busDGP(ccc)=PPL_c*busDGP(ccc);
% busDGP(aaa)=(1.05+(1.30-1.05)*1.0)*busDGP(aaa);%% originally for a: 1.30. for b: 0.95
% busDGP(bbb)=1.05*busDGP(bbb);
% busDGP(ccc)=(1.05-(1.05-0.95)*1.0)*busDGP(ccc);
% busDGP=zeros(108,1);
% busDGP=0.00*DGP.*(PPL_final/100);
% DGQ=1.0*(tan(acos(0.90)).*DGP);
% DGQ(4)=DGQ(4)*(1+0.0519*12);
% DGQ(6)=DGQ(6)*(1-0.0107*12);
% DGQ(4)=DGQ(4)*(1+0.2611);
% DGQ(6)=DGQ(6)*(1+0.1305);
% DGQ(aaa)=1.2*DGQ(aaa);
% DGQ(bbb)=0.1*DGQ(bbb);
% DGQ(ccc)=0.1*DGQ(ccc);
% busDGQ=-0.00*ones(108,1);
busDGQ=0.00*(tan(acos(0.97)).*busDGP);
busBTP=zeros(length(busV),1);

%%%%%%%%%%% Load Calculations
% Load_PA0=sum(busP0L(aaa))+sum(busP0Z(aaa))+sum(busP0I(aaa));
% Load_QA0=sum(busQ0L(aaa))+sum(busQ0Z(aaa))+sum(busQ0I(aaa));
% Load_PB0=sum(busP0L(bbb))+sum(busP0Z(bbb))+sum(busP0I(bbb));
% Load_QB0=sum(busQ0L(bbb))+sum(busQ0Z(bbb))+sum(busQ0I(bbb));
% Load_PC0=sum(busP0L(ccc))+sum(busP0Z(ccc))+sum(busP0I(ccc));
% Load_QC0=sum(busQ0L(ccc))+sum(busQ0Z(ccc))+sum(busQ0I(ccc));
% [Load_PA0 Load_QA0 Load_PB0 Load_QB0 Load_PC0 Load_QC0]
tot_line=length(line(:,1));% total no. of lines
num_f=zeros(tot_line,1);num_t=zeros(tot_line,1);
for ii=1:tot_line
    f=cell2mat(line(:,1));
    t=cell2mat(line(:,2));
    num_f(ii)=find(f(ii)==bus_ind);
    num_t(ii)=find(t(ii)==bus_ind);
end
z_line=cell(tot_line,1);
y_line=cell(tot_line,1);
b_line=cell(tot_line,1);
for ii=1:tot_line
    y_line{ii}=line{ii,3};
    if length(line(ii,:))<4
        b_line{ii}=zeros(4,4);
    else
        b_line{ii}=0.5*line{ii,4};
    end
end

% formation of bus admittance matrix
tot_bus_3ph=tot_bus;%round(tot_bus/n_ph);

Y=cell(tot_bus_3ph,tot_bus_3ph);
for i=1:tot_bus_3ph
    for j=1:tot_bus_3ph
        Y{i,j}=zeros(4,4);
    end
end
% adding off diagonal elements
for i=1:tot_line
    Y{num_f(i),num_t(i)}=Y{num_f(i),num_t(i)}+y_line{i};
    Y{num_t(i),num_f(i)}=Y{num_f(i),num_t(i)};
end
%adding diagonal elements
Y_dummy=cell(tot_bus_3ph,tot_bus_3ph); % dummey Y matrix declared for summation
for i=1:tot_bus_3ph
    for j=1:tot_bus_3ph
        Y_dummy{i,j}=Y{i,j};
    end
end
for m=1:tot_bus_3ph
    for l=2:tot_bus_3ph
       Y_dummy{l,m}=Y_dummy{l,m}+Y_dummy{l-1,m};
    end
end
for i=1:tot_bus_3ph
    for j=1:tot_bus_3ph
        if i==j
            Y{i,j}=Y{i,j}+Y_dummy{tot_bus_3ph,j};
        else
            Y{i,j}=Y{i,j};
        end
    end
end
% adding line charging components
for i=1:tot_bus_3ph
    for j=1:tot_line
        if (num_f(j)==i)
            Y{i,i} = Y{i,i}+ b_line{j};
        elseif (num_t(j)==i)
            Y{i,i}=Y{i,i}+ b_line{j};
        end
    end
end
% %adding line shunt and load admittance components
% for i=1:tot_bus_3ph
%     for j=1:tot_bus_3ph
%         if i==j
%             %Y{i,j}=Y{i,j}+diag(y_CIL{i})+diag(y_SHN{i});%diag(y_SHN{i});%diag(y_CZL{i})+
%             Y{i,j}=Y{i,j}+diag(y_SHN{i});%+diag(y_CZL{i})+diag(y_CIL{i});
%         else
%             Y{i,j}=Y{i,j};
%         end
%     end
% end
% inverting sign of off-diagonal elements
for i=1:tot_bus_3ph
   for j=1:tot_bus_3ph
        if i==j
            Y{i,j}=Y{i,j};
        else
            Y{i,j}=-Y{i,j};
        end
    end
end
Y=cell2mat(Y);
% Y(4,4)=Y(4,4)+(0.00+0.00*1i);
% Y(8,8)=Y(8,8)+inv(0.20+0.50*1i);
% Y(12,12)=Y(12,12)+inv(2.00+1.00*1i);
% Y(4,:)=[];Y(:,4)=[];
% Y(1:7,1:7)=Y(1:7,1:7)+trafo_Y;
% Y(5:12,5:12)=Y(5:12,5:12)+trafo_Y;
% Y(9:16,9:16)=Y(9:16,9:16)+trafo_Y;
%%%%% adding the trafo primitive admittance matrix with system admittance matrix %%%%%%%%
% yprim;
% Yprim(8,5:7)=zeros; Yprim(5:7,8)=zeros;
% Yprim(4,5:7)=zeros; Yprim(5:7,4)=zeros;
% Y(5:12,5:12)=Y(5:12,5:12)+Yprim; %%% for IEEE 4 bus
% Y(9:16,9:16)=Y(9:16,9:16)+Yprim; %%% for data_3ph4w
% Y(17:24,17:24)=Y(17:24,17:24)+Yprim; %%% for Gatton 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Y([4 8],:)=[];Y(:,[4 8])=[];
% tap_imp;
%%%%%%% the following line must be activated if primitive trafo admittance matrix is not used %%%%%% 
% Y([4*(([1:tot_3w_bus])-1)+4],:)=zeros;Y(:,[4*(([1:tot_3w_bus])-1)+4])=zeros;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% addition of neutral grounding impedance %%%%%%%%%%%%%%%%%%%%

%%% IEEE 4-bus case or a generic case where all 4 wire buses will have neutral grounding %%%%
for ii=1:2%(tot_3w_bus+1):tot_bus
%     Y(4*(ii-1)+4,4*(ii-1)+4)=Y(4*(ii-1)+4,4*(ii-1)+4)+inv((10.0e-6+1i*0.0)/Z_baseL);
%     Y(4*(ii-1)+4,4*(ii-1)+4)=Y(4*(ii-1)+4,4*(ii-1)+4)+inv((65+1i*00)/Z_baseL);
end
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% Binda-Bigga Simulation for Load Flow Paper %%%%%%%%%%
% for ii=74:87
% %     Y(4*(ii-1)+4,4*(ii-1)+4)=Y(4*(ii-1)+4,4*(ii-1)+4)+inv(1i*1e-6);
%     if ((ii==74)||(ii==81))
%         Y(4*(ii-1)+4,4*(ii-1)+4)=Y(4*(ii-1)+4,4*(ii-1)+4)+inv((0.05+1i*00)/Z_baseL);
%     else
%         Y(4*(ii-1)+4,4*(ii-1)+4)=Y(4*(ii-1)+4,4*(ii-1)+4)+inv((5+1i*00)/Z_baseL);
%     end
% end
% for ii=130:150
% %     Y(4*(ii-1)+4,4*(ii-1)+4)=Y(4*(ii-1)+4,4*(ii-1)+4)+inv(1i*1e-6);
%     if ((ii==130)||(ii==137)||(ii==144))
%         Y(4*(ii-1)+4,4*(ii-1)+4)=Y(4*(ii-1)+4,4*(ii-1)+4)+inv((0.05+1i*00)/Z_baseL);
%     else
%         Y(4*(ii-1)+4,4*(ii-1)+4)=Y(4*(ii-1)+4,4*(ii-1)+4)+inv((0.5+1i*00)/Z_baseL);
%     end
% end
% for ii=88:129
% %     Y(4*(ii-1)+4,4*(ii-1)+4)=Y(4*(ii-1)+4,4*(ii-1)+4)+inv(1i*1e-6);
%     Y(4*(ii-1)+4,4*(ii-1)+4)=Y(4*(ii-1)+4,4*(ii-1)+4)+inv((0.05+1i*00)/Z_baseL);
% end
% Dgnd=zeros(4*tot_bus,1);
% Dgnd((4*74):(4*tot_bus))=inv(1i*1e-2);
% Ygnd=diag(Dgnd);
% Y=Ygnd+Y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Y([4 8 12],:)=zeros;Y(:,[4 8 12])=zeros;

G=real(Y);
B=imag(Y);
% jan=sum(sum(Y(:,:))); % for test purpose only
dY=diag(Y);
zyind=find(dY==0);%zyind(1:3)=[];
% dumY=Y;
% dumY(zyind,:)=[];
% dumY(:,zyind)=[];
%dumJin=inv(dumJ);
idxLP=find(busP0L);
idxLQ=find(busQ0L);
idxZP=find(busP0Z);
idxZQ=find(busQ0Z);
idxIP=find(busP0I);
idxIQ=find(busQ0I);
% busV(4)=[];busA(4)=[];
% busPG(4)=[];busQG(4)=[];
% busPL(4)=[];busQL(4)=[];
% busDGP(4)=[];busDGQ(4)=[];
% busV(1:3)=busV(1:3)*kV_baseH;
% busV(4:11)=busV(4:11)*kV_baseL;
% busPL=busPL*kVA_base;busQL=busQL*kVA_base;
bus_typ_ind=cell2mat(bus(:,14));
pq_ind=find(bus_typ_ind==3);
pv_ind=find(bus_typ_ind==2);
% pv_ind=(2:10);
swing_ind=find(bus_typ_ind==1);
% busPL(aaa)=(0.95+(1.10-0.95)*1.0)*busPL(aaa);busPL(bbb)=0.95*busPL(bbb);busPL(ccc)=(0.95-(0.95-0.90)*1.0)*busPL(ccc); %% originally for a: 1.10, b: 0.90
% busPI(aaa)=0.9*busPI(aaa);busPI(ccc)=1.1*busPI(ccc);
% busPZ(aaa)=0.8*busPZ(aaa);busPZ(ccc)=1.2*busPZ(ccc);
% busQL(aaa)=(0.95+(1.10-0.95)*1.0)*busQL(aaa);busQL(bbb)=0.95*busQL(bbb);busQL(ccc)=(0.95-(0.95-0.90)*1.0)*busQL(ccc);
% busQI(aaa)=0.8*busQI(aaa);busQI(ccc)=1.2*busQI(ccc);
% busQZ(aaa)=0.8*busQZ(aaa);busQZ(ccc)=1.2*busQZ(ccc);
% busPL(aaa(1:73))=5e-3;busPL(bbb(1:73))=5e-3;busPL(ccc(1:73))=5e-3;
% busQL(aaa(1:73))=5e-3*tan(acos(0.95));busQL(bbb(1:73))=5e-3*tan(acos(0.95));busQL(ccc(1:73))=5e-3*tan(acos(0.95));







