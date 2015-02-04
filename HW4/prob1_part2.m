clear
clc
close all
num_random_bits=3;
bit_period=1;
sample_per_bit=16;
Kt=5;
r=1;

[n, an]=random_bits(num_random_bits,[1 -1]);
figure(2)
stem(n,an)
figure(1)
[h,t]=RCRO_Pulse(Kt,bit_period,sample_per_bit,r);
plot(t,h,'*')
%axis([-5 5 -0.5 1.8])
xlabel('time seconds')
ylabel('signal')
title('h(t) using RCRO')
size_of_s=(length(t)+(num_random_bits-1)*sample_per_bit);
s_t=zeros(1,size_of_s);
tt=linspace(t(1),t(length(t))+(num_random_bits-1)*bit_period,size_of_s);

figure(3)

for i=1:num_random_bits
   shamt=(i-1)*sample_per_bit+1
   s_t(1,shamt:(length(t)+shamt-1))=s_t(1,shamt:(length(t)+shamt-1))+an(i).*h ;  
end
plot(tt,s_t)
xlabel('time seconds')
ylabel('signal')
title('s(t) using RCRO pulse')
hold on
for l=0:bit_period:tt(length(tt))-bit_period*Kt  
   plot(l,interp1(tt,s_t,l),'r*'); 
    
end
hold off