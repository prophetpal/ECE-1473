function [ h,t ] = RootRCRO_Pulse( Kt,Tb,sample_per_bit,r )
%Root Raised Cosine Rolloff pulse
%  Tb is the bit period and 2kT represents the number of bit periods
t=-Kt*Tb:Tb/sample_per_bit:Kt*Tb;
t=t(1,1:length(t)-1);
h=0*t;
R=1/Tb;

for t1=1:length(t)   
    denom=(sin(pi*R*t(t1)*(1-r))+4*R*r*t(t1)*cos(pi*R*t(t1)*(1+r)));
    numr=(pi*R*t(t1)*(1-(4*R*r*t(t1)).^2));
   if t(t1)==0
       h(t1)=1-r+4*r/pi;       
   elseif abs(abs(t(t1))-Tb/4/r) < Tb/ sample_per_bit/2    %percision sucks     
       h(t1)=r/2^0.5*((1+2/pi)*sin(pi/4/r)+(1-2/pi)*cos(pi/4/r)) ; 
      
   else 
       
       h(t1)=denom./numr;     
   
   end   
   
end
end

