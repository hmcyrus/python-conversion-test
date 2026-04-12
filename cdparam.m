function [A_C B_C K_C E0_C A_D B_D K_D E0_D]=cdparam(Efull_C,Eexp_C,Enom_C,Efull_D,Eexp_D,Enom_D,Q,R)
% CR=Q/5;
% %%%%%%%% Charging Parameters %%%%%%
% A_C=Efull_C-Eexp_C;
% Qexp_C=0.2*Q;
% B_C=3/Qexp_C;
% Qnom_C=0.8*Q;
% K_C=(((Efull_C-Enom_C)+A_C*(exp(-B_C*Qnom_C)-1)-0*R*CR)*(Q-Qnom_C))/Qnom_C;
% E0_C=Efull_C+(K_C-R*CR-A_C);
% %%%%%%%% Discharge Parameters %%%%%%
% A_D=Efull_D-Eexp_D;
% Qexp_D=0.00*Q;
% B_D=3/Qexp_D;
% Qnom_D=0.8*Q;
% K_D=(((Efull_D-Enom_D)+A_D*(exp(-B_D*Qnom_D)-1)-0*R*CR)*(Q-Qnom_D))/Qnom_D;
% E0_D=Efull_D+(K_D+R*CR-A_D);

CR=Q/5;
%%%%%%%% Charging Parameters %%%%%%
A_C=Efull_C-Eexp_C;
Qexp_C=0.2*Q;
B_C=3./Qexp_C;
Qnom_C=0.8*Q;
K_C=(((Efull_C-Enom_C)+A_C*(exp(-B_C.*Qnom_C)-1)-0*R*CR).*(Q-Qnom_C))./Qnom_C;
E0_C=Efull_C+(K_C-R*CR-A_C);
%%%%%%%% Discharge Parameters %%%%%%
A_D=Efull_D-Eexp_D;
Qexp_D=0.00*Q;
B_D=3./Qexp_D;
Qnom_D=0.8*Q;
K_D=(((Efull_D-Enom_D)+A_D*(exp(-B_D.*Qnom_D)-1)-0*R*CR).*(Q-Qnom_D))./Qnom_D;
E0_D=Efull_D+(K_D+R*CR-A_D);