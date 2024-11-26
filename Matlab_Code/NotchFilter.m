%陷波滤波器参数

%Dp = -26;
Dp = -52;

Bf = 64;
%Bf = 128;

f = 100;

%构造陷波滤波器
num = [1 10^(Dp/20)*2*pi*Bf (2*pi*f)^2];
den = [1 2*pi*Bf (2*pi*f)^2];
G = tf(num,den);

bode(G);