clear
clc
close all
num_random_bits=200;
R=1000;%bps might cause aliasing
bit_period=1/R;
sample_per_bit=128;
Kt=5;
r=0.6;
%%%%carrier
fc=10000;
wc=2*pi*fc;
Ac=1;
%%%%for DFT
Tb=bit_period;
N=51200; %number of FFT must be big enough to have more fine details
fs=sample_per_bit*R;  %%%%%%%%%%it looks like sampling speed foe FFT must match the original signal to avoid aliasing
d_t=1/fs;
T=N*d_t;
iterations=100;

%%%%generating a pulse
[h,t]=RootRCRO_Pulse(Kt,bit_period,sample_per_bit,r);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%modulation and detection
%%one realization
%%%%generating bits
[n, an]=random_bits(num_random_bits,[1 0]);
figure(5)
subplot(2,1,1)
stem(n,an,'r*')
title('random bits')
xlabel('number')
ylabel('bits')



%%%%generating baseband signal
[s_t,tt]=get_baseband(h,t,bit_period,an,sample_per_bit );
subplot(2,1,2)
plot(tt,s_t)


%%%%generating passband signal
carrier=Ac*cos(wc.*tt);
modulated=carrier.*s_t;
hold on
plot(tt,modulated)
title(strcat('s(t) using RCRO pulse r= ',sprintf('%0.3f',r)));
xlabel('t (sec)')
ylabel('OOK signal')

%plotting stars
for i=0:num_random_bits-1
    if an(i+1)>0
        plot(bit_period*i,1,'g*');
    else
        plot(bit_period*i,0,'g*');
    end
   
end
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%using a product detector
figure(6)
modulated=2*carrier.*modulated;%%compensate the 1/2 from cosine
rt=conv(modulated,h,'same');%%matched filter
plot(tt,rt)
hold on
%plotting stars
peak=sample_per_bit;
for l=0:1:length(an)-1
   %plot(l,interp1(tt,s_t,l),'r*');  
   plot(l*bit_period,peak*an(l+1),'g*'); 
end
hold off
title('after using a matched filter, the signal has zero ISI')
xlabel('time')
ylabel('signal')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PSD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%plotting
f=linspace(-fs/2,fs/2,N);
theory_PSD=Ac^2/16*(Tb*(sinc((f-fc)*Tb)).^2)+Ac^2/16*(Tb*(sinc((f+fc)*Tb)).^2);
figure(3)%%plotting the PSD from equation




%     %%PSD
%     figure(3)
%     subplot(2,1,1)
% 
%     F=fft(carrier,N);
%     F=fftshift(abs(F));
%     F=F*d_t;%normalize
%     PSD=abs(F.^2)./T;
%     plot(f,PSD)
% 
% return




averagedPSD=0*theory_PSD;
figure(1)
figure(2)
input('press anything to simulate PSD>>>')
for i=1:iterations
    %%%%generating bits
    [n, an]=random_bits(num_random_bits,[1 0]);
    figure(1)
    subplot(2,1,1)
    stem(n,an,'r*')
    title('random bits')
    xlabel('number')
    ylabel('bits')



    %%%%generating baseband signal
    figure(1)
    [s_t,tt]=get_baseband(h,t,bit_period,an,sample_per_bit );%removing the beginning and the end (DC)
    s_t=s_t(5*sample_per_bit:length(tt));
    tt=tt(5*sample_per_bit:length(tt));
    
    subplot(2,1,2)
    plot(tt,s_t)
    xlabel('time seconds')
    ylabel('signal')
    title(strcat('s(t) using RCRO pulse r= ',sprintf('%0.3f',r)));


    %%%%comparing with carrier
    figure(2)
    carrier=Ac*cos(wc.*tt);
    modulated=carrier.*s_t;
    plot(tt,modulated)
    title('OOK Modulation')
    xlabel('t (sec)')
    ylabel('OOK signal')

    %%%%PSD
    figure(3)
    subplot(2,1,1)

    F=fft(modulated,N);
    F=fftshift(abs(F));
    F=F*d_t;%normalize
    PSD=abs(F.^2)./T;
    plot(f,PSD);

    hold on
    plot(f,theory_PSD,'r')
    hold off
    subplot(2,1,2)
   
    averagedPSD=averagedPSD+PSD;
    
    plot(f,averagedPSD/i);
    hold on
    plot(f,theory_PSD,'r')
    hold off
    
    %pause(0.1)
end
figure(3)%%plotting the PSD from equation
subplot(2,1,2)
xlabel('freq (Hz)')
ylabel('|S_t|')
title('average PSD vs. theory')
subplot(2,1,1)
xlabel('freq (Hz)')
ylabel('|S_t|')
title('one realization of PSD')

figure(4)
plot(f,20*log10(abs(theory_PSD)),'r')
hold on
plot(f,20*log10(abs(averagedPSD)/i))
hold off

xlabel('freq (Hz)')
ylabel('|S_t| in dB')
title('simulated PSD vs. theory')


