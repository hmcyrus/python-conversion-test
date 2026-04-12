%%%% Lead-Acid Battery Parameters from R. Perez, Home Power 36, Aug/Sep 1993%%%%
%%%% Charging C/5 %%%%%%%%%%%%%
EfullCby5=15.95/6;
EexpCby5=13.67/6;
EnomCby5=12.80/6;
%%%%%%%%%%%%%%%%%%%%
%%%% Charging C/10 %%%%%%%%%%%%%
EfullCby10=15.30;
EexpCby10=13.40;
EnomCby10=12.60;
%%%%%%%%%%%%%%%%%%%%
%%%% Charging C/20 %%%%%%%%%%%%%
EfullCby20=14.20;
EexpCby20=13.20;
EnomCby20=12.50;
%%%%%%%%%%%%%%%%%%%%
%%%% Charging C/40 %%%%%%%%%%%%%
EfullCby40=15.95;
EexpCby40=13.67;
EnomCby40=12.95;
%%%%%%%%%%%%%%%%%%%%
%%%% Discharging C/5 %%%%%%%%%%%%%
EfullDby5=12.10/6;
EexpDby5=11.10/6;
EnomDby5=10.20/6;
%%%%%%%%%%%%%%%%%%%%
% R=0.04/10; %%% for Pb-SO4
% R=0.09; %%% for Li-Ion
% R=0.026; % Li-Ion CES
R=0.125; % Li-Ion PEV Nissan LEaf
Q=1*(60/1);
Ibatt=Q/1.0;
% A=EfullCby5-EexpCby5;
% Qexp=Ibatt*1;
Qexp=0.2*Q;
B=3/Qexp;
% Qnom=4*Ibatt;
Qnom=0.8*Q;
%%%%%% Internal Resistance Variation with SoC %%%%%%%
rho=(0.4*R)/Q;
%%%%%%%%%%%%%%%%%%%%
%%% Ni-MH
% Efull=1.4;
% Eexp=1.25;
% Enom=1.2;
% R=0.0046;
% Q=6.5;
% Ibatt=Q/2;
% A=Efull-Eexp;
% Qexp=Ibatt*1;
% B=3/Qexp;
% Qnom=4*Ibatt;

%%% Li-Ion
% Efull=4.4;
% Eexp=3.90;
% Enom=3.75;
% R=0.09;
% Q=250;
% Ibatt=Q/5;
% A=Efull-Eexp;
% Qexp=0.02*Q;
% B=3/Qexp;
% Qnom=0.98*Q;

%%% Li-Ion CES
% EfullC=425;
% EexpC=390;
% EnomC=380;
% EfullD=425;
% EexpD=390;
% EnomD=380;
%%% Li-Ion PEV Nissan Leaf
EfullC=400;
EexpC=390;
EnomC=350;
EfullD=400;
EexpD=390;
EnomD=350;
% R=0.09;
% Q=250;
% Ibatt=Q/5;
% A=Efull-Eexp;
% Qexp=0.02*Q;
% B=3/Qexp;
% Qnom=0.98*Q;
% A_C=31.0098;
% B_C=0.44575;
% K_C=0.0150;
% E0_C=395.43;
% A_D=31.0098;
% B_D=0.44575;
% K_D=0.0150;
% E0_D=395.43;

%%%%%%%%%%%%%%%%%%%%%
% K=(((Efull-Enom)+A*(exp(-B*Qnom)-1)-0*R*Ibatt)*(Q-Qnom))/Qnom;
% E0=Efull+(K-R*Ibatt-A);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [A_C B_C K_C E0_C A_D B_D K_D E0_D]=cdparam(EfullCby5,EexpCby5,EnomCby5,EfullDby5,EexpDby5,EnomDby5,Q,R);
[A_C B_C K_C E0_C A_D B_D K_D E0_D]=cdparam(EfullC,EexpC,EnomC,EfullD,EexpD,EnomD,Q,R);
% given_data=[0.468 3.5294 0.008762 3.7348 0.468 3.5294 0.008762 3.7348];
% A_C=given_data(1);B_C=given_data(2);K_C=given_data(3);E0_C=given_data(4);
% A_D=given_data(5);B_D=given_data(6);K_D=given_data(7);E0_D=given_data(8);
% A_C=A;B_C=B;K_C=K;E0_C=E0;
% A_D=A;B_D=B;K_D=K;E0_D=E0;
%%%% Tremblay Storage Model %%%%%%%
SoC=(0.0:0.01:0.99)*Q;
t=0:(1/60):(20);
% E=E0-K*(Q./(Q-SoC)).*SoC-R*(Ibatt)+A.*exp(-B*SoC)-K*(Q./(Q-SoC))*Ibatt;
% E=E0-K*(Q./(Q-Ibatt*t)).*(Ibatt*t)+A.*exp(-B*Ibatt*t)-K*(Q./(Q-Ibatt*t)).*(Ibatt);
% E=E0-K*(Q./(Q-Ibatt*t))+A.*exp(-B*Ibatt*t);
% E_C=E0_C-K_C*(Q./(Q-Ibatt*t))+A_C.*exp(-B_C*Ibatt*t);
% Vbatt_C=E_C+1*(1.0*R)*(1+0*rho*(Ibatt*t))*Ibatt;
E_C=E0_C-K_C*(Q./(Q-SoC))+A_C.*exp(-B_C*SoC);
Vbatt_C=E_C+(1.0*R+1*rho*SoC)*Ibatt;
% E_C=E0_C-K_C*(Q./(Q-(Q-SoC)))+A_C.*exp(-B_C*(Q-SoC));
% Vbatt_C=E_C+(1.4*R-1*rho*(Q-SoC))*Ibatt;
% E_D=E0_D-K_D*(Q./(Q-Ibatt*t))+A_D.*exp(-B_D*Ibatt*t);
% Vbatt_D=E_D-1*(1.0*R)*(1+0*rho*(Ibatt*t))*Ibatt;
E_D=E0_D-K_D*(Q./(Q-SoC))+A_D.*exp(-B_D*SoC);
Vbatt_D=E_D-(R+1*rho*SoC)*Ibatt;
plot(100-100*SoC/Q,1*Vbatt_C,'--r');
hold on;
plot(100-100*SoC/Q,1*Vbatt_D,'--b');
% plot(t,6*Vbatt_C,'--r');
% hold on;
% plot(t,6*Vbatt_D,'--b');
% plot(t,Vbatt,'r');
% axis([0 20 6 18]);
% plot(100-(Ibatt*t/Q)*100,Vbatt,'--r');
% axis([0 100 2*10.0 2*16.5]);
% axis([0 100 2.5 4.5]);
% figure;
% Pbatt=(6*Vbatt_C*Ibatt)/1000;
% Pload=1;
% Ppv=3;
% nuinv=0.89;
% nubat=1.00;
% Pinj=-Pload+nuinv*(Ppv-1*Pbatt/nubat);
% plot(100-100*SoC/Q,Pinj)
% PLmin=Pload*1e3;
% PPVmax=Ppv*1e3;
% x=fsolve(@(x)-x-((nubat*(PLmin-nuinv*PPVmax))/(nuinv*(6*(E_C(1)+R*x)))),0);