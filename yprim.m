Trf_Z=0.01+0.06*1i;
V_base=1;%(4.16e3)/sqrt(1);
VA_base_A=10.0e6;%1.5e6;%
VA_base_B=10.0e6;
VA_base_C=10.0e6;%2.5e6;%
za=Trf_Z*(V_base^2/VA_base_A);
zb=Trf_Z*(V_base^2/VA_base_B);
zc=Trf_Z*(V_base^2/VA_base_C);
ZB=diag([Trf_Z Trf_Z Trf_Z]);
B=[1 0 0;-1 0 0;0 1 0;0 -1 0;0 0 1;0 0 -1];
Yl=B/(ZB)*transpose(B);
Vp=1;%7.2e3;
Vs=1;%4.16e3;
Na=[1/Vp 0;-1/Vp 0;0 1/Vs;0 -1/Vs];
Nb=Na;
Nc=Na;
N=cell(3,3);
N{1,1}=Na;
N{2,2}=Nb;
N{3,3}=Nc;
N{1,2}=zeros(4,2);
N{1,3}=zeros(4,2);
N{2,1}=zeros(4,2);
N{2,3}=zeros(4,2);
N{3,1}=zeros(4,2);
N{3,2}=zeros(4,2);
N=cell2mat(N);
% YW=(N*B)/(ZB)*(transpose(B)*transpose(N));
YW=N*Yl*transpose(N);
% for ii=1:12
%     YW(ii,ii)=YW(ii,ii)+1e-6;
% end
A=zeros(8,12);
%% Wye (4W)- Wye (4W)
% A(1,1)=1;
% A(2,5)=1;
% A(3,9)=1;
% A(4,[2 6 10])=1;
% A(5,3)=1;
% A(6,7)=1;
% A(7,11)=1;
% A(8,[4 8 12])=1;
% Yprim=A*YW*transpose(A);

%% Wye (3W)- Wye (3W)
% A(1,1)=1;
% A(2,5)=1;
% A(3,9)=1;
% % A(4,[2 6 10])=1;
% A(5,3)=1;
% A(6,7)=1;
% A(7,11)=1;
% % A(4,[4 8 12])=1;
% Yprim=A*YW*transpose(A);
%% Wye (4W)-Delta
% A(1,1)=1;
% A(2,5)=1;
% A(3,9)=1;
% A(4,[2 6 10])=1;
% A(5,[3 12])=1;
% A(6,[4 7])=1;
% A(7,[8 11])=1;
% Yprim=A*YW*transpose(A);
% Yprim(5:8,5:8)=Yprim(5:8,5:8)/3;
% Yprim(1:4,5:8)=Yprim(1:4,5:8)/sqrt(3);
% Yprim(5:8,1:4)=Yprim(5:8,1:4)/sqrt(3);
%% Wye (3Y)-Delta
% A(1,1)=1;
% A(2,5)=1;
% A(3,9)=1;
% % A(4,[2 6 10])=1;
% A(5,[3 12])=1;
% A(6,[4 7])=1;
% A(7,[8 11])=1;
% Yprim=A*YW*transpose(A);
% Yprim(5:8,5:8)=Yprim(5:8,5:8)/3;
% Yprim(1:4,5:8)=Yprim(1:4,5:8)/sqrt(3);
% Yprim(5:8,1:4)=Yprim(5:8,1:4)/sqrt(3);
ytl=inv(0.01+0.06*1i);
YPP=[ytl 0 0 0;0 ytl 0 0;0 0 ytl 0;0 0 0 0];
YPS=[-ytl/sqrt(3) ytl/sqrt(3) 0 0;0 -ytl/sqrt(3) ytl/sqrt(3) 0;ytl/sqrt(3) 0 -ytl/sqrt(3) 0; 0 0 0 0];
YSP=transpose(YPS);
YSS=[2*ytl/3 -ytl/3 -ytl/3 0;-ytl/3 2*ytl/3 -ytl/3 0;-ytl/3 -ytl/3 2*ytl/3 0;0 0 0 0];
Yprim=[YPP YPS;YSP YSS];
%% Delta-Wye
% A(1,[1 10])=1;
% A(2,[2 5])=1;
% A(3,[6 9])=1;
% A(5,3)=1;
% A(6,7)=1;
% A(7,11)=1;
% A(8,[4 8 12])=1;
% Yprim=A*YW*transpose(A);
% Yprim(1:3,1:3)=Yprim(1:3,1:3)/3;
% Yprim(1:4,5:8)=Yprim(1:4,5:8)/sqrt(3);
% Yprim(5:8,1:4)=Yprim(5:8,1:4)/sqrt(3);
% for ii=1:7
%     Yprim(ii,ii)=Yprim(ii,ii)+1e-6;
% end
%%% OpenWye-OpenDelta
% A(1,1)=1;
% A(2,5)=1;
% % A(3,9)=1;
% A(4,[2 6])=1;
% A(5,[3])=1;
% A(6,[4 7])=1;
% A(7,[8])=1;
% Yprim=A*YW*transpose(A);
% Yprim(5:8,5:8)=Yprim(5:8,5:8)/3;
% Yprim(1:4,5:8)=Yprim(1:4,5:8)/sqrt(3);
% Yprim(5:8,1:4)=Yprim(5:8,1:4)/sqrt(3);
% Yprim(4,1:4)=zeros; Yprim(1:4,4)=zeros;
% Yprim(4,5:7)=zeros; 
% Yprim(5:7,4)=zeros;

% Zbase=((11.00e3/sqrt(3))^2)/10.0e6;
% Ybase=1/Zbase;
% Yprim_pu=Yprim*Zbase;