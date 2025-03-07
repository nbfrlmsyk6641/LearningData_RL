% 系统参数
J1 = 1.59e-4;
J2 = 12.50e-4;
Ks = 570;
alpha1 = 0.018;
alpha2 = 0.6;
Tc = 3.18e-4;  % 截止频率500Hz,H(s) = Tc*s/Tc*s+1,Tc = 1/2*pi*fc
wa2 = Ks/J2;
wr2 = (Ks*(J1+J2))/(J1*J2);

% Wm/Tm 开环传递函数
num0 = [J2 0 Ks];
den0 = [J1*J2 0 (J1+J2)*Ks 0];
G0 = tf(num0,den0);

% Wl/Tm 开环传递函数
num1 = [0 Ks];
den1 = [J1*J2 0 (J1+J2)*Ks 0];
G1 = tf(num1,den1);

% Wm/Tm，负反馈闭环传递函数，Tm = Tm'-alpha*H(s)*Wm，H(s)为高通滤波器
num2 = [J2*Tc J2 Ks*Tc Ks];
den2 = [J1*J2*Tc (J1*J2)+J2*alpha1*Tc Ks*Tc*(J1+J2) Ks*(J1+J2)+Ks*(alpha1*Tc) 0];
G2 = tf(num2,den2);

% Wm/Tm，负反馈闭环传递函数，Tm = Tm'-alpha*H(s)*Ts，H(s)为高通滤波器
num3 = [J2*Tc J2 Ks*Tc Ks];
den3 = [J1*J2*Tc (J1*J2) (Ks*Tc*(J1+J2)-alpha1*Tc*J2*Ks) Ks*(J1+J2) 0];
G3 = tf(num3,den3);

% Wm/Tm，负反馈闭环传递函数，Tm = Tm'-alpha*Ts
num4 = [J2 0 Ks];
den4 = [J1*J2 0 Ks*(J1+J2+(alpha1*J2)) 0];
G4 = tf(num4,den4);

% 绘制bode图
figure;
bode(G0, 'b', G2, 'r--');
grid on;

