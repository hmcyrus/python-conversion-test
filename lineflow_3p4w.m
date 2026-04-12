% line{34,3}=inv(diag([SR_new SR_new SR_new]));
% line{35,3}=inv(diag([SR_new SR_new SR_new]));
Vsend_mag=zeros(4*tot_line,1);Vsend_ang=zeros(4*tot_line,1);
Vrecv_mag=zeros(4*tot_line,1);Vrecv_ang=zeros(4*tot_line,1);
I_ff=cell(tot_line,1);
I_tt=cell(tot_line,1);
I_ft=cell(tot_line,1);
I_from=cell(tot_line,1);
I_to=cell(tot_line,1);
P_loss=cell(tot_line,1);
L_res=cell(tot_line,1);
% Vsend=zeros(3*tot_line,1);
% Vrecv=zeros(3*tot_line,1);
for nline=1:tot_line
    for p=1:4
        Vsend_mag(4*(nline-1)+p)=busV(4*(num_f(nline)-1)+p);
        Vsend_ang(4*(nline-1)+p)=busA(4*(num_f(nline)-1)+p);
        Vrecv_mag(4*(nline-1)+p)=busV(4*(num_t(nline)-1)+p);
        Vrecv_ang(4*(nline-1)+p)=busA(4*(num_t(nline)-1)+p);
    end
end
Vsend=Vsend_mag.*(exp(1i*(Vsend_ang)));
Vrecv=Vrecv_mag.*(exp(1i*(Vrecv_ang)));
% for ii=1:13
%     for jj=1:3
%         Vsend(4*(ii-1)+(jj))=Vsend(4*(ii-1)+(jj))-Vsend(4*(ii-1)+(4));
%         Vrecv(4*(ii-1)+(jj))=Vrecv(4*(ii-1)+(jj))-Vrecv(4*(ii-1)+(4));
%     end
% end
ind=4*ones(1,tot_line);
Vsend=mat2cell(Vsend,ind);
Vrecv=mat2cell(Vrecv,ind);
%%%%%%%%%%% Caluclations performed for IEEE 34 Bus Distribution Test System
% lf12=Vsend(1:3).*((line{1,3})*conj(Vsend(1:3)-Vsend(4:6)))+(0.5*(line{1,4}))*Vsend(1:3)
% I1=(Vsend(1:3)-Vsend(4:6)).*([Y(1,3);Y(2,4);Y(3,6)])+Vsend(1:3).*([Y(1,1);Y(2,2);Y(3,2)])
% Ibase=kVA_base/kV_baseL;
% I1=line{1,3}*(Vsend(1:3)-Vsend(4:6))+0.5*line{1,4}*Vsend(1:3)
% I1_amp=[abs(I1)*Ibase angle(I1)*(180/pi)]
% S1=Vsend(1:3).*conj(I1)
% Sub_kVA=abs(S1)
% Tot_kVA=sum(Sub_kVA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for nline=1:tot_line
    L_res{nline}=real(diag(imp_line_34w(:,:,nline)));
    if length(line(nline,:))<4
        I_ff{nline}=zeros(4,4)*(Vsend{nline});%zeros(3,1);%line{nline,4}*(Vsend{nline});
        I_tt{nline}=zeros(4,4)*(Vrecv{nline});%zeros(3,1);%line{nline,4}*(Vrecv{nline});
    else
        I_ff{nline}=line{nline,4}*(Vsend{nline});
        I_tt{nline}=line{nline,4}*(Vrecv{nline});
    end
    I_ft{nline}=(line{nline,3})*(Vsend{nline}-Vrecv{nline});
    I_from{nline}=I_ff{nline}+I_ft{nline};
    I_to{nline}=I_ft{nline}-I_tt{nline};
    P_loss{nline}=(abs(I_ft{nline}).^2).*L_res{nline};
end
% I_from{2}=I_from{2}/1.06;
% I_to{2}=I_to{2}/1.06;
% [abs(cell2mat(I_to)) angle(cell2mat(I_to))*(180/pi)]
I_from=cell2mat(I_from);
I_from_act=I_from*I_baseL;
I_to=cell2mat(I_to);
I_to_act=I_to*I_baseL;
line_loss=cell2mat(P_loss);
line_ind=1:nline; % number of lines
% line_ind([10 11 18 19 27 28])=[];
aaa_line=(4*((line_ind)-1)+1);bbb_line=(4*((line_ind)-1)+2);ccc_line=(4*((line_ind)-1)+3);ddd_line=(4*((line_ind)-1)+4);
line_loss_a=sum(line_loss(aaa_line));line_loss_b=sum(line_loss(bbb_line));line_loss_c=sum(line_loss(ccc_line));line_loss_n=sum(line_loss(ddd_line));
line_loss=sum(line_loss);
% compass(real(I_to(7)),imag(I_to(7)),'r');
% hold on;
% compass(real(I_to(8)),imag(I_to(8)),'g');
% compass(real(I_to(9)),imag(I_to(9)),'b');
S_from=cell2mat(Vsend).*conj(I_from);
S_to=cell2mat(Vrecv).*conj(I_to);
% S_from_act=S_from*kVA_base/1000e3;
% S_to_act=S_to*kVA_base/1000e3;