BW=0.000;
V_HL=1.09;%
V_LL=0.96;%
max_step=16;
max_tap_step=6;
%% Regulator 3
% disp('Regulator 3 in Operation')
s_b3=num_f(28); % sending bus
r_b3=num_t(28); % receiving bus
send3=[(4*(s_b3-1)+1):(4*(s_b3-1)+3)];
recv3=[(4*(r_b3-1)+1):(4*(r_b3-1)+3)];
V0_recv3=busV(recv3);
% Vspec3=(1.01*V0_recv3);
ld_cen_bus=28;%28;
ld_cen_bus=4*(ld_cen_bus-1)+(1:3);
zt3=diag(diag(imp_line(:,:,28)));
yt3=reg3_adm;%inv(zt3);
for tap_it=1:max_tap_step
    for i=1:3
        if i==1
            if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase A than specified');
                T32(i)=T31(i)-0.00625;
                if T32(i)<=-max_step*0.00625
                    T32(i)=-max_step*0.00625;
                end
                flag_a=0;
            elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase A than specified');
                T32(i)=T31(i)+0.00625;
                if T32(i)>=max_step*0.00625
                    T32(i)=max_step*0.00625;
                end
                flag_a=0;
            else
                T32(i)=T31(i);
                flag_a=1;
            end
        elseif i==2
            if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase B than specified');
                T32(i)=T31(i)-0.00625;
                if T32(i)<=-max_step*0.00625
                    T32(i)=-max_step*0.00625;
                end
                flag_b=0;
            elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase B than specified');
                T32(i)=T31(i)+0.00625;
                if T32(i)>=max_step*0.00625
                    T32(i)=max_step*0.00625;
                end
                flag_b=0;
            else
                T32(i)=T31(i);
                flag_b=1;
            end
        elseif i==3
            if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase C than specified');
                T32(i)=T31(i)-0.00625;
                if T32(i)<=-max_step*0.00625
                    T32(i)=-max_step*0.00625;
                end
                flag_c=0;
            elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase C than specified');
                T32(i)=T31(i)+0.00625;
                if T32(i)>=max_step*0.00625
                    T32(i)=max_step*0.00625;
                end
                flag_c=0;
            else
                T32(i)=T31(i);
                flag_c=1;
            end
        end
        alpha(i)=T31(i)/(1+T31(i));
        beta(i)=T32(i)/(1+T32(i));
        Y(send3(i),recv3(i))=Y(send3(i),recv3(i))-(alpha(i)-beta(i))*yt3(i,i);
        Y(recv3(i),send3(i))=Y(send3(i),recv3(i));
        Y(send3(i),send3(i))=Y(send3(i),send3(i))+((beta(i))^2-(alpha(i))^2+2*(alpha(i)-beta(i)))*yt3(i,i);
        Y(recv3(i),recv3(i))=Y(recv3(i),recv3(i))+((alpha(i)-beta(i))+(beta(i)-alpha(i)))*yt3(i,i);
        G=real(Y);
        B=imag(Y);
    end
    for iter=1:50
        curr_mm_3p3_4w;
        if(max(abs(dI))<=1e-6)
            break;
        end
    end
    T31=T32;
    if and(and(flag_a,flag_b),flag_c)==1
%         disp('Reg 3 has reached the specified voltage');
%         fprintf('Tap Operations for Regulator1: %d\n',tap_it-1);
%         fprintf('Final Tap Value for Regulator1:\n');
%         fprintf('Phase A:%f\nPhase B:%f\nPhase C:%f\n',T32(1),T32(2),T32(3));
        break;
    else
         flag_a=0;flag_b=0;flag_c=0;
    end
end
%%
