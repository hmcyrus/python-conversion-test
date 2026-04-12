% sumBTP=[];
% for ii=1:361
%     sumBTP=[sumBTP;sum(BTP((20*(ii-1)+(1:20)),1))+sum(BTP((20*(ii-1)+(1:20)),2))+sum(BTP((20*(ii-1)+(1:20)),3))];
% end
% 
% % plot(day_1min(1080:1440),sumBTP);
figure; hold on;
for bb=1:20
    plot(day_1min(1080:1440),100*BTP(bb:20:(length(BTP(:,1))),:),'-');
end

figure; hold on;

for bb=1:20
    plot(day_1min(1080:1440),100*SOC(bb:20:(length(BTP(:,1))),:),'-');
end
% maxBTP=[];
% for bb=[1 2 3 4 5 6 8 9 10 11 12 13 15 16 17 18 19 20]
%     for pp=1:3
%         maxBTP=[maxBTP;max(abs(100*BTP(bb:20:(length(BTP(:,1))),pp)))];
%     end
% end
% plot(SoCRandom,maxBTP/2.2,'o')