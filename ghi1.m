DoY=255;
x=(360/365)*(DoY-81)*(pi/180);
delta=23.45*sin(x)*(pi/180);
SM=120; % Standrad Meridian
LM=152; % Local Meridian
Lat=-27.5*(pi/180);
EoT=9.87*sin(2*x)-7.53*cos(x)-1.5*sin(x);
% LocT=6:(1/1):18;% hour
SolT=7:(1/60):17;% min
LocT=SolT-((SM-LM)*4+EoT)*(1/60);
HA=((12-SolT)*15)*(pi/180); % Hour Angle
alt_ang=asin(cos(Lat)*cos(delta)*cos(HA)+sin(Lat)*sin(delta));
azm_ang=asin((cos(delta)*sin(HA))./cos(alt_ang));
for ii=1:length(HA)
    if azm_ang(ii)<(pi/2)
        if cos(HA(ii))>=(tan(delta)/tan(Lat)) 
            azm_ang(ii)=azm_ang(ii);
        elseif cos(HA(ii))<(tan(delta)/tan(Lat))
            azm_ang(ii)=pi-azm_ang(ii);
        end
    end
end
A=1160+75*sin((360/365)*(DoY-275)*(pi/180));
k=0.174+0.035*sin((360/365)*(DoY-100)*(pi/180));
m=1./sin(alt_ang);
C=0.095+0.04*sin((360/365)*(DoY-100)*(pi/180));
rftnc=0.0;
IB=A*exp(-k*m);
IBH=IB.*sin(alt_ang);
col_azm_ang=0*(pi/180);
col_tlt_ang=20*(pi/180);
inc_ang=acos((cos(alt_ang).*cos(azm_ang-col_azm_ang))*sin(col_tlt_ang)+(sin(alt_ang)*cos(col_tlt_ang)));
%% Fixed Tilt %%
IBC_FT=IB.*cos(inc_ang);
IDC_FT=(C*IB)*((1+cos(col_tlt_ang))/2);
IRC_FT=rftnc*IB.*((sin(alt_ang)+C)*((1-cos(col_tlt_ang))/2));
IC_FT=IBC_FT+IDC_FT+IRC_FT;
IC_FT(IC_FT<0)=0;
%% Single Axis
IBC_SAT=IB.*cos(delta);
IDC_SAT=(C*IB).*((1+cos((pi/2)-alt_ang+delta))/2);
IRC_SAT=rftnc*(IBH+C*IB).*((1-cos((pi/2)-alt_ang+delta))/2);
IC_SAT=IBC_SAT+IDC_SAT+IRC_SAT;
% IBH(IBH<0)=0;
% IBC(IBC<0)=0;
% plot(LocT,IBH);
% hold on;
% plot(LocT,IBC);