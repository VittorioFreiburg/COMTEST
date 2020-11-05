function s=RCinfo(y,t)
  setvalue=y(end);
  peakIdx=find(x==max(x),1,'first');
  s.peak=t(peakIdx);
  s.setlingMax=max(x);
  s.setlingMin=min(x(s.peak:end))
  s.overshoot=((s.setlingMax/setvalue)-1)*100
  setlingRise=s.setlingMax*0.9;

  riseIdx=find(x>setlingrise,1,'first');
  if riseIdx==1
    s.riseTime=t(1);
  else
    v1=y(riseIdx-1);
    v2=y(riseIdx);
    s.riseTime=t(riseIdx-1)+(t(riseIdx)-t(riseIdx-1))*((setlingRise-v1)/(v2-v1));
  end
  setlingDelay=s.setlingMax*0.5;
  delayIdx=find(x>setlingdelay,1,'first');
   if delayIdx==1
    s.delayTime=t(1);
  else
    v1=y(delayIdx-1);
    v2=y(delayIdx);
    s.delayTime=t(riseIdx-1)+(t(riseIdx)-t(riseIdx-1))*((setlingRise-v1)/(v2-v1));
  end 
endfunction

