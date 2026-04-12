load=3*10*1000*Feeder_Load_abc(CustomerBus(1):tot_bus:length(Feeder_Load_abc(:,1)),1);
pv=-3*10*1000*Feeder_PV_abc(CustomerBus(1):tot_bus:length(Feeder_PV_abc(:,1)),1);
spv=pv-load;
spv(spv<0)=0;
socprof=[];
pchg=zeros(length(spv),1);
soc_ul=0.9*760;
soc_start=0.5*760;
day_cap=soc_ul-soc_start;
soc=soc_start;
esurp=0;
factor_old=0.01;
factor_prof=[];
correc=0;
for ii=1:length(spv)
    if (esurp>0)
%     if rem(ii,1)==0
%         factor=(soc-soc_start)/esurp;
% if spv(ii-1)==0
%     multip=1.0;
% else
%     multip=spv(ii)/spv(ii-1);
% end
multip=(esurp+(spv(ii)/60))/esurp;

        factor=((day_cap/390)*(ii-1+multip))/esurp;
        factor_old=factor;
%         disp('hello')
[ii (soc-soc_start) (day_cap/390)*(ii)]
    else
        factor=factor_old;
    end

    esurp=esurp+spv(ii)*(1/60);
%     pchg(ii)=((soc_ul-soc)/day_cap)*spv(ii);
%     pchg(ii)=((soc_ul-soc)/day_cap)*(esurp/day_cap)*spv(ii);
%     pchg(ii)=((day_cap*60)/((0)+spv(ii)*(400-ii)))*spv(ii);
    correc=((day_cap/390)*(ii)-(soc-soc_start));
    pchg(ii)=factor*spv(ii)+correc;
    if pchg(ii)>spv(ii)
        pchg(ii)=spv(ii);
    elseif pchg(ii)<0
        pchg(ii)=0;
    elseif (soc-soc_start)>=day_cap
        pchg(ii)=0;
    end
    soc=soc+pchg(ii)*(1/60);
    factor_prof=[factor_prof;factor];
end
plot(spv);
hold on;
plot(pchg);
    