clear all;
disp('--------------------------------------------------');
disp('Online BESS Cycle Life Degradation Assessment Tool'); 
disp('--------------------------------------------------');
disp('          ');
% load data_slightvarPV.mat SOC CustomerBus tot_bus
load data_highvarPV.mat SOC CustomerBus tot_bus
SoCdata=100*SOC(CustomerBus:tot_bus:length(SOC(:,1)),1);
DoDdata=100-SoCdata;%(1:99);
% rfdata=[0;40;50;70;10;50;40;90;50;10];
% rfdata=100-[38;27;96;46;83;30;99;48;60;52;98;25;67];
% DoDdata=rfdata(1:13);
% SoCdata=SoCdata(1:240);
A=[];
Apv_offline=[];
DoD_now=DoDdata(1);
A=[A;DoD_now];
% pause(1.0);
DoD_now=DoDdata(2);
A=[A;DoD_now];
diff_old=(A(2)-A(1));
% Apv=A(1);
rfdata_nw=A(1);
% rfdata_nw=[];

binedge1=[(0:0.1:0.9) (1:1:99)]';
binedge2=[(0.1:0.1:1) (2:1:100)]';
CycleData=[];
CycleCntData=[];
TotCycData=zeros(length(binedge1),1);
OfflineRangeData=[];
OfflineCycleCntData=[];
DODSwing=binedge2;
LT=2873.1*((0.01*DODSwing).^(-1.483));
CLD=0;
sw=1;
lidx=3;
while sw==1
pause(0.0);
DoD_now=DoDdata(lidx);
A=[A;DoD_now];
diff_new=(A(lidx)-A(lidx-1));
% [lidx diff_old diff_new]
signchngflag=0;
% if diff_old*diff_new<0
%     disp('sign changed');
%     rfdata_nw=[rfdata_nw;A(lidx-1)];
%     signchngflag=1;
% end
if diff_new~=0
    if (diff_old*diff_new<=0)
%         disp('sign changed');
        rfdata_nw=[rfdata_nw;A(lidx-1)];
        Apv_offline=[Apv_offline;A(lidx-1)];
        signchngflag=1;
%         [lidx length(Apv_offline)]
        diff_old=diff_new;
    end
end
% Apv=[Apv;A(length(A))];
% rfdata_nw=Apv;
CycleData=[];
CycleCntData=[];
TotCycData=zeros(length(binedge1),1);
%     if length(rfdata_nw)==3
%         ii=2;
%     end
kk=2;
% if ((length(rfdata_nw)>=3)&&(signchngflag==1))
while((length(rfdata_nw)>=3)&&(signchngflag==1))
%     for ii=2:(length(rfdata_nw)-1)
%     ii
    seg1=abs(rfdata_nw(kk)-rfdata_nw(kk-1));
    seg2=abs(rfdata_nw(kk+1)-rfdata_nw(kk));
    if ((seg1>0)&&(seg1<=seg2))
        if (kk-1)==1
%             disp('hehe1')
            CycleCntData=[CycleCntData;0.5];
            OfflineCycleCntData=[OfflineCycleCntData;0.5];
            cyl_dum=[rfdata_nw(kk-1) rfdata_nw(kk)];
            CycleData=[CycleData;cyl_dum];
            rfdata_nw(kk-1)=[];
        else
%             disp('hehe2')
            CycleCntData=[CycleCntData;1.0];
            OfflineCycleCntData=[OfflineCycleCntData;1.0];
            cyl_dum=[rfdata_nw(kk-1) rfdata_nw(kk)];
            CycleData=[CycleData;cyl_dum];
            rfdata_nw([(kk-1) kk])=[];
%             [kk length(rfdata_nw)]
        end
        kk=2;
    else
        kk=kk+1;
%         disp('trying next segment')
        if (kk+1)>(length(rfdata_nw)-0)
            break;
        end
    end
end
% CycleCntData
% end
if isempty(CycleData)==0
    RangeData=[abs(CycleData(:,1)-CycleData(:,2))];
    OfflineRangeData=[OfflineRangeData;RangeData];
    for jj=1:length(binedge1)
        dmyind=find((RangeData>binedge1(jj))&(RangeData<=binedge2(jj)));
        TotCycData(jj)=sum(CycleCntData(dmyind));
    end
 end
CLD=CLD+sum((TotCycData./LT)*100);   
% diff_old=diff_new;
% pause(0.01);
% LT=2873.1*((0.01*DODSwing).^(-1.483));
% sum((TotCycData./LT)*100)
% if lidx==length(DoDdata)
%     [Apv_offline(length(Apv_offline)) DoDdata(length(DoDdata))]
%     if Apv_offline(length(Apv_offline))~=DoDdata(length(DoDdata))
%         disp('hehe')
%         rfdata_nw=[rfdata_nw;DoDdata(length(DoDdata))];
%     end
    CycleData=[];
    CycleCntData=[];
    TotCycData=zeros(length(binedge1),1);
    resthfcycle=abs(diff(rfdata_nw));
    CycleCntData=[0.5*ones(length(resthfcycle),1)];
    RangeData=[resthfcycle];
    for jj=1:length(binedge1)
        dmyind=find((RangeData>binedge1(jj))&(RangeData<=binedge2(jj)));
        TotCycData(jj)=sum(CycleCntData(dmyind));
    end
    CLD_resthfcycle=sum((TotCycData./LT)*100);
    CLD_display=CLD+CLD_resthfcycle;
%     sprintf('Time Elapsed: %d seconds',lidx)
%     sprintf('Cycle Life Degradation up to now: %.5f%%',CLD_display)
    strdisp=sprintf('Cycle Life Degradation at %d-th minute: %.5f%%',lidx,CLD_display);
    if CLD_display>0.01
    disp(strdisp);
    end
%     disp(['Cycle Life Degradation at ' num2str(lidx)' '-th second:' num2str(CLD_display)]);
%     break;
% end
if lidx==length(DoDdata)
    break
end
lidx=lidx+1;
end
% OfflineRangeData=[OfflineRangeData;RangeData];
% OfflineCycleCntData=[OfflineCycleCntData;0.5*ones(length(resthfcycle),1)];
% OfflineTotCycData=zeros(length(binedge1),1);
% for jj=1:length(binedge1)
%         dmyind=find((OfflineRangeData>binedge1(jj))&(OfflineRangeData<=binedge2(jj)));
%         OfflineTotCycData(jj)=sum(OfflineCycleCntData(dmyind));
% end
% Offline_CLD=sum((OfflineTotCycData./LT)*100)