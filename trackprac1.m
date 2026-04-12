A11=5;
A12=5;
A21=-5;
A22=-5;
B1=[2 8];
B2=-[2 8];
B11_calc(1)=5;
B12_calc(1)=5;
B21_calc(1)=-5;
B22_calc(1)=-5;
thr=0.9;
for ii=2:20
%     B11_calc(ii)=A11+(B1(1)-A11)/10;
%     B12_calc(ii)=A12+(B1(2)-A12)/10;
%     B21_calc(ii)=A21+(B2(1)-A21)/10;
%     B22_calc(ii)=A22+(B2(2)-A22)/10;
    if abs((B1(1))-(A11))>thr
        B11_calc(ii)=A11+((B1(1)-A11)/(abs((B1(1))-(A11))))*thr;
    else
        B11_calc(ii)=B1(1);
    end
    if abs(abs(B1(2))-abs(A12))>thr
        B12_calc(ii)=A12+((B1(2)-A12)/(abs((B1(2))-(A12))))*thr;
    else
        B12_calc(ii)=B1(2);
    end
%     if abs(abs(B2(1))-abs(A21))>thr
%         B21_calc(ii)=A21+((B2(1)-A21)/(abs(abs(B2(1))-abs(A21))))*thr;
%     else
%         B21_calc(ii)=B2(1);
%     end
%     if abs(abs(B2(2))-abs(A22))>thr
%         B22_calc(ii)=A22+((B2(2)-A22)/(abs(abs(B2(2))-abs(A22))))*thr;
%     else
%         B22_calc(ii)=B2(2);
%     end
    A11=B11_calc(ii)
    A12=B12_calc(ii);
%     A21=B21_calc(ii);
%     A22=B22_calc(ii);
end