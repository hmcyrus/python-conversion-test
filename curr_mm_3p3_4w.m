clear busP_spec busQ_spec;
dummm=1;
Pcalc_curr=zeros(4*tot_bus,1);
Qcalc_curr=zeros(4*tot_bus,1);
I=zeros(4*tot_bus,1);
dIr=zeros(4*tot_bus,1);
dIm=zeros(4*tot_bus,1);
a_L=zeros(4*tot_bus,1);
b_L=zeros(4*tot_bus,1);
c_L=zeros(4*tot_bus,1);
d_L=zeros(4*tot_bus,1);
V=busV.*exp(1i*busA);
Vr=real(V);
Vm=imag(V);
% Vr(1)=Vr(1)-Vr(4);Vr(2)=Vr(2)-Vr(4);Vr(3)=Vr(3)-Vr(4);
% Vr(5)=Vr(5)-Vr(8);Vr(6)=Vr(6)-Vr(8);Vr(7)=Vr(7)-Vr(8);
% Vm(1)=Vm(1)-Vm(4);Vm(2)=Vm(2)-Vm(4);Vm(3)=Vm(3)-Vm(4);
% Vm(5)=Vm(5)-Vm(8);Vm(6)=Vm(6)-Vm(8);Vm(7)=Vm(7)-Vm(8);
% V=Vr+1i*Vm;
busP_spec=busPG-(busPL+busPZ+busPI)-busDGP-busBTP;
busQ_spec=busQG-(busQL+busQZ+busQI)-busDGQ;
% I=Y*V;
% I(1:3)=(busP_spec(1:3)-1i*busQ_spec(1:3))./((Vr(1:3)-Vr([4 4 4]))-1i*(Vm(1:3)-Vm([4 4 4])));
% I(5:7)=(busP_spec(5:7)-1i*busQ_spec(5:7))./((Vr(5:7)-Vr([8 8 8]))-1i*(Vm(5:7)-Vm([8 8 8])));
% I(9:11)=(busP_spec(9:11)-1i*busQ_spec(9:11))./((Vr(9:11)-Vr([12 12 12]))-1i*(Vm(9:11)-Vm([12 12 12])));
% I(13:15)=(busP_spec(13:15)-1i*busQ_spec(13:15))./((Vr(13:15)-Vr([16 16 16]))-1i*(Vm(13:15)-Vm([16 16 16])));
% I(4)=-sum(I(1:3));I(8)=-sum(I(5:7));I(12)=-sum(I(9:11));I(16)=-sum(I(13:15));
% Ir=real(I);
% Im=imag(I);
% [Ir Im]
for b=1:tot_bus
    for p=1:4
        if p<4
            I(4*(b-1)+p)=(busP_spec(4*(b-1)+p)-1i*busQ_spec(4*(b-1)+p))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))-1i*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4)));
        else
            I(4*(b-1)+p)=-sum(I(4*(b-1)+(1:3)));%(-z_line_12(4,4)\z_line_12(4,1:3))*I(4*(b-1)+(1:3));%
        end
    end
end
% I(8)=0.0+1i*0.0;
Ir=real(I);
Im=imag(I);
for b=1:tot_bus
    for p=1:4
        if p==4
            continue
        else
            Pcalc_curr(4*(b-1)+p)=(Vr(4*(b-1)+p)-Vr(4*(b-1)+4))*Ir(4*(b-1)+p)+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*Im(4*(b-1)+p);
            Qcalc_curr(4*(b-1)+p)=(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*Ir(4*(b-1)+p)-(Vr(4*(b-1)+p)-Vr(4*(b-1)+4))*Im(4*(b-1)+p);
        end
    end
end
delP=busP_spec-Pcalc_curr;
delQ=busQ_spec-Qcalc_curr;
% for b=1:2
%     for p=1:3
%         for ii=1:2
%             for jj=1:3
%                 dIr(4*(b-1)+p)=dIr(4*(b-1)+p)+(G(4*(b-1)+p,4*(ii-1)+jj)*Vr(4*(ii-1)+jj)-B(4*(b-1)+p,4*(ii-1)+jj)*Vm(4*(ii-1)+jj));
%                 dIm(4*(b-1)+p)=dIm(4*(b-1)+p)+(G(4*(b-1)+p,4*(ii-1)+jj)*Vm(4*(ii-1)+jj)+B(4*(b-1)+p,4*(ii-1)+jj)*Vr(4*(ii-1)+jj));
%             end
%         end
%     end
% end
for b=1:tot_bus
    for p=1:4
        for ii=1:tot_bus
            for jj=1:4
                dIr(4*(b-1)+p)=dIr(4*(b-1)+p)+(G(4*(b-1)+p,4*(ii-1)+jj)*Vr(4*(ii-1)+jj)-B(4*(b-1)+p,4*(ii-1)+jj)*Vm(4*(ii-1)+jj));
                dIm(4*(b-1)+p)=dIm(4*(b-1)+p)+(G(4*(b-1)+p,4*(ii-1)+jj)*Vm(4*(ii-1)+jj)+B(4*(b-1)+p,4*(ii-1)+jj)*Vr(4*(ii-1)+jj));
            end
        end
    end
end
% for b=1:tot_bus
%     for p=1:4
%         dIr_sum1=0.0;
%         dIm_sum1=0.0;
%         dIr_sum2=0.0;
%         dIm_sum2=0.0;
%         for ii=1:tot_bus
%             for jj=1:4
%                 if b~=ii
%                     dIr_sum1=dIr_sum1+(G(4*(b-1)+p,4*(ii-1)+jj)*Vr(4*(ii-1)+jj)-B(4*(b-1)+p,4*(ii-1)+jj)*Vm(4*(ii-1)+jj));
%                     dIm_sum1=dIm_sum1+(G(4*(b-1)+p,4*(ii-1)+jj)*Vm(4*(ii-1)+jj)+B(4*(b-1)+p,4*(ii-1)+jj)*Vr(4*(ii-1)+jj));
%                 else
%                     dIr_sum2=dIr_sum2+(G(4*(b-1)+p,4*(ii-1)+jj)*Vr(4*(ii-1)+jj)-B(4*(b-1)+p,4*(ii-1)+jj)*Vm(4*(ii-1)+jj));
%                     dIm_sum2=dIm_sum2+(G(4*(b-1)+p,4*(ii-1)+jj)*Vm(4*(ii-1)+jj)+B(4*(b-1)+p,4*(ii-1)+jj)*Vr(4*(ii-1)+jj));
%                 end
%             end
%         end
%         dIr(4*(b-1)+p)=dIr_sum1+dIr_sum2;
%         dIm(4*(b-1)+p)=dIm_sum1+dIm_sum2;
%     end
% end
% dIr(5)=1*(G(5,1)*Vr(1)-B(5,1)*Vm(1))+1*(G(5,2)*Vr(2)-B(5,2)*Vm(2))+1*(G(5,3)*Vr(3)-B(5,3)*Vm(3))+0*(G(5,4)*Vr(4)-B(5,4)*Vm(4))+(G(5,5)*Vr(5)-B(5,5)*Vm(5))+(G(5,6)*Vr(6)-B(5,6)*Vm(6))+(G(5,7)*Vr(7)-B(5,7)*Vm(7))+0*(G(5,8)*Vr(8)-B(5,8)*Vm(8));
% dIr(6)=(G(6,1)*Vr(1)-B(6,1)*Vm(1))+(G(6,2)*Vr(2)-B(6,2)*Vm(2))+(G(6,3)*Vr(3)-B(6,3)*Vm(3))+0*(G(6,4)*Vr(4)-B(6,4)*Vm(4))+(G(6,5)*Vr(5)-B(6,5)*Vm(5))+(G(6,6)*Vr(6)-B(6,6)*Vm(6))+(G(6,7)*Vr(7)-B(6,7)*Vm(7))+0*(G(6,8)*Vr(8)-B(6,8)*Vm(8));
% dIr(7)=(G(7,1)*Vr(1)-B(7,1)*Vm(1))+(G(7,2)*Vr(2)-B(7,2)*Vm(2))+(G(7,3)*Vr(3)-B(7,3)*Vm(3))+0*(G(7,4)*Vr(4)-B(7,4)*Vm(4))+(G(7,5)*Vr(5)-B(7,5)*Vm(5))+(G(7,6)*Vr(6)-B(7,6)*Vm(6))+(G(7,7)*Vr(7)-B(7,7)*Vm(7))+0*(G(7,8)*Vr(8)-B(7,8)*Vm(8));
% dIr(8)=(G(8,1)*Vr(1)-B(8,1)*Vm(1))+(G(8,2)*Vr(2)-B(8,2)*Vm(2))+(G(8,3)*Vr(3)-B(8,3)*Vm(3))+0*(G(8,4)*Vr(4)-B(8,4)*Vm(4))+(G(8,5)*Vr(5)-B(8,5)*Vm(5))+(G(8,6)*Vr(6)-B(8,6)*Vm(6))+(G(8,7)*Vr(7)-B(8,7)*Vm(7))+0*(G(8,8)*Vr(8)-B(8,8)*Vm(8));
% dIm(5)=(B(5,1)*Vr(1)+G(5,1)*Vm(1))+(B(5,2)*Vr(2)+G(5,2)*Vm(2))+(B(5,3)*Vr(3)+G(5,3)*Vm(3))+0*(B(5,4)*Vr(4)+G(5,4)*Vm(4))+(B(5,5)*Vr(5)+G(5,5)*Vm(5))+(B(5,6)*Vr(6)+G(5,6)*Vm(6))+(B(5,7)*Vr(7)+G(5,7)*Vm(7))+0*(B(5,8)*Vr(8)+G(5,8)*Vm(8));
% dIm(6)=(B(6,1)*Vr(1)+G(6,1)*Vm(1))+(B(6,2)*Vr(2)+G(6,2)*Vm(2))+(B(6,3)*Vr(3)+G(6,3)*Vm(3))+0*(B(6,4)*Vr(4)+G(6,4)*Vm(4))+(B(6,5)*Vr(5)+G(6,5)*Vm(5))+(B(6,6)*Vr(6)+G(6,6)*Vm(6))+(B(6,7)*Vr(7)+G(6,7)*Vm(7))+0*(B(6,8)*Vr(8)+G(6,8)*Vm(8));
% dIm(7)=(B(7,1)*Vr(1)+G(7,1)*Vm(1))+(B(7,2)*Vr(2)+G(7,2)*Vm(2))+(B(7,3)*Vr(3)+G(7,3)*Vm(3))+0*(B(7,4)*Vr(4)+G(7,4)*Vm(4))+(B(7,5)*Vr(5)+G(7,5)*Vm(5))+(B(7,6)*Vr(6)+G(7,6)*Vm(6))+(B(7,7)*Vr(7)+G(7,7)*Vm(7))+0*(B(7,8)*Vr(8)+G(7,8)*Vm(8));
% dIm(8)=(B(8,1)*Vr(1)+G(8,1)*Vm(1))+(B(8,2)*Vr(2)+G(8,2)*Vm(2))+(B(8,3)*Vr(3)+G(8,3)*Vm(3))+0*(B(8,4)*Vr(4)+G(8,4)*Vm(4))+(B(8,5)*Vr(5)+G(8,5)*Vm(5))+(B(8,6)*Vr(6)+G(8,6)*Vm(6))+(B(8,7)*Vr(7)+G(8,7)*Vm(7))+0*(B(8,8)*Vr(8)+G(8,8)*Vm(8));
% dIr(5)=(G(4,1)*Vr(1)-B(4,1)*Vm(1))+(G(4,2)*Vr(2)-B(4,2)*Vm(2))+(G(4,3)*Vr(3)-B(4,3)*Vm(3))+1*(G(4,4)*Vr(5)-B(4,4)*Vm(5))+(G(4,5)*Vr(6)-B(4,5)*Vm(6))+(G(4,6)*Vr(7)-B(4,6)*Vm(7))+1*(G(4,7)*Vr(8)-B(4,7)*Vm(8));
% dIr(6)=(G(5,1)*Vr(1)-B(5,1)*Vm(1))+(G(5,2)*Vr(2)-B(5,2)*Vm(2))+(G(5,3)*Vr(3)-B(5,3)*Vm(3))+1*(G(5,4)*Vr(5)-B(5,4)*Vm(5))+(G(5,5)*Vr(6)-B(5,5)*Vm(6))+(G(5,6)*Vr(7)-B(5,6)*Vm(7))+1*(G(5,7)*Vr(8)-B(5,7)*Vm(8));
% dIr(7)=(G(6,1)*Vr(1)-B(6,1)*Vm(1))+(G(6,2)*Vr(2)-B(6,2)*Vm(2))+(G(6,3)*Vr(3)-B(6,3)*Vm(3))+1*(G(6,4)*Vr(5)-B(6,4)*Vm(5))+(G(6,5)*Vr(6)-B(6,5)*Vm(6))+(G(6,6)*Vr(7)-B(6,6)*Vm(7))+1*(G(6,7)*Vr(8)-B(6,7)*Vm(8));
% dIr(8)=(G(7,1)*Vr(1)-B(7,1)*Vm(1))+(G(7,2)*Vr(2)-B(7,2)*Vm(2))+(G(7,3)*Vr(3)-B(7,3)*Vm(3))+1*(G(7,4)*Vr(5)-B(7,4)*Vm(5))+(G(7,5)*Vr(6)-B(7,5)*Vm(6))+(G(7,6)*Vr(7)-B(7,6)*Vm(7))+1*(G(7,7)*Vr(8)-B(7,7)*Vm(8));
% dIm(5)=(B(4,1)*Vr(1)+G(4,1)*Vm(1))+(B(4,2)*Vr(2)+G(4,2)*Vm(2))+(B(4,3)*Vr(3)+G(4,3)*Vm(3))+1*(B(4,4)*Vr(5)+G(4,4)*Vm(5))+(B(4,5)*Vr(6)+G(4,5)*Vm(6))+(B(4,6)*Vr(7)+G(4,6)*Vm(7))+1*(B(4,7)*Vr(8)+G(4,7)*Vm(8));
% dIm(6)=(B(5,1)*Vr(1)+G(5,1)*Vm(1))+(B(5,2)*Vr(2)+G(5,2)*Vm(2))+(B(5,3)*Vr(3)+G(5,3)*Vm(3))+1*(B(5,4)*Vr(5)+G(5,4)*Vm(5))+(B(5,5)*Vr(6)+G(5,5)*Vm(6))+(B(5,6)*Vr(7)+G(5,6)*Vm(7))+1*(B(5,7)*Vr(8)+G(5,7)*Vm(8));
% dIm(7)=(B(6,1)*Vr(1)+G(6,1)*Vm(1))+(B(6,2)*Vr(2)+G(6,2)*Vm(2))+(B(6,3)*Vr(3)+G(6,3)*Vm(3))+1*(B(6,4)*Vr(5)+G(6,4)*Vm(5))+(B(6,5)*Vr(6)+G(6,5)*Vm(6))+(B(6,6)*Vr(7)+G(6,6)*Vm(7))+1*(B(6,7)*Vr(8)+G(6,7)*Vm(8));
% dIm(8)=(B(7,1)*Vr(1)+G(7,1)*Vm(1))+(B(7,2)*Vr(2)+G(7,2)*Vm(2))+(B(7,3)*Vr(3)+G(7,3)*Vm(3))+1*(B(7,4)*Vr(5)+G(7,4)*Vm(5))+(B(7,5)*Vr(6)+G(7,5)*Vm(6))+(B(7,6)*Vr(7)+G(7,6)*Vm(7))+1*(B(7,7)*Vr(8)+G(7,7)*Vm(8));
for b=1:tot_bus
    for p=1:4
        if p==4
            dIr(4*(b-1)+p)=-dIr(4*(b-1)+p)+Ir(4*(b-1)+p);%;-sum(Ir(4*(b-1)+(1:3)));%
            dIm(4*(b-1)+p)=-dIm(4*(b-1)+p)+Im(4*(b-1)+p);%;-sum(Im(4*(b-1)+(1:3)));%
        else
            dIr(4*(b-1)+p)=-dIr(4*(b-1)+p)+((busP_spec(4*(b-1)+p)*(Vr(4*(b-1)+p)-Vr(4*(b-1)+4))+busQ_spec(4*(b-1)+p)*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4)))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2));
            dIm(4*(b-1)+p)=-dIm(4*(b-1)+p)+((busP_spec(4*(b-1)+p)*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))-busQ_spec(4*(b-1)+p)*(Vr(4*(b-1)+p)-Vr(4*(b-1)+4)))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2));
        end
    end
end

% for b=1:tot_bus
%     for p=1:4
%         if p==4
%             dIr(4*(b-1)+p)=(Ir(4*(b-1)+p));
%             dIm(4*(b-1)+p)=-(Im(4*(b-1)+p));
%         else
%             dIr(4*(b-1)+p)=(delP(4*(b-1)+p)*(Vr(4*(b-1)+p)-Vr(4*(b-1)+4))+delQ(4*(b-1)+p)*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4)))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2);
%             dIm(4*(b-1)+p)=(delP(4*(b-1)+p)*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))-delQ(4*(b-1)+p)*(Vr(4*(b-1)+p)-Vr(4*(b-1)+4)))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2);
%         end
%     end
% end
delP(1:4)=[];
delQ(1:4)=[];
B11=B;
G12=G;
G21=G;
B22=-B;
for b=1:tot_bus
    for p=1:4
        if p==4
            continue
        else
%             a_L(4*(b-1)+p)=(busQ_spec(4*(b-1)+p)*((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2-(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)-2*(Vr(4*(b-1)+p)-Vr(4*(b-1)+4))*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*busP_spec(4*(b-1)+p))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)^2;
%             b_L(4*(b-1)+p)=(busP_spec(4*(b-1)+p)*((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2-(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)+2*(Vr(4*(b-1)+p)-Vr(4*(b-1)+4))*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*busQ_spec(4*(b-1)+p))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)^2;
%             c_L(4*(b-1)+p)=-b_L(4*(b-1)+p);
%             d_L(4*(b-1)+p)=a_L(4*(b-1)+p);
            AP=(busQ_spec(4*(b-1)+p)*((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2-(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)-2*(Vr(4*(b-1)+p)-Vr(4*(b-1)+4))*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*busP_spec(4*(b-1)+p))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)^2;
            AI=(Vr(4*(b-1)+p)*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*busPI(4*(b-1)+p)+busQI(4*(b-1)+p)*((Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)^(3/2);
            AZ=busQZ(4*(b-1)+p);
            a_L(4*(b-1)+p)=AP+AI+AZ;
            BP=(busP_spec(4*(b-1)+p)*((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2-(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)+2*(Vr(4*(b-1)+p)-Vr(4*(b-1)+4))*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*busQ_spec(4*(b-1)+p))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)^2;
            BI=((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*busQI(4*(b-1)+p)+busPI(4*(b-1)+p)*((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)^(3/2);
            BZ=busPZ(4*(b-1)+p);
            b_L(4*(b-1)+p)=BP-BI-BZ;
            CP=(busP_spec(4*(b-1)+p)*((Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2-(Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2)-2*(Vr(4*(b-1)+p)-Vr(4*(b-1)+4))*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*busQ_spec(4*(b-1)+p))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)^2;
            CI=((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*busQI(4*(b-1)+p)-busPI(4*(b-1)+p)*((Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)^(3/2);
            CZ=busPZ(4*(b-1)+p);
            c_L(4*(b-1)+p)=CP+CI-CZ;
            DP=(busQ_spec(4*(b-1)+p)*((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2-(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)-2*(Vr(4*(b-1)+p)-Vr(4*(b-1)+4))*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*busP_spec(4*(b-1)+p))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)^2;
            DI=((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))*(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))*busPI(4*(b-1)+p)-busQI(4*(b-1)+p)*((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2))/((Vr(4*(b-1)+p)-Vr(4*(b-1)+4))^2+(Vm(4*(b-1)+p)-Vm(4*(b-1)+4))^2)^(3/2);
            DZ=busQZ(4*(b-1)+p);
            d_L(4*(b-1)+p)=DP+DI-DZ;
        end
    end
end

n_pv_bus=length(pv_ind);
IJAC=zeros(8*tot_bus+3*n_pv_bus,8*tot_bus+3*n_pv_bus);
efgh=zeros(8,8,tot_bus);
dI=zeros(8*tot_bus,1);
for ii=1:tot_bus
    dummy=efgh(:,:,ii);
    dummy(1:3,1:3)=-diag(a_L(4*(ii-1)+(1:3)));
    dummy(4,1:3)=a_L(4*(ii-1)+(1:3));
    dummy(1:3,4)=a_L(4*(ii-1)+(1:3));
    dummy(4,4)=-sum(a_L(4*(ii-1)+(1:3)));
    dummy(1:3,5:7)=-diag(b_L(4*(ii-1)+(1:3)));
    dummy(4,5:7)=b_L(4*(ii-1)+(1:3));
    dummy(1:3,8)=b_L(4*(ii-1)+(1:3));
    dummy(4,8)=-sum(b_L(4*(ii-1)+(1:3)));
    dummy(5:7,1:3)=-diag(c_L(4*(ii-1)+(1:3)));
    dummy(8,1:3)=c_L(4*(ii-1)+(1:3));
    dummy(5:7,4)=c_L(4*(ii-1)+(1:3));
    dummy(8,4)=-sum(c_L(4*(ii-1)+(1:3)));
    dummy(5:7,5:7)=-diag(d_L(4*(ii-1)+(1:3)));
    dummy(8,5:7)=d_L(4*(ii-1)+(1:3));
    dummy(5:7,8)=d_L(4*(ii-1)+(1:3));
    dummy(8,8)=-sum(d_L(4*(ii-1)+(1:3)));
    efgh(:,:,ii)=dummy;
    clear dummy;
end
   
for ii=1:tot_bus
    for jj=1:tot_bus
        IJAC(8*(ii-1)+(1:4),8*(jj-1)+(1:4))=IJAC(8*(ii-1)+(1:4),8*(jj-1)+(1:4))+B(4*(ii-1)+(1:4),4*(jj-1)+(1:4));
        IJAC(8*(ii-1)+(1:4),8*(jj-1)+(5:8))=IJAC(8*(ii-1)+(1:4),8*(jj-1)+(5:8))+G(4*(ii-1)+(1:4),4*(jj-1)+(1:4));
        IJAC(8*(ii-1)+(5:8),8*(jj-1)+(1:4))=IJAC(8*(ii-1)+(5:8),8*(jj-1)+(1:4))+G(4*(ii-1)+(1:4),4*(jj-1)+(1:4));
        IJAC(8*(ii-1)+(5:8),8*(jj-1)+(5:8))=IJAC(8*(ii-1)+(5:8),8*(jj-1)+(5:8))-B(4*(ii-1)+(1:4),4*(jj-1)+(1:4));
    end
end

for ii=1:tot_bus
    IJAC(8*(ii-1)+(1:8),8*(ii-1)+(1:8))=IJAC(8*(ii-1)+(1:8),8*(ii-1)+(1:8))+efgh(:,:,ii);
end

% for ii=1:length(pv_ind)
%     IJAC(8*(ii-1)+(1:4),8*(jj-1)+(1:4))=IJAC(8*(ii-1)+(1:4),8*(jj-1)+(5:8))-IJAC(8*(ii-1)+(1:4),8*(jj-1)+(1:4))*(Vm(4*(ii-1)+(1:4))./Vr(4*(ii-1)+(1:4)));
%     IJAC(8*(ii-1)+(5:8),8*(jj-1)+(1:4))=IJAC(8*(ii-1)+(5:8),8*(jj-1)+(1:4))+IJAC(8*(ii-1)+(5:8),8*(jj-1)+(5:8))*(Vm(4*(ii-1)+(1:4))./Vr(4*(ii-1)+(1:4)));
%     IJAC(8*(ii-1)+(1:4),8*(jj-1)+(5:8))=diag(((Vr(4*(ii-1)+(1:4)).^2)./abs(complex(Vr(4*(ii-1)+(1:4)),Vm(4*(ii-1)+(1:4))))));
%     IJAC(8*(ii-1)+(5:8),8*(jj-1)+(5:8))=-diag(((Vm(4*(ii-1)+(1:4)).^2)./abs(complex(Vr(4*(ii-1)+(1:4)),Vm(4*(ii-1)+(1:4))))));
% end

% X=zeros(n_pv_bus*3,(tot_bus+n_pv_bus)*8);
% Y=zeros(n_pv_bus*3,8);
for ii=1:n_pv_bus
    IJAC((8*(tot_bus-0)+3*(ii-1))+(1:3),8*(pv_ind(ii)-1)+(1:3))=0*IJAC((8*(tot_bus-0)+3*(ii-1))+(1:3),8*(pv_ind(ii)-1)+(1:3))+1*diag((Vr(4*(pv_ind(ii)-1)+(1:3)))./abs(complex(Vr(4*(pv_ind(ii)-1)+(1:3)),Vm(4*(pv_ind(ii)-1)+(1:3)))));
    IJAC((8*(tot_bus-0)+3*(ii-1))+(1:3),8*(pv_ind(ii)-1)+(5:7))=0*IJAC((8*(tot_bus-0)+3*(ii-1))+(1:3),8*(pv_ind(ii)-1)+(5:7))+1*diag((Vm(4*(pv_ind(ii)-1)+(1:3)))./abs(complex(Vr(4*(pv_ind(ii)-1)+(1:3)),Vm(4*(pv_ind(ii)-1)+(1:3)))));
    dummy1=zeros(3,8);
    dummy1(1:3,1:3)=+diag(Vr(4*(pv_ind(ii)-1)+(1:3))./(abs(complex(Vr(4*(pv_ind(ii)-1)+(1:3)),Vm(4*(pv_ind(ii)-1)+(1:3))))).^2);
    dummy1(1:3,5:7)=-diag(Vm(4*(pv_ind(ii)-1)+(1:3))./(abs(complex(Vr(4*(pv_ind(ii)-1)+(1:3)),Vm(4*(pv_ind(ii)-1)+(1:3))))).^2);
    dummy1=transpose(dummy1);
    IJAC(8*(pv_ind(ii)-1)+(1:8),(8*(tot_bus-0)+3*(ii-1))+(1:3))=0*IJAC(8*(pv_ind(ii)-1)+(1:8),(8*(tot_bus-0)+3*(ii-1))+(1:3))+dummy1;
end 

% IJAC(1:8,:)=[];IJAC(:,1:8)=[];

% vanish_ind=zeros(2*(tot_3w_bus-1),1);
% for ii=1:(tot_3w_bus-1)
% vanish_ind(2*(ii-1)+1)=8*(ii-1)+4;
% vanish_ind(2*(ii-1)+2)=8*(ii-1)+8;
% end
% vanish_ind=[(8*(swing_ind-1)+(1:8)) 12 16 20 24 28 32];
vanish_ind=[];
for ii=1:length(ind_3w_bus)
    vanish_ind=[vanish_ind 8*(ind_3w_bus(ii)-1)+4 8*(ind_3w_bus(ii)-1)+8];
end
vanish_ind=[1:8 vanish_ind];
    
IJAC(vanish_ind,:)=[];IJAC(:,vanish_ind)=[];

for ii=1:tot_bus
    dI(8*(ii-1)+(1:4))=dIm(4*(ii-1)+(1:4));
    dI(8*(ii-1)+(5:8))=dIr(4*(ii-1)+(1:4));
end
delta_I=dI;
delta_I_vanish_ind=zeros(1,1);
for ii=1:length(pv_ind)
delta_I_vanish_ind=horzcat(delta_I_vanish_ind,8*(pv_ind(ii)-1)+(1:8));
end
delta_I_vanish_ind(1)=[];
delta_I(delta_I_vanish_ind)=[];
delta_I(1:8)=[];
% dI(1:8)=[];

dI(vanish_ind)=[];
% if isempty(pv_ind)==0
% %     exit
% % else
%     % delV_spec=sqrt(abs((([0.95;0.95;0.95]).^2)-(Vr(5:7).^2)-(Vm(5:7).^2)));
% %     delV_spec=[1.0151+0.5*(1.02-1.0151);0.9936+0.2*(1.02-0.9936);1.0150+0.9*(1.02-1.0150)]-busV([5:7]);% 9:11 13:15 17:19 21:23 25:27 29:31 33:35 37:39]);
%     % delV_spec=[1.0126;1.0126;1.0126;1.006;1.006;1.006;1.00;1.00;1.00;0.995;0.995;0.995;0.991;0.991;0.991;0.988;0.988;0.988;0.985;0.985;0.985;0.983;0.983;0.983;0.983;0.983;0.983]-busV([5:7 9:11 13:15 17:19 21:23 25:27 29:31 33:35 37:39]);
%     % delV_spec=[0.99;0.99;0.99;0.97;0.97;0.97]-busV([9:11 13:15]); % IEEE 4 bus system
%     delV_spec=[1.08;1.08;1.08]-busV([465:467]);
%     % delV_spec=1.02*[1.00;1.00;1.00;1.00;1.00;1.00;1.00;1.00;1.00;1.00;1.00;1.00;1.00;1.00;1.00]-busV([5:7 9:11 13:15 17:19 21:23]); 
%     dI=[dI;delV_spec];
% end
delV_spec=zeros(3*length(pv_ind),1);
if isempty(pv_ind)==0
    for b=1:length(pv_ind)
        for p=1:3
            delV_spec(3*(b-1)+p)=busV0(4*(pv_ind(b)-1)+p)-busV(4*(pv_ind(b)-1)+p);
        end
    end
    dI=[dI;delV_spec];
end

dV=IJAC\dI;
dV=dV(1:(length(dV)-length(delV_spec)));
dV1=zeros(8*tot_bus,1);

for ii=1:length(dV1)
    if isempty(find(ii==vanish_ind))==1
        dV1(ii)=dV(dummm);
        dummm=dummm+1;
    elseif isempty(find(ii==vanish_ind))==0
        dV1(ii)=dV1(ii);
    end
end

dV=dV1;
dVr=zeros(4*tot_bus,1);
dVm=zeros(4*tot_bus,1);

for ii=1:tot_bus
    dVr(4*(ii-1)+(1:4))=dV(8*(ii-1)+(1:4));
    dVm(4*(ii-1)+(1:4))=dV(8*(ii-1)+(5:8));
end
Vr=Vr+dVr;
Vm=Vm+dVm;

V=Vr+1i*Vm;
busV=abs(V);
busA=angle(V);
busPZ=busP0Z.*(busV.^2);
busQZ=busQ0Z.*(busV.^2);
busPI=busP0I.*(busV.^1);
busQI=busQ0I.*(busV.^1);