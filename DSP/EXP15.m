%%
clear
b=[1,-3,11,27,18];
a=[16,12,2,-4,-1];
n=0:63;
figure;
h=impz(b,a,n);
u=dstep(b,a,n);
w=linspace(-2*pi,2*pi,500);
H=freqz(b,a,w);
H=20*log10(abs(H));
subplot(3,1,1),stem(n,h,'.');
title('直接型单位冲激响应');
n=0:62;
subplot(3,1,2),stem(n,u,'.');
title('直接型单位阶跃响应');
subplot(3,1,3),plot(w/pi,H);
title('直接型频率响应');
axis([0,1,-50,20]);
xlabel('单位：pi');
ylabel('单位：dB');
%%
clear
b=[1,-3,11,27,18];
a=[16,12,2,-4,-1];
n=0:63;
%将其转换为二阶节积的形式
[sos,g]=tf2sos(b,a);
N=size(sos);
N=N(1);
h0=[n==0];
fprintf('*******滤波器级联形式各级系数*******')
for k=1:N
    b1=sos(k,1:3)
    a1=sos(k,4:6)
    h1=impz(b1,a1,n);
    h0=conv(h0,h1);
end
h0=g*h0;
h0=h0(1:64);
figure
subplot(3,1,1),stem(n,h0,'.');
title('级联型单位冲激响应')
u0=[n>=0];
for k=1:N
    b1=sos(k,1:3);
    a1=sos(k,4:6);
    h1=impz(b1,a1,n);
    u0=conv(u0,h1);
end
u0=g*u0;
u0=u0(1:64);
subplot(3,1,2),stem(n,u0,'.');
title('级联型单位阶跃响应')
w=linspace(-2*pi,2*pi,500);
H0=ones(1,length(w));
for k=1:N
    b1=sos(k,1:3);
    a1=sos(k,4:6);
    H1=freqz(b1,a1,w);
    H0=H0.*H1;
end
H0=g*H0;
H0=20*log10(abs(H0));
subplot(3,1,3),plot(w/pi,H0);
title('级联型频率响应');
axis([0,1,-50,20])
xlabel('单位：pi')
ylabel('单位：dB')

%计算并联形式
%分解为部分分式
[r,p,q]=residuez(b,a);
N=size(r);
N=N(1);
h0=zeros(1,64);
fprintf('*******滤波器并联形式各级系数*******')
for k=1:N
    b1=r(k)
    a1=[1,-1*p(k)]
    s=[n==0];
    h1=filter(b1,a1,s);
    h0=h0+h1;
end
h1=[n==0];
h1=q*h1;
h0=h0+h1;
figure
subplot(3,1,1),stem(n,h0,'.')
title('并联型单位冲激响应')

u0=zeros(1,64);
for k=1:N
    b1=[r(k),0];
    a1=[1,-1*p(k)];
    s=[n>=0];
    u1=filter(b1,a1,s);
    u0=u0+u1;
end
u1=[n>=0];
u1=q*u1;
u0=u0+u1;
subplot(3,1,2),stem(n,u0,'.')
title('并联型单位阶跃响应')

w=linspace(-2*pi,2*pi,500);
H10=zeros(1,length(w));
for k=1:N
    b1=[r(k),0];
    a1=[1,-1*p(k)];
    H11=freqz(b1,a1,w);
    H10=H10+H11;
end
H10=q+H10;
H10=20*log10(abs(H10));
subplot(3,1,3),plot(w/pi,H10);
title('并联型频率响应');
axis([0,1,-50,20])
xlabel('单位：pi')
ylabel('单位：dB')