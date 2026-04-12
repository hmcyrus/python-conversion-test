BW=0.000;
V_HL=1.015;%
V_LL=0.99;%
max_step=16;
max_tap_step=2;
% lineflow;
% % [abs(S_from(num_t(10))) angle(S_from(num_t(10)))*(180/pi)]
% if(angle(S_from(num_t(10))))>0
%     mode=1; % mode: 1 = Forward Mode | -1 = Reverse Mode
% else
%     mode=-1;
% end
mode=1;
%% Regulator 1
% disp('Regulator 1 in Operation')
s_b1=num_f(5); % sending bus
r_b1=num_t(5); % receiving bus
send1=[(4*(s_b1-1)+1):(4*(s_b1-1)+3)];
recv1=[(4*(r_b1-1)+1):(4*(r_b1-1)+3)];
V0_recv1=busV(recv1);
ld_cen_bus=6;%18;%11;
ld_cen_bus=4*(ld_cen_bus-1)+(1:3);
% Vspec1=(1.00*V0_recv1);
% zt1=diag(diag(imp_line(:,:,10)));
yt1=reg1_adm;%inv(zt1);
for tap_it=1:max_tap_step
    for i=1:3
        if i==1
            if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase A than specified');
                T12(i)=T11(i)-mode*0.00625;
                if T12(i)<=-max_step*0.00625
                    T12(i)=-max_step*0.00625;
                end
                flag_a=0;
            elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase A than specified');
                T12(i)=T11(i)+mode*0.00625;
                if T12(i)>=max_step*0.00625
                    T12(i)=max_step*0.00625;
                end
                flag_a=0;
            else
                T12(i)=T11(i);
                flag_a=1;
            end
        elseif i==2
            if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase B than specified');
                T12(i)=T11(i)-mode*0.00625;
                if T12(i)<=-max_step*0.00625
                    T12(i)=-max_step*0.00625;
                end
                flag_b=0;
            elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase B than specified');
                T12(i)=T11(i)+mode*0.00625;
                if T12(i)>=max_step*0.00625
                    T12(i)=max_step*0.00625;
                end
                flag_b=0;
            else
                T12(i)=T11(i);
                flag_b=1;
            end
        elseif i==3
            if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase C than specified');
                T12(i)=T11(i)-mode*0.00625;
                if T12(i)<=-max_step*0.00625
                    T12(i)=-max_step*0.00625;
                end
                flag_c=0;
            elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase C than specified');
                T12(i)=T11(i)+mode*0.00625;
                if T12(i)>=max_step*0.00625
                    T12(i)=max_step*0.00625;
                end
                flag_c=0;
            else
                T12(i)=T11(i);
                flag_c=1;
            end
        end
        alpha(i)=T11(i)/(1+T11(i));
        beta(i)=T12(i)/(1+T12(i));
        Y(send1(i),recv1(i))=Y(send1(i),recv1(i))-(alpha(i)-beta(i))*yt1(i,i);
        Y(recv1(i),send1(i))=Y(send1(i),recv1(i));
        Y(send1(i),send1(i))=Y(send1(i),send1(i))+((beta(i))^2-(alpha(i))^2+2*(alpha(i)-beta(i)))*yt1(i,i);
        Y(recv1(i),recv1(i))=Y(recv1(i),recv1(i))+((alpha(i)-beta(i))+(beta(i)-alpha(i)))*yt1(i,i);
        G=real(Y);
        B=imag(Y);
    end
    for iter=1:50
        curr_mm_3p3_4w;
        if(max(abs(dI))<=1e-6)
            break;
        end
    end
    iter
    T11=T12;
    if and(and(flag_a,flag_b),flag_c)==1
%         disp('Reg 1 has reached the specified voltage');
%         fprintf('Tap Operations for Regulator1: %d\n',tap_it-1);
%         fprintf('Final Tap Value for Regulator1:\n');
%         fprintf('Phase A:%f\nPhase B:%f\nPhase C:%f\n',T12(1),T12(2),T12(3));  
        break;
    else
         flag_a=0;flag_b=0;flag_c=0;
    end
end
%%
% %% Regulator 1
% disp('Regulator 1 in Operation')
% s_b1=num_f(10); % sending bus
% r_b1=num_t(10); % receiving bus
% send1=[(3*(s_b1-1)+1):(3*(s_b1-1)+3)];
% recv1=[(3*(r_b1-1)+1):(3*(r_b1-1)+3)];
% V0_recv1=busV(recv1);
% ld_cen_bus=11;%18;%11;
% ld_cen_bus=3*(ld_cen_bus-1)+(1:3);
% % Vspec1=(1.00*V0_recv1);
% zt1=diag(diag(imp_line(:,:,10)));
% yt1=reg1_adm;%inv(zt1);
% for tap_it=1:max_step
%     for i=1:3
%         if i==1
%             if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase A than specified');
%                 T12(i)=T11(i)-mode*0.00625;
%                 flag_a=0;
%             elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase A than specified');
%                 T12(i)=T11(i)+mode*0.00625;
%                 flag_a=0;
%             else
%                 T12(i)=T11(i);
%                 flag_a=1;
%             end
%         elseif i==2
%             if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase B than specified');
%                 T12(i)=T11(i)-mode*0.00625;
%                 flag_b=0;
%             elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase B than specified');
%                 T12(i)=T11(i)+mode*0.00625;
%                 flag_b=0;
%             else
%                 T12(i)=T11(i);
%                 flag_b=1;
%             end
%         elseif i==3
%             if busV(ld_cen_bus(i))<V_LL*(1+BW);%Vspec1*(1-BW);
%                 disp('voltage is still lower in Phase C than specified');
%                 T12(i)=T11(i)-mode*0.00625;
%                 flag_c=0;
%             elseif busV(ld_cen_bus(i))>V_HL*(1-BW);
%                 disp('voltage is still higher in Phase C than specified');
%                 T12(i)=T11(i)+mode*0.00625;
%                 flag_c=0;
%             else
%                 T12(i)=T11(i);
%                 flag_c=1;
%             end
%         end
%         alpha(i)=T11(i)/(1+T11(i));
%         beta(i)=T12(i)/(1+T12(i));
%         Y(send1(i),recv1(i))=Y(send1(i),recv1(i))-(alpha(i)-beta(i))*yt1(i,i);
%         Y(recv1(i),send1(i))=Y(send1(i),recv1(i));
%         Y(send1(i),send1(i))=Y(send1(i),send1(i))+((beta(i))^2-(alpha(i))^2+2*(alpha(i)-beta(i)))*yt1(i,i);
%         Y(recv1(i),recv1(i))=Y(recv1(i),recv1(i))+((alpha(i)-beta(i))+(beta(i)-alpha(i)))*yt1(i,i);
%         G=real(Y);
%         B=imag(Y);
%     end
%     for iter=1:50
%         manjac;
%         if(max(abs(dPQ))<=1e-6)
%             break;
%         end
%     end
%     T11=T12;
%     if and(and(flag_a,flag_b),flag_c)==1
%         disp('Reg 1 has reached the specified voltage');
%         fprintf('Tap Operations for Regulator1: %d\n',tap_it-1);
%         fprintf('Final Tap Value for Regulator1:\n');
%         fprintf('Phase A:%f\nPhase B:%f\nPhase C:%f\n',T12(1),T12(2),T12(3));  
%         break;
%     else
%          flag_a=0;flag_b=0;flag_c=0;
%     end
% end
%%