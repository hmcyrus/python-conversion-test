% clear all;
% load('data_slightvarPV.mat')
load('data_highvarPV.mat')
% rfdata=[0;40;50;70;10;50;40;90;50;10];
% rfdata=[38;27;96;46;83;30;99;48;60;52;98;25;67];
% rfdata=[0;4;1;3;2;6;-2;5;1;4;2;3;-3;1;-2];
% rfdata=[-2;1;-3;5;-1;3;-4;4;-2];
% rfdata=[8;2;10;5;10;2;6;-10];
% rfdata=[8;6;3;2;5;10;7;5;6;7;8;10;8;4;2;3;6;0;-10];
% rfdata=[1;10;3;10;5;10;2;10];
% rfdata=[-2;1;-3;5;-1;3;-4;4;-2];
% rfdata=[5;8;10;10;15;25;5;45;15;35;5;40;10];
% rfdata=[28;29;30;27;26;27;26;24;26;29;25;22;26;28;30];
%  rfdata=[...
%      0
%     0.6000
%     0.2000
%     0.8000
%     0.6000
%     0.9000
%     0.5000
%     1.0000
%     0.3000
%     0.7000
%     0.4000
%     0.6000
%          0
%          ];
DoD_data=100-100*SOC(CustomerBus:tot_bus:length(BTP(:,1)),1);
% DoD_data=[50;50;50;48;52;51;50;50;50;50;47;54];
A=DoD_data(1:128);
% A=rfdata;
% figure;
% plot(A);
% hold on;
%% Reversal Calc
diff_old=(A(2)-A(1));
Apv=A(1);
Apv=[];
for ii=2:(length(A)-1)
    diff_new=(A(ii+1)-A(ii));
%     [ii diff_old diff_new]
    if diff_new~=0
        if (diff_old*diff_new<=0)
        Apv=[Apv;A(ii)];
%         [ii length(Apv)]
        diff_old=diff_new;
        end
    end
%     diff_old=diff_new;
end

% if A(1)~=Apv(1)
%     Apv=[A(1);Apv];
% end
% if A(length(A))~=Apv(length(Apv))
%     Apv=[Apv;A(length(A))];
% end
% 
% Apv=[Apv;A(length(A))];
%
% valley=find(diff(sign(diff(A)))>0)+1;
% peak=find(diff(sign(diff(A)))<0)+1;
% pkvl=union(valley,peak);
% Apv=zeros((2+length(pkvl)),1);
% Apv(1)=A(1);
% Apv(2:(length(Apv)-1))=A(pkvl);
% Apv(length(Apv))=A(length(A));
% Apv=Apv';
plot(Apv,'-o');
rfdata=Apv;%(2:(length(Apv)-1));a';%
%%
% valley1=find(diff(sign(diff(Apv))) > 0) + 1;
% peak1 = find(diff(sign(diff(Apv))) < 0) + 1;
% pkvl1=union(valley1,peak1);
% Apv1=zeros((2+length(pkvl1)),1);
% Apv1(1) = Apv(1);
% Apv1(2:(length(Apv1)-1))=Apv(pkvl1);
% Apv1(length(Apv))=Apv(length(Apv));
% Apv1 = Apv1';
% rfdata=Apv;%(2:(length(Apv)-1));
%%
%
% rfdata_dm=rfdata;
% vind=[];
% for ii=2:length(rfdata_dm)
%     if rfdata_dm(ii-1)==rfdata_dm(ii)
%         vind=[vind;(ii-1)];
%     end
% end
% rfdata_dm(vind)=[];
%
CycleData=[];
CycleCntData=[];
mx_ind=find(rfdata==max(rfdata));
% if length(mx_ind)>1
%     disp('1')
    rfdata_nw=rfdata;
% else
%     disp('2')
%     rfdata_nw=[rfdata(mx_ind:(length(rfdata)-0))';rfdata(2:(mx_ind))'];
% end

% [rfdata' rfdata_nw]
% figure;
% plot(rfdata)
% hold on
% plot(rfdata_nw)
% plot(rfdata_dm)

ii=2;
while(length(rfdata_nw)>=3)
    if (abs(rfdata_nw(ii-1)-rfdata_nw(ii))>0)&&(abs(rfdata_nw(ii-1)-rfdata_nw(ii))<=abs(rfdata_nw(ii)-rfdata_nw(ii+1)))
        if (ii-1)==1
            CycleCntData=[CycleCntData;0.5];
            cyl_dum=[rfdata_nw(ii-1) rfdata_nw(ii)];
            CycleData=[CycleData;cyl_dum];
            rfdata_nw(ii-1)=[];
%         ind1=find(rfdata_nw==cyl_dum(1));ind2=find(rfdata_nw==cyl_dum(2));
%         cyl_dum_ind=[ind1(1) ind2(1)];
%         rfdata_nw(cyl_dum_ind)=[];
        else
            CycleCntData=[CycleCntData;1.0];
            cyl_dum=[rfdata_nw(ii-1) rfdata_nw(ii)];
            CycleData=[CycleData;cyl_dum];
            rfdata_nw([(ii-1) ii])=[];
        end
        ii=2;
    else
        ii=ii+1;
        if (ii+1)>length(rfdata_nw)
            disp('Finished data');
            break;
        end
    end
end
% CycleData
% rfdata_nw
RangeData=[abs(CycleData(:,1)-CycleData(:,2))];
% RangeData=[abs(CycleData(:,1)-CycleData(:,2));abs(rfdata_nw(1)-rfdata_nw(2))]
% [CycleData RangeData]

resthfcycle=abs(diff(rfdata_nw));
CycleCntData=[CycleCntData;0.5*ones(length(resthfcycle),1)];
RangeData=[RangeData;resthfcycle];
% [RangeData CycleCntData]
% binedge1=(0:1:49)';
% binedge2=(1:1:50)';
binedge1=[(0:0.1:0.9) (1:1:99)]';
binedge2=[(0.1:0.1:1) (2:1:100)]';
% binedge1=L(1:13)';
% binedge2=L(2:14)';
TotCycData=zeros(length(binedge1),1);
for ii=1:length(binedge1)
    dmyind=find((RangeData>binedge1(ii))&(RangeData<=binedge2(ii)));
    TotCycData(ii)=sum(CycleCntData(dmyind));
end
% [binedge1 binedge2 TotCycData]
% [range_cycles RangeData(find(RangeData>0)) CycleCntData(find(RangeData>0))]
DODSwing=binedge2;%0.01:0.01:0.5;
LT=2873.1*((0.01*DODSwing).^(-1.483));
% [sum((TotCycData./LT)*100)*365 (1/LT(find(DODSwing==40)))*100*365]
sprintf('%0.5f%%',sum((TotCycData./LT)*100))
% figure;
% h1=histogram(RangeData,binedge2);
% stem(h1.BinEdges(find(h1.Values>0)),h1.Values(find(h1.Values>0)),'o')
% semilogy(RangeData,2873.1*((0.01*RangeData).^(-1.483)),'o')