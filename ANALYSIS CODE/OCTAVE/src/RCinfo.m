function s=RCinfo(y,t)
  setValue=y(end);
  error=abs(y-setValue)/setValue;
  setlingIdx=find(error>0.02,1,'last');
  s.setlingTime=t(min(length(t),setlingIdx+1));
  peakIdx=find(y==max(y),1,'first');
  s.peak=t(peakIdx);
  s.setlingMax=max(y);
  s.setlingMin=min(y(s.peak:end));
  s.overshoot=((s.setlingMax/setValue)-1)*100
  setlingRise=setValue*0.9;
  
 
  riseIdx=find(y>setlingRise,1,'first');
  if riseIdx==1
    s.riseTime=t(1);
  else
    v1=y(riseIdx-1);
    v2=y(riseIdx);
    s.riseTime=t(riseIdx-1)+(t(riseIdx)-t(riseIdx-1))*((setlingRise-v1)/(v2-v1));
  end
  setlingDelay=setValue*0.5;
  delayIdx=find(y>setlingDelay,1,'first');
   if delayIdx==1
    s.delayTime=t(1);
  else
    v1=y(delayIdx-1);
    v2=y(delayIdx);
    s.delayTime=t(riseIdx-1)+(t(riseIdx)-t(riseIdx-1))*((setlingRise-v1)/(v2-v1));
  end 
endfunction

