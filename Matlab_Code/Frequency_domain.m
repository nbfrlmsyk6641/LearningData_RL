%系统参数
J1 = 1.59e-4;
J2 = 12.50e-4;
Ks = 570;
T = 0.0001;
T_zoh = 0.0005;

%系统传递函数
num1 = [J2 0 Ks];
den1 = [J1*J2 0 (J1+J2)*Ks 0];
G1 = tf(num1,den1);
Gz1 = c2d(G1, T, 'tustin');
%绘制系统的bode图
% bode(G1);
% grid on;

%PI控制器传递函数
Kp = 0.6;
Ki = 66.3;
num2 = [Kp,Kp*Ki];
den2 = [1,0];
G2 = tf(num2,den2);

%抗饱和PI控制器传递函数
Kw = 66.3;
s = tf('s');
G3 = Kp + Ki / (s + Kw);
Gz3 = c2d(G3, T, 'zoh');

% ZOH 的传递函数在频域上为：
% Hz(z) = (1 - z^{-N}) / (N * (1 - z^{-1}))
N = 5;
num_zoh = [1, zeros(1, N-1), -1];
den_zoh = N * [1, -1];
Hz = tf(num_zoh, den_zoh, T);


%转速闭环系统传递函数
G4 = feedback(Gz3*Hz*Gz1,1);
bode(G4);
grid on;
