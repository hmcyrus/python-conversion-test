BW=0.000;
V_HL=1.09;%
V_LL=0.94;%
max_step=16;
max_tap_step=6;

%% Regulator 2
s_b2=num_f(18); % sending bus
r_b2=num_t(18); % receiving bus
send2=[(4*(s_b2-1)+1):(4*(s_b2-1)+3)];
recv2=[(4*(r_b2-1)+1):(4*(r_b2-1)+3)];
V0_recv2=busV(recv2);
ld_cen_bus=26;%19;
ld_cen_bus=4*(ld_cen_bus-1)+(1:3);
%     Vspec2=(1.01*V0_recv2);
zt2=diag(diag(imp_line(:,:,18)));
yt2=reg2_adm;%inv(zt2);
% disp('Regulator 2 in Operation')
for tap_it=1:max_tap_step
    for i=1:3
        if i==1
            if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase A than specified');
                T22(i)=T21(i)-0.00625;
                if T22(i)<=-max_step*0.00625
                    T22(i)=-max_step*0.00625;
                end
                flag_a=0;
            elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase A than specified');
                T22(i)=T21(i)+0.00625;
                if T22(i)>=max_step*0.00625
                    T22(i)=max_step*0.00625;
                end
                flag_a=0;
            else
                T22(i)=T21(i);
                flag_a=1;
            end
        elseif i==2
            if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase B than specified');
                T22(i)=T21(i)-0.00625;
                if T22(i)<=-max_step*0.00625
                    T22(i)=-max_step*0.00625;
                end
                flag_b=0;
            elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase B than specified');
                T22(i)=T21(i)+0.00625;
                if T22(i)>=max_step*0.00625
                    T22(i)=max_step*0.00625;
                end
                flag_b=0;
            else
                T22(i)=T21(i);
                flag_b=1;
            end
        elseif i==3
            if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase C than specified');
                T22(i)=T21(i)-0.00625;
                if T22(i)<=-max_step*0.00625
                    T22(i)=-max_step*0.00625;
                end
                flag_c=0;
            elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase C than specified');
                T22(i)=T21(i)+0.00625;
                if T22(i)>=max_step*0.00625
                    T22(i)=max_step*0.00625;
                end
                flag_c=0;
            else
                T22(i)=T21(i);
                flag_c=1;
            end
        end
        alpha(i)=T21(i)/(1+T21(i));
        beta(i)=T22(i)/(1+T22(i));
        Y(send2(i),recv2(i))=Y(send2(i),recv2(i))-(alpha(i)-beta(i))*yt2(i,i);
        Y(recv2(i),send2(i))=Y(send2(i),recv2(i));
        Y(send2(i),send2(i))=Y(send2(i),send2(i))+((beta(i))^2-(alpha(i))^2+2*(alpha(i)-beta(i)))*yt2(i,i);
        Y(recv2(i),recv2(i))=Y(recv2(i),recv2(i))+((alpha(i)-beta(i))+(beta(i)-alpha(i)))*yt2(i,i);
        G=real(Y);
        B=imag(Y);
    end
    for iter=1:50
        curr_mm_3p3_4w;
        if(max(abs(dI))<=1e-6)
            break;
        end
    end
    T21=T22;
    if and(and(flag_a,flag_b),flag_c)==1
%         disp('Reg 2 has reached the specified voltage');
%         fprintf('Tap Operations for Regulator2: %d\n',tap_it-1);
%         fprintf('Final Tap Value for Regulator2:\n');
%         fprintf('Phase A:%f\nPhase B:%f\nPhase C:%f\n',T22(1),T22(2),T22(3));
        break;
    else
        flag_a=0;flag_b=0;flag_c=0;
    end
end
%%