CapVec=[380 380 380];
CycleVec=[4000 4000 4000];
RatedDoDVec=[0.8 0.8 0.8];
LifeCapVec=CycleVec.*CapVec.*RatedDoDVec;
TptVec=[1000 1000 1000];
RTptVec=LifeCapVec-TptVec;
Ptot=450;
PwrVec=(RTptVec/(sum(RTptVec)))*Ptot;
